package com.dgis.map.android_auto

import androidx.car.app.model.DateTimeWithZone
import com.dgis.map.DgisMapInitializer
import com.dgis.map.map_api.SoundToggleType
import java.lang.Exception
import java.util.Calendar
import java.util.EnumSet
import java.util.GregorianCalendar
import java.util.concurrent.TimeUnit
import kotlin.math.max
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.Duration
import ru.dgis.sdk.directory.DirectoryObject
import ru.dgis.sdk.geometry.ComplexGeometry
import ru.dgis.sdk.geometry.PointGeometry
import ru.dgis.sdk.map.CameraAnimationType
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.StyleZoom
import ru.dgis.sdk.map.StyleZoomToTiltRelation
import ru.dgis.sdk.map.Tilt
import ru.dgis.sdk.map.TiltFollowController
import ru.dgis.sdk.map.calcPosition
import ru.dgis.sdk.navigation.BetterRouteInfo
import ru.dgis.sdk.navigation.BetterRouteResponse
import ru.dgis.sdk.navigation.InstructionManeuver
import ru.dgis.sdk.navigation.NavigationManager
import ru.dgis.sdk.navigation.NavigationVoice
import ru.dgis.sdk.navigation.PackedNavigationState
import ru.dgis.sdk.navigation.RouteBuildOptions
import ru.dgis.sdk.navigation.RouteInfo
import ru.dgis.sdk.navigation.SoundCategory
import ru.dgis.sdk.navigation.SpeedRange
import ru.dgis.sdk.navigation.SpeedRangeToStyleZoom
import ru.dgis.sdk.navigation.State
import ru.dgis.sdk.navigation.duration
import ru.dgis.sdk.navigation.getInstructionManeuver
import ru.dgis.sdk.navigation.metersPerSecondToKilometersPerHour
import ru.dgis.sdk.navigation.notificationVolume
import ru.dgis.sdk.positioning.Location
import ru.dgis.sdk.routing.FloatRouteLongAttribute
import ru.dgis.sdk.routing.InstructionRouteAttribute
import ru.dgis.sdk.routing.InstructionRouteEntry
import ru.dgis.sdk.routing.RouteDistance
import ru.dgis.sdk.routing.RoutePoint
import ru.dgis.sdk.routing.TrafficRoute
import ru.dgis.sdk.routing.compareTo
import ru.dgis.sdk.routing.meters
import ru.dgis.sdk.routing.minus
import ru.dgis.sdk.routing.plus

