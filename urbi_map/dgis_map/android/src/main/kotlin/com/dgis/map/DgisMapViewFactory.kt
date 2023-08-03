package com.dgis.map

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class DgisMapViewFactory(
    private val sdkContext: ru.dgis.sdk.Context,
    private val binaryMessenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<*, *>?
        return DgisMapView(
            sdkContext = sdkContext,
            context = context,
            id = viewId,
            creationParams = creationParams,
            binaryMessenger = binaryMessenger
        )
    }
}
