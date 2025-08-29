package com.dgis.map.control_handlers.public_transport

import android.app.usage.UsageEvents.Event
import com.dgis.map.control_handlers.RouteHandler
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.routing.TrafficRoute

class PublicTransportHandler(
    private val eventSink: EventChannel.EventSink,
    private  val routeHandler: RouteHandler,
) {
    private enum class Events {
        onPublicTransportRoutesChanged,
        onPublicTransportActiveRouteChanged
    }

    fun onRoutesChanged() {
        val trafficRoutes = routeHandler.getPublicTransportRoutes()

        val briefs = trafficRoutes.map(::BriefPublicTransportModel)

        eventSink.success(mapOf(
            "event" to Events.onPublicTransportRoutesChanged.name,
            "routes" to briefs.map(BriefPublicTransportModel::toMap),
        ))
    }

    fun onActiveRouteChanged() {
        routeHandler.getActivePublicTransportRoute()?.let {
            eventSink.success(mapOf(
                "event" to Events.onPublicTransportActiveRouteChanged.name,
                "route" to PublicTransportModel(it).toMap(),
            ))
        }
    }
}


