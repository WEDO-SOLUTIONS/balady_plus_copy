package com.dgis.map.android_auto

import android.text.SpannableString
import android.text.Spanned
import androidx.car.app.CarContext
import androidx.car.app.ScreenManager
import androidx.car.app.constraints.ConstraintManager
import androidx.car.app.model.Action
import androidx.car.app.model.DistanceSpan
import androidx.car.app.model.Header
import androidx.car.app.model.ItemList
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.car.app.navigation.model.PlaceListNavigationTemplate
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.dgis.map.DgisMapInitializer
import com.dgis.map.R
import com.dgis.map.android_auto.utils.AndroidAutoUtils
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.Latitude
import ru.dgis.sdk.coordinates.Longitude
import ru.dgis.sdk.directory.SearchHistory
import ru.dgis.sdk.directory.SearchHistoryItem
import ru.dgis.sdk.directory.SearchHistoryPage
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.geometry.distance
import ru.dgis.sdk.map.LogicalPixel
import ru.dgis.sdk.map.Marker
import ru.dgis.sdk.map.MarkerOptions
import kotlin.math.max

class SearchHistoryScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
) : CarMapScreen(carContext, mapController) {

    private var state: SearchHistoryScreenState = SearchHistoryScreenState.Loading

    private val itemsLimit = carContext.getCarService(ConstraintManager::class.java)
        .getContentLimit(ConstraintManager.CONTENT_LIMIT_TYPE_PLACE_LIST)

    private val header by lazy {
        Header.Builder().setStartHeaderAction(Action.BACK)
            .setTitle(getString(R.string.search_history)).build()
    }

    private val searchHistory = SearchHistory(DgisMapInitializer.getSdkContext())

    init {
        val history = searchHistory.items(
            SearchHistoryPage(limit = itemsLimit.toLong())
        )
        history.apply {
            onResult { response ->
                handleHistoryResult(response.items)
            }
            onError {
                SearchScreenState.Initial
                invalidate()
            }
        }


        lifecycle.addObserver(object : DefaultLifecycleObserver {
            override fun onStop(owner: LifecycleOwner) {
                mapController.removeAllMarkers()
            }

            override fun onResume(owner: LifecycleOwner) {
                val state = state
                if (state is SearchHistoryScreenState.Result && state.markers != null) {
                    mapController.addMarkers(state.markers)
                }
            }

            override fun onDestroy(owner: LifecycleOwner) {
                mapController.removeAllMarkers()
            }
        })
    }

    override fun onGetTemplate(): Template {
        val template = PlaceListNavigationTemplate.Builder()
        template.setPanModeListener(panModeListener)
        template.setHeader(header).setMapActionStrip(buildMapActionStrip())
        when (val state = this.state) {
            SearchHistoryScreenState.Loading -> {
                template.setLoading(true)
            }

            SearchHistoryScreenState.Error -> {
                template.setLoading(false)
                val itemList = ItemList.Builder()
                    .setNoItemsMessage(getString(R.string.you_dont_seem_to_have_internet_description))
                template.setItemList(itemList.build())
            }

            is SearchHistoryScreenState.Result -> {
                template.setLoading(false)
                template.setItemList(state.itemList)
            }
        }

        return template.build()
    }

    private fun handleHistoryResult(searchHistoryItems: List<SearchHistoryItem>) {
        val items = searchHistoryItems.mapNotNull { it.asDirectoryObject }
            .filter { it.markerPosition != null }
        val itemList = ItemList.Builder()
        val myLocation = mapController.getMyLocation()
        var markers: List<Marker>? = null

        if (items.isEmpty() || myLocation == null) {
            itemList.setNoItemsMessage(getString(R.string.empty_trips_history_message))
        } else {
            markers = items.mapIndexed { index, marker ->
                val options = MarkerOptions(
                    position = marker.markerPosition!!,
                    icon = createIndexedMarker(index + 1),
                    iconWidth = LogicalPixel(16f),
                )
                Marker(options)
            }
            mapController.addMarkers(markers)
            val firstObject = items.first()
            moveToMarker(firstObject.markerPosition!!)

            itemList.setOnItemsVisibilityChangedListener { i1, i2 ->
                val index = if (i2 == items.size) i2 - 1 else max(i1, 0)
                val markerPosition = items.getOrNull(index)?.markerPosition

                if (markerPosition != null) {
                    moveToMarker(markerPosition)
                }
            }

            items.forEachIndexed { index, item ->
                val markerPosition = item.markerPosition!!
                val distanceInMeters = markerPosition.distance(
                    GeoPoint(
                        Latitude(myLocation.latitude), Longitude(myLocation.longitude)
                    )
                ).value.toDouble()

                val distanceSpan = DistanceSpan.create(
                    AndroidAutoUtils.createDistance(distanceInMeters)
                )
                val title = SpannableString("${item.title}\n ")
                val spanStart = title.length
                title.setSpan(
                    distanceSpan,
                    spanStart - 1,
                    spanStart,
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )

                itemList.addItem(
                    Row.Builder().setTitle(title)
                        .setImage(createIndexedIcon(index + 1))
                        .addText(item.subtitle).setBrowsable(true).setOnClickListener {
                            searchHistory.addItem(SearchHistoryItem(item))
                            carContext.getCarService(ScreenManager::class.java).push(
                                RoutePreviewScreen(
                                    carContext,
                                    mapController,
                                    item.toRoutePreviewParams(),
                                )
                            )
                        }.build()
                )
            }
        }

        state = SearchHistoryScreenState.Result(itemList.build(), markers)
        invalidate()
    }


    private fun moveToMarker(markerPosition: GeoPointWithElevation) {
        mapController.moveCamera(
            GeoPoint(markerPosition.latitude, markerPosition.longitude)
        )
    }
}

private sealed class SearchHistoryScreenState {
    data object Loading : SearchHistoryScreenState()
    data object Error : SearchHistoryScreenState()
    data class Result(val itemList: ItemList, val markers: List<Marker>?) :
        SearchHistoryScreenState()
}
