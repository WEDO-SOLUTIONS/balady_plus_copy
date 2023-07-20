package com.dgis.map.control_handlers

import com.dgis.map.extensions.unsafeLazy
import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.EGComplexDateFilterMessage
import com.dgis.map.map_api.Messages.EGDateRangeFilterMessage
import com.dgis.map.map_api.Messages.EGDoubleFilterMessage
import com.dgis.map.map_api.Messages.EGIntFilterMessage
import com.dgis.map.map_api.Messages.EGStringFilterMessage
import com.dgis.map.map_api.Messages.EverGisLayerMessage
import com.dgis.map.map_api.Messages.Result
import ru.dgis.sdk.Context
import ru.dgis.sdk.map.*
import ru.dgis.sdk.map.Map as DgisMap

class EvergisLayerHandler(sdkContext: Context) : AutoCloseable {

    private val everGisLayerManager by unsafeLazy { EverGisLayerManager(sdkContext, endPointData) }

    private var future: AutoCloseable? = null

    private val layers = mutableMapOf<String, EverGisLayer>()

    private val filters = mutableListOf<EverGisAttributeFilter>()

    fun getLayers(map: DgisMap, result: Result<List<EverGisLayerMessage>>?) {
        future = everGisLayerManager.getLayers().apply {
            onResult { it ->
                val availableLayers = it ?: run {
                    result?.error(IllegalArgumentException("No available Evergis layers"))
                    return@onResult
                }
                availableLayers
                    .filter { layers[it.alias] == null }
                    .onEach { layer ->
                        layers[layer.alias] = layer
                        map.addSource(layer)
                    }
                result?.success(availableLayers.map { layer ->
                    EverGisLayerMessage.Builder()
                        .setName(layer.name)
                        .setAlias(layer.alias)
                        .build()
                })
            }
            onError { result?.error(it) }
        }
    }

    fun applyEverGisFilters(
        layerAlias: String,
        stringFilters: List<EGStringFilterMessage>,
        doubleFilters: List<EGDoubleFilterMessage>,
        intFilters: List<EGIntFilterMessage>,
        dateRangeFilters: List<EGDateRangeFilterMessage>,
        complexDateFilters: List<EGComplexDateFilterMessage>,
        result: Result<Void>?
    ) {
        val layer = layers[layerAlias] ?: kotlin.run {
            result?.error(IllegalArgumentException("Layer with alias $layerAlias not found"))
            return
        }

        try {
            filters.clear()

            filters.addAll(stringFilters.map(::mapMessageToFilter))
            filters.addAll(doubleFilters.map(::mapMessageToFilter))
            filters.addAll(intFilters.map(::mapMessageToFilter))
            filters.addAll(dateRangeFilters.map(::mapMessageToFilter))
            filters.addAll(
                complexDateFilters
                    .map(::mapMessageToFilter)
                    .flatten()
            )

            layer.filter = filters;
        } catch (e: IllegalArgumentException) {
            result?.error(e)
        }
    }

    fun setLayerVisible(alias: String, isVisible: Boolean, result: Result<Void>?) {
        val layer = layers[alias]

        if (layer == null) {
            result?.error(IllegalArgumentException("Layer with alias $alias not found"))
            return
        }

        if (isVisible) layer.drawLayer() else layer.clearLayer()

        result?.success(null)
    }

    override fun close() {
        future?.close()
    }

    private fun mapMessageToFilter(message: EGStringFilterMessage) =
        EverGisAttributeFilter.createStringFilter(
            attributeName = message.attrName,
            type = StringFilterType.CONTAINS,
            value = message.value,
        )

    private fun mapMessageToFilter(message: EGDoubleFilterMessage) =
        EverGisAttributeFilter.createDoubleInRangeFilter(
            attributeName = message.attrName,
            min = message.from,
            max = message.to,
        )

    private fun mapMessageToFilter(message: EGIntFilterMessage) =
        EverGisAttributeFilter.createIntFilter(
            attributeName = message.attrName,
            type = NumericalFilterType.EQUAL,
            value = message.value,
        )

    private fun mapMessageToFilter(message: EGDateRangeFilterMessage): EverGisAttributeFilter {
        val from = message.from
        val to = message.to
        return when {
            from != null && to != null -> EverGisAttributeFilter.createDatetimePeriodFilter(
                attributeName = message.attrName,
                begin = from,
                end = to,
            )
            from != null && to == null -> EverGisAttributeFilter.createDatetimeFilter(
                attributeName = message.attrName,
                type = DateTimeFilterType.MORE_OR_EQUAL,
                value = from,
            )
            from == null && to != null -> EverGisAttributeFilter.createDatetimeFilter(
                attributeName = message.attrName,
                type = DateTimeFilterType.LESS_OR_EQUAL,
                value = to,
            )
            else -> {
                throw IllegalArgumentException("Both 'from' and 'to' arguments are null")
            }
        }
    }

    private fun mapMessageToFilter(message: EGComplexDateFilterMessage): List<EverGisAttributeFilter> {
        val from = message.from
        val to = message.to
        return when {
            from != null && to != null -> {
                listOf(
                    EverGisAttributeFilter.createDatetimeFilter(
                        attributeName = message.attrFromName,
                        type = DateTimeFilterType.MORE_OR_EQUAL,
                        value = from,
                    ),
                    EverGisAttributeFilter.createDatetimeFilter(
                        attributeName = message.attrToName,
                        type = DateTimeFilterType.LESS_OR_EQUAL,
                        value = to,
                    )
                )

            }
            from != null && to == null -> listOf(
                EverGisAttributeFilter.createDatetimeFilter(
                    attributeName = message.attrFromName,
                    type = DateTimeFilterType.MORE_OR_EQUAL,
                    value = from,
                )
            )
            from == null && to != null -> listOf(
                EverGisAttributeFilter.createDatetimeFilter(
                    attributeName = message.attrToName,
                    type = DateTimeFilterType.LESS_OR_EQUAL,
                    value = to,
                )
            )
            else -> {
                throw IllegalArgumentException("Both 'from' and 'to' arguments are null")
            }
        }
    }

    companion object {
        private val endPointData = EverGisEndPointData(
            "https://ever.2gis.ru/sp/",
            "mapnessuser",
            "W92Xu{[L'1eSD"
        )
    }
}
