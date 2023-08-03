package com.dgis.map

import io.flutter.plugin.common.EventChannel

class DgisStreamHandler(private val eventSink: QueuingEventSink) : EventChannel.StreamHandler {
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink.setDelegate(events)
    }

    override fun onCancel(arguments: Any?) {
        eventSink.setDelegate(null)
    }
}