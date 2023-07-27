package com.dgis.map.control_handlers

import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.map.CameraState
import ru.dgis.sdk.map.Map
import java.util.*

class VisibleRectHandler(
    private val map: Map,
    private val eventSink: EventChannel.EventSink
): AutoCloseable {

    private val closeables = mutableListOf<AutoCloseable>()

    init {
        closeables.add(map.camera.visibleRectChannel.connect {
            visibleRectChanged()
        })
    }

    private fun visibleRectChanged() {
        val visibleRect = map.camera.visibleRect
        val zoom = map.camera.position.zoom

        eventSink.success(
            mapOf(
                "event" to Events.visibleRectChanged.name,
                "visibleRect" to mapOf(
                    "northEastLat" to visibleRect.northEastPoint.latitude.value,
                    "northEastLon" to visibleRect.northEastPoint.longitude.value,
                    "southWestLat" to visibleRect.southWestPoint.latitude.value,
                    "southWestLon" to visibleRect.southWestPoint.longitude.value,
                ),
                "zoom" to zoom.value
            )
        )
    }

    override fun close() {
        closeables.forEach(AutoCloseable::close)
        closeables.clear()
    }

    companion object {
        private enum class Events {
            visibleRectChanged,
        }
    }
}