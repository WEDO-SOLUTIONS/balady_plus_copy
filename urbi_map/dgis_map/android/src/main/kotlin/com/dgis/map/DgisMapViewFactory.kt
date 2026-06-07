package com.dgis.map

import android.content.Context
import com.dgis.map.extensions.toLogOptions
import com.dgis.map.map_api.LogOptionsMessage
import com.dgis.map.map_api.MapApi
import androidx.lifecycle.LifecycleOwner
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class DgisMapViewFactory(
    private val binaryMessenger: BinaryMessenger,
) : PlatformViewFactory(MapApi.codec) {
    var lifecycleOwner: LifecycleOwner? = null

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val sdkContext = DgisMapInitializer.getSdkContext()
        val locationSource = DgisMapInitializer.getLocationSource()

        return DgisMapView(
            sdkContext = sdkContext,
            context = context,
            id = viewId,
            binaryMessenger = binaryMessenger,
            locationSource = locationSource,
            lifecycleOwner = lifecycleOwner,
        )
    }
}
