package com.dgis.map.extensions

import android.content.Context
import com.dgis.map.Logger
import com.dgis.map.map_api.LogLevelMessage
import com.dgis.map.map_api.LogOptionsMessage
import ru.dgis.sdk.platform.LogLevel
import ru.dgis.sdk.platform.LogOptions

fun LogOptionsMessage.toLogOptions(context: Context): LogOptions = LogOptions(
    systemLevel = this.systemLevel.toLogLevel(),
    customLevel = this.customLevel.toLogLevel(),
    customSink = this.customSink?.let {
        Logger(context, it)
    }
)

fun LogLevelMessage.toLogLevel(): LogLevel = when (this) {
    LogLevelMessage.VERBOSE -> LogLevel.VERBOSE
    LogLevelMessage.INFO -> LogLevel.INFO
    LogLevelMessage.WARNING -> LogLevel.WARNING
    LogLevelMessage.ERROR -> LogLevel.ERROR
    LogLevelMessage.FATAL -> LogLevel.FATAL
    LogLevelMessage.OFF -> LogLevel.OFF
}
