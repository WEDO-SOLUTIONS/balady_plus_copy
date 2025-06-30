package momra.balady.android

import android.content.Context
import android.os.Bundle
import android.util.Log
import com.dgis.FlutterProvider
import com.dgis.map.android_auto.MainAppScreenStateNotifier
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister


class MainActivity : FlutterFragmentActivity() {

    override fun onStart() {
        super.onStart()
        MainAppScreenStateNotifier.screenShown()
    }

    override fun onStop() {
        MainAppScreenStateNotifier.screenHidden()
        super.onStop()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FlutterProvider.getHostFlutterApi(this).runMain { }
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine {
        val engine = FlutterProvider.getFlutterEngine(context)
        return engine
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegister.registerGeneratedPlugins(flutterEngine)
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
