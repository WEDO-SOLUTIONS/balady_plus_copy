package com.dgis.map

import android.content.Context
import com.dgis.map.extensions.toLogOptions
import com.dgis.map.map_api.Messages.LogOptionsMessage
import com.dgis.map.map_api.Messages.MapApi
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import ru.dgis.sdk.*
import ru.dgis.sdk.positioning.LocationSource
import ru.dgis.sdk.positioning.registerPlatformLocationSource
import ru.dgis.sdk.positioning.registerPlatformMagneticSource

class DgisMapViewFactory(
    private val binaryMessenger: BinaryMessenger,
    private val locationSource: FusedLocationSource
) : PlatformViewFactory(StandardMessageCodec()) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        if (DgisMapPlugin.sdkContext == null) {
            throw Error("Plugin has not been initialized")
        }
        registerServices(DgisMapPlugin.sdkContext!!, locationSource)

        return DgisMapView(
            sdkContext = DgisMapPlugin.sdkContext!!,
            context = context,
            id = viewId,
            binaryMessenger = binaryMessenger,
            locationSource = locationSource
        )
    }

    private fun registerServices(sdkContext: ru.dgis.sdk.Context, locationSource: LocationSource) {
        registerPlatformLocationSource(sdkContext, locationSource)
        registerPlatformMagneticSource(sdkContext, null)
    }
}
