package com.dgis.map.android_auto

import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.directory.DirectoryObject
import ru.dgis.sdk.directory.SearchManager
import ru.dgis.sdk.directory.SearchQueryBuilder
import ru.dgis.sdk.directory.SortingType
import ru.dgis.sdk.directory.Suggest
import ru.dgis.sdk.directory.SuggestQueryBuilder
import ru.dgis.sdk.directory.SuggestorType
import java.lang.Exception

class CarSearchHandler(private val searchManager: SearchManager) : AutoCloseable {

    private var searchFuture: AutoCloseable? = null
    private var suggestFuture: AutoCloseable? = null

    fun searchByDirectoryObjectId(
        objectId: DgisObjectId,
        resultCallback: (result: DirectoryObject?) -> Unit,
        errorCallback: ((exception: Exception) -> Unit)? = null
    ) {
        searchManager.searchByDirectoryObjectId(objectId).apply {
            onResult { resultCallback(it) }
            onError { errorCallback?.invoke(it) }
        }
    }

    fun search(
        queryText: String,
        pageSize: Int,
        resultCallback: (result: List<DirectoryObject>) -> Unit,
        errorCallback: ((exception: Exception) -> Unit)? = null
    ) {
        val query =
            SearchQueryBuilder.fromQueryText(queryText).setSortingType(SortingType.BY_DISTANCE)
                .setPageSize(pageSize).setSpatialRestriction(saRestrictions).build()

        searchFuture = searchManager.search(query).apply {
            onResult { searchResult ->
                resultCallback(
                    searchResult.firstPage?.items ?: emptyList()
                )
            }
            onError { errorCallback?.invoke(it) }
        }
    }

    fun suggest(
        queryText: String,
        limit: Int,
        resultCallback: (result: List<Suggest>) -> Unit,
        errorCallback: ((exception: Exception) -> Unit)? = null
    ) {
        val suggestQuery =
            SuggestQueryBuilder.fromQueryText(queryText)
                .setSpatialRestriction(saRestrictions)
                .setSuggestorType(SuggestorType.ROUTE_ENDPOINT)
                .setLimit(limit)
                .build()

        suggestFuture?.close()
        suggestFuture =
            searchManager.suggest(suggestQuery).apply {
                onResult { response -> resultCallback(response.suggests) }
                onError { errorCallback?.invoke(it) }
            }
    }

    companion object {
        private val saRestrictions: List<GeoPoint> = listOf(
            GeoPoint(latitude = 32.568765, longitude = 56.694472),
            GeoPoint(latitude = 32.568765, longitude = 32.61185),
            GeoPoint(latitude = 15.506104, longitude = 32.61185),
            GeoPoint(latitude = 15.506104, longitude = 56.694472),
        )
    }

    override fun close() {
        searchFuture?.close()
    }
}
