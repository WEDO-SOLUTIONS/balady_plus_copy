package com.dgis.map.android_auto

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.ScreenManager
import androidx.car.app.constraints.ConstraintManager
import androidx.car.app.model.Action
import androidx.car.app.model.ItemList
import androidx.car.app.model.Row
import androidx.car.app.model.SearchTemplate
import androidx.car.app.model.SearchTemplate.SearchCallback
import androidx.car.app.model.Template
import com.dgis.map.DgisMapInitializer
import com.dgis.map.R
import ru.dgis.sdk.directory.SearchHistory
import ru.dgis.sdk.directory.SearchHistoryItem
import ru.dgis.sdk.directory.SearchHistoryPage
import ru.dgis.sdk.directory.Suggest

class SearchScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
    private val initialQuery: String? = null
) : Screen(carContext) {

    private var state: SearchScreenState = SearchScreenState.Loading

    private val searchItemsLimit = carContext.getCarService(ConstraintManager::class.java)
        .getContentLimit(ConstraintManager.CONTENT_LIMIT_TYPE_PLACE_LIST)

    private val searchHistory = SearchHistory(DgisMapInitializer.getSdkContext())

    init {
        if (initialQuery != null) {
            search(initialQuery)
        } else {
            loadHistory()
        }
    }

    override fun onGetTemplate(): Template {
        val template = SearchTemplate.Builder(
            object : SearchCallback {
                override fun onSearchTextChanged(searchText: String) {
                    if (searchText.isNotEmpty()) {
                        search(searchText)
                    } else {
                        loadHistory()
                    }
                }
            })
            .setHeaderAction(Action.BACK)
            .setShowKeyboardByDefault(false)
            .setInitialSearchText(initialQuery ?: "")

        when (val state = this.state) {
            SearchScreenState.Initial -> {}

            SearchScreenState.Loading -> {
                template.setLoading(true)
            }

            SearchScreenState.Error -> {
                template.setLoading(false)
                val itemList = ItemList.Builder()
                    .setNoItemsMessage(getString(R.string.you_dont_seem_to_have_internet_description))
                template.setItemList(itemList.build())
            }

            is SearchScreenState.Result -> {
                template.setLoading(false)
                template.setItemList(state.itemList)
            }

            is SearchScreenState.History -> {
                template.setLoading(false)
                template.setItemList(state.itemList)
            }
        }
        return template.build()
    }

    private fun search(queryText: String) {
        state = SearchScreenState.Loading
        invalidate()
        mapController.suggest(
            queryText,
            searchItemsLimit,
            resultCallback = ::handleSearchResult,
            errorCallback = {
                state = SearchScreenState.Error
                invalidate()
            }
        )
    }

    private fun loadHistory() {
        val history = searchHistory.items(
            SearchHistoryPage(limit = searchItemsLimit.toLong())
        )
        history.apply {
            onResult { response ->
                val items = response.items.mapNotNull { it.asDirectoryObject }
                    .filter { it.markerPosition != null }
                val itemList = ItemList.Builder()

                if (items.isEmpty()) {
                    SearchScreenState.Initial
                    invalidate()
                    return@onResult
                }

                for (item in items) {
                    val markerPosition = item.markerPosition!!
                    itemList.addItem(
                        Row.Builder().setTitle(item.title).addText(item.makeAddressString())
                            .setOnClickListener {
                                searchHistory.addItem(SearchHistoryItem(item))
                                mapController.setRouteParams(
                                    markerPosition.latitude.value,
                                    markerPosition.longitude.value,
                                    item.id
                                )
                                carContext.getCarService(ScreenManager::class.java).popToRoot()
                            }.build()
                    )
                }

                state = SearchScreenState.History(itemList.build())
                invalidate()
            }
            onError {
                SearchScreenState.Initial
                invalidate()
            }
        }
    }

    private fun handleSearchResult(suggests: List<Suggest>) {
        val items =
            suggests.filter { it.handler.asObjectHandler != null || it.handler.asObjectHandler!!.item.markerPosition != null }
        val itemList = ItemList.Builder()

        if (items.isEmpty()) {
            itemList.setNoItemsMessage(getString(R.string.search_nothing_found))
        } else {
            for (item in items) {
                val dgisObject = item.handler.asObjectHandler!!
                val markerPosition = dgisObject.item.markerPosition!!

                itemList.addItem(
                    Row.Builder().setTitle(item.title.text).addText(item.subtitle.text)
                        .setOnClickListener {
                            searchHistory.addItem(SearchHistoryItem(dgisObject.item))
                            mapController.setRouteParams(
                                markerPosition.latitude.value,
                                markerPosition.longitude.value,
                                dgisObject.item.id
                            )
                            carContext.getCarService(ScreenManager::class.java).popToRoot()
                        }.build()
                )
            }
        }

        state = SearchScreenState.Result(itemList.build())
        invalidate()
    }
}

sealed class SearchScreenState {
    data object Initial : SearchScreenState()
    data object Loading : SearchScreenState()
    data object Error : SearchScreenState()
    class Result(val itemList: ItemList) : SearchScreenState()
    class History(val itemList: ItemList) : SearchScreenState()
}
