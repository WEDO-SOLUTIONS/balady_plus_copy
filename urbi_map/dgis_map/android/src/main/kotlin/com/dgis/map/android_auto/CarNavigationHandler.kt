package com.dgis.map.android_auto

import androidx.car.app.model.DateTimeWithZone
import com.dgis.map.DgisMapInitializer
import com.dgis.map.map_api.SoundToggleType
import ru.dgis.sdk.geometry.ComplexGeometry
import ru.dgis.sdk.geometry.PointGeometry
import ru.dgis.sdk.map.CameraAnimationType
import ru.dgis.sdk.map.Map
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
import java.util.Calendar
import java.util.EnumSet
import java.util.GregorianCalendar
import java.util.concurrent.TimeUnit
import kotlin.math.max

class CarNavigationHandler(
    private val navigationManager: NavigationManager,
    private val searchHandler: CarSearchHandler,
    private val sharedPrefs: SharedPrefs,
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
    }

    private fun subscribeToNavigation() {
        val navigationModel = navigationManager.uiModel
        navigationCloseables.add(navigationModel.stateChannel.connect(::navigationStateListener))
        navigationCloseables.add(navigationModel.routeChannel.connect(::routeListener))
        navigationCloseables.add(navigationModel.routePositionChannel.connect(::routePositionListener))
        navigationCloseables.add(navigationModel.locationChannel.connect(::locationListener))
        navigationCloseables.add(navigationModel.locationAvailableChannel.connect(::locationAvailableListener))
        navigationCloseables.add(navigationModel.exceedingMaxSpeedLimitChannel.connect(this::exceedLimitListener))
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
            return
        }

        // Maneuver
        instructions?.let {
            val position = navigationManager.uiModel.routePosition ?: return@let
            updateManeuverInfo(position, it)
        }

        // Destination
        if (destination == null && state == State.NAVIGATION && routeBuildOptions != null) {
            searchHandler.searchByDirectoryObjectId(
                routeBuildOptions.finishPoint.objectId,
                resultCallback = {
                    destination = it?.title
                    updateEta()
                })
        }
    }

    private fun routeListener(routeInfo: RouteInfo) {
        val navigationState = navigationManager.uiModel.state.toNavigationState(
            routeInfo.routeBuildOptions != null
        )

        // SDK sometimes doesn't send navigation state to stateChannel when navigation on route is started after freeroam,
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
                entry?.let { metersPerSecondToKilometersPerHour(entry.value.toDouble()).toInt() }
            navigationListener?.onSpeedLimitChanged(speedLimit)
        }
    }

    private fun locationListener(location: Location?) {
        val speed = location?.groundSpeed
        speed?.let {
            val kmph = metersPerSecondToKilometersPerHour(it.value).toInt()
            navigationListener?.onSpeedChanged(kmph)
        }
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
        if (!sharedPrefs.suggestBetterRoad) {
            navigationListener?.onBetterRouteFound(durationProfit = null)
            return
        }
        val activeRouteDuration = navigationManager.uiModel.duration?.inSeconds
        val betterRouteDuration = routeInfo?.trafficRoute?.route?.geometry?.first?.point?.let {
            routeInfo.trafficRoute.traffic.durations.calculateDuration(
                it
            ).inSeconds
        }
        val durationProfit =
            if (activeRouteDuration != null && betterRouteDuration != null) (activeRouteDuration - betterRouteDuration).toInt() else null
        navigationListener?.onBetterRouteFound(durationProfit = durationProfit)
    }


    private fun updateManeuverInfo(
        routePosition: RoutePoint, instructions: InstructionRouteAttribute,
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
        instructionEntry: InstructionRouteEntry, routePosition: RoutePoint,
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
        routePosition: RoutePoint, instructionEntry: InstructionRouteEntry,
    ): ManeuverModel? {
        val instruction = instructionEntry.value
        val instructionManeuver = getInstructionManeuver(instruction.extraInstructionInfo)

        val instructions = this.instructions ?: return null
        if (instructionEntry == instructions.first && (instructionManeuver == InstructionManeuver.START || instructionManeuver == InstructionManeuver.CROSSROAD_STRAIGHT)) {
            return null
        }
        if (instructionEntry == instructions.last) {
            return null
        }
        if ((instructionEntry.point - routePosition).meters > maxDistanceToManeuver) {
            return null
        }

        val nextInstructionEntry = instructions.findNearForward(
            RoutePoint(instructionEntry.point.distance + RouteDistance(millimeters = 1000))
        ) ?: return null

        val distanceBetween = (nextInstructionEntry.point - instructionEntry.point).meters
        if (distanceBetween > maxDistanceBetweenManeuvers) {
            return null
        }

        return getManeuver(routePosition, nextInstructionEntry)
    }

    private fun getManeuver(
        routePosition: RoutePoint, instructionEntry: InstructionRouteEntry,
    ): ManeuverModel? {
        val instruction = instructionEntry.value
        val instructionManeuver = getInstructionManeuver(instruction.extraInstructionInfo)

        val maneuverType = instructionManeuver.toManeuverType() ?: return null

        val iconId = instructionManeuver.iconId() ?: return null

        val exitNumber = instruction.extraInstructionInfo.asCarRoundabout?.let {
            val exit = it.exitNumber
            return@let if (exit == 0 || exit == -1) null else exit
        }

        val distance = max((instructionEntry.point - routePosition).meters, minDistanceToManeuver)

        val speed = navigationManager.uiModel.location?.groundSpeed?.value ?: return null
        val arrivalTime = GregorianCalendar().apply {
            add(Calendar.SECOND, (distance / speed).toInt())
        }
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
        if (navigationModel.state != State.NAVIGATION && navigationModel.state != State.ROUTE_SEARCH) {
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
        val arrivalTime = GregorianCalendar().apply {
            add(Calendar.SECOND, duration.inSeconds.toInt())
        }

        val eta = EtaModel(
            duration.inSeconds, distance, getDateTimeWithZone(arrivalTime), destination
        )
        navigationListener?.onEtaUpdated(eta)
    }

    fun setNavigationVoice(voice: NavigationVoice) {
        navigationManager.voiceSelector.voice = voice
    }

    fun followNavigation() {
        map?.camera?.setBehaviour(
            behaviour = navigationManager.mapFollowController.cameraBehaviour
        )
        navigationManager.mapFollowController.setFollow(true)
    }

    fun startNavigation(routeBuildOptions: RouteBuildOptions, trafficRoute: TrafficRoute) {
        navigationManager.start(
            routeBuildOptions = routeBuildOptions,
            trafficRoute = trafficRoute
        )
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
        val geometries = navigationManager.uiModel.route.route.geometry.entries.map { entry ->
            PointGeometry(entry.value)
        }
        val geometry = ComplexGeometry(geometries)
        val cameraPosition = calcPosition(camera = map.camera, geometry = geometry)
        map.camera.move(cameraPosition, animationType = CameraAnimationType.LINEAR)
    }

    fun acceptBetterRoute() {
        navigationManager.uiModel.betterRouteResponse(BetterRouteResponse.ACCEPT)
    }

    fun rejectBetterRoute() {
        navigationManager.uiModel.betterRouteResponse(BetterRouteResponse.REJECT)
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

        val updatedCategories = when (toggleType) {
            SoundToggleType.NONE -> {
                EnumSet.noneOf(SoundCategory::class.java).apply {
                    addAll(currentCategories)
                    removeAll(EnumSet.allOf(SoundCategory::class.java))
                }
            }

            SoundToggleType.ALL -> {
                EnumSet.allOf(SoundCategory::class.java).apply {
                    addAll(currentCategories)
                }
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
                TimeUnit.MILLISECONDS.toSeconds(timeZone.getOffset(timeSinceEpochMillis).toLong())
            val zoneShortName = calendar.timeZone.displayName
            return DateTimeWithZone.create(
                timeSinceEpochMillis, timeZoneOffsetSeconds.toInt(), zoneShortName
            )
        }
    }
}
