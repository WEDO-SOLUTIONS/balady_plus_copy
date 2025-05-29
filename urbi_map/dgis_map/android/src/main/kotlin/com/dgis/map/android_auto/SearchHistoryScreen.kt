package com.dgis.map.android_auto

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.text.SpannableString
import android.text.Spanned
import android.util.Size
import androidx.car.app.CarContext
import androidx.car.app.ScreenManager
import androidx.car.app.constraints.ConstraintManager
import androidx.car.app.model.Action
import androidx.car.app.model.CarIcon
import androidx.car.app.model.Distance
import androidx.car.app.model.DistanceSpan
import androidx.car.app.model.Header
import androidx.car.app.model.ItemList
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.car.app.navigation.model.PlaceListNavigationTemplate
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.IconCompat
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.dgis.map.DgisMapInitializer
import com.dgis.map.R
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.Latitude
import ru.dgis.sdk.coordinates.Longitude
import ru.dgis.sdk.directory.SearchHistory
import ru.dgis.sdk.directory.SearchHistoryItem
import ru.dgis.sdk.directory.SearchHistoryPage
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.geometry.distance
import ru.dgis.sdk.map.Image
import ru.dgis.sdk.map.LogicalPixel
import ru.dgis.sdk.map.Marker
import ru.dgis.sdk.map.MarkerOptions
import ru.dgis.sdk.map.Padding
import ru.dgis.sdk.map.imageFromBitmap
import ru.dgis.sdk.map.imageFromResource
import kotlin.math.max
import kotlin.math.round

class SearchHistoryScreen(
    carContext: CarContext,
    private val mapController: CarMapController
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
            override fun onDestroy(owner: LifecycleOwner) {
                mapController.removeAllMarkers()
                mapController.setCameraPadding(
                    Padding(0, 0, 0, 0)
                )
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

        if (items.isEmpty() || myLocation == null) {
            itemList.setNoItemsMessage(getString(R.string.empty_trips_history_message))
        } else {
            val markers = items.mapIndexed { index, marker ->
                val options = MarkerOptions(
                    position = marker.markerPosition!!,
                    icon = createIndexedMarker(index + 1),
                    iconWidth = LogicalPixel(16f),
                )
                Marker(options)
            }
            mapController.setCameraPadding(Padding(128, 0, 0, 0))
            mapController.addMarkers(markers)
            val firstObject = items.first()
            moveToMarker(firstObject.markerPosition!!)

            itemList.setOnItemsVisibilityChangedListener { i, _ ->
                val index = max(i, 0)
                val markerPosition = items.getOrNull(index)?.markerPosition

                if (markerPosition != null) {
                    moveToMarker(markerPosition)
                }
            }

            items.forEachIndexed { index, item ->
                val markerPosition = item.markerPosition!!
                val address = item.makeAddressString()

                val distanceInMeters = markerPosition.distance(
                    GeoPoint(
                        Latitude(myLocation.latitude), Longitude(myLocation.longitude)
                    )
                ).value.toDouble()

                val distanceSpan = DistanceSpan.create(
                    createDistance(distanceInMeters)
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
                        .addText(item.subtitle).setOnClickListener {
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
        }

        state = SearchHistoryScreenState.Result(itemList.build())
        invalidate()
    }


    private fun moveToMarker(markerPosition: GeoPointWithElevation) {
        mapController.moveCamera(
            GeoPoint(markerPosition.latitude, markerPosition.longitude)
        )
    }

    private fun createIndexedMarker(index: Int): Image {
        val marker = ContextCompat.getDrawable(carContext, R.drawable.marker_large)
        val bitmap = Bitmap.createBitmap(48, 48, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        marker?.setBounds(0, 0, canvas.width, canvas.height)
        marker?.draw(canvas)
        val paint = Paint().apply {
            color = Color.WHITE
            textSize = 27f
            textAlign = Paint.Align.CENTER
            isAntiAlias = true
        }
        val y = canvas.height / 2 - ((paint.descent() + paint.ascent()) / 2)
        canvas.drawText(index.toString(), canvas.width / 2f, y, paint)
        return imageFromBitmap(DgisMapInitializer.getSdkContext(), bitmap)
    }

    private fun createIndexedIcon(index: Int): CarIcon {
        val marker = ContextCompat.getDrawable(carContext, R.drawable.marker_small)
        val bitmap = Bitmap.createBitmap(32, 32, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        marker?.setBounds(0, 0, canvas.width, canvas.height)
        marker?.draw(canvas)
        val paint = Paint().apply {
            color = Color.WHITE
            textSize = 18f
            textAlign = Paint.Align.CENTER
            isAntiAlias = true
        }
        val y = canvas.height / 2 - ((paint.descent() + paint.ascent()) / 2)
        canvas.drawText(index.toString(), canvas.width / 2f, y, paint)
        val icon = IconCompat.createWithBitmap(bitmap)
        return CarIcon.Builder(icon).build()
    }

    private fun createDistance(distanceInMeter: Double): Distance {
        val unit: Int
        val distance: Double
        if (distanceInMeter >= 1000) {
            distance = distanceInMeter / 1000.0
            unit = Distance.UNIT_KILOMETERS_P1
        } else {
            distance = round(distanceInMeter / 10) * 10
            unit = Distance.UNIT_METERS
        }
        return Distance.create(distance, unit)
    }
}

private sealed class SearchHistoryScreenState {
    data object Loading : SearchHistoryScreenState()
    data object Error : SearchHistoryScreenState()
    data class Result(val itemList: ItemList) : SearchHistoryScreenState()
}
