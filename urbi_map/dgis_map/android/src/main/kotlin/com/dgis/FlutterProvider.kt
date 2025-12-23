package com.dgis

import android.content.Context
import com.dgis.map.map_api.HostFlutterApi
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister


object FlutterProvider {
    private var flutterEngine: FlutterEngine? = null
    private var api: HostFlutterApi? = null

    fun getFlutterEngine(context: Context): FlutterEngine {
        if (flutterEngine == null) {
            val dartVmArgs = null
            val automaticallyRegisterPlugins = false
            flutterEngine = FlutterEngine(context, dartVmArgs, automaticallyRegisterPlugins)
            flutterEngine!!.navigationChannel.setInitialRoute("/")
            flutterEngine!!.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
        }
        return flutterEngine!!
    }

    fun getHostFlutterApi(context: Context): HostFlutterApi {
        val flutterEngine = getFlutterEngine(context)
        if (api == null) {
            api = HostFlutterApi(flutterEngine.dartExecutor.binaryMessenger)
        }
        return api!!
    }

    fun destroyFlutterEngine() {
        flutterEngine?.destroy()
        flutterEngine = null
        api = null
    }
}
