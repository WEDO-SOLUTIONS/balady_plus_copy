package com.dgis.map

import android.os.Handler
import android.os.Looper
import android.util.Size
import com.dgis.map.extensions.toTextStyle
import com.dgis.map.map_api.FlutterMapApi
import com.dgis.map.map_api.MapObjectManagerMessage
import com.dgis.map.map_api.SimpleClusterOptionsMessage
import io.flutter.FlutterInjector
import kotlinx.coroutines.runBlocking
import ru.dgis.sdk.Context
import ru.dgis.sdk.map.*
import java.io.FileNotFoundException
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

class FlutterClusterRenderer(
    private val sdkContext: Context,
    private val api: FlutterMapApi,
    private val manager: MapObjectManagerMessage,
): SimpleClusterRenderer {
    private val iconCache = mutableMapOf<String, Image>()

    suspend fun apiRenderCluster(manager: MapObjectManagerMessage, objectCount: Int) = suspendCoroutine<SimpleClusterOptionsMessage> { cont ->
        Handler(Looper.getMainLooper()).post {
            api.renderCluster(
                manager,
                objectCount.toLong()
            ) {
                var options = it.getOrNull() ?: SimpleClusterOptionsMessage()

                cont.resume(options)
            }
        }
    }

    override fun renderCluster(cluster: SimpleClusterObject): SimpleClusterOptions {
        // TODO(ilyasov): fix force unwrap
        val options = runBlocking { apiRenderCluster(manager, cluster.objectCount) }

        var markerImage: Image? = null
        if (options.icon != null && options.icon!!.svgPath != null) {
            if (options.icon!!.svgPath in iconCache) {
                markerImage = iconCache[options.icon!!.svgPath!!]
            } else {
                try {
                    val asset =
                        FlutterInjector
                            .instance()
                            .flutterLoader()
                            .getLookupKeyForAsset(options.icon!!.svgPath!!)

                    markerImage = imageFromAsset(sdkContext, asset, Size(0, 0))
                    iconCache[options.icon!!.svgPath!!] = markerImage
                } catch (e: FileNotFoundException) {
                    print(e)
                }
            }
        }

        return SimpleClusterOptions(
            icon = markerImage,
            iconMapDirection = options.icon?.iconMapDirection?.let {
                MapDirection(it.degree)
            },
            anchor = options.anchor?.let {
                Anchor(it.x.toFloat(), it.y.toFloat())
            } ?: Anchor(0.5f, 0.5f),
            text = options.text,
            textStyle = options.textStyle?.toTextStyle(),
            iconWidth = options.icon?.let {
                LogicalPixel(it.width.toFloat())
            } ?: LogicalPixel(0f),
            userData = manager,
            animatedAppearance = false,
        )
    }
}
