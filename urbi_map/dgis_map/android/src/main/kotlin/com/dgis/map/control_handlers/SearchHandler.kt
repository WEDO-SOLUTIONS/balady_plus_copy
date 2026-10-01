package com.dgis.map.control_handlers

import android.content.res.Resources.NotFoundException
import com.dgis.map.FusedLocationSource
import com.dgis.map.extensions.*
import com.dgis.map.map_api.*
import org.json.JSONObject
import org.json.JSONTokener
import ru.dgis.sdk.Context
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.await
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.GeoRect
import ru.dgis.sdk.directory.*
import ru.dgis.sdk.map.*
import ru.dgis.sdk.platform.Locale
import java.util.UUID
import ru.dgis.sdk.map.Map as DgisMap

class SearchHandler(
        private val map: DgisMap,
        private val searchManager: SearchManager,
        private val locationSource: FusedLocationSource,
        private val searchHistory: SearchHistory,
) : AutoCloseable {
    // Multiple concurrent searchByDirectoryObjectId calls (e.g. resolving positions for a
    // batch of favorite places via Future.wait on the Dart side) must each keep their own
    // future alive until completion, otherwise a later call overwriting a single field would
    // drop the SDK's required strong reference to the earlier one and its callback would
    // never fire (surfacing as a client-side timeout).
    private val objectSearchFutures: MutableSet<AutoCloseable> =
        java.util.concurrent.ConcurrentHashMap.newKeySet()
    private var searchFuture: AutoCloseable? = null
    private var itemMarkerInfosFuture: AutoCloseable? = null
    private var suggestFuture: AutoCloseable? = null

    private var pages = mutableMapOf<String, Page>()
    private var queries = mutableMapOf<String, SearchQuery>()

    override fun close() {
        objectSearchFutures.forEach { it.close() }
        objectSearchFutures.clear()
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

    fun searchByDirectoryObjectId(
        objectId: DgisObjectId,
        callback: (Result<DirectoryObjectMessage>)->Unit
    ) {
        lateinit var future: AutoCloseable
        future = searchManager.searchByDirectoryObjectId(objectId).apply {
            onResult { response ->
                objectSearchFutures.remove(future)
                if (response == null) {
                    callback(Result.failure(NotFoundException("Object with id ${objectId.objectId} not found")))
                    return@onResult
                }

                callback(Result.success(response.toMessage()))
            }
            onError {
                objectSearchFutures.remove(future)
                callback(Result.failure(it))
            }
        }
        objectSearchFutures.add(future)
    }

    fun search(
        queryText: String,
        rubricIds: List<RubricId>?,
        spatialRestriction: List<GeoPoint>?,
        searchGeoRect: GeoRect?,
        weekTimeMessage: WeekTimeSearchMessage? = null,
        sortingType: SortingTypeMessage,
        pageSize: Int,
        locale: String?,
        callback: (Result<SearchResultMessage>)->Unit
    ) {
        val queryBuilder =
                if (rubricIds != null)
                        SearchQueryBuilder.fromQueryTextAndRubricIds(queryText, rubricIds)
                else SearchQueryBuilder.fromQueryText(queryText)

        val query =
                queryBuilder
                        .setSortingType(sortingType.toSortingType())
                        .setPageSize(pageSize)
                        .setLocale(if(locale != null) Locale.makeLocale(localeStr = locale) else null)
                        .setDirectoryFilter(
                                DirectoryFilter(weekTimeMessage.toFilter(), emptyList())
                        )
                        .setAreaOfInterest(searchGeoRect)
                        .setSpatialRestriction(spatialRestriction ?: saRestrictions)
                        .build()

        performSearch(
            query = query,
            callback = callback
        )
    }

    fun searchByQuery(
        queryId: SearchQueryMessage,
        spatialRestriction: List<GeoPoint>?,
        searchGeoRect: GeoRect?,
        weekTimeMessage: WeekTimeSearchMessage? = null,
        sortingType: SortingTypeMessage,
        pageSize: Int,
        locale: String?,
        callback: (Result<SearchResultMessage>)->Unit
    ) {
        if (this.queries[queryId.id] == null) {
            callback(Result.failure(IllegalArgumentException("SearchQuery with given id not exists")))
            return
        }

        val searchQuery = this.queries[queryId.id]!!

        val query =
                SearchQueryBuilder.fromQuery(searchQuery)
                        .setSortingType(sortingType.toSortingType())
                        .setPageSize(pageSize)
                        .setLocale(if(locale != null) Locale.makeLocale(localeStr = locale) else null)
                        .setDirectoryFilter(
                                DirectoryFilter(weekTimeMessage.toFilter(), emptyList())
                        )
                        .setAreaOfInterest(searchGeoRect)
                        .setSpatialRestriction(spatialRestriction ?: saRestrictions)
                        .build()

        performSearch(
            query = query,
            callback = callback
        )
    }

    fun searchByRubrics(
        rubricIds: List<RubricId>,
        spatialRestriction: List<GeoPoint>?,
        searchGeoRect: GeoRect?,
        weekTimeMessage: WeekTimeSearchMessage? = null,
        sortingType: SortingTypeMessage,
        pageSize: Int,
        locale: String?,
        callback: (Result<SearchResultMessage>)->Unit
    ) {
        val query =
                SearchQueryBuilder.fromRubricIds(rubricIds)
                        .setSortingType(sortingType.toSortingType())
                        .setPageSize(pageSize)
                        .setLocale(if(locale != null) Locale.makeLocale(localeStr = locale) else null)
                        .setDirectoryFilter(
                                DirectoryFilter(weekTimeMessage.toFilter(), emptyList())
                        )
                        .setAreaOfInterest(searchGeoRect)
                        .setSpatialRestriction(spatialRestriction ?: saRestrictions)
                        .build()

        performSearch(
            query = query,
            callback = callback
        )
    }

    private fun performSearch(query: SearchQuery, callback: (Result<SearchResultMessage>)->Unit) {
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

                                callback(Result.success(
                                    response.toMessage(pageId, map.camera, items)
                                ))
                            }
                            onError { error -> callback(Result.failure(error)) }
                        }
                }
                onError { error -> callback(Result.failure(error)) }
            }
    }

    fun fetchNextPage(pageId: PageIdMessage,callback: (Result<PageMessage>)->Unit) {
        if (this.pages[pageId.id] == null) {
            callback(Result.failure(IllegalArgumentException("Page with given id not exists")))
//            return txtCilor = while. naturalOrder<>()
        }

        searchFuture =
                this.pages[pageId.id]!!.fetchNextPage().apply {
                    onResult { response ->
                        if (response != null) {
                            val pageId = UUID.randomUUID().toString()
                            this@SearchHandler.pages[pageId] = response

                    callback(Result.success(
                        response.toMessage(pageId))
                    )
                } else {
                    callback(Result.failure(IllegalArgumentException("Failed to fetch page")))
                }
            }
            onError { error ->
                callback(Result.failure(error))
            }
        }
    }

    fun fetchPrevPage(pageId: PageIdMessage,callback: (Result<PageMessage>)->Unit) {
        if (this.pages[pageId.id] == null) {
            callback(Result.failure(IllegalArgumentException("Page with given id not exists")))
            return
        }

        searchFuture =
                this.pages[pageId.id]!!.fetchPrevPage().apply {
                    onResult { response ->
                        if (response != null) {
                            val pageId = UUID.randomUUID().toString()
                            this@SearchHandler.pages[pageId] = response

                    callback(Result.success(
                        response.toMessage(pageId)
                    ))
                } else {
                    callback(Result.failure(IllegalArgumentException("Failed to fetch page")))
                }
            }
            onError { error ->
                callback(Result.failure(error))
            }
        }
    }

    fun releasePage(pageId: PageIdMessage, callback: (Result<Unit>) -> Unit) {
        if (this.pages[pageId.id] == null) {
            callback(Result.failure(IllegalArgumentException("Page with given id not exists")))
            return
        }

        this.pages.remove(pageId.id)
        callback(Result.success(Unit))
    }

    fun fetchSuggests(
        queryText: String,
        allowedResultTypes: List<SuggestedTypeMessage_>?,
        searchGeoRect: GeoRect?,
        locale: String?,
        suggestorType: SuggestorTypeEnum?,
        limit: Int?,
        callback: (Result<SuggestResultMessage>)->Unit
    ) {
        var suggestQueryBuilder =
                SuggestQueryBuilder.fromQueryText(queryText)
                        .setAreaOfInterest(searchGeoRect)
                        .setSpatialRestriction(saRestrictions)
                        .setLocale(if(locale != null) Locale.makeLocale(localeStr = locale) else null)
        
        if(suggestorType != null) {
            suggestQueryBuilder = suggestQueryBuilder.setSuggestorType(suggestorType.toSuggestType())
        }
        if (limit != null) {
            suggestQueryBuilder = suggestQueryBuilder.setLimit(limit)
        }
        
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

                        callback(
                            Result.success(
                                SuggestResultMessage(suggests = suggests)
                            )
                        )
                    }
                    onError { callback(Result.failure(it)) }
                }
            }

    fun getDistanceTo(
        points: List<DistanceRequestMessage>,
        callback: (Result<List<DistanceResponseMessage>>)-> Unit
    ) {
        val location = locationSource.lastLocation ?: run {
            callback(Result.failure(IllegalArgumentException("Last location unknown")))
            return
        }

        val current = GeoPoint(location.latitude, location.longitude)
        val distance = points.map { it.toResponse(current) }

        callback(Result.success(distance))
    }

    suspend fun searchByDirectoryObjectIdSync(objectId: DgisObjectId): DirectoryObject? =
        searchManager.searchByDirectoryObjectId(objectId).await()

    suspend fun getSearchHistoryItems(): List<SearchHistoryDirectoryObjectMessage> {
        return getRawSearchHistoryItems().map { it.toMessage() }
    }

    suspend fun getRawSearchHistoryItems(): List<SearchHistoryItem> =
        searchHistory.items(SearchHistoryPage()).await().items

    fun addDirectoryObjectSearchHistoryItem(directoryObject: DirectoryObject) {
        searchHistory.addItem(
            item = SearchHistoryItem(directoryObject)
        )
    }

    fun addQuerySearchHistoryItem(queryText: String) {
        searchHistory.addItem(
            item = SearchHistoryItem(
                SearchQueryWithInfo(
                    searchQuery = SearchQueryBuilder.fromQueryText(queryText = queryText).build(),
                    title = queryText,
                    subtitle = ""
                )
            )
        )
    }

    fun removeSearchHistoryItem(item: SearchHistoryItem) {
        searchHistory.removeItem(item = item)
    }

    fun clearSearchHistory() {
        searchHistory.clear()
    }
}
