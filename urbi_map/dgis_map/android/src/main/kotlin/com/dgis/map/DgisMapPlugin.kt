package com.dgis.map

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.dgis.map.map_api.Messages.MapApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import ru.dgis.sdk.*
import ru.dgis.sdk.positioning.LocationSource
import ru.dgis.sdk.positioning.registerPlatformLocationSource
import ru.dgis.sdk.positioning.registerPlatformMagneticSource
import ru.dgis.sdk.Context as SdkContext

class DgisMapPlugin : FlutterPlugin, ActivityAware {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val sdkContext = initializeDGis(binding.applicationContext)
        val locationSource = FusedLocationSource(binding.applicationContext)
        registerServices(sdkContext, locationSource)

        val viewFactory = DgisMapViewFactory(sdkContext, binding.binaryMessenger, locationSource)

        binding
            .platformViewRegistry
            .registerViewFactory("com.dgis.map_view", viewFactory)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        MapApi.setup(binding.binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }

    private fun initializeDGis(appContext: Context): SdkContext {
        return DGis.initialize(
            appContext,
            vendorConfig = VendorConfig(
                fromAsset = VendorConfigFromAsset("vendor-config.jsonx")
            )
        )
    }

    private fun registerServices(sdkContext: SdkContext, locationSource: LocationSource) {
        registerPlatformLocationSource(sdkContext, locationSource)
        registerPlatformMagneticSource(sdkContext, null)
    }
}
