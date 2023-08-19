package com.dgis.map

import android.content.Context
import com.dgis.map.extensions.toLogOptions
import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.MapApi
import com.dgis.map.map_api.Messages.PluginApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import ru.dgis.sdk.*
import ru.dgis.sdk.Context as SdkContext

class DgisMapPlugin : FlutterPlugin, PluginApi, ActivityAware {
    companion object {
        var sdkContext: SdkContext? = null
    }

    private lateinit var context: Context

    override fun initialize(message: Messages.LogOptionsMessage?, result: Messages.Result<Void>?) {
        sdkContext = initializeDGis(context, message?.toLogOptions(context))
        result?.success(null)
    }

    private fun initializeDGis(appContext: Context, logOptions: LogOptions?): ru.dgis.sdk.Context {
        return DGis.initialize(
            appContext,
            logOptions = logOptions ?: LogOptions(),
            vendorConfig = VendorConfig(
                fromAsset = VendorConfigFromAsset("vendor-config.jsonx")
            )
        )
    }
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val locationSource = FusedLocationSource(binding.applicationContext)
        val viewFactory = DgisMapViewFactory(binding.binaryMessenger, locationSource)

        binding
            .platformViewRegistry
            .registerViewFactory("com.dgis.map_view", viewFactory)

        context = binding.applicationContext
        PluginApi.setup(binding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        MapApi.setup(binding.binaryMessenger, null)
        PluginApi.setup(binding.binaryMessenger, null)
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
