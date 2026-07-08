package com.dgis.map.control_handlers

import com.dgis.map.extensions.toMessage
import com.dgis.map.map_api.*
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.Context
import ru.dgis.sdk.map.DefaultRasterUrlTemplate
import ru.dgis.sdk.map.RasterTileSource
import ru.dgis.sdk.map.RasterUrlTemplate
import ru.dgis.sdk.map.Source
import ru.dgis.sdk.navigation.VoiceManager
import ru.dgis.sdk.update.PackageInfo
import ru.dgis.sdk.update.PackageManager
import ru.dgis.sdk.update.PackageUpdateStatus

class WeatherHandler(
        val sdkContext: Context,
        val map: ru.dgis.sdk.map.Map,

) : AutoCloseable {
    private var temperatureTileSource: Source? = null
    private var precipitationTileSource: Source? = null
    private var isHeatmapVisible = false

    fun toggleHeatmap(message: WeatherMapMessage, callback: (Result<Boolean>) -> Unit) {

        if (message.enabled) {

            when (message.type) {

                WeatherMapType.TEMPERATURE -> {
                    precipitationTileSource?.let {
                        if (map.sources.contains(it)) {
                            map.removeSource(it)
                        }
                    }

                    if (temperatureTileSource == null) {
                        temperatureTileSource = RasterTileSource(
                                sdkContext,

                        message.layerName ?: "",
                            RasterUrlTemplate(DefaultRasterUrlTemplate(message.rasterTileUri ?: ""))
                        )

                    }
                    temperatureTileSource?.let {
                        if (!map.sources.contains(it)) {
                            map.addSource(it)
                        }
                    }
                }

                WeatherMapType.PRECIPITATION -> {
                    temperatureTileSource?.let {
                        if (map.sources.contains(it) == true) {
                            map.removeSource(it)
                        }

                        if (precipitationTileSource == null) {
                            precipitationTileSource = RasterTileSource(
                                    sdkContext,
                    message.layerName ?: "",
                                RasterUrlTemplate(DefaultRasterUrlTemplate(message.rasterTileUri ?: ""))
                            )

                        }
                        precipitationTileSource?.let { source ->
                            if (!map.sources.contains(source)) {
                                map.addSource(source)
                            }
                        }
                    }
                }

                else -> {}
            }

        } else {

            precipitationTileSource?.let {
                if (map.sources.contains(it)) {
                    map.removeSource(it)
                }
            }
            temperatureTileSource?.let {
                if (map.sources.contains(it)) {
                    map.removeSource(it)
                }
            }
        }
        isHeatmapVisible = message.enabled
        callback(Result.success(isHeatmapVisible))
    }

    override fun close() {}
}
