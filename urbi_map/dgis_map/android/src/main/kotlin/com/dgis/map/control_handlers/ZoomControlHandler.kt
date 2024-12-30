package com.dgis.map.control_handlers

import android.util.Log
import com.dgis.map.map_api.*
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.ZoomControlButton
import ru.dgis.sdk.map.ZoomControlModel

class ZoomControlHandler(
    map: Map,
    eventSink: EventChannel.EventSink,
) : AutoCloseable {

    private val zoomControlModel = ZoomControlModel(map)
    private val closeables = mutableListOf<AutoCloseable>()

    init {
        closeables.add(
            zoomControlModel.isEnabled(ZoomControlButton.ZOOM_IN).connect { isEnabled ->
                eventSink.success(
                    mapOf(
                        "event" to Events.zoomInEvent.name,
                        "value" to isEnabled,
                    )
                )
            },
        )
        closeables.add(
            zoomControlModel.isEnabled(ZoomControlButton.ZOOM_OUT).connect { isEnabled ->
                eventSink.success(
                    mapOf(
                        "event" to Events.zoomOutEvent.name,
                        "value" to isEnabled,
                    )
                )
            },
        )
    }

    fun onZoomDown(type: ZoomControlMessage) {
        zoomControlModel.setPressed(type.toButton, true)
    }

    fun onZoomUp(type: ZoomControlMessage) {
        zoomControlModel.setPressed(type.toButton, false)
    }

    override fun close() {
        closeables.forEach(AutoCloseable::close)
        closeables.clear()
    }

    private val ZoomControlMessage.toButton: ZoomControlButton
        get() = when (this) {
            ZoomControlMessage.ZOOM_IN -> ZoomControlButton.ZOOM_IN
            ZoomControlMessage.ZOOM_OUT -> ZoomControlButton.ZOOM_OUT
        }

    companion object {
        private enum class Events {
            zoomOutEvent,
            zoomInEvent,
        }
    }
}
