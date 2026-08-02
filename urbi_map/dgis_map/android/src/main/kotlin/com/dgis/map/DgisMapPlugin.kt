package com.dgis.map

import android.content.Context
import com.dgis.map.extensions.toLogOptions
import com.dgis.map.live_updates.LiveUpdatesCoordinator
import com.dgis.map.map_api.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import ru.dgis.sdk.platform.LogOptions

class DgisMapPlugin : FlutterPlugin, PluginApi, ActivityAware {
    private lateinit var context: Context
    private var liveUpdatesChannel: MethodChannel? = null

    override fun initialize(
        message: LogOptionsMessage?,
        configMessage: VendorConfigMessage?,
        vendorConfigContentMessage: VendorConfigContentMessage?,
        callback: (Result<Unit>) -> Unit
    ) {
        initializeDGis(context, message?.toLogOptions(context), configMessage, vendorConfigContentMessage)
        callback(Result.success(Unit))
    }

    private fun initializeDGis(
        appContext: Context, logOptions: LogOptions?, vendorConfig: VendorConfigMessage?,
        vendorConfigContentMessage: VendorConfigContentMessage?,
    ) {

        DgisMapInitializer.init(appContext, vendorConfig, vendorConfigContentMessage, logOptions)
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val viewFactory = DgisMapViewFactory(binding.binaryMessenger)

        binding.platformViewRegistry.registerViewFactory("com.dgis.map_view", viewFactory)

        context = binding.applicationContext
        PluginApi.setUp(binding.binaryMessenger, this)

        val channel = MethodChannel(binding.binaryMessenger, "balady/navigation_live_updates")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "setSessionMetadata" -> {
                    val args = call.arguments as? Map<*, *>
                    @Suppress("UNCHECKED_CAST")
                    val strings = (args?.get("strings") as? Map<String, String>).orEmpty()
                    LiveUpdatesCoordinator.setSessionMetadata(
                        destinationName = args?.get("destinationName") as? String,
                        mode = args?.get("mode") as? String ?: "navigation",
                        routeType = args?.get("routeType") as? String ?: "car",
                        language = args?.get("language") as? String ?: "en",
                        strings = strings,
                        enabled = args?.get("enabled") as? Boolean ?: true,
                    )
                    result.success(null)
                }
                "endSession" -> {
                    LiveUpdatesCoordinator.endSession()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        liveUpdatesChannel = channel
        LiveUpdatesCoordinator.attach(binding.applicationContext, channel)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        MapApi.setUp(binding.binaryMessenger, null)
        PluginApi.setUp(binding.binaryMessenger, null)
        liveUpdatesChannel?.setMethodCallHandler(null)
        liveUpdatesChannel = null
        LiveUpdatesCoordinator.detachChannel()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }
}
