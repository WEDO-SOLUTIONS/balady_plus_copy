package com.dgis.map.control_handlers

import com.dgis.map.control_handlers.navigation_controls.DashboardControlModel
import com.dgis.map.control_handlers.navigation_controls.MessageControlModel
import com.dgis.map.control_handlers.navigation_controls.ManeuverControlModel
import com.dgis.map.control_handlers.navigation_controls.SpeedControlModel
import com.dgis.map.extensions.toMessage
import com.dgis.map.extensions.toRouteSearchOptionsMessage
import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.BetterRouteResponseMessage
import com.dgis.map.map_api.Messages.BetterRouteSettingsMessage
import com.dgis.map.map_api.Messages.NavigationStateMessage
import com.dgis.map.map_api.Messages.Result
import com.dgis.map.map_api.Messages.SoundToggleType
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.Duration
import ru.dgis.sdk.ScreenSize
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.geometry.ComplexGeometry
import ru.dgis.sdk.geometry.PointGeometry
import ru.dgis.sdk.map.CalloutVisualizationMode
import ru.dgis.sdk.map.CameraBehaviour
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.Padding
import ru.dgis.sdk.map.RouteMapObject
import ru.dgis.sdk.map.RouteMapObjectDisplayFlag
import ru.dgis.sdk.map.StyleZoom
import ru.dgis.sdk.map.Tilt
import ru.dgis.sdk.map.calcPosition
import ru.dgis.sdk.navigation.*
import ru.dgis.sdk.routing.RouteDistance
import ru.dgis.sdk.routing.RouteSearchOptions
import ru.dgis.sdk.routing.RouteSearchPoint
import ru.dgis.sdk.routing.TrafficRoute
import ru.dgis.sdk.Context as SdkContext

