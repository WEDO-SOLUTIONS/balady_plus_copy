package com.dgis.map.control_handlers

import com.dgis.map.extensions.toMessage
import com.dgis.map.extensions.toVoiceMessage
import com.dgis.map.map_api.Messages
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.Context
import ru.dgis.sdk.navigation.VoiceManager
import ru.dgis.sdk.navigation.getVoiceManager
import ru.dgis.sdk.update.Package
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
    private val installTasks = mutableListOf<InstallTask>()

    init {
        closeables.add(
            packageManager.packagesChannel.connect { checkInstallTasks() }
        )
        closeables.add(
            voiceManager.voicesChannel.connect { checkInstallTasks() }
        )
        packageManager.autoupdateEnabled = true
        packageManager.checkForUpdates()
    }

    private enum class Events {
        packageProgressEvent,
        packageInfoChangedEvent
    }

    sealed class InstallTask {
        class Voice(val id: String) : InstallTask()
        class Package(val id: String) : InstallTask()
    }

    private fun checkInstallTasks() {
        val tasks = this.installTasks.toList()
        installTasks.clear()

        for (task in tasks) {
            when (task) {
                is InstallTask.Package -> installPackage(task.id, null)
                is InstallTask.Voice -> installVoice(task.id, null)
            }
        }
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

    fun listPackages(result: Messages.Result<List<Messages.PackageMessage>>) {
        result.success(packageManager.packages.map { it.toMessage() }.toList())
    }

    fun listVoices(result: Messages.Result<List<Messages.VoiceMessage>>) {
        result?.success(voiceManager.voices.map { it.toVoiceMessage() }.toList())
    }

    fun voicePlayWelcome(id: String, result: Messages.VoidResult) {
        voiceManager.voices.find { it.id == id }?.playWelcome()
        result.success()
    }

    fun installPackage(id: String, result: Messages.VoidResult?) {
        val pakage = packageManager.packages.firstOrNull { it.id == id }
        if (pakage != null) {
            closeables.add(pakage.progressChannel.connect { progress ->
                eventSink.success(
                    mapOf(
                        "event" to Events.packageProgressEvent.name,
                        "packageId" to id,
                        "progress" to progress
                    )
                )
            })
            closeables.add(pakage.infoChannel.connect { info ->
                eventSink.success(
                    mapOf(
                        "event" to Events.packageInfoChangedEvent.name,
                        "id" to pakage.id,
                        "info" to mapInfo(info)
                    )
                )
            })
            pakage.install()
        } else {
            installTasks.add(InstallTask.Package(id))
        }
        result?.success()
    }

    fun installVoice(id: String, result: Messages.VoidResult?) {
        val voice = voiceManager.voices.firstOrNull { it.id == id }
        if (voice != null) {
            closeables.add(voice.progressChannel.connect { progress ->
                eventSink.success(
                        mapOf(
                                "event" to Events.packageProgressEvent.name,
                                "packageId" to id,
                                "progress" to progress
                        )
                )
            })
            closeables.add(voice.infoChannel.connect { info ->
                eventSink.success(
                        mapOf(
                                "event" to Events.packageInfoChangedEvent.name,
                                "id" to voice.id,
                                "info" to mapInfo(info)
                        )
                )
            })
            voice.install()
        } else {
            installTasks.add(InstallTask.Voice(id))
        }
        result?.success()
    }
}
