package com.dgis.map.control_handlers

import com.dgis.map.extensions.unsafeLazy
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.map.AttributeValue
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.traffic.TrafficControlModel

class TrafficAndParkingControlHandler(
        private val map: Map,
        private val eventSink: EventChannel.EventSink)
    : AutoCloseable {

    private val closeables = mutableListOf<AutoCloseable>()
    private val parkingAttrName = "parkingOn"

    private val trafficControlModel by unsafeLazy {
        TrafficControlModel(map = map)
    }

    private var Map.isParkingOn: Boolean
        get() {
            return attributes.getAttributeValue(parkingAttrName).asBoolean == true
        }
        set(value) {
            attributes.setAttributeValue(parkingAttrName, AttributeValue(value))
        }

    fun onAttachToMap() {
        closeables += map.attributes.changed.connect {
            if (it.contains(parkingAttrName)) {
                eventSink.success(
                   mapOf(
                       "event" to Companion.Events.parkingStateChanged.name,
                       "visible" to map.isParkingOn
                   )
                )
            }
        }
        closeables += trafficControlModel.stateChannel.connect {
            eventSink.success(
                    mapOf(
                        "event" to Companion.Events.trafficStateChanged.name,
                        "status" to it.status.value,
                         "score" to it.score
                    )
            )
        }
    }

    fun onDetachFromMap() {
        close()
    }

    fun onParkingClicked() {
        map.isParkingOn = !map.isParkingOn
    }

    fun onTrafficClicked() {
        trafficControlModel.onClicked()
    }

    override fun close() {
        closeables.forEach(AutoCloseable::close)
        closeables.clear()
    }

    companion object {
        private enum class Events {
            parkingStateChanged,
            trafficStateChanged,
        }
    }
}

