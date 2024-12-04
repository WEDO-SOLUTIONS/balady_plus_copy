package com.dgis.map.control_handlers

import android.content.res.Resources.NotFoundException
import com.dgis.map.FusedLocationSource
import com.dgis.map.extensions.*
import com.dgis.map.map_api.Messages.*
import java.util.UUID
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.GeoRect
import ru.dgis.sdk.directory.*
import ru.dgis.sdk.map.*
import ru.dgis.sdk.map.Map as DgisMap

class SearchHandler(
        private val map: DgisMap,
        private val searchManager: SearchManager,
        private val locationSource: FusedLocationSource,
) : AutoCloseable {
    private var objectSearchFuture: AutoCloseable? = null
    private var searchFuture: AutoCloseable? = null
    private var itemMarkerInfosFuture: AutoCloseable? = null
    private var suggestFuture: AutoCloseable? = null

    private var pages = mutableMapOf<String, Page>()
    private var queries = mutableMapOf<String, SearchQuery>()

    override fun close() {
        objectSearchFuture?.close()
        searchFuture?.close()
        suggestFuture?.close()
        itemMarkerInfosFuture?.close()
    }

    companion object {
        private val saRestrictions: List<GeoPoint> =
                listOf(
                        GeoPoint(latitude = 32.568765, longitude = 56.694472),
                        GeoPoint(latitude = 32.568765, longitude = 32.61185),
                        GeoPoint(latitude = 15.506104, longitude = 32.61185),
                        GeoPoint(latitude = 15.506104, longitude = 56.694472),
                )
    }

    fun searchByDirectoryObjectId(objectId: DgisObjectId, result: Result<DirectoryObjectMessage>?) {
        objectSearchFuture =
                searchManager.searchByDirectoryObjectId(objectId).apply {
                    onResult { response ->
                        if (response == null) {
                            result?.error(
                                    NotFoundException(
                                            "Object with id ${objectId.objectId} not found"
                                    )
                            )
                            return@onResult
                        }

                        result?.success(response.toMessage())
                    }
                    onError { result?.error(it) }
                }
    }

    fun search(
            queryText: String,
            categories: List<RubricId>?,
            spatialRestriction: List<GeoPoint>?,
            searchGeoRect: GeoRect?,
            weekTimeMessage: WeekTimeSearchMessage? = null,
            sortingType: SortingTypeMessage,
            pageSize: Int,
            result: Result<SearchResultMessage>?
    ) {
        val queryBuilder =
                if (categories != null)
                        SearchQueryBuilder.fromQueryTextAndRubricIds(queryText, categories!!)
                else SearchQueryBuilder.fromQueryText(queryText)

        val query =
                queryBuilder
                        .setSortingType(sortingType.toSortingType())
                        .setPageSize(pageSize)
                        .setDirectoryFilter(
                                DirectoryFilter(weekTimeMessage.toFilter(), emptyList())
                        )
                        .setAreaOfInterest(searchGeoRect)
                        .setSpatialRestriction(spatialRestriction ?: saRestrictions)
                        .build()

        performSearch(query = query, result = result)
    }

    fun searchByQuery(
            queryId: SearchQueryMessage,
            spatialRestriction: List<GeoPoint>?,
            searchGeoRect: GeoRect?,
            weekTimeMessage: WeekTimeSearchMessage? = null,
            sortingType: SortingTypeMessage,
            pageSize: Int,
            result: Result<SearchResultMessage>?
    ) {
        if (this.queries[queryId.id] == null) {
            result?.error(IllegalArgumentException("SearchQuery with given id not exists"))
            return
        }

        val searchQuery = this.queries[queryId.id]!!

        val query =
                SearchQueryBuilder.fromQuery(searchQuery)
                        .setSortingType(sortingType.toSortingType())
                        .setPageSize(pageSize)
                        .setDirectoryFilter(
                                DirectoryFilter(weekTimeMessage.toFilter(), emptyList())
                        )
                        .setAreaOfInterest(searchGeoRect)
                        .setSpatialRestriction(spatialRestriction ?: saRestrictions)
                        .build()

        performSearch(query = query, result = result)
    }

    fun searchByCategories(
            categories: List<RubricId>,
            spatialRestriction: List<GeoPoint>?,
            searchGeoRect: GeoRect?,
            weekTimeMessage: WeekTimeSearchMessage? = null,
            sortingType: SortingTypeMessage,
            pageSize: Int,
            result: Result<SearchResultMessage>?
    ) {
        val query =
                SearchQueryBuilder.fromRubricIds(categories)
                        .setSortingType(sortingType.toSortingType())
                        .setPageSize(pageSize)
                        .setDirectoryFilter(
                                DirectoryFilter(weekTimeMessage.toFilter(), emptyList())
                        )
                        .setAreaOfInterest(searchGeoRect)
                        .setSpatialRestriction(spatialRestriction ?: saRestrictions)
                        .build()

        performSearch(query = query, result = result)
    }

    fun searchByParkCategory(
            searchGeoRect: GeoRect?,
            spatialRestriction: List<GeoPoint>?,
            weekTimeMessage: WeekTimeSearchMessage? = null,
            sortingType: SortingTypeMessage,
            pageSize: Int,
            result: Result<SearchResultMessage>?
    ) {
        val query =
                SearchQueryBuilder.fromQueryText("park")
                        .setAllowedResultTypes(listOf(ObjectType.ATTRACTION))
                        .setSortingType(sortingType.toSortingType())
                        .setPageSize(pageSize.toInt())
                        .setDirectoryFilter(
                                DirectoryFilter(weekTimeMessage.toFilter(), emptyList())
                        )
                        .setAreaOfInterest(searchGeoRect)
                        .setSpatialRestriction(spatialRestriction ?: saRestrictions)
                        .build()

        performSearch(query = query, result = result)
    }

    fun searchByBeachCategory(
            searchGeoRect: GeoRect?,
            spatialRestriction: List<GeoPoint>?,
            weekTimeMessage: WeekTimeSearchMessage? = null,
            sortingType: SortingTypeMessage,
            pageSize: Int,
            result: Result<SearchResultMessage>?
    ) {
        val query =
                SearchQueryBuilder.fromQueryText("beach")
                        .setAllowedResultTypes(listOf(ObjectType.ATTRACTION))
                        .setSortingType(sortingType.toSortingType())
                        .setPageSize(pageSize.toInt())
                        .setDirectoryFilter(
                                DirectoryFilter(weekTimeMessage.toFilter(), emptyList())
                        )
                        .setAreaOfInterest(searchGeoRect)
                        .setSpatialRestriction(spatialRestriction ?: saRestrictions)
                        .build()

        performSearch(query = query, result = result)
    }

    private fun performSearch(query: SearchQuery, result: Result<SearchResultMessage>?) {
        searchFuture =
                searchManager.search(query).apply {
                    onResult { response ->
                        this@SearchHandler.itemMarkerInfosFuture =
                                response.itemMarkerInfos.apply {
                                    onResult { items ->
                                        val pageId = UUID.randomUUID().toString()
                                        if (response.firstPage != null) {
                                            this@SearchHandler.pages[pageId] = response.firstPage!!
                                        }

                                        result?.success(
                                                response.toMessage(pageId, map.camera, items)
                                        )
                                    }
                                    onError { error -> result?.error(error) }
                                }
                    }
                    onError { error -> result?.error(error) }
                }
    }

    fun fetchNextPage(pageId: PageIdMessage, result: Result<PageMessage>?) {
        if (this.pages[pageId.id] == null) {
            result?.error(IllegalArgumentException("Page with given id not exists"))
            //            return txtCilor = while. naturalOrder<>()
        }

        searchFuture =
                this.pages[pageId.id]!!.fetchNextPage().apply {
                    onResult { response ->
                        if (response != null) {
                            val pageId = UUID.randomUUID().toString()
                            this@SearchHandler.pages[pageId] = response

                            result?.success(response.toMessage(pageId))
                        } else {
                            result?.error(IllegalArgumentException("Failed to fetch page"))
                        }
                    }
                    onError { error -> result?.error(error) }
                }
    }

    fun fetchPrevPage(pageId: PageIdMessage, result: Result<PageMessage>?) {
        if (this.pages[pageId.id] == null) {
            result?.error(IllegalArgumentException("Page with given id not exists"))
            return
        }

        searchFuture =
                this.pages[pageId.id]!!.fetchPrevPage().apply {
                    onResult { response ->
                        if (response != null) {
                            val pageId = UUID.randomUUID().toString()
                            this@SearchHandler.pages[pageId] = response

                            result?.success(response.toMessage(pageId))
                        } else {
                            result?.error(IllegalArgumentException("Failed to fetch page"))
                        }
                    }
                    onError { error -> result?.error(error) }
                }
    }

    fun releasePage(pageId: PageIdMessage, result: VoidResult) {
        if (this.pages[pageId.id] == null) {
            result?.error(IllegalArgumentException("Page with given id not exists"))
            return
        }

        this.pages.remove(pageId.id)
        result.success()
    }

    fun fetchSuggests(
            queryText: String,
            allowedResultTypes: List<SuggestedTypeMessage_>?,
            searchGeoRect: GeoRect?,
            result: Result<SuggestResultMessage>?
    ) {
        var suggestQueryBuilder =
                SuggestQueryBuilder.fromQueryText(queryText)
                        .setAreaOfInterest(searchGeoRect)
                        .setSpatialRestriction(saRestrictions)

        if (allowedResultTypes != null) {
            suggestQueryBuilder =
                    suggestQueryBuilder.setAllowedResultTypes(
                            allowedResultTypes.map { it.type.toSuggestType() }
                    )
        }

        val suggestQuery = suggestQueryBuilder.build()

        suggestFuture?.close()
        suggestFuture =
                searchManager.suggest(suggestQuery).apply {
                    onResult { response ->
                        this@SearchHandler.queries.clear()
                        val suggests =
                                response.suggests.map {
                                    var queryId: String? = null
                                    if (it.handler.isPerformSearchHandler) {
                                        queryId = UUID.randomUUID().toString()
                                        this@SearchHandler.queries[queryId] =
                                                it.handler.asPerformSearchHandler!!.searchQuery
                                    }

                                    it.toMessage(queryId)
                                }

                        result?.success(
                                SuggestResultMessage.Builder().setSuggests(suggests).build()
                        )
                    }
                    onError { result?.error(it) }
                }
    }

    fun getDistanceTo(
            points: List<DistanceRequestMessage>,
            result: Result<List<DistanceResponseMessage>>?
    ) {
        val location =
                locationSource.lastLocation
                        ?: run {
                            result?.error(IllegalArgumentException("Last location unknown"))
                            return
                        }

        val current = GeoPoint(location.latitude, location.longitude)
        val distance = points.map { it.toResponse(current) }

        result?.success(distance)
    }
}
