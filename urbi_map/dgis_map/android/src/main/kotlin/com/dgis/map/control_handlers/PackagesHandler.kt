package com.dgis.map.control_handlers

import com.dgis.map.extensions.toMessage
import com.dgis.map.extensions.toVoiceMessage
import com.dgis.map.map_api.*
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.Context
import ru.dgis.sdk.navigation.VoiceManager
import ru.dgis.sdk.update.Package
import ru.dgis.sdk.update.PackageInfo
import ru.dgis.sdk.update.PackageManager
import ru.dgis.sdk.update.PackageUpdateStatus

class PackagesHandler(
    sdkContext: Context,
    private val eventSink: EventChannel.EventSink
): AutoCloseable {
    private val packageManager: PackageManager = PackageManager.instance(sdkContext)
    private val voiceManager: VoiceManager = VoiceManager.instance(sdkContext)
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

    fun listPackages(callback: (Result<List<PackageMessage>>) -> Unit) {
        callback(Result.success(packageManager.packages.map { it.toMessage() }.toList()))
    }

    fun listVoices(callback: (Result<List<VoiceMessage>>) -> Unit) {
        callback(Result.success(voiceManager.voices.map { it.toVoiceMessage() }.toList()))
    }

    fun voicePlayWelcome(id: String, callback: (Result<Unit>) -> Unit) {
        voiceManager.voices.find { it.id == id }?.playWelcome()
        callback(Result.success(Unit))
    }

    fun installPackage(id: String, callback: ((Result<Unit>) -> Unit)?) {
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
        callback?.invoke(Result.success(Unit))
    }

    fun installVoice(id: String, callback: ((Result<Unit>) -> Unit)?) {
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
        callback?.invoke(Result.success(Unit))
    }
}
