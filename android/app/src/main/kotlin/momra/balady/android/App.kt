package momra.balady.android

import android.app.Application
import android.util.Log
import com.dgis.FlutterProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        val engine = FlutterProvider.getFlutterEngine(this)
        // Register plugins early to ensure Pigeon API channels are available
        // This is needed because the engine is created before MainActivity.configureFlutterEngine() is called
        GeneratedPluginRegister.registerGeneratedPlugins(engine)
        AppIconQuickActionChannel.register(engine.dartExecutor.binaryMessenger)
    }
}
