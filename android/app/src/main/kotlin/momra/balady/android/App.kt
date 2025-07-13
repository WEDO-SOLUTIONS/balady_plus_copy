package momra.balady.android

import android.app.Application
import android.util.Log
import com.dgis.FlutterProvider

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        FlutterProvider.getFlutterEngine(this)
    }
}
