package com.dgis.map.control_handlers

import android.content.res.Resources.NotFoundException
import android.util.Size
import com.dgis.map.R
import com.dgis.map.extensions.*
import com.dgis.map.map_api.Messages.*
import io.flutter.FlutterInjector
import ru.dgis.sdk.Context
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.GeoRect
import ru.dgis.sdk.directory.*
import ru.dgis.sdk.map.*
import ru.dgis.sdk.positioning.DefaultLocationSource
import java.io.FileNotFoundException
import ru.dgis.sdk.map.Map as DgisMap

class SearchHandler(
    private val map: DgisMap,
    private val sdkContext: Context,
    private val searchManager: SearchManager,
    private val locationSource: DefaultLocationSource,
) : AutoCloseable {

    private var objectSearchFuture: AutoCloseable? = null
    private var searchFuture: AutoCloseable? = null
    private var suggestFuture: AutoCloseable? = null
    private var searchMarkerFuture: AutoCloseable? = null

    private var page: Page? = null

    private val avalilableFlagFilters = hashSetOf<FlagFilter>()

    private var lastQuery: SearchQuery? = null

    private var suggests = emptyList<Suggest>()

    private val objectManager by unsafeLazy {
        val logicalPixelValue = 30f
        MapObjectManager.withGeneralization(
            map = map,
            logicalPixel = LogicalPixel(logicalPixelValue),
            maxZoom = Zoom(18.0f),
        )
    }

    private var searchMarkerIcon: Image? = null
    private var searchMarkerWidth: LogicalPixel? = null

    override fun close() {
        objectSearchFuture?.close()
        searchFuture?.close()
        suggestFuture?.close()
        searchMarkerFuture?.close()
    }

    fun searchByDirectoryObjectId(
        objectId: DgisObjectId,
        result: Result<ObjectInfoMessage>?
    ) {
        objectSearchFuture = searchManager.searchByDirectoryObjectId(objectId).apply {
            onResult { response ->
                if (response == null) {
                    result?.error(NotFoundException("Object with id ${objectId.objectId} not found"))
                    return@onResult
                }

                result?.success(response.toMessage())
            }
            onError { result?.error(it) }
        }
    }

    fun getSuggestObject(index: Int, result: Result<ObjectInfoMessage>?) {
        val item = suggests[index].handler.asObjectHandler?.item ?: run {
            result?.error(IllegalArgumentException("Suggest with index $index no found"))
            return
        }

        result?.success(item.toMessage())
    }

    fun fetchSuggests(
        queryText: String,
        searchGeoRect: GeoRect,
        result: Result<List<SuggestMessage>>?
    ) {
        val suggestQuery = SuggestQueryBuilder.fromQueryText(queryText)
            .setAreaOfInterest(searchGeoRect)
            .build()

        suggestFuture = searchManager.suggest(suggestQuery).apply {
            onResult { response ->
                suggests = response.suggests

                result?.success(
                    response.suggests.mapIndexed(::mapSuggestToMessage)
                )
            }
            onError { result?.error(it) }
        }
    }

    fun searchBySuggest(
        index: Int,
        searchMarker: MarkerIconMessage,
        searchGeoRect: GeoRect,
        weekTimeMessage: WeekTimeSearchMessage? = null,
        sortingType: SortingTypeMessage,
        pageSize: Int,
        result: Result<List<ObjectInfoMessage>>?
    ) {
        val suggestQuery = suggests[index].handler.asPerformSearchHandler?.searchQuery ?: run {
            result?.error(IllegalArgumentException("Suggest with index $index no found"))
            return
        }

        val query = SearchQueryBuilder.fromQuery(suggestQuery)

        performSearch(
            builder = query,
            searchMarker = searchMarker,
            searchGeoRect = searchGeoRect,
            weekTimeMessage = weekTimeMessage,
            sortingType = sortingType,
            pageSize = pageSize,
            result = result
        )
    }

    fun search(
        queryText: String,
        searchMarker: MarkerIconMessage,
        searchGeoRect: GeoRect,
        weekTimeMessage: WeekTimeSearchMessage? = null,
        sortingType: SortingTypeMessage,
        pageSize: Int,
        result: Result<List<ObjectInfoMessage>>?
    ) {
        val query = SearchQueryBuilder.fromQueryText(queryText)

        performSearch(
            builder = query,
            searchMarker = searchMarker,
            searchGeoRect = searchGeoRect,
            weekTimeMessage = weekTimeMessage,
            sortingType = sortingType,
            pageSize = pageSize,
            result = result
        )
    }

    fun applyDirectoryFilters(
        filters: List<FlagFilterMessage>,
        isOpenFilter: WorkingFilterMessage,
        sortingType: SortingTypeMessage,
        result: Result<List<ObjectInfoMessage>>?
    ) {
        val lastQuery = lastQuery ?: kotlin.run {
            result?.error(IllegalArgumentException("No query to apply filters"))
            return
        }

        val timeFilter = when (isOpenFilter) {
            WorkingFilterMessage.IS_OPEN -> WorkTimeFilter(IsOpenNow())
            WorkingFilterMessage.NONE -> null
            WorkingFilterMessage.IS_OPEN24X7 -> null
        }

        val query = SearchQueryBuilder.fromQuery(lastQuery)
            .setDirectoryFilter(DirectoryFilter(
                timeFilter,
                filters
                    .filter { it.flagValue }
                    .map {
                        DynamicFilter(
                            FlagFilter(
                                tagName = it.tagName,
                                displayName = it.displayName,
                                flagValue = it.flagValue,
                            )
                        )
                    }
            ))
            .setSortingType(sortingType.toSortingType())
            .build()

        searchFuture = searchManager.search(query).apply {
            onResult { response ->
                parseDynamicFilters(response.dynamicFilters)
                drawSearchMarkers(response)
                this@SearchHandler.lastQuery = query
                result?.success(handleSearchResponse(response.firstPage))
            }
            onError { result?.error(it) }
        }
    }

    fun getDirectoryDynamicFilters(result: Result<List<FlagFilterMessage>>?) {
        result?.success(
            avalilableFlagFilters.map {
                FlagFilterMessage.Builder()
                    .setDisplayName(getFlagFilterDisplayName(it))
                    .setTagName(it.tagName)
                    .setFlagValue(it.flagValue ?: false)
                    .build()
            }
        )
    }

    fun getDistanceTo(
        points: List<DistanceRequestMessage>,
        result: Result<List<DistanceResponseMessage>>?
    ) {
        val location = locationSource.lastLocation ?: run {
            result?.error(IllegalArgumentException("Last location unknown"))
            return
        }

        val current = GeoPoint(location.latitude, location.longitude)
        val distance = points.map { it.toResponse(current) }

        result?.success(distance)
    }

    fun getNextPage(result: Result<List<ObjectInfoMessage>>?) {
        searchFuture = page?.fetchNextPage()?.apply {
            onResult { page -> result?.success(handleSearchResponse(page)) }
            onError { result?.error(it) }
        }
    }

    fun removeSearchMarkers() {
        objectManager.removeAll()
    }

    private fun getFlagFilterDisplayName(filter: FlagFilter): String {
        if (filter.tagName == "general_payment_type_card") {
            return "Payment by card through the terminal"
        }
        return filter.displayName
    }

    private fun performSearch(
        builder: SearchQueryBuilder,
        searchMarker: MarkerIconMessage,
        searchGeoRect: GeoRect,
        weekTimeMessage: WeekTimeSearchMessage? = null,
        sortingType: SortingTypeMessage,
        pageSize: Int,
        result: Result<List<ObjectInfoMessage>>?
    ) {
        try {
            val asset =
                FlutterInjector
                    .instance()
                    .flutterLoader()
                    .getLookupKeyForAsset(searchMarker.path)

            this.searchMarkerIcon = imageFromAsset(sdkContext, asset, Size(0, 0))
        } catch (e: FileNotFoundException) {
            result?.error(e)
            return
        }
        this.searchMarkerWidth = LogicalPixel(value = searchMarker.width.toFloat())

        val query = builder.setSortingType(sortingType.toSortingType())
            .setPageSize(pageSize)
            .setDirectoryFilter(DirectoryFilter(weekTimeMessage.toFilter(), emptyList()))
            .setAreaOfInterest(searchGeoRect)
            .build()

        searchFuture = searchManager.search(query).apply {
            onResult { response ->
                parseDynamicFilters(response.dynamicFilters)
                drawSearchMarkers(response)
                lastQuery = query
                result?.success(handleSearchResponse(response.firstPage))
            }
            onError { error ->
                val tympError = error
                println("this this this"+error)
                println(error)
                println(error)
//                result?.error(error)
            }
        }
    }

    private fun parseDynamicFilters(filters: List<DynamicFilter>) {
        avalilableFlagFilters.clear()
        avalilableFlagFilters.addAll(
            filters.filter(DynamicFilter::isFlagFilter)
                .mapNotNull(DynamicFilter::asFlagFilter)
        )
    }

    private fun drawSearchMarkers(searchResult: SearchResult) {
        removeSearchMarkers()
        searchMarkerFuture = searchResult.itemMarkerInfos.apply {
            onResult {
                val itemMarkerInfos = it ?: return@onResult

                val markers = itemMarkerInfos.map { markerInfo ->
                    Marker(
                        MarkerOptions(
                            position = markerInfo.geoPoint,
                            icon = searchMarkerIcon,
                            iconWidth = searchMarkerWidth ?: LogicalPixel(value = 16f),
                            userData = markerInfo.objectId
                        )
                    )
                }

                objectManager.addObjects(markers)
            }
        }
    }

    private fun handleSearchResponse(
        page: Page?,
    ): List<ObjectInfoMessage> {
        this.page = page
        val items = page?.items ?: return emptyList()

        return items.map(DirectoryObject::toMessage)
    }
}
