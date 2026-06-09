package com.dgis.map.control_handlers

import android.content.Context
import com.dgis.map.control_handlers.navigation_controls.DashboardControlModel
import com.dgis.map.control_handlers.navigation_controls.ManeuverControlModel
import com.dgis.map.control_handlers.navigation_controls.MessageControlModel
import com.dgis.map.control_handlers.navigation_controls.SpeedControlModel
import com.dgis.map.extensions.toMessage
import com.dgis.map.extensions.toRouteSearchOptionsMessage
import com.dgis.map.map_api.*
import com.dgis.map.map_api.BetterRouteResponseMessage
import com.dgis.map.map_api.BetterRouteSettingsMessage
import com.dgis.map.map_api.NavigationStateMessage
import com.dgis.map.map_api.SoundToggleType
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.Context as SdkContext
import ru.dgis.sdk.Duration
import ru.dgis.sdk.Meter
import ru.dgis.sdk.ScreenSize
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.geometry.ComplexGeometry
import ru.dgis.sdk.geometry.PointGeometry
import ru.dgis.sdk.map.CalloutVisualizationMode
import ru.dgis.sdk.map.CameraBehaviour
import ru.dgis.sdk.map.CameraZoomRestrictions
import ru.dgis.sdk.map.FollowBearing
import ru.dgis.sdk.map.FollowPosition
import ru.dgis.sdk.map.FollowStyleZoom
import ru.dgis.sdk.map.FollowTilt
import ru.dgis.sdk.map.StyleZoomToTiltRelation
import ru.dgis.sdk.map.TiltFollowController
import ru.dgis.sdk.map.Zoom
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.MyLocationControllerSettings
import ru.dgis.sdk.map.MyLocationMapObjectSource
import ru.dgis.sdk.map.Padding
import ru.dgis.sdk.map.RouteMapObject
import ru.dgis.sdk.map.RouteMapObjectDisplayFlag
import ru.dgis.sdk.map.Source
import ru.dgis.sdk.map.GraphicsPreset
import ru.dgis.sdk.map.StyleZoom
import ru.dgis.sdk.map.Tilt
import ru.dgis.sdk.map.calcPosition
import ru.dgis.sdk.navigation.*
import ru.dgis.sdk.routing.RouteDistance
import ru.dgis.sdk.routing.RouteSearchOptions
import ru.dgis.sdk.routing.RouteSearchPoint
import ru.dgis.sdk.routing.TrafficRoute
import ru.dgis.sdk.traffic.TrafficControlModel
import ru.dgis.sdk.traffic.TrafficControlStatus

