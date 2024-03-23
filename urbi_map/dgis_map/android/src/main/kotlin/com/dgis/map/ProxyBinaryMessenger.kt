package com.dgis.map

import io.flutter.plugin.common.BinaryMessenger
import java.nio.ByteBuffer

class ProxyBinaryMessenger(
        private val messenger: BinaryMessenger,
        private val nameSuffix: String,
) : BinaryMessenger {

    private fun String.appendSuffix() = "$this$nameSuffix"

    override fun send(channel: String, message: ByteBuffer?) {
        messenger.send(channel.appendSuffix(), message)
    }

    override fun send(channel: String, message: ByteBuffer?, callback: BinaryMessenger.BinaryReply?) {
        messenger.send(channel.appendSuffix(), message, callback)
    }

    override fun setMessageHandler(channel: String, handler: BinaryMessenger.BinaryMessageHandler?) {
        messenger.setMessageHandler(channel.appendSuffix(), handler)
    }
}
