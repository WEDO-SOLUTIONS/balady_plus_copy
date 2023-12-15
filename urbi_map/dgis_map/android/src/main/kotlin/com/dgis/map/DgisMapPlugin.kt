package com.dgis.map

import android.content.Context
import android.util.Log
import com.dgis.map.extensions.toLogOptions
import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.MapApi
import com.dgis.map.map_api.Messages.PluginApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import ru.dgis.sdk.*
import java.io.BufferedReader
import ru.dgis.sdk.Context as SdkContext

class DgisMapPlugin : FlutterPlugin, PluginApi, ActivityAware {
    companion object {
        var sdkContext: SdkContext? = null
        var vendorConfig: VendorConfig? = null;
    }

    private lateinit var context: Context

    override fun initialize(
            message: Messages.LogOptionsMessage?,
            configMessage: Messages.VendorConfigMessage?, result: Messages.Result<Void>?) {
        initializeDGis(context, message?.toLogOptions(context),configMessage)
        result?.success(null)
    }

    private fun initializeDGis(appContext: Context,
                               logOptions: LogOptions?,
                               message: Messages.VendorConfigMessage?){
       val vendorConfigFile = when (message) {
            Messages.VendorConfigMessage.URBI_PRE_PROD -> "urbi-pre-prod-vendor-config.jsonx"
            Messages.VendorConfigMessage.MOMRAH_PROD -> "momrah-prod-vendor-config.jsonx"
            null -> "momrah-prod-vendor-config.jsonx"
        }
        val vendorContent = context
                .assets
                .open(vendorConfigFile)
                .bufferedReader()
                .use(BufferedReader::readText)
        vendorConfig = vendorContent.let { VendorConfig.from(it) }
        sdkContext = DGis.initialize(
            appContext,
            logOptions = logOptions ?: LogOptions(),
            vendorConfig = VendorConfig(
                fromAsset = VendorConfigFromAsset(vendorConfigFile)
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
