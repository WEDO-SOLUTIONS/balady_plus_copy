package com.dgis.map.control_handlers.public_transport

import android.os.Handler
import android.os.Looper
import com.dgis.map.control_handlers.RouteHandler
import io.flutter.plugin.common.EventChannel
import java.util.Timer
import java.util.TimerTask
import kotlin.math.*

class PublicTransportHandler(
    private val eventSink: EventChannel.EventSink,
    private val routeHandler: RouteHandler,
) {
    private enum class Events {
        onPublicTransportRoutesChanged,
        onPublicTransportActiveRouteChanged
    }

    private var updateTimer: Timer? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    companion object {
        private const val UPDATE_INTERVAL_MS = 10_000L
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
        startDurationUpdates()
    }

    fun startDurationUpdates() {
        stopDurationUpdates()
        updateTimer = Timer()
        updateTimer?.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                mainHandler.post { sendUpdatedRoute() }
            }
        }, UPDATE_INTERVAL_MS, UPDATE_INTERVAL_MS)
    }

    fun stopDurationUpdates() {
        updateTimer?.cancel()
        updateTimer = null
    }

    private fun sendUpdatedRoute() {
        val route = routeHandler.getActivePublicTransportRoute() ?: return
        val location = routeHandler.getLastLocation() ?: return

        val entries = route.route.geometry.entries
        if (entries.isEmpty()) return

        val nearestEntry = entries.minByOrNull { entry ->
            haversineDistanceMeters(
                location.latitude, location.longitude,
                entry.value.latitude.value, entry.value.longitude.value,
            )
        } ?: return

        eventSink.success(mapOf(
            "event" to Events.onPublicTransportActiveRouteChanged.name,
            "route" to PublicTransportModel(route, currentPosition = nearestEntry.point).toMap(),
        ))
    }

    private fun haversineDistanceMeters(
        lat1: Double, lon1: Double,
        lat2: Double, lon2: Double,
    ): Double {
        val r = 6_371_000.0
        val dLat = Math.toRadians(lat2 - lat1)
        val dLon = Math.toRadians(lon2 - lon1)
        val a = sin(dLat / 2).pow(2) +
            cos(Math.toRadians(lat1)) * cos(Math.toRadians(lat2)) * sin(dLon / 2).pow(2)
        return r * 2 * atan2(sqrt(a), sqrt(1 - a))
    }
}
