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

    // A single shared source: the SDK only supports one active RoadEventSource per map, so
    // Traffic and the explicit "Road Events" button both contribute categories into the same
    // instance instead of each owning their own.
    private val roadEventsSource by unsafeLazy {
        RoadEventSource(sdk)
    }

    private var trafficWantsRoadEvents = false
    private var buttonWantsRoadEvents = false

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
                TrafficControlStatus.ENABLED -> {
                    trafficWantsRoadEvents = true
                    updateRoadEventsSource()
                }
                TrafficControlStatus.DISABLED -> {
                    trafficWantsRoadEvents = false
                    updateRoadEventsSource()
                }
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
    }

    private fun updateRoadEventsSource() {
        val categories = EnumSet.noneOf(RoadEventDisplayCategory::class.java)
        if (trafficWantsRoadEvents) {
            categories.add(RoadEventDisplayCategory.ROAD_RESTRICTION)
        }
        if (buttonWantsRoadEvents) {
            categories.addAll(EnumSet.allOf(RoadEventDisplayCategory::class.java))
        }

        if (categories.isEmpty()) {
            if (map.sources.contains(roadEventsSource)) {
                map.removeSource(roadEventsSource)
            }
            return
        }

        roadEventsSource.visibleEvents = categories
        if (!map.sources.contains(roadEventsSource)) {
            map.addSource(roadEventsSource)
        }
    }

    fun addRoadEventSource() {
        buttonWantsRoadEvents = true
        updateRoadEventsSource()
    }

    fun removeRoadEventSource() {
        buttonWantsRoadEvents = false
        updateRoadEventsSource()
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

