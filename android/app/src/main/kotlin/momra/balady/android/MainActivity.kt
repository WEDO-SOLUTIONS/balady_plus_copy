package momra.balady.android

import android.os.Bundle
import com.adjust.sdk.Adjust
import com.adjust.sdk.oaid.AdjustOaid
import com.dgis.map.android_auto.MainAppScreenStateNotifier
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize Adjust OAID
        AdjustOaid.readOaid(applicationContext)
    }

    override fun onStart() {
        super.onStart()
        MainAppScreenStateNotifier.screenShown()
    }

    override fun onStop() {
        MainAppScreenStateNotifier.screenHidden()
        super.onStop()
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