class NavigationHandler(
        sdkContext: SdkContext,
        private val navigationManager: NavigationManager,
        private val eventSink: EventChannel.EventSink,
        private val map: Map,
        private val appContext: Context,
) : AutoCloseable {
        private val context: SdkContext = sdkContext
        private val voicesManager = getVoiceManager(sdkContext)
        private var dashboardControlModel: DashboardControlModel

        private val stateClosable: AutoCloseable
        private val routeInfoCloseable: AutoCloseable
        private val betterRouteCloseable: AutoCloseable

        private var prevCameraBehaviour: CameraBehaviour? = null
        private var prevGraphicsPreset: GraphicsPreset? = null
        private var oldSource: Source? = null

        // Active tilt-by-zoom controller added via [applyCameraSettings]; tracked so it can be
        // replaced/removed cleanly.
        private var tiltFollowController: TiltFollowController? = null

        var isNavigating: Boolean = false
                private set

        // Models to observe channels and send events to Flutter
        private val speedControlModel =
                SpeedControlModel(model = navigationManager.uiModel, eventSink = eventSink)

        private val messageControlModel =
                MessageControlModel(model = navigationManager.uiModel, eventSink = eventSink)

        private val maneuverControlModel =
                ManeuverControlModel(
                        model = navigationManager.uiModel,
                        eventSink = eventSink,
                )

        init {
                navigationManager.mapManager.addMap(map)

                navigationManager.alternativeRoutesProviderSettings.alternativeRoutesEnabled = false
                navigationManager.routeSourceSettings.calloutVisualizationMode =
                        CalloutVisualizationMode.MULTIPLE_ROUTES
                navigationManager.routeMapSettings.onRouteDisplayFlags.add(
                        RouteMapObjectDisplayFlag.IMMERSIVE_ROUTE_PARTS
                )

                dashboardControlModel =
                        DashboardControlModel(
                                navigationManager.uiModel,
                                eventSink,
                                navigationManager,
                                appContext,
                        )

                stateClosable =
                        navigationManager.uiModel.stateChannel.connect(::stateChannelListener)
                routeInfoCloseable =
                        navigationManager.uiModel.routeChannel.connect(::routeInfoListener)
                betterRouteCloseable =
                        navigationManager.uiModel.betterRouteChannel.connect(::betterRouteListener)
        }

        fun setupCamera(speedRangeZoom: List<SpeedRangeZoom>) {
                // Store the original graphics preset before changing it
                // This allows us to restore it later to preserve traffic layer colors
                prevGraphicsPreset = map.graphicsPreset
                
                // NEVER change graphics preset if it's not already immersive
                // This preserves traffic layer colors when freeroam starts
                // The preset will only be changed if it's already immersive (no-op)
                // This ensures traffic colors remain consistent regardless of traffic state
                // Only change to immersive if current preset is already immersive (no change needed)
                // Otherwise, preserve the current preset to maintain traffic colors
                if (map.graphicsPreset == GraphicsPreset.IMMERSIVE) {
                        // Already immersive, no change needed
                } else {
                        // Preserve current preset - don't change to immersive
                        // This keeps traffic colors consistent
                }
                
                prevCameraBehaviour = map.camera.behaviour.newBehaviour
                map.camera.setBehaviour(
                        behaviour = navigationManager.mapFollowController.cameraBehaviour
                )

                navigationManager.mapFollowController.setFollow(true)
                val zooms = speedRangeZoom.map { speedRangeZoom ->
                        SpeedRangeToStyleZoom(
                                range =
                                        SpeedRange(
                                                minSpeed = speedRangeZoom.minSpeedRange,
                                                maxSpeed = speedRangeZoom.maxSpeedRange
                                        ),
                                minDistanceToManeuver =
                                        RouteDistance(
                                                millimeters =
                                                        speedRangeZoom
                                                                .routeDistanceMillimeters
                                                                .toLong()
                                        ),
                                maxDistanceToManeuver =
                                        RouteDistance(
                                                millimeters =
                                                        speedRangeZoom
                                                                .routeDistanceMillimeters
                                                                .toLong()
                                        ),
                                styleZoom =
                                        StyleZoom(
                                                value =
                                                        speedRangeZoom.styleZoomValue
                                                                .toFloat()
                                        )
                        )
                }
                navigationManager.zoomFollowSettings.speedRangeToStyleZoomSequence = zooms
                navigationManager.zoomFollowSettings.speedRangeToStyleZoomFreeRoamSequence = zooms
        }

        /**
         * Applies any subset of navigation-camera controls. Every field of [settings] is optional:
         * a null field leaves the corresponding SDK behavior untouched, so this can be used both to
         * configure the full camera at navigation start and to tweak a single parameter live.
         */
        fun applyCameraSettings(settings: NavigationCameraSettings) {
                // Remember the phone-tuned settings so Android Auto can mirror the tilt-by-zoom
                // curve / zoom restriction on its own map (see CarNavigationHandler).
                com.dgis.map.DgisMapInitializer.lastNavigationCameraSettings = settings

                val zoomFollowSettings = navigationManager.zoomFollowSettings

                settings.speedZoomRules?.let { rules ->
                        zoomFollowSettings.speedRangeToStyleZoomSequence = rules.map(::toSpeedRangeToStyleZoom)
                }
                settings.freeRoamSpeedZoomRules?.let { rules ->
                        zoomFollowSettings.speedRangeToStyleZoomFreeRoamSequence =
                                rules.map(::toSpeedRangeToStyleZoom)
                }

                settings.zoomTuning?.let { tuning ->
                        tuning.styleZoomSpeedRangesAnimationMs?.let {
                                zoomFollowSettings.styleZoomSpeedRangesAnimationDuration =
                                        Duration.ofMilliseconds(it)
                        }
                        tuning.zoomInBeforeManeuverAnimationMs?.let {
                                zoomFollowSettings.zoomInBeforeManeuverAnimationDuration =
                                        Duration.ofMilliseconds(it)
                        }
                        tuning.zoomOutAfterManeuverAnimationMs?.let {
                                zoomFollowSettings.zoomOutAfterManeuverAnimationDuration =
                                        Duration.ofMilliseconds(it)
                        }
                        tuning.distanceGapToManeuverMm?.let {
                                zoomFollowSettings.distanceGapToManeuver = RouteDistance(it.toLong())
                        }
                        tuning.minSpeedToConsiderInZoomInBeforeManeuver?.let {
                                zoomFollowSettings.minSpeedToConsiderInZoomInBeforeManeuverAnimation = it
                        }
                        tuning.zoomInBeforeManeuverAnimationAcceleration?.let {
                                zoomFollowSettings.zoomInBeforeManeuverAnimationAcceleration = it
                        }
                        tuning.minAnimationMs?.let {
                                zoomFollowSettings.minAnimationDuration = Duration.ofMilliseconds(it)
                        }
                }

                settings.followBehaviour?.let { behaviour ->
                        val cameraBehaviour =
                                CameraBehaviour(
                                        position =
                                                FollowPosition(
                                                        bearing =
                                                                if (behaviour.followBearing) FollowBearing.ON
                                                                else FollowBearing.OFF,
                                                        styleZoom =
                                                                if (behaviour.followStyleZoom) FollowStyleZoom.ON
                                                                else FollowStyleZoom.OFF,
                                                ),
                                        tilt =
                                                if (behaviour.followTilt) FollowTilt.ON
                                                else FollowTilt.OFF,
                                )
                        navigationManager.mapFollowController.cameraBehaviour = cameraBehaviour
                        map.camera.setBehaviour(cameraBehaviour)
                }

                settings.tiltRelation?.let { points ->
                        tiltFollowController?.let { map.camera.removeFollowController(it) }
                        val controller = TiltFollowController(tiltRelationOf(points))
                        map.camera.addFollowController(controller)
                        tiltFollowController = controller
                }

                settings.maxTiltRelation?.let { points ->
                        map.camera.maxTiltRestriction = tiltRelationOf(points)
                }

                if (settings.minZoom != null || settings.maxZoom != null) {
                        val current = map.camera.zoomRestrictions
                        map.camera.zoomRestrictions =
                                CameraZoomRestrictions(
                                        minZoom = settings.minZoom?.let { Zoom(it.toFloat()) }
                                                ?: current.minZoom,
                                        maxZoom = settings.maxZoom?.let { Zoom(it.toFloat()) }
                                                ?: current.maxZoom,
                                )
                }

                settings.followReturnDelaySeconds?.let {
                        navigationManager.mapFollowController.followReturnDelay = Duration.ofSeconds(it)
                }
        }

        private fun toSpeedRangeToStyleZoom(rule: SpeedZoomRule): SpeedRangeToStyleZoom =
                SpeedRangeToStyleZoom(
                        range = SpeedRange(minSpeed = rule.minSpeed, maxSpeed = rule.maxSpeed),
                        minDistanceToManeuver =
                                RouteDistance(millimeters = rule.minDistanceToManeuverMm.toLong()),
                        maxDistanceToManeuver =
                                RouteDistance(millimeters = rule.maxDistanceToManeuverMm.toLong()),
                        styleZoom = StyleZoom(value = rule.styleZoom.toFloat()),
                )

        private fun tiltRelationOf(points: List<StyleZoomTiltPoint>): StyleZoomToTiltRelation =
                object : StyleZoomToTiltRelation {
                        override fun styleZoomToTilt(styleZoom: StyleZoom): Tilt =
                                Tilt(interpolateTilt(points, styleZoom.value.toDouble()))
                }

        /** Linear interpolation of tilt across the zoom→tilt curve, clamped at the endpoints. */
        private fun interpolateTilt(points: List<StyleZoomTiltPoint>, zoom: Double): Float {
                if (points.isEmpty()) return 0f
                val sorted = points.sortedBy { it.styleZoom }
                if (zoom <= sorted.first().styleZoom) return sorted.first().tiltDegrees.toFloat()
                if (zoom >= sorted.last().styleZoom) return sorted.last().tiltDegrees.toFloat()
                for (i in 0 until sorted.size - 1) {
                        val a = sorted[i]
                        val b = sorted[i + 1]
                        if (zoom in a.styleZoom..b.styleZoom) {
                                val t = (zoom - a.styleZoom) / (b.styleZoom - a.styleZoom)
                                return (a.tiltDegrees + t * (b.tiltDegrees - a.tiltDegrees)).toFloat()
                        }
                }
                return sorted.last().tiltDegrees.toFloat()
        }

        fun followNavigation() {
                map.camera.setBehaviour(
                        behaviour = navigationManager.mapFollowController.cameraBehaviour
                )
                this.startFollowNavigation()
        }

        fun startFollowNavigation() {

                navigationManager.mapFollowController.setFollow(true)
                // Delay before returning to follow mode. Default is 15 seconds
                navigationManager.mapFollowController.followReturnDelay = Duration.ofSeconds(15)
        }

        fun stopFollowNavigation() {

                navigationManager.mapFollowController.setFollow(false)
                // Disable foollow return delay
                navigationManager.mapFollowController.followReturnDelay = Duration.ZERO
        }

        fun resetCamera() {
                // Drop the navigation tilt-by-zoom controller so the chase pitch does not leak into
                // normal map mode after navigation ends.
                tiltFollowController?.let { map.camera.removeFollowController(it) }
                tiltFollowController = null

                if (this.prevCameraBehaviour != null) {
                        map.camera.setBehaviour(this.prevCameraBehaviour!!)
                }
                
                // Restore the original graphics preset if it was stored
                // This preserves traffic layer colors when freeroam ends
                if (prevGraphicsPreset != null) {
                        map.graphicsPreset = prevGraphicsPreset!!
                        prevGraphicsPreset = null
                }

                if (oldSource != null) {
                        if (map.sources.isNotEmpty()) {
                                map.removeSource(map.sources.first { it is MyLocationMapObjectSource })
                        }
                        map.addSource(oldSource!!)
                        oldSource = null
                }
        }

        override fun close() {
                dashboardControlModel.close()
                messageControlModel.close()
                speedControlModel.close()
                stateClosable.close()
                routeInfoCloseable.close()
                speedControlModel.close()
                maneuverControlModel.close()
                betterRouteCloseable.close()
        }

        fun toggleVoiceInstruction(toggleType: SoundToggleType) {
                dashboardControlModel.toggleVoiceInstruction(toggleType)
        }

        fun setNavigatorVoice(id: String, callback: (Result<Unit>) -> Unit) {
                navigationManager.voiceSelector.voice =
                        voicesManager.voices.firstOrNull { it.id == id }?.navigationVoice
                callback(Result.success(Unit))
        }

        fun toggleRoadCameras(roadCameras: Boolean) {
                dashboardControlModel.toggleRoadCameras(roadCameras)
        }

        fun toggleOverSpeeding(overSpeeding: Boolean) {
                dashboardControlModel.toggleOverSpeeding(overSpeeding)
        }

        fun setNavigatorVolume(volume: Int) {
                dashboardControlModel.setNavigatorVolume(volume)
        }

        fun muteOtherSounds(mute: Boolean) {
                dashboardControlModel.muteOtherSounds(mute)
        }

        fun saveNavigationState(callback: (Result<ByteArray>) -> Unit) {
                val state = PackedNavigationState.fromModel(model = this.navigationManager.uiModel)
                callback(Result.success(state.toBytes()))
        }

        fun restoreNavigationState(
                state: ByteArray,
                speedRangeZoom: List<SpeedRangeZoom>,
                callback: (Result<Unit>) -> Unit
        ) {
                try {
                        val state = PackedNavigationState.fromBytes(state)
                        this.startNavigation(
                                finishPoint = state.finishPoint,
                                options = state.routeSearchOptions,
                                route = state.trafficRoute,
                                speedRangeZoom = speedRangeZoom,
                                callback = callback
                        )
                } catch (e: Exception) {
                        callback(Result.failure(e))
                        return
                }
        }

        fun getCurrentNavigationState(callback: (Result<NavigationStateMessage>) -> Unit) {
                val state =
                        when (navigationManager.uiModel.state) {
                                State.NAVIGATION, State.ROUTE_SEARCH -> NavigationState.NAVIGATION
                                State.FINISHED -> NavigationState.FINISH
                                State.DISABLED -> NavigationState.DISABLED
                        }
                val options =
                        navigationManager.uiModel.route.routeBuildOptions?.routeSearchOptions
                                ?.toRouteSearchOptionsMessage()
                callback(
                        Result.success(
                                NavigationStateMessage(state = state, routeSearchOptions = options)
                        )
                )
        }

        fun startNavigation(
                finishPoint: RouteSearchPoint?,
                options: RouteSearchOptions?,
                route: TrafficRoute?,
                speedRangeZoom: List<SpeedRangeZoom>,
                callback: (Result<Unit>) -> Unit,
        ) {
                if (finishPoint == null || options == null || route == null) {
                        callback(
                                Result.failure(
                                        Exception(
                                                "Not enough data to start navigation. Check RouteHandler documentation"
                                        )
                                )
                        )
                        return
                }

                setupCamera(speedRangeZoom = speedRangeZoom)

                if (oldSource == null && map.sources.isNotEmpty()) {
                        oldSource = map.sources.first { it is MyLocationMapObjectSource }
                        map.removeSource(oldSource!!)
                        map.addSource(
                                MyLocationMapObjectSource(
                                        context = this.context,
                                        controllerSettings =
                                                MyLocationControllerSettings(
                                                        coordinatesThreshold = Meter(10.0f),
                                                        bearingThreshold = Bearing(90.0)
                                                )
                                )
                        )
                }

                if (!options.isPublicTransport) {
                        navigationManager.start(
                                routeBuildOptions =
                                        RouteBuildOptions(
                                                finishPoint = finishPoint,
                                                routeSearchOptions = options,
                                        ),
                                trafficRoute = route
                        )
                }

                callback(Result.success(Unit))
        }

        fun simulationSettings(speed: Double) {
                navigationManager.simulationSettings.speedMode =
                        SimulationSpeedMode(speed = SimulationConstantSpeed(speed))
        }

        fun startSimulation(
                finishPoint: RouteSearchPoint?,
                options: RouteSearchOptions?,
                route: TrafficRoute?,
                speedRangeZoom: List<SpeedRangeZoom>,
                callback: (Result<Unit>) -> Unit,
        ) {
                if (finishPoint == null || options == null || route == null) {
                        callback(
                                Result.failure(
                                        Exception(
                                                "Not enough data to start navigation. Check RouteHandler documentation"
                                        )
                                )
                        )
                        return
                }

                setupCamera(speedRangeZoom = speedRangeZoom)

                if (!options.isPublicTransport) {
                        navigationManager.startSimulation(
                                routeBuildOptions =
                                        RouteBuildOptions(
                                                finishPoint = finishPoint,
                                                routeSearchOptions = options,
                                        ),
                                trafficRoute = route
                        )
                }

                callback(Result.success(Unit))
        }

        fun stopNavigation() {
                navigationManager.stop()
                resetCamera()
        }

        fun startFreeRoam(speedRangeZoom: List<SpeedRangeZoom>) {
                setupCamera(speedRangeZoom = speedRangeZoom)
                navigationManager.start()
        }

        fun stopFreeRoam() {
                navigationManager.stop()
                resetCamera()
        }

        private fun stateChannelListener(state: State) {
                when (state) {
                        State.DISABLED -> {
                                eventSink.success(
                                        mapOf(
                                                "event" to Event.navigationEvent.name,
                                                "state" to Event.stateDisabled
                                        )
                                )
                                isNavigating = false
                        }
                        State.FINISHED -> {
                                eventSink.success(
                                        mapOf(
                                                "event" to Event.navigationEvent.name,
                                                "state" to Event.stateFinished
                                        )
                                )
                                stopNavigation()
                                isNavigating = false
                        }
                        State.NAVIGATION -> {
                                eventSink.success(
                                        mapOf(
                                                "event" to Event.navigationEvent.name,
                                                "state" to Event.stateNavigation
                                        )
                                )
                                isNavigating = true
                        }
                        State.ROUTE_SEARCH -> {
                                eventSink.success(
                                        mapOf(
                                                "event" to Event.navigationEvent.name,
                                                "state" to Event.stateRouteSearch
                                        )
                                )
                                isNavigating = true
                        }
                }
        }

        fun onRouteTap(route: RouteMapObject) {
                val trafficRoute = route.route
                if (!route.isActive) {
                        this.navigationManager.alternativeRouteSelector.selectAlternativeRoute(
                                trafficRoute
                        )
                        betterRouteResponse(BetterRouteResponseMessage.ACCEPT)
                }
        }

        private fun routeInfoListener(routeInfo: RouteInfo) {
                eventSink.success(
                        mapOf(
                                "event" to Event.routeOptionsEvent.name,
                                "hasOptions" to (routeInfo.routeBuildOptions != null)
                        )
                )
        }

        private fun betterRouteListener(routeInfo: BetterRouteInfo?) {
                val activeRouteDuration = navigationManager.uiModel.duration?.inSeconds
                val betterRouteDuration =
                        routeInfo?.trafficRoute?.route?.geometry?.first?.point?.let {
                                routeInfo.trafficRoute.traffic.durations.calculateDuration(it)
                                        .inSeconds
                        }
                val durationProfit =
                        if (activeRouteDuration != null && betterRouteDuration != null)
                                (activeRouteDuration - betterRouteDuration).toInt()
                        else 0
                eventSink.success(
                        mapOf(
                                "event" to Event.betterRouteEvent.name,
                                "route" to
                                        if (routeInfo != null)
                                                RouteHandler.mapRouteInfo(routeInfo.trafficRoute)
                                        else null,
                                "durationProfit" to durationProfit,
                        )
                )
        }

        fun betterRouteResponse(response: BetterRouteResponseMessage) {
                when (response) {
                        BetterRouteResponseMessage.ACCEPT ->
                                this.navigationManager.uiModel.betterRouteResponse(
                                        BetterRouteResponse.ACCEPT
                                )
                        BetterRouteResponseMessage.REJECT ->
                                this.navigationManager.uiModel.betterRouteResponse(
                                        BetterRouteResponse.REJECT
                                )
                        BetterRouteResponseMessage.TIMEOUT ->
                                this.navigationManager.uiModel.betterRouteResponse(
                                        BetterRouteResponse.TIMEOUT
                                )
                }
        }

        fun getBetterRouteSettings(callback: (Result<BetterRouteSettingsMessage>) -> Unit) {
                val settings = navigationManager.alternativeRoutesProviderSettings
                callback(
                        Result.success(
                                BetterRouteSettingsMessage(
                                        betterRouteTimeCostThreshold =
                                                settings.betterRouteTimeCostThreshold.inSeconds,
                                        betterRouteLengthThreshold =
                                                settings.betterRouteLengthThreshold.millimeters,
                                        routeSearchDelay =
                                                settings.routeSearchDelay.inSeconds,
                                )
                        )
                )
        }

        fun setBetterRouteSettings(settings: BetterRouteSettingsMessage) {
                navigationManager.alternativeRoutesProviderSettings.routeSearchDelay =
                        Duration.ofSeconds(settings.routeSearchDelay)
                navigationManager.alternativeRoutesProviderSettings.betterRouteTimeCostThreshold =
                        Duration.ofSeconds(settings.betterRouteTimeCostThreshold)
                navigationManager.alternativeRoutesProviderSettings.betterRouteLengthThreshold =
                        RouteDistance(settings.betterRouteLengthThreshold)
        }

        fun setBetterRouteEnabled(enabled: Boolean) {
                navigationManager.alternativeRoutesProviderSettings.betterRouteEnabled = enabled
        }

        fun calcPositionForRoute(
                options: CalcPositionOptionsMessage,
                callback: (Result<CameraPositionMessage>) -> Unit
        ) {
                val geometries =
                        navigationManager.uiModel.route.route.geometry.entries.map { entry ->
                                PointGeometry(entry.value)
                        }
                val geometry = ComplexGeometry(geometries)

                val cameraPosition =
                        calcPosition(
                                camera = map.camera,
                                geometry = geometry,
                                screenArea =
                                        options.screenArea?.let {
                                                Padding(
                                                        left = it.leftPadding.toInt(),
                                                        top = it.topPadding.toInt(),
                                                        right = it.rightPadding.toInt(),
                                                        bottom = it.bottomPadding.toInt()
                                                )
                                        },
                                tilt = options.tilt?.let { Tilt(it.toFloat()) },
                                bearing = options.bearing?.let { Bearing(it) },
                                size =
                                        options.size?.let {
                                                ScreenSize(
                                                        width = it.width.toInt(),
                                                        height = it.height.toInt()
                                                )
                                        }
                        )
                callback(
                        Result.success(
                                CameraPositionMessage(
                                        point = cameraPosition.point.toMessage(),
                                        zoom = cameraPosition.zoom.value.toDouble(),
                                        tilt = cameraPosition.tilt.value.toDouble(),
                                        bearing = cameraPosition.bearing.value,
                                )
                        )
                )
        }
}

private enum class Event {
        // event name
        navigationEvent,
        routeOptionsEvent,
        betterRouteEvent;

        // event values
        companion object {

                val stateDisabled = "disabled"
                val stateFinished = "finished"
                val stateNavigation = "navigation"
                val stateRouteSearch = "routeSearch"
        }
}
