package com.dgis.map.control_handlers

import android.view.View
import com.dgis.map.control_handlers.navigation_controls.DashboardControlModel
import com.dgis.map.control_handlers.navigation_controls.MessageControlModel
import com.dgis.map.control_handlers.navigation_controls.ManeuverControlModel
import com.dgis.map.control_handlers.navigation_controls.SpeedControlModel
import com.dgis.map.map_api.Messages.Result
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.navigation.*
import ru.dgis.sdk.routing.RouteSearchOptions
import ru.dgis.sdk.routing.RouteSearchPoint
import ru.dgis.sdk.routing.TrafficRoute
import ru.dgis.sdk.Context as SdkContext

class NavigationHandler(
    sdkContext: SdkContext,
    private val navigationView: NavigationView,
    private val eventSink: EventChannel.EventSink,
) : AutoCloseable {
    private val navigationManager = NavigationManager(sdkContext)
    private lateinit var dashboardControlModel: DashboardControlModel

    private val stateClosable: AutoCloseable
    private val routeInfoCloseable: AutoCloseable

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
        navigationView.visibility = View.INVISIBLE
        navigationView.navigationManager = navigationManager

        navigationManager.alternativeRoutesProviderSettings.alternativeRoutesEnabled = false
        navigationManager.alternativeRoutesProviderSettings.betterRouteEnabled = false

        dashboardControlModel = DashboardControlModel(
            navigationManager.uiModel,
            eventSink,
            navigationManager,
        )

        stateClosable = navigationManager.uiModel.stateChannel.connect(::stateChannelListener)
        routeInfoCloseable = navigationManager.uiModel.routeChannel.connect(::routeInfoListener)
    }

    override fun close() {
        dashboardControlModel.close()
        messageControlModel.close()
        speedControlModel.close()
        stateClosable.close()
        routeInfoCloseable.close()
        speedControlModel.close()
        maneuverControlModel.close()
    }

    fun toggleSounds() {
        dashboardControlModel.toggleSounds()
    }

    fun startNavigation(
        finishPoint: RouteSearchPoint?,
        options: RouteSearchOptions?,
        route: TrafficRoute?,
        result: Result<Void>?,
    ) {
        if (finishPoint == null || options == null || route == null) {
            result?.error(Exception("Not enough data to start navigation. Check RouteHandler documentation"))
            return
        }

        navigationManager.start(
            routeBuildOptions = RouteBuildOptions(
                finishPoint = finishPoint,
                routeSearchOptions = options,
            ),
            trafficRoute = route
        )
        navigationView.visibility = View.VISIBLE

        result?.success(null)
    }

    fun startSimulation(
        finishPoint: RouteSearchPoint?,
        options: RouteSearchOptions?,
        route: TrafficRoute?,
        result: Result<Void>?,
    ) {
        if (finishPoint == null || options == null || route == null) {
            result?.error(Exception("Not enough data to start navigation. Check RouteHandler documentation"))
            return
        }

        navigationManager.startSimulation(
            routeBuildOptions = RouteBuildOptions(
                finishPoint = finishPoint,
                routeSearchOptions = options,
            ),
            trafficRoute = route
        )
        navigationView.visibility = View.VISIBLE

        result?.success(null)
    }

    fun stopNavigation() {
        navigationManager.stop()
        navigationView.visibility = View.INVISIBLE
    }

    fun startFreeRoam() {
        navigationManager.start()
    }

    fun stopFreeRoam() {
        navigationManager.stop()
    }

    private fun stateChannelListener(state: State) {
        when (state) {
            State.DISABLED -> eventSink.success(
                mapOf(
                    "event" to Event.navigationEvent.name,
                    "state" to Event.stateDisabled
                )
            )

            State.FINISHED -> eventSink.success(
                mapOf(
                    "event" to Event.navigationEvent.name,
                    "state" to Event.stateFinished
                )
            )

            else -> {}
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
}

private enum class Event {
    // event name
    navigationEvent,
    routeOptionsEvent;

    // event values
    companion object {

        val stateDisabled = "disabled";
        val stateFinished = "finished";
    }
}
