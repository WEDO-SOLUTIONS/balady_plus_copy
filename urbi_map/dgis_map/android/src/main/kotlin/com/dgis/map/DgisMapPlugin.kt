package com.dgis.map

import android.content.Context
import com.dgis.map.extensions.toLogOptions
import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.MapApi
import com.dgis.map.map_api.Messages.PluginApi
import com.dgis.map.map_api.Messages.VendorConfigContentMessage
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import ru.dgis.sdk.platform.LogOptions

class DgisMapPlugin : FlutterPlugin, PluginApi, ActivityAware {
    private lateinit var context: Context

    override fun initialize(
        message: Messages.LogOptionsMessage?,
        configMessage: Messages.VendorConfigMessage?,
        result: Messages.VoidResult
    ) {
        initializeDGis(context, message?.toLogOptions(context), configMessage)
        result.success()
    }

    private fun initializeDGis(
        appContext: Context, logOptions: LogOptions?, vendorConfig: Messages.VendorConfigMessage?,
        vendorConfigContentMessage: VendorConfigContentMessage?,
    ) {

        DgisMapInitializer.init(appContext, vendorConfig, vendorConfigContentMessage, logOptions)
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val viewFactory = DgisMapViewFactory(binding.binaryMessenger)

        binding.platformViewRegistry.registerViewFactory("com.dgis.map_view", viewFactory)

        context = binding.applicationContext
        PluginApi.setUp(binding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        MapApi.setUp(binding.binaryMessenger, null)
        PluginApi.setUp(binding.binaryMessenger, null)
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
