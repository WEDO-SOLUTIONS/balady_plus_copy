package com.dgis.map.control_handlers.navigation_controls;

import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.AudioVolume
import com.dgis.map.map_api.Messages.SoundToggleType
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.Duration
import ru.dgis.sdk.navigation.Model
import ru.dgis.sdk.navigation.NavigationManager
import ru.dgis.sdk.navigation.SoundCategory
import ru.dgis.sdk.navigation.duration
import ru.dgis.sdk.navigation.mute
import ru.dgis.sdk.navigation.notificationVolume
import ru.dgis.sdk.routing.RouteDistance
import ru.dgis.sdk.routing.meters
import ru.dgis.sdk.routing.minus
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.EnumSet

class DashboardControlModel(
    private val model: Model,
    private val eventSink: EventChannel.EventSink,
    private val navigationManager: NavigationManager
) : AutoCloseable {
    private val closeables = mutableListOf<AutoCloseable>()
    private var routeLength: RouteDistance = RouteDistance(0)

    companion object {
        private val allSounds = SoundCategory.values()
        private val dateFormat = SimpleDateFormat("HH:mm")
    }
    
    init {
        closeables.add(model.routeChannel.connect {
            routeLength = it.route.geometry.length
        })
        closeables.add(
            this.model.routePositionChannel.connect {
                this.update()
            }
        )
    }
    
    private fun update() {
        if (this.model.duration == null || model.routePosition == null ) {
            return
        }

        val duration = this.model.duration as Duration;
        val distance = (routeLength - model.routePosition!!.distance).meters;

        val arrival = Calendar.getInstance()
        arrival.add(Calendar.SECOND, duration.inSeconds.toInt())
        
        eventSink.success(
            mapOf(
                "event" to Events.dashboardEvent.name,
                "duration" to duration.inSeconds.toInt(),
                "distance" to distance,
                "arrivalTime" to dateFormat.format(arrival.time)
            )
        )
    }

    fun setVolume(volume: Messages.AudioVolume) {
        this.navigationManager.soundNotificationSettings.notificationVolume = ru.dgis.sdk.navigation.AudioVolume.valueOf(volume.name)
    }
    fun muteSound(mute: Boolean) {
        this.navigationManager.soundNotificationSettings.mute = mute

    }
    fun toggleSounds(toggleType: SoundToggleType) {
        this.navigationManager.soundNotificationSettings.enabledSoundCategories = soundToggleMapper(toggleType)
    }

    private fun soundToggleMapper(toggleType: SoundToggleType): EnumSet<SoundCategory> {
     return when (toggleType) {
            SoundToggleType.NONE -> EnumSet.noneOf(SoundCategory::class.java)
            SoundToggleType.ALL -> EnumSet.allOf(SoundCategory::class.java)
            SoundToggleType.IMPORTANT -> EnumSet.of(SoundCategory.NO_STOPPING_CONTROL_CAMERAS, SoundCategory.ACCIDENTS)
        }
    }

    override fun close() {
        closeables.forEach(AutoCloseable::close)
        closeables.clear()
    }
}

enum class Events {
    dashboardEvent
}