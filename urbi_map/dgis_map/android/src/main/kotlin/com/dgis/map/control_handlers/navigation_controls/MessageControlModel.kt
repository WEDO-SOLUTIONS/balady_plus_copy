package com.dgis.map.control_handlers.navigation_controls

import com.dgis.map.live_updates.NavLiveEventBus
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.navigation.Model
import ru.dgis.sdk.navigation.State

class MessageControlModel(
    model: Model,
    private val eventSink: EventChannel.EventSink,
) : AutoCloseable {

    private val closeables = mutableListOf<AutoCloseable>()
    private var prevState: State? = null

    init {
        closeables.add(
            model.stateChannel.connect {
                if (it == State.ROUTE_SEARCH && prevState == State.NAVIGATION) {
                    emit(Event.stateRouteResearch)
                } else {
                    emit(Event.stateNone)
                }
                this.prevState = it
            }
        )
        closeables.add(
            model.locationAvailableChannel.connect {
                if (!it && model.state != State.FINISHED && model.state != State.DISABLED) {
                    emit(Event.stateGpsLost)
                } else {
                    emit(Event.stateNone)
                }
            }
        )
    }

    private fun emit(state: String) {
        eventSink.success(
            mapOf(
                "event" to Event.messageEvent.name,
                "state" to state,
            )
        )
        NavLiveEventBus.message.value = state
    }

    override fun close() {
        closeables.forEach(AutoCloseable::close)
        closeables.clear()
    }
}

private enum class Event {
    // event name
    messageEvent;

    // event values
    companion object {
        const val stateGpsLost = "gpsLost"
        const val stateRouteResearch = "routeResearch"
        const val stateNone = "none"
    }
}

