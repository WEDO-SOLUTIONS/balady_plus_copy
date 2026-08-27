package com.dgis.map.control_handlers

import com.dgis.map.map_api.SatelliteMapMessage
import ru.dgis.sdk.Context
import ru.dgis.sdk.map.DefaultRasterUrlTemplate
import ru.dgis.sdk.map.RasterTileSource
import ru.dgis.sdk.map.RasterUrlTemplate
import ru.dgis.sdk.map.Source
import ru.dgis.sdk.map.WmsRasterUrlTemplate

class SatelliteHandler(
    val sdkContext: Context,
    val map: ru.dgis.sdk.map.Map,
) : AutoCloseable {
    private var satelliteTileSource: Source? = null
    private var cachedTileUri: String? = null
    private var cachedLayerName: String? = null
    private var isVisible = false

    fun toggleSatellite(message: SatelliteMapMessage, callback: (Result<Boolean>) -> Unit) {
        if (message.enabled) {
            val tileUri = message.rasterTileUri ?: ""
            val layerName = message.layerName ?: ""
            val needsRecreate = satelliteTileSource == null ||
                cachedTileUri != tileUri ||
                cachedLayerName != layerName

            if (needsRecreate) {
                satelliteTileSource?.let { old ->
                    if (map.sources.contains(old)) {
                        map.removeSource(old)
                    }
                }
                satelliteTileSource = RasterTileSource(
                    sdkContext,
                    layerName,
//                    RasterUrlTemplate(WmsRasterUrlTemplate(tileUri),),
                    RasterUrlTemplate(
                        WmsRasterUrlTemplate(urlTemplate = "https://server.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/WMTS/tile/1.0.0/World_Imagery/default/default028mm/{z}/{y}/{x}.jpg"),),
                )
                cachedTileUri = tileUri
                cachedLayerName = layerName
            }

            satelliteTileSource?.let { source ->
                if (!map.sources.contains(source)) {
                    map.addSource(source)
                }
            }
        } else {
            satelliteTileSource?.let { source ->
                if (map.sources.contains(source)) {
                    map.removeSource(source)
                }
            }
        }
        isVisible = message.enabled
        callback(Result.success(isVisible))
    }

    override fun close() {}
}
