package momra.balady.android

import com.adjust.sdk.Adjust
import com.adjust.sdk.oaid.AdjustOaid
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.os.Build
import android.os.Bundle
import com.dgis.FlutterProvider
import com.dgis.map.android_auto.CarAppConnectionState
import com.dgis.map.android_auto.MainAppScreenState
import com.dgis.map.android_auto.MainAppScreenStateNotifier
import com.dgis.map.android_auto.NavigationCarAppService
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.ryanheise.audioservice.AudioServiceFragmentActivity

class MainActivity : AudioServiceFragmentActivity() {
    
    // TEMPORARILY DISABLED: private var mediaSessionHandler: MediaSessionHandler? = null
    private var audioCoordinationChannel: MethodChannel? = null
    private var audioManager: AudioManager? = null
    private var focusRequest: AudioFocusRequest? = null
    private var mbcLockBridge: MbcLockBridge? = null

    private val audioFocusListener = AudioManager.OnAudioFocusChangeListener { focusChange ->
        // Forward focus changes to Flutter so it can pause/resume the in-app player.
        // DGis navigation voice prompts typically request transient focus, causing
        // LOSS_TRANSIENT(_CAN_DUCK) for the currently playing media.
        when (focusChange) {
            AudioManager.AUDIOFOCUS_LOSS_TRANSIENT,
            AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK -> {
                audioCoordinationChannel?.invokeMethod("duckAudio", mapOf("volume" to 0.0))
            }
            AudioManager.AUDIOFOCUS_GAIN -> {
                audioCoordinationChannel?.invokeMethod("restoreAudio", mapOf("volume" to 1.0))
            }
            AudioManager.AUDIOFOCUS_LOSS -> {
                audioCoordinationChannel?.invokeMethod("duckAudio", mapOf("volume" to 0.0))
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        // Capture before super.onCreate — FlutterFragmentActivity may attach plugins and read the intent.
        AppIconQuickActionChannel.captureFromIntent(intent)

        super.onCreate(savedInstanceState)
        // Initialize Adjust OAID
        AdjustOaid.readOaid(applicationContext)

        FlutterProvider.getHostFlutterApi(this).runMain { }
        MainAppScreenStateNotifier.setState(MainAppScreenState.CREATED)

        audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
    }

    override fun onStart() {
        super.onStart()
        // Fallback for devices that deliver the shortcut intent after onCreate.
        AppIconQuickActionChannel.captureFromIntent(intent)
        MainAppScreenStateNotifier.setState(MainAppScreenState.STARTED)
    }

    override fun onResume() {
        super.onResume()
        // Warm-start shortcuts can arrive via onNewIntent without onStart re-running.
        AppIconQuickActionChannel.captureFromIntent(intent)
        MainAppScreenStateNotifier.setState(MainAppScreenState.RESUMED)

        // Ensure we are listening for focus changes while the app is active.
        requestAudioFocusForCoordination()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Required for singleTask — home-screen shortcuts deliver a new intent on warm resume.
        setIntent(intent)
        AppIconQuickActionChannel.captureFromIntent(intent)
    }

    override fun onPause() {
        super.onPause()
        MainAppScreenStateNotifier.setState(MainAppScreenState.PAUSED)

        abandonAudioFocusForCoordination()
    }

    override fun onStop() {
        super.onStop()
        MainAppScreenStateNotifier.setState(MainAppScreenState.STOPPED)
    }

    override fun onDestroy() {
        super.onDestroy()
        MainAppScreenStateNotifier.setState(MainAppScreenState.DESTROYED)
        
        // Audio interruption handler removed

        if (NavigationCarAppService.connectionState == CarAppConnectionState.DISCONNECTED) {
            FlutterProvider.destroyFlutterEngine()
        }
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine {
        val engine = FlutterProvider.getFlutterEngine(context)
        return engine
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Don't register plugins here - they're already registered by FlutterFragmentActivity
        // and FlutterProvider to avoid duplicate registration warnings
        
        // TEMPORARILY DISABLED: Set up MediaSession method channel
        // val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "balady_media_session")
        // mediaSessionHandler = MediaSessionHandler(this, channel)
        // channel.setMethodCallHandler(mediaSessionHandler)
        
        // Native audio interruption removed for simplicity

        // Android audio coordination → Flutter events (duck/restore).
        audioCoordinationChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.balady.audio_coordination"
        )

        AppIconQuickActionChannel.register(flutterEngine.dartExecutor.binaryMessenger)

        // Saudi National Day launcher-icon swap (activity-alias toggle).
        LauncherIconChannel.register(applicationContext, flutterEngine.dartExecutor.binaryMessenger)

        // MBC live-radio wake / Wi-Fi lock bridge — keeps the foreground
        // streaming service alive while the screen is off so HLS doesn't stall
        // on Wi-Fi throttling / Doze.
        mbcLockBridge = MbcLockBridge(applicationContext).also { it.register(flutterEngine) }
    }

    override fun shouldDestroyEngineWithHost(): Boolean {
        return false
    }

    private fun requestAudioFocusForCoordination() {
        val am = audioManager ?: return
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val attrs = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()

                // IMPORTANT: do NOT request AUDIOFOCUS_GAIN here.
                // That would steal exclusive media focus from the MBC live-radio
                // foreground service (just_audio_background) every time the
                // activity resumes, which on screen-off / fast app-switching
                // contributed to the radio dying after 1-2 min on Android.
                // We only need transient, dux-friendly focus to listen for
                // navigation voice ducking hints from the system.
                val req = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)
                    .setAudioAttributes(attrs)
                    .setWillPauseWhenDucked(false)
                    .setAcceptsDelayedFocusGain(true)
                    .setOnAudioFocusChangeListener(audioFocusListener)
                    .build()
                focusRequest = req
                am.requestAudioFocus(req)
            } else {
                @Suppress("DEPRECATION")
                am.requestAudioFocus(
                    audioFocusListener,
                    AudioManager.STREAM_MUSIC,
                    AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK,
                )
            }
        } catch (_: Exception) {
            // Best-effort: if focus cannot be requested, coordination will be unavailable.
        }
    }

    private fun abandonAudioFocusForCoordination() {
        val am = audioManager ?: return
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                focusRequest?.let { am.abandonAudioFocusRequest(it) }
                focusRequest = null
            } else {
                @Suppress("DEPRECATION")
                am.abandonAudioFocus(audioFocusListener)
            }
        } catch (_: Exception) {
        }
    }
}

//import io.flutter.embedding.android.FlutterActivity
//class MainActivity: FlutterActivity() {
//}


// added for local_auth plugin
//import io.flutter.embedding.android.FlutterFragmentActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugins.GeneratedPluginRegistrant

// added for local_auth plugin
//class MainActivity: FlutterFragmentActivity() {
// override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//     GeneratedPluginRegistrant.registerWith(flutterEngine)
//  }
//}
