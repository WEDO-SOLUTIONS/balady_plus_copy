package com.dgis.map.control_handlers

import com.dgis.map.extensions.toMessage
import com.dgis.map.map_api.Messages
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.Context
import ru.dgis.sdk.navigation.VoiceManager
import ru.dgis.sdk.navigation.getVoiceManager
import ru.dgis.sdk.update.PackageInfo
import ru.dgis.sdk.update.PackageManager
import ru.dgis.sdk.update.PackageUpdateStatus
import ru.dgis.sdk.update.getPackageManager
class PackagesHandler(
    sdkContext: Context,
    private val eventSink: EventChannel.EventSink
): AutoCloseable {
    private val packageManager: PackageManager = getPackageManager(sdkContext)
    private val voiceManager: VoiceManager = getVoiceManager(sdkContext)
    private val closeables = mutableListOf<AutoCloseable>()

    private enum class Events {
        packageProgressEvent,
        packageInfoChangedEvent
    }

    private fun mapStatus(status: PackageUpdateStatus) = when (status) {
        PackageUpdateStatus.NOT_AVAILABLE -> "notAvailable"
        PackageUpdateStatus.IN_PROGRESS -> "inProgress"
        PackageUpdateStatus.PAUSED -> "paused"
    }

    private fun mapInfo(info: PackageInfo): Map<String, Any> {
        return mapOf(
            "name" to info.name,
            "installed" to info.installed,
            "incomplete" to info.incomplete,
            "preinstalled" to info.preinstalled,
            "compatible" to info.compatible,
            "hasUpdate" to info.hasUpdate,
            "updateStatus" to mapStatus(info.updateStatus),
        )
    }

    override fun close() {
        closeables.forEach { it.close() }
        closeables.clear()
    }

    fun listPackages(result: Messages.Result<List<Messages.PackageMessage>>?) {
        result?.success(packageManager.packages.map { it.toMessage() }.toList())
    }

    fun listVoices(result: Messages.Result<List<Messages.PackageMessage>>?) {
        result?.success(voiceManager.voices.map { it.toMessage() }.toList())
    }

    fun installPackage(id: String, result: Messages.Result<Void>?) {
        packageManager.packages.first { it.id == id }.let {
            closeables.add(it.progressChannel.connect { progress ->
                eventSink.success(
                    mapOf(
                        "event" to Events.packageProgressEvent.name,
                        "packageId" to id,
                        "progress" to progress
                    )
                )
            })
            closeables.add(it.infoChannel.connect { info ->
                eventSink.success(
                    mapOf(
                        "event" to Events.packageInfoChangedEvent.name,
                        "id" to it.id,
                        "info" to mapInfo(info)
                    )
                )
            })
            it.install()
        }
        result?.success(null)
    }

    fun installVoice(id: String, result: Messages.Result<Void>?) {
        voiceManager.voices.first { it.id == id }.let {
            closeables.add(it.progressChannel.connect { progress ->
                eventSink.success(
                    mapOf(
                        "event" to Events.packageProgressEvent.name,
                        "packageId" to id,
                        "progress" to progress
                    )
                )
            })
            closeables.add(it.infoChannel.connect { info ->
                eventSink.success(
                    mapOf(
                        "event" to Events.packageInfoChangedEvent.name,
                        "id" to it.id,
                        "info" to mapInfo(info)
                    )
                )
            })
            it.install()
        }
        result?.success(null)
    }
}
