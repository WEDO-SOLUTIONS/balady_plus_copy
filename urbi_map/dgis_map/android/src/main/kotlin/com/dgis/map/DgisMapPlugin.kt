package com.dgis.map

import android.content.Context
import com.dgis.map.extensions.toLogOptions
import com.dgis.map.map_api.*
import androidx.lifecycle.LifecycleOwner
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import ru.dgis.sdk.platform.LogOptions

class DgisMapPlugin : FlutterPlugin, PluginApi, ActivityAware {
    private lateinit var context: Context
    private var viewFactory: DgisMapViewFactory? = null

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
        val factory = DgisMapViewFactory(binding.binaryMessenger)
        viewFactory = factory

        binding.platformViewRegistry.registerViewFactory("com.dgis.map_view", factory)

        context = binding.applicationContext
        PluginApi.setUp(binding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        MapApi.setUp(binding.binaryMessenger, null)
        PluginApi.setUp(binding.binaryMessenger, null)
        viewFactory = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        viewFactory?.lifecycleOwner = binding.activity as? LifecycleOwner
    }

    override fun onDetachedFromActivityForConfigChanges() {
        viewFactory?.lifecycleOwner = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        viewFactory?.lifecycleOwner = binding.activity as? LifecycleOwner
    }

    override fun onDetachedFromActivity() {
        viewFactory?.lifecycleOwner = null
    }
}
