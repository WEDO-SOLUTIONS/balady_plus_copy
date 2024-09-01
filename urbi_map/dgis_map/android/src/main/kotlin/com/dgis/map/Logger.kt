package com.dgis.map

import android.content.Context
import android.util.Log
import ru.dgis.sdk.platform.LogLevel
import ru.dgis.sdk.platform.LogMessage
import ru.dgis.sdk.platform.LogSink
import java.io.File
import java.io.PrintWriter
import java.text.SimpleDateFormat
import java.util.*

class Logger(context: Context, logFileName: String) : LogSink {
    private val logFile: PrintWriter
    private val dateFormat: SimpleDateFormat

    private enum class Constants(val format: String) {
        LogMessageFormat("yyyy-MM-dd HH:mm:ss.SSSZ"),
        LogFileDateFormat("yyyy-MM-dd-HH-mm-ss-sss")
    }

    init {
        val logFileDateFormat = SimpleDateFormat(Constants.LogFileDateFormat.format)
        val logFile = File(context.getExternalFilesDir(null), "$logFileName-${logFileDateFormat.format(Date())}.log")
        if (!logFile.exists()) {
            logFile.createNewFile()
        }
        this.logFile = PrintWriter(logFile.bufferedWriter(), true)
        Log.e("DgisLogger", logFile.absolutePath)
        this.dateFormat = SimpleDateFormat(Constants.LogMessageFormat.format)
    }

    @Synchronized
    override fun write(message: LogMessage) {
        val logLine = "${dateFormat.format(Date())} ${makeLevelString(message.level)} ${message.file}:${message.line} - ${message.text}"
        logFile.println(logLine)
    }

    private fun makeLevelString(level: LogLevel): String = when (level) {
        LogLevel.VERBOSE -> "VERBOSE"
        LogLevel.INFO -> "INFO"
        LogLevel.WARNING -> "WARNING"
        LogLevel.ERROR -> "ERROR"
        LogLevel.FATAL -> "FATAL"
        LogLevel.OFF -> ""
    }
}
