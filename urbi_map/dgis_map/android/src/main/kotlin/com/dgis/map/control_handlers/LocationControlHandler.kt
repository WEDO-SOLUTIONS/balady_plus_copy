package com.dgis.map.control_handlers

import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.MyLocationControlModel
import ru.dgis.sdk.map.TransitionType

class LocationControlHandler(
    map: Map,
    eventSink: EventChannel.EventSink,
) : AutoCloseable {

    private val model = MyLocationControlModel(map, TransitionType.SMOOTH)
    private val closables = mutableListOf<AutoCloseable>()

    init {
        closables.add(
            model.isEnabledChannel.connect { isEnabled ->
                eventSink.success(
                    mapOf(
                        "event" to Event.locationEnabledEvent.name,
                        "value" to isEnabled
                    )
                )
            },
        )
        closables.add(
            model.followStateChannel.connect { followState ->
                eventSink.success(
                    mapOf(
                        "event" to Event.locationFollowEvent.name,
                        "value" to followState.value
                    )
                )
            }
        )
    }

    fun onTap() {
        model.onClicked()
    }

    override fun close() {
        closables.forEach(AutoCloseable::close)
        closables.clear()
    }

    companion object {
        private enum class Event {
            locationFollowEvent,
            locationEnabledEvent,
        }
    }
}