class CarNavigationHandler(
        private val navigationManager: NavigationManager,
        private val sharedPrefs: SharedPrefs,
        private val searchByDirectoryObjectId:
                (
                        objectId: DgisObjectId,
                        resultCallback: (result: DirectoryObject?) -> Unit,
                        errorCallback: ((exception: Exception) -> Unit)?,
                ) -> Unit,
) : AutoCloseable {

    interface NavigationListener {
        fun onNavigationStateChanged(state: NavigationState)
        fun onEtaUpdated(eta: EtaModel?)
        fun onManeuverUpdate(maneuver: ManeuverModel?, nextManeuver: ManeuverModel?)
        fun onLocationStateChanged(state: LocationState)
        fun onBetterRouteFound(durationProfit: Int?)
        fun onSpeedChanged(speed: Int)
        fun onSpeedLimitChanged(speedLimit: Int?)
        fun onSpeedLimitExceeded(exceeded: Boolean)
    }

    private var destination: String? = null
    private var instructions: InstructionRouteAttribute? = null
    private var speedLimits: FloatRouteLongAttribute? = null
    private val navigationCloseables = mutableListOf<AutoCloseable>()
    private var navigationListener: NavigationListener? = null
    private var map: Map? = null

    // Tilt follow controller for stable chase camera
    private var tiltFollowController: TiltFollowController? = null
    private var currentChaseTilt: Float = 68f

    // CarPlay-style camera: tilt and post-maneuver transition
    private var lastPassedManeuverRouteDistanceMm: Long? = null
    private var prevBackwardInstructionDistanceMm: Long? = null
    private var lastAppliedTilt: Float? = null

    fun setListener(listener: NavigationListener) {
        navigationListener = listener
        subscribeToNavigation()
    }

    fun resetNavigationListener() {
        navigationListener = null
        unsubscribeFromNavigation()
    }

    fun addMap(map: Map) {
        this.map = map
        navigationManager.mapManager.addMap(map)
        // Add TiltFollowController to keep a stable chase perspective without manual camera.move()
        val tiltRelation =
                object : StyleZoomToTiltRelation {
                    override fun styleZoomToTilt(styleZoom: StyleZoom): Tilt {
                        return Tilt(currentChaseTilt)
                    }
                }
        val tiltController = TiltFollowController(tiltRelation)
        map.camera.addFollowController(tiltController)
        this.tiltFollowController = tiltController
    }

    private fun subscribeToNavigation() {
        val navigationModel = navigationManager.uiModel
        navigationCloseables.add(navigationModel.stateChannel.connect(::navigationStateListener))
        navigationCloseables.add(navigationModel.routeChannel.connect(::routeListener))
        navigationCloseables.add(
                navigationModel.routePositionChannel.connect(::routePositionListener)
        )
        navigationCloseables.add(navigationModel.locationChannel.connect(::locationListener))
        navigationCloseables.add(
                navigationModel.locationAvailableChannel.connect(::locationAvailableListener)
        )
        navigationCloseables.add(
                navigationModel.exceedingMaxSpeedLimitChannel.connect(this::exceedLimitListener)
        )
        navigationCloseables.add(navigationModel.betterRouteChannel.connect(::betterRouteListener))
    }

    private fun unsubscribeFromNavigation() {
        navigationCloseables.forEach(AutoCloseable::close)
    }

    private fun navigationStateListener(state: State) {
        val routeBuildOptions = navigationManager.uiModel.route.routeBuildOptions
        navigationListener?.onNavigationStateChanged(
                state.toNavigationState(routeBuildOptions != null)
        )

        if (state == State.DISABLED) {
            destination = null
            instructions = null
            speedLimits = null
            lastPassedManeuverRouteDistanceMm = null
            prevBackwardInstructionDistanceMm = null
            lastAppliedTilt = null
            return
        }

        // Maneuver
        instructions?.let {
            val position = navigationManager.uiModel.routePosition ?: return@let
            updateManeuverInfo(position, it)
        }

        // Destination
        if (destination == null && state == State.NAVIGATION && routeBuildOptions != null) {
            searchByDirectoryObjectId(
                    routeBuildOptions.finishPoint.objectId,
                    {
                        destination = it?.title
                        updateEta()
                    },
                    null,
            )
        }
    }

    private fun routeListener(routeInfo: RouteInfo) {
        val navigationState =
                navigationManager.uiModel.state.toNavigationState(
                        routeInfo.routeBuildOptions != null
                )

        // SDK sometimes doesn't send navigation state to stateChannel when navigation on route is
        // started after freeroam,
        // therefore we should call onNavigationStateChanged with NAVIGATION here
        if (navigationState == NavigationState.NAVIGATION) {
            navigationListener?.onNavigationStateChanged(navigationState)
        }

        // Speed limits
        speedLimits = routeInfo.route.maxSpeedLimits

        // Maneuver
        instructions = routeInfo.route.instructions
        instructions?.let {
            val routePosition = navigationManager.uiModel.routePosition ?: return@let
            updateManeuverInfo(routePosition, it)
        }
    }

    private fun routePositionListener(position: RoutePoint?) {
        // Eta
        updateEta()

        // Maneuver
        position?.let {
            val instructions = instructions ?: return@let
            updateManeuverInfo(it, instructions)
        }

        // Speed limit
        position?.let {
            val entry = speedLimits?.entry(it)
            val speedLimit =
                    entry?.let {
                        metersPerSecondToKilometersPerHour(entry.value.toDouble()).toInt()
                    }
            navigationListener?.onSpeedLimitChanged(speedLimit)
        }

        updateCarPlayStyleCameraTilt()
    }

    private fun locationListener(location: Location?) {
        val speed = location?.groundSpeed
        speed?.let {
            val kmph = metersPerSecondToKilometersPerHour(it.value).toInt()
            navigationListener?.onSpeedChanged(kmph)
        }
        updateCarPlayStyleCameraTilt()
    }

    private fun locationAvailableListener(available: Boolean) {
        navigationListener?.onLocationStateChanged(
                if (available) LocationState.AVAILABLE else LocationState.NOT_AVAILABLE
        )
    }

    private fun exceedLimitListener(exceeded: Boolean) {
        navigationListener?.onSpeedLimitExceeded(exceeded)
    }

    private fun betterRouteListener(routeInfo: BetterRouteInfo?) {
        if (!sharedPrefs.suggestBetterRoad || routeInfo == null) {
            navigationListener?.onBetterRouteFound(durationProfit = null)
            return
        }
        val activeRouteDuration = navigationManager.uiModel.duration?.inSeconds
        val betterRouteDuration =
                routeInfo.trafficRoute.route.geometry.first?.point?.let {
                    routeInfo.trafficRoute.traffic.durations.calculateDuration(it).inSeconds
                }
        val durationProfit =
                if (activeRouteDuration != null && betterRouteDuration != null)
                        (activeRouteDuration - betterRouteDuration).toInt()
                else 0
        navigationListener?.onBetterRouteFound(durationProfit = durationProfit.coerceAtLeast(0))
    }

    private fun updateManeuverInfo(
            routePosition: RoutePoint,
            instructions: InstructionRouteAttribute,
    ) {
        if (navigationManager.uiModel.state != State.NAVIGATION) {
            navigationListener?.onManeuverUpdate(null, null)
            return
        }

        instructions.findNearBackward(routePosition)?.let {
            if (routePosition <= it.point + it.value.range) {
                handleInstructionForPosition(it, routePosition)
                return
            }
        }

        instructions.findNearForward(routePosition)?.let {
            handleInstructionForPosition(it, routePosition)
        }
    }

    private fun handleInstructionForPosition(
            instructionEntry: InstructionRouteEntry,
            routePosition: RoutePoint,
    ) {
        val maneuver = getManeuver(routePosition, instructionEntry)
        if (maneuver == null) {
            navigationListener?.onManeuverUpdate(null, null)
            return
        }
        val nextManeuver = getNextManeuver(routePosition, instructionEntry)
        navigationListener?.onManeuverUpdate(maneuver, nextManeuver)
    }

    private fun getNextManeuver(
            routePosition: RoutePoint,
            instructionEntry: InstructionRouteEntry,
    ): ManeuverModel? {
        val instruction = instructionEntry.value
        val instructionManeuver = getInstructionManeuver(instruction.extraInstructionInfo)

        val instructions = this.instructions ?: return null
        if (instructionEntry == instructions.first &&
                        (instructionManeuver == InstructionManeuver.START ||
                                instructionManeuver == InstructionManeuver.CROSSROAD_STRAIGHT)
        ) {
            return null
        }
        if (instructionEntry == instructions.last) {
            return null
        }
        if ((instructionEntry.point - routePosition).meters > maxDistanceToManeuver) {
            return null
        }

        val nextInstructionEntry =
                instructions.findNearForward(
                        RoutePoint(
                                instructionEntry.point.distance + RouteDistance(millimeters = 1000)
                        )
                )
                        ?: return null

        val distanceBetween = (nextInstructionEntry.point - instructionEntry.point).meters
        if (distanceBetween > maxDistanceBetweenManeuvers) {
            return null
        }

        return getManeuver(routePosition, nextInstructionEntry)
    }

    private fun getManeuver(
            routePosition: RoutePoint,
            instructionEntry: InstructionRouteEntry,
    ): ManeuverModel? {
        val instruction = instructionEntry.value
        val instructionManeuver = getInstructionManeuver(instruction.extraInstructionInfo)

        val maneuverType = instructionManeuver.toManeuverType() ?: return null

        val iconId = instructionManeuver.iconId() ?: return null

        val exitNumber =
                instruction.extraInstructionInfo.asCarRoundabout?.let {
                    val exit = it.exitNumber
                    return@let if (exit == 0 || exit == -1) null else exit
                }

        val distance = max((instructionEntry.point - routePosition).meters, minDistanceToManeuver)

        val speed = navigationManager.uiModel.location?.groundSpeed?.value ?: return null
        val arrivalTime =
                GregorianCalendar().apply { add(Calendar.SECOND, (distance / speed).toInt()) }
        return ManeuverModel(
                maneuverType,
                distance,
                getDateTimeWithZone(arrivalTime),
                instruction.roadName,
                iconId,
                exitNumber
        )
    }

    private fun updateEta() {
        val navigationModel = navigationManager.uiModel
        if (navigationModel.state != State.NAVIGATION && navigationModel.state != State.ROUTE_SEARCH
        ) {
            navigationListener?.onEtaUpdated(null)
            return
        }

        val duration = navigationModel.duration
        val routePosition = navigationModel.routePosition
        val routeLength = navigationModel.route.route.geometry.length
        if (duration == null || routePosition == null) {
            return
        }

        val distance = (routeLength - routePosition.distance).meters
        val arrivalTime =
                GregorianCalendar().apply { add(Calendar.SECOND, duration.inSeconds.toInt()) }

        val eta =
                EtaModel(
                        duration.inSeconds,
                        distance,
                        getDateTimeWithZone(arrivalTime),
                        destination
                )
        navigationListener?.onEtaUpdated(eta)
    }

    fun setNavigationVoice(voice: NavigationVoice) {
        navigationManager.voiceSelector.voice = voice
    }

    /**
     * CarPlay-style camera: 0–~64 km/h → zoom ~16.5 (zoom-out-after-maneuver completes within
     * 500 m); 60+ km/h → zoom ~14. Active only when navigation is on (Go or FreeRoam).
     */
    fun setupCamera() {
        val maneuverZoneMm = 500_000L // 500 meters
        val farMm = 1_000_000_000L

        val styles =
                listOf(
                        // NEAR MODE: slow speed (0–~64 km/h). minDistanceToManeuver/
                        // maxDistanceToManeuver tune the approach-to-maneuver animation,
                        // not a speed-range selector — a single range covers this bucket.
                        SpeedRangeToStyleZoom(
                                // Upper bound overlaps the FAR range by 1 m/s: the SDK silently
                                // drops the whole sequence otherwise (maxSpeed[i] must be >
                                // minSpeed[i+1]).
                                range = SpeedRange(0.0, 17.67), // 0–~64 km/h
                                minDistanceToManeuver = RouteDistance(0),
                                maxDistanceToManeuver = RouteDistance(maneuverZoneMm),
                                styleZoom = StyleZoom(19.3f) // visually this will look like ~16.5
                        ),

                        // FAR MODE (normal navigation):
                        // Fast driving (60+ km/h) → normal overview camera
                        SpeedRangeToStyleZoom(
                                range = SpeedRange(16.67, 1000.0), // 60+ km/h
                                minDistanceToManeuver = RouteDistance(0),
                                maxDistanceToManeuver = RouteDistance(farMm),
                                styleZoom = StyleZoom(15.8f) // visually this will look like ~14
                        )
                )

        navigationManager.zoomFollowSettings.speedRangeToStyleZoomSequence = styles
        navigationManager.zoomFollowSettings.speedRangeToStyleZoomFreeRoamSequence = styles

        // Animation timings
        navigationManager.zoomFollowSettings.styleZoomSpeedRangesAnimationDuration =
                Duration.ofMilliseconds(500)
        navigationManager.zoomFollowSettings.zoomInBeforeManeuverAnimationDuration =
                Duration.ofMilliseconds(700)
        navigationManager.zoomFollowSettings.zoomOutAfterManeuverAnimationDuration =
                Duration.ofMilliseconds(700)

        // Distance after maneuver where camera returns back to FAR mode
        navigationManager.zoomFollowSettings.distanceGapToManeuver =
                RouteDistance(millimeters = maneuverZoneMm)

        // NOTE: This SDK version does not expose styleZoomToTiltRelation on zoomFollowSettings.
        // Tilt is controlled by the navigation camera internally in Android Auto and cannot be
        // overridden here.
    }

    /**
     * CarPlay-style tilt: simplified for stable chase view. Keep a stable chase view. Do not run
     * any per-tick camera moves here. The base chase camera is applied once in followNavigation().
     */
    private fun updateCarPlayStyleCameraTilt() {
        if (navigationManager.uiModel.state != State.NAVIGATION) return

        val speedKmph =
                navigationManager.uiModel.location?.groundSpeed?.value?.let {
                    metersPerSecondToKilometersPerHour(it).toInt()
                }
                        ?: return

        val routePosition = navigationManager.uiModel.routePosition ?: return
        val instructions = instructions ?: return

        // Near maneuver (<= 500 m) and slow (< 60 km/h) -> flatter chase
        instructions.findNearForward(routePosition)?.let { entry ->
            val distM = (entry.point - routePosition).meters
            if (distM <= 500 && speedKmph < 60) {
                // Near mode: keep perspective, but flatter than far mode
                setChaseTilt(32f)
                return
            }
        }

        // Default far chase view
        setChaseTilt(68f)
    }

    private fun applyChaseCameraBase() {
        // no-op: tilt is controlled by TiltFollowController
    }

    private fun applyTiltIfNeeded(desiredTilt: Float) {
        // Intentionally no-op. Tilt is controlled by TiltFollowController.
    }

    fun followNavigation() {
        val map = this.map ?: return
        setupCamera()
        navigationManager.mapFollowController.setFollow(true)
        map.camera.setBehaviour(behaviour = navigationManager.mapFollowController.cameraBehaviour)
    }

    private fun setChaseTilt(deg: Float) {
        currentChaseTilt = deg
        // No direct setter in SDK: the relation is queried by camera, so just update the value.
    }

    fun startNavigation(routeBuildOptions: RouteBuildOptions, trafficRoute: TrafficRoute) {
        navigationManager.start(routeBuildOptions = routeBuildOptions, trafficRoute = trafficRoute)
    }

    fun startFreeroam() {
        navigationManager.start()
    }

    fun startNavigationSimulation() {
        val routeBuildOptions = navigationManager.uiModel.route.routeBuildOptions ?: return
        navigationManager.startSimulation(
                routeBuildOptions,
                TrafficRoute.fromNavigationState(
                        PackedNavigationState.fromModel(navigationManager.uiModel),
                        DgisMapInitializer.getSdkContext(),
                ),
        )
    }

    fun overviewRoute() {
        val map = this.map ?: return
        val geometries =
                navigationManager.uiModel.route.route.geometry.entries.map { entry ->
                    PointGeometry(entry.value)
                }
        val geometry = ComplexGeometry(geometries)
        val cameraPosition = calcPosition(camera = map.camera, geometry = geometry)
        map.camera.move(cameraPosition, animationType = CameraAnimationType.LINEAR)
    }

    fun acceptBetterRoute() {
        respondToBetterRoute(BetterRouteResponse.ACCEPT)
    }

    fun rejectBetterRoute() {
        respondToBetterRoute(BetterRouteResponse.REJECT)
    }

    fun timeoutBetterRoute() {
        respondToBetterRoute(BetterRouteResponse.TIMEOUT)
    }

    private fun respondToBetterRoute(response: BetterRouteResponse) {
        // Answering a better-route offer that the SDK has already resolved — a user tap racing the
        // 10s alert timeout, or the offer being retracted between the channel emit and our reply —
        // throws inside the native SDK. Swallow it so a stale response can never tear down the
        // Android Auto process.
        try {
            navigationManager.uiModel.betterRouteResponse(response)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun stopNavigation() {
        navigationManager.stop()
    }

    fun getCurrentNavigationState(): NavigationState {
        val routeBuildOptions = navigationManager.uiModel.route.routeBuildOptions
        return navigationManager.uiModel.state.toNavigationState(routeBuildOptions != null)
    }

    fun toggleVoiceInstruction(toggleType: SoundToggleType) {
        val currentCategories =
                this.navigationManager.soundNotificationSettings.enabledSoundCategories

        val updatedCategories =
                when (toggleType) {
                    SoundToggleType.NONE -> {
                        EnumSet.noneOf(SoundCategory::class.java).apply {
                            addAll(currentCategories)
                            removeAll(EnumSet.allOf(SoundCategory::class.java))
                        }
                    }
                    SoundToggleType.ALL -> {
                        EnumSet.allOf(SoundCategory::class.java).apply { addAll(currentCategories) }
                    }
                    SoundToggleType.IMPORTANT -> {
                        EnumSet.copyOf(currentCategories).apply {
                            remove(SoundCategory.INSTRUCTIONS)
                        }
                    }
                }

        this.navigationManager.soundNotificationSettings.enabledSoundCategories = updatedCategories
    }

    fun setNavigatorVolume(volume: Int) {
        this.navigationManager.soundNotificationSettings.notificationVolume = volume
    }

    override fun close() {
        unsubscribeFromNavigation()
    }

    private companion object {
        const val maxDistanceToManeuver = 1000.0
        const val maxDistanceBetweenManeuvers = 50.0
        const val minDistanceToManeuver = 1.0

        fun getDateTimeWithZone(calendar: GregorianCalendar): DateTimeWithZone {
            val date = calendar.time
            val timeZone = calendar.timeZone
            val timeSinceEpochMillis = date.time
            val timeZoneOffsetSeconds =
                    TimeUnit.MILLISECONDS.toSeconds(
                            timeZone.getOffset(timeSinceEpochMillis).toLong()
                    )
            val zoneShortName = calendar.timeZone.displayName
            return DateTimeWithZone.create(
                    timeSinceEpochMillis,
                    timeZoneOffsetSeconds.toInt(),
                    zoneShortName
            )
        }
    }
}
