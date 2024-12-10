package com.dgis.map.control_handlers.navigation_controls;

import android.util.Log
import com.dgis.map.map_api.SoundToggleType
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

    fun setNavigatorVolume(volume: Int) {
        this.navigationManager.soundNotificationSettings.notificationVolume = volume
    }

    fun muteOtherSounds(mute: Boolean) {
        //TODO(Ayat) Waited in Sdk for add muteOtherSounds in Android
    }

    fun toggleVoiceInstruction(toggleType: SoundToggleType) {
        val currentCategories = this.navigationManager.soundNotificationSettings.enabledSoundCategories

        val updatedCategories = when (toggleType) {
            SoundToggleType.NONE -> {
                EnumSet.noneOf(SoundCategory::class.java).apply {
                    addAll(currentCategories)
                    removeAll(EnumSet.allOf(SoundCategory::class.java))
                }
            }
            SoundToggleType.ALL -> {
                EnumSet.allOf(SoundCategory::class.java).apply {
                    addAll(currentCategories)
                }
            }
            SoundToggleType.IMPORTANT -> {
                EnumSet.copyOf(currentCategories).apply {
                    remove(SoundCategory.INSTRUCTIONS)
                }
            }
        }

        this.navigationManager.soundNotificationSettings.enabledSoundCategories = updatedCategories
    }

    fun toggleOverSpeeding(overSpeeding: Boolean) {
        val currentCategories = this.navigationManager.soundNotificationSettings.enabledSoundCategories

        val updatedCategories = EnumSet.copyOf(currentCategories).apply {
            if (overSpeeding) {
                add(SoundCategory.EXCEED_SPEED_LIMITS)
            } else {
                remove(SoundCategory.EXCEED_SPEED_LIMITS)
            }
        }

        this.navigationManager.soundNotificationSettings.enabledSoundCategories = updatedCategories
    }

    fun toggleRoadCameras(roadCameras: Boolean) {
        val currentCategories = this.navigationManager.soundNotificationSettings.enabledSoundCategories

        val roadCameraCategories = EnumSet.of(
            SoundCategory.CROSSROAD_CAMERAS,
            SoundCategory.LANE_CAMERAS,
            SoundCategory.NO_STOPPING_CONTROL_CAMERAS,
            SoundCategory.ROAD_MARKING_CAMERAS,
            SoundCategory.AVERAGE_SPEED_CAMERAS,
            SoundCategory.MAX_SPEED_CAMERAS
        )

        val updatedCategories = EnumSet.copyOf(currentCategories).apply {
            if (roadCameras) {
                addAll(roadCameraCategories)
            } else {
                removeAll(roadCameraCategories)
            }
        }

        this.navigationManager.soundNotificationSettings.enabledSoundCategories = updatedCategories
    }

    override fun close() {
        closeables.forEach(AutoCloseable::close)
        closeables.clear()
    }
}

enum class Events {
    dashboardEvent
}