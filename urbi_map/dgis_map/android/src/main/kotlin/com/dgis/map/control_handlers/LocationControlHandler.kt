package com.dgis.map.control_handlers

import com.dgis.map.map_api.Messages
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.map.CameraBehaviour
import ru.dgis.sdk.map.FollowBearing
import ru.dgis.sdk.map.FollowPosition
import ru.dgis.sdk.map.FollowStyleZoom
import ru.dgis.sdk.map.FollowTilt
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.MyLocationControlModel

class LocationControlHandler(
    private val map: Map,
    eventSink: EventChannel.EventSink,
) : AutoCloseable {
    private val model = MyLocationControlModel(map)
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

    fun setFollowState(state: Messages.FollowStateMessage) {
        val prevBehaviour = map.camera.behaviour.newBehaviour

        val behaviour = when (state) {
            Messages.FollowStateMessage.OFF -> CameraBehaviour(
                position = null,
                tilt = prevBehaviour.tilt
            )
            Messages.FollowStateMessage.FOLLOW_POSITION -> CameraBehaviour(
                position = FollowPosition(
                    bearing = FollowBearing.OFF,
                    styleZoom = prevBehaviour.position?.styleZoom ?: FollowStyleZoom.OFF,
                ),
                tilt = prevBehaviour.tilt
            )
            Messages.FollowStateMessage.FOLLOW_DIRECTION -> CameraBehaviour(
                position = FollowPosition(
                    bearing = FollowBearing.ON,
                    styleZoom = prevBehaviour.position?.styleZoom ?: FollowStyleZoom.OFF,
                ),
                tilt = prevBehaviour.tilt
            )
        }

        map.camera.setBehaviour(behaviour)
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