class NavigationHandler(
    sdkContext: SdkContext,
    private val navigationManager: NavigationManager,
    private val eventSink: EventChannel.EventSink,
    private val map: Map,
) : AutoCloseable {
    private val voicesManager = getVoiceManager(sdkContext)
    private var dashboardControlModel: DashboardControlModel

    private val stateClosable: AutoCloseable
    private val routeInfoCloseable: AutoCloseable
    private val betterRouteCloseable: AutoCloseable

    private var prevCameraBehaviour: CameraBehaviour? = null

    var isNavigating: Boolean = false
        private set

    // Models to observe channels and send events to Flutter
    private val speedControlModel = SpeedControlModel(
        model = navigationManager.uiModel,
        eventSink = eventSink
    )

    private val messageControlModel = MessageControlModel(
        model = navigationManager.uiModel,
        eventSink = eventSink
    )

    private val maneuverControlModel = ManeuverControlModel(
        model = navigationManager.uiModel,
        eventSink = eventSink,
    )

    init {
        navigationManager.mapManager.addMap(map)

        navigationManager.alternativeRoutesProviderSettings.alternativeRoutesEnabled = false
        navigationManager.routeSourceSettings.calloutVisualizationMode =
            CalloutVisualizationMode.MULTIPLE_ROUTES
        navigationManager.routeMapSettings.onRouteDisplayFlags.add(RouteMapObjectDisplayFlag.IMMERSIVE_ROUTE_PARTS)

        dashboardControlModel = DashboardControlModel(
            navigationManager.uiModel,
            eventSink,
            navigationManager,
        )

        stateClosable = navigationManager.uiModel.stateChannel.connect(::stateChannelListener)
        routeInfoCloseable = navigationManager.uiModel.routeChannel.connect(::routeInfoListener)
        betterRouteCloseable =
            navigationManager.uiModel.betterRouteChannel.connect(::betterRouteListener)

    }

    fun setupCamera(speedRangeZoom: Messages.SpeedRangeZoom) {
        prevCameraBehaviour = map.camera.behaviour.newBehaviour
        map.camera.setBehaviour(
            behaviour = navigationManager.mapFollowController.cameraBehaviour
        )

        navigationManager.mapFollowController.setFollow(true)
        navigationManager.zoomFollowSettings.speedRangeToStyleZoomSequence = listOf(
            SpeedRangeToStyleZoom(
                range = SpeedRange(
                    minSpeed = speedRangeZoom.minSpeedRange,
                    maxSpeed = speedRangeZoom.maxSpeedRange
                ),
                minDistanceToManeuver = RouteDistance(millimeters = speedRangeZoom.routeDistanceMillimeters.toLong()),
                maxDistanceToManeuver = RouteDistance(millimeters = speedRangeZoom.routeDistanceMillimeters.toLong()),
                styleZoom = StyleZoom(value = speedRangeZoom.styleZoomValue.toFloat())
            )
        )
    }

    fun followNavigation() {
        map.camera.setBehaviour(
            behaviour = navigationManager.mapFollowController.cameraBehaviour
        )
        navigationManager.mapFollowController.setFollow(true)
    }

    fun resetCamera() {
        if (this.prevCameraBehaviour != null) {
            map.camera.setBehaviour(this.prevCameraBehaviour!!)
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

    fun setNavigatorVoice(id: String, result: Messages.Result<Void>?) {
        navigationManager.voiceSelector.voice =
            voicesManager.voices.firstOrNull { it.id == id }?.navigationVoice
        result?.success(null)
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

    fun saveNavigationState(result: Result<ByteArray>?) {
        val state = PackedNavigationState.fromModel(model = this.navigationManager.uiModel)
        result?.success(state.toBytes())
    }

    fun restoreNavigationState(
        state: ByteArray,
        speedRangeZoom: Messages.SpeedRangeZoom,
        result: Messages.Result<Void>?
    ) {
        try {
            val state = PackedNavigationState.fromBytes(state)
            this.startNavigation(
                finishPoint = state.finishPoint,
                options = state.routeSearchOptions,
                route = state.trafficRoute,
                speedRangeZoom = speedRangeZoom,
                result = result
            )
        } catch (e: Exception) {
            result?.error(e)
            return
        }
    }

    fun getCurrentNavigationState(result: Result<NavigationStateMessage>) {
        val state = when (navigationManager.uiModel.state) {
            State.NAVIGATION, State.ROUTE_SEARCH -> Messages.NavigationState.NAVIGATION
            State.FINISHED -> Messages.NavigationState.FINISH
            State.DISABLED -> Messages.NavigationState.DISABLED
        }
        val options =
            navigationManager.uiModel.route.routeBuildOptions?.routeSearchOptions?.toRouteSearchOptionsMessage()
                ?: Messages.RouteSearchOptionsMessage.CAR
        result.success(
            NavigationStateMessage.Builder().setState(state)
                .setRouteSearchOptions(options).build()
        )
    }

    fun startNavigation(
        finishPoint: RouteSearchPoint?,
        options: RouteSearchOptions?,
        route: TrafficRoute?,
        speedRangeZoom: Messages.SpeedRangeZoom,
        result: Result<Void>?,
    ) {
        if (finishPoint == null || options == null || route == null) {
            result?.error(Exception("Not enough data to start navigation. Check RouteHandler documentation"))
            return
        }

        setupCamera(speedRangeZoom = speedRangeZoom)
        navigationManager.start(
            routeBuildOptions = RouteBuildOptions(
                finishPoint = finishPoint,
                routeSearchOptions = options,
            ),
            trafficRoute = route
        )

        result?.success(null)
    }

    fun simulationSettings(speed: Double) {
        navigationManager.simulationSettings.speedMode = SimulationSpeedMode(speed =  SimulationConstantSpeed(speed))
    }

    fun startSimulation(
        finishPoint: RouteSearchPoint?,
        options: RouteSearchOptions?,
        route: TrafficRoute?,
        speedRangeZoom: Messages.SpeedRangeZoom,
        result: Result<Void>?,
    ) {
        if (finishPoint == null || options == null || route == null) {
            result?.error(Exception("Not enough data to start navigation. Check RouteHandler documentation"))
            return
        }

        setupCamera(speedRangeZoom = speedRangeZoom)
        navigationManager.startSimulation(
            routeBuildOptions = RouteBuildOptions(
                finishPoint = finishPoint,
                routeSearchOptions = options,
            ),
            trafficRoute = route
        )

        result?.success(null)
    }

    fun stopNavigation() {
        navigationManager.stop()
        resetCamera()
    }

    fun startFreeRoam(speedRangeZoom: Messages.SpeedRangeZoom) {
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
                isNavigating = true
            }

            State.ROUTE_SEARCH -> {
                isNavigating = true
            }
        }
    }

    fun onRouteTap(route: RouteMapObject) {
        val trafficRoute = route.route
        if (!route.isActive) {
            this.navigationManager.alternativeRouteSelector.selectAlternativeRoute(trafficRoute)
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
        val betterRouteDuration = routeInfo?.trafficRoute?.route?.geometry?.first?.point?.let {
            routeInfo.trafficRoute.traffic.durations.calculateDuration(
                it
            ).inSeconds
        }
        val durationProfit =
            if (activeRouteDuration != null && betterRouteDuration != null) (activeRouteDuration - betterRouteDuration).toInt() else 0;
        eventSink.success(
            mapOf(
                "event" to Event.betterRouteEvent.name,
                "route" to if (routeInfo != null) RouteHandler.mapRouteInfo(routeInfo.trafficRoute) else null,
                "durationProfit" to durationProfit,
            )
        )
    }

    fun betterRouteResponse(response: BetterRouteResponseMessage) {
        when (response) {
            BetterRouteResponseMessage.ACCEPT -> this.navigationManager.uiModel.betterRouteResponse(
                BetterRouteResponse.ACCEPT
            )

            BetterRouteResponseMessage.REJECT -> this.navigationManager.uiModel.betterRouteResponse(
                BetterRouteResponse.REJECT
            )

            BetterRouteResponseMessage.TIMEOUT -> this.navigationManager.uiModel.betterRouteResponse(
                BetterRouteResponse.TIMEOUT
            )
        }
    }

    fun getBetterRouteSettings(result: Result<BetterRouteSettingsMessage>?) {
        val settings = navigationManager.alternativeRoutesProviderSettings
        result?.success(
            BetterRouteSettingsMessage.Builder()
                .setRouteSearchDelay(settings.routeSearchDelay.inSeconds)
                .setBetterRouteTimeCostThreshold(settings.betterRouteTimeCostThreshold.inSeconds)
                .setBetterRouteLengthThreshold(settings.betterRouteLengthThreshold.millimeters)
                .build()
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
        navigationManager.alternativeRoutesProviderSettings.betterRouteEnabled =
        enabled
    }

    fun calcPositionForRoute(
        options: Messages.CalcPositionOptionsMessage,
        result: Result<Messages.CameraPositionMessage>?
    ) {
        val geometries = navigationManager.uiModel.route.route.geometry.entries
            .map { entry ->
                PointGeometry(entry.value)
            }
        val geometry = ComplexGeometry(geometries)

        val cameraPosition = calcPosition(
            camera = map.camera,
            geometry = geometry,
            screenArea = options.screenArea?.let {
                Padding(
                    left = it.leftPadding.toInt(),
                    top = it.topPadding.toInt(),
                    right = it.rightPadding.toInt(),
                    bottom = it.bottomPadding.toInt()
                )
            },
            tilt = options.tilt?.let {
                Tilt(it.toFloat())
            },
            bearing = options.bearing?.let {
                Bearing(it)
            },
            size = options.size?.let {
                ScreenSize(
                    width = it.width.toInt(),
                    height = it.height.toInt()
                )
            }
        )

        result?.success(
            Messages.CameraPositionMessage
                .Builder()
                .setPoint(cameraPosition.point.toMessage())
                .setZoom(cameraPosition.zoom.value.toDouble())
                .setTilt(cameraPosition.tilt.value.toDouble())
                .setBearing(cameraPosition.bearing.value)
                .build()
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

        val stateDisabled = "disabled";
        val stateFinished = "finished";
    }
}
