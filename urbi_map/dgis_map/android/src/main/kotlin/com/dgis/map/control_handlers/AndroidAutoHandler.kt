package com.dgis.map.control_handlers

import android.content.Context
import androidx.car.app.connection.CarConnection
import io.flutter.plugin.common.EventChannel

class AndroidAutoHandler(
    context: Context,
    private val eventSink: EventChannel.EventSink,
) : AutoCloseable {

    private val carConnection = CarConnection(context)

    init {
        carConnection.type.observeForever(::onConnectionStateUpdated)
    }

    fun getConnectionState(): Boolean {
        return carConnection.type.value == CarConnection.CONNECTION_TYPE_PROJECTION
    }

    private fun onConnectionStateUpdated(connectionState: Int) {
        val connected = when (connectionState) {
            CarConnection.CONNECTION_TYPE_PROJECTION -> true
            else -> false
        }

        eventSink.success(
            mapOf(
                "event" to Event.carConnectionEvent.name,
                "connected" to connected,
            )
        )
    }

    override fun close() {
        carConnection.type.removeObserver(::onConnectionStateUpdated)
    }

    private enum class Event {
        carConnectionEvent;
    }
}

