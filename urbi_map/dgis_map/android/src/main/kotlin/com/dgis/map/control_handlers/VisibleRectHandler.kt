package com.dgis.map.control_handlers

import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.map.CameraChangeReason
import ru.dgis.sdk.map.CameraPosition
import ru.dgis.sdk.map.CameraState
import ru.dgis.sdk.map.Map
import java.util.*

class VisibleRectHandler(
    private val map: Map,
    private val eventSink: EventChannel.EventSink
): AutoCloseable {

    private val closeables = mutableListOf<AutoCloseable>()

    init {
        closeables.add(map.camera.changed.connect { change ->
            if (change.changeReasons.contains(CameraChangeReason.VISIBLE_RECT)) {
                visibleRectChanged()
            }
            if (change.changeReasons.contains(CameraChangeReason.POSITION)) {
                positionChanged(map.camera.position)
            }
            if (change.changeReasons.contains(CameraChangeReason.STATE)) {
                stateChanged(map.camera.state)
            }
        })
    }

    private fun stateChanged(state: CameraState) {
        eventSink.success(
            mapOf(
                "event" to Events.cameraStateChanged.name,
                "state" to when (state) {
                    CameraState.BUSY -> "busy"
                    CameraState.FLY -> "fly"
                    CameraState.FREE -> "free"
                }
            )
        )
    }

    private fun positionChanged(position: CameraPosition) {
        eventSink.success(
            mapOf(
                "event" to Events.cameraPositionChanged.name,
                "point" to mapOf(
                    "latitude" to position.point.latitude.value,
                    "longitude" to position.point.longitude.value
                ),
                "zoom" to position.zoom.value,
                "tilt" to position.tilt.value,
                "bearing" to position.bearing.value
            )
        )
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
            cameraPositionChanged,
            cameraStateChanged
        }
    }
}
