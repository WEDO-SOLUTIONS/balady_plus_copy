package com.dgis.map.control_handlers

import com.dgis.map.extensions.unsafeLazy
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.Context
import ru.dgis.sdk.map.AttributeValue
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.RoadEventDisplayCategory
import ru.dgis.sdk.map.RoadEventSource
import ru.dgis.sdk.traffic.TrafficControlModel
import ru.dgis.sdk.traffic.TrafficControlStatus
import java.util.EnumSet

class TrafficAndParkingControlHandler(
        private val sdk: Context,
        private val map: Map,
        private val eventSink: EventChannel.EventSink)
    : AutoCloseable {

    private val closeables = mutableListOf<AutoCloseable>()
    private val parkingAttrName = "parkingOn"
    private val parkingFilterAttrName = "parkingFilter"

    private val trafficControlModel by unsafeLazy {
        TrafficControlModel(map = map)
    }

    private val roadEventsSource by unsafeLazy {
        val source = RoadEventSource(sdk)
        source.visibleEvents = EnumSet.of(RoadEventDisplayCategory.ROAD_RESTRICTION);

        source
    }

    private var Map.isParkingOn: Boolean
        get() {
            return attributes.getAttributeValue(parkingAttrName).asBoolean == true
        }
        set(value) {
            attributes.setAttributeValue(parkingAttrName, AttributeValue(value))
        }

    fun onAttachToMap() {
        closeables += map.attributes.changed.connect { attributes ->
            if (attributes.contains(parkingAttrName) || attributes.contains(parkingFilterAttrName)) {
                eventSink.success(
                    mapOf(
                        "event" to Companion.Events.parkingStateChanged.name,
                        "visible" to map.isParkingOn,
                        "filterAttribute" to map.attributes.getAttributeValue(parkingFilterAttrName).asString
                    )
                )
            }
        }

        closeables += trafficControlModel.stateChannel.connect {
            when (it.status) {
                TrafficControlStatus.ENABLED -> enableRoadEvents()
                TrafficControlStatus.DISABLED -> disableRoadEvents()
                else -> {}
            }
            eventSink.success(
                    mapOf(
                        "event" to Companion.Events.trafficStateChanged.name,
                        "status" to it.status.value,
                        "score" to (it.score ?: 0),
                    )
            )
        }

        eventSink.success(
            mapOf(
                "event" to Companion.Events.trafficStateChanged.name,
                "status" to trafficControlModel.state.status.value,
                "score" to (trafficControlModel.state.score ?: 0),
            )
        )
    }

    private fun enableRoadEvents() {
        if (!map.sources.contains(roadEventsSource)) {
            map.addSource(roadEventsSource)
        }
    }

    private fun disableRoadEvents() {
        map.removeSource(roadEventsSource)
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

