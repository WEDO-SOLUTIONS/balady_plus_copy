package com.dgis.map.control_handlers

import com.dgis.map.extensions.unsafeLazy
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.map.CompassControlModel
import ru.dgis.sdk.map.Map

class CompassControlHandler(
        private val map: Map,
        private val eventSink: EventChannel.EventSink
): AutoCloseable {

    private val closeables = mutableListOf<AutoCloseable>()
    private val compassControlModel by unsafeLazy {
        CompassControlModel(map = map)
    }

    init {
        closeables.add(compassControlModel.bearingChannel.connect {
            eventSink.success(
                mapOf(
                   "event" to Events.compassBearingChanged.name,
                   "value" to it.value
                )
            )
        })
    }

    fun onClicked() {
        compassControlModel.onClicked()
    }


    override fun close() {
        closeables.forEach {
            it.close()
        }
        closeables.clear()
    }

    companion object {
        private enum class Events {
            compassBearingChanged,
        }
    }

}