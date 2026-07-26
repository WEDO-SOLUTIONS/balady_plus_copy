package com.dgis.map.control_handlers.navigation_controls;

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.dgis.map.live_updates.NavEta
import com.dgis.map.live_updates.NavLiveEventBus
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
    private val navigationManager: NavigationManager,
    private val appContext: Context,
) : AutoCloseable {
    private val closeables = mutableListOf<AutoCloseable>()
    private var routeLength: RouteDistance = RouteDistance(0)
    private val mainHandler = Handler(Looper.getMainLooper())

    // Implements short "duck then restore" behavior for other audio apps.
    // The SDK does not currently expose a native Android equivalent to iOS AudioFocusPolicy.
    private val audioManager: AudioManager? =
        appContext.getSystemService(Context.AUDIO_SERVICE) as? AudioManager
    private var focusRequest: AudioFocusRequest? = null
    private var restoreRunnable: Runnable? = null

    companion object {
        private val dateFormat = SimpleDateFormat("HH:mm")
        private const val DUCK_DURATION_MS = 3000L
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
        val arrivalTime = dateFormat.format(arrival.time)

        eventSink.success(
            mapOf(
                "event" to Events.dashboardEvent.name,
                "duration" to duration.inSeconds.toInt(),
                "distance" to distance,
                "arrivalTime" to arrivalTime
            )
        )

        NavLiveEventBus.eta.value = NavEta(
            durationSec = duration.inSeconds.toInt(),
            distanceMeters = distance.toDouble(),
            arrivalTime = arrivalTime,
        )
    }

    fun setNavigatorVolume(volume: Int) {
        this.navigationManager.soundNotificationSettings.notificationVolume = volume
    }

    fun muteOtherSounds(mute: Boolean) {
        // Despite the name coming from Flutter (`muteOtherSounds(bool)`), we implement
        // a temporary ducking policy:
        // - mute=true  -> request transient audio focus with MAY_DUCK and auto-release after a short duration
        // - mute=false -> release immediately and cancel any pending release

        val am = audioManager ?: return

        // Cancel any pending restore to avoid races.
        restoreRunnable?.let { mainHandler.removeCallbacks(it) }
        restoreRunnable = null

        if (!mute) {
            abandonAudioFocus(am)
            return
        }

        requestDuckAudioFocus(am)

        val runnable = Runnable { abandonAudioFocus(am) }
        restoreRunnable = runnable
        mainHandler.postDelayed(runnable, DUCK_DURATION_MS)
    }

    private fun requestDuckAudioFocus(am: AudioManager) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val attrs = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ASSISTANCE_NAVIGATION_GUIDANCE)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build()

                val req = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)
                    .setAudioAttributes(attrs)
                    .setOnAudioFocusChangeListener { /* no-op */ }
                    .build()

                focusRequest = req
                am.requestAudioFocus(req)
            } else {
                @Suppress("DEPRECATION")
                am.requestAudioFocus(
                    null,
                    AudioManager.STREAM_MUSIC,
                    AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK
                )
            }
        } catch (e: Exception) {
            Log.w("DashboardControlModel", "Failed to request duck audio focus: ${e.message}")
        }
    }

    private fun abandonAudioFocus(am: AudioManager) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                focusRequest?.let { am.abandonAudioFocusRequest(it) }
                focusRequest = null
            } else {
                @Suppress("DEPRECATION")
                am.abandonAudioFocus(null)
            }
        } catch (e: Exception) {
            Log.w("DashboardControlModel", "Failed to abandon audio focus: ${e.message}")
        }
    }

    fun toggleVoiceInstruction(toggleType: SoundToggleType) {
        val currentCategories = this.navigationManager.soundNotificationSettings.enabledSoundCategories

        // Mirror iOS: sdk.audioSettings?.mute = (toggleType == .none)
        // This directly silences the SDK audio pipeline (including any in-flight utterance)
        // instead of relying on the audio-focus request/abandon trick which is not synchronous.
        this.navigationManager.soundNotificationSettings.mute = (toggleType == SoundToggleType.NONE)

        val updatedCategories = when (toggleType) {
            SoundToggleType.NONE -> EnumSet.noneOf(SoundCategory::class.java)
            SoundToggleType.ALL -> EnumSet.allOf(SoundCategory::class.java)
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