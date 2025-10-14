package momra.balady.android

import com.adjust.sdk.Adjust
import com.adjust.sdk.oaid.AdjustOaid
import android.content.Context
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
// TEMPORARILY DISABLED: import com.ryanheise.audioservice.AudioServiceFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    
    // TEMPORARILY DISABLED: private var mediaSessionHandler: MediaSessionHandler? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Initialize Adjust OAID
        AdjustOaid.readOaid(applicationContext)

        FlutterProvider.getHostFlutterApi(this).runMain { }
        MainAppScreenStateNotifier.setState(MainAppScreenState.CREATED)
    }

    override fun onStart() {
        super.onStart()
        MainAppScreenStateNotifier.setState(MainAppScreenState.STARTED)
    }

    override fun onResume() {
        super.onResume()
        MainAppScreenStateNotifier.setState(MainAppScreenState.RESUMED)
    }

    override fun onPause() {
        super.onPause()
        MainAppScreenStateNotifier.setState(MainAppScreenState.PAUSED)
    }

    override fun onStop() {
        super.onStop()
        MainAppScreenStateNotifier.setState(MainAppScreenState.STOPPED)
    }

    override fun onDestroy() {
        super.onDestroy()
        MainAppScreenStateNotifier.setState(MainAppScreenState.DESTROYED)

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
    }

    override fun shouldDestroyEngineWithHost(): Boolean {
        return false
    }
}