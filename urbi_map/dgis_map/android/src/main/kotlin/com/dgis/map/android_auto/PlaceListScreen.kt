package com.dgis.map.android_auto

import android.text.SpannableString
import android.text.Spanned
import android.util.Size
import androidx.car.app.CarContext
import androidx.car.app.ScreenManager
import androidx.car.app.constraints.ConstraintManager
import androidx.car.app.model.Action
import androidx.car.app.model.Distance
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
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.Latitude
import ru.dgis.sdk.coordinates.Longitude
import ru.dgis.sdk.directory.DirectoryObject
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.geometry.distance
import ru.dgis.sdk.map.LogicalPixel
import ru.dgis.sdk.map.Marker
import ru.dgis.sdk.map.MarkerOptions
import ru.dgis.sdk.map.Padding
import ru.dgis.sdk.map.imageFromResource
import kotlin.math.max
import kotlin.math.min
import kotlin.math.round

class PlaceListScreen(
    carContext: CarContext, private val mapController: CarMapController, private val query: String
) : CarMapScreen(carContext, mapController) {

    private var state: PlaceListScreenState = PlaceListScreenState.Loading
    private val markerImage = imageFromResource(
        DgisMapInitializer.getSdkContext(), R.drawable.ic_marker_m, Size(16, 16)
    )

    init {
        val carLimit = carContext.getCarService(ConstraintManager::class.java)
            .getContentLimit(ConstraintManager.CONTENT_LIMIT_TYPE_PLACE_LIST)
        mapController.search(query,
            min(carLimit, placeListLimit),
            resultCallback = ::handleSearchResult,
            errorCallback = {
                state = PlaceListScreenState.Error
                invalidate()
            })
        lifecycle.addObserver(object : DefaultLifecycleObserver {
            override fun onDestroy(owner: LifecycleOwner) {
                mapController.removeAllMarkers()
            }
        })
    }

    override fun onGetTemplate(): Template {
        val template = PlaceListNavigationTemplate.Builder()
        template.setPanModeListener(panModeListener)
        val header = Header.Builder().setStartHeaderAction(Action.BACK).setTitle(query).build()
        val mapActionStrip = buildMapActionStrip()
        template.setHeader(header).setMapActionStrip(mapActionStrip)
        when (val state = this.state) {
            PlaceListScreenState.Loading -> {
                template.setLoading(true)
            }

            PlaceListScreenState.Error -> {
                template.setLoading(false)
                val itemList = ItemList.Builder()
                    .setNoItemsMessage(getString(R.string.you_dont_seem_to_have_internet_description))
                template.setItemList(itemList.build())
            }

            is PlaceListScreenState.Result -> {
                template.setLoading(false)
                val myLocation = mapController.getMyLocation()
                val itemList = ItemList.Builder()
                if (myLocation != null && state.items.isNotEmpty()) {
                    for (item in state.items) {
                        val markerPosition = item.markerPosition!!
                        val address = makeAddress(item)
                        val text = SpannableString("  \n$address")

                        val distanceInMeters = markerPosition.distance(
                            GeoPoint(
                                Latitude(myLocation.latitude), Longitude(myLocation.longitude)
                            )
                        ).value.toDouble()

                        val distanceSpan = DistanceSpan.create(
                            createDistance(distanceInMeters)
                        )
                        text.setSpan(distanceSpan, 0, 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE)

                        itemList.addItem(
                            Row.Builder().setTitle(item.title).addText(text).setOnClickListener {
                                mapController.setRouteParams(
                                    markerPosition.latitude.value,
                                    markerPosition.longitude.value,
                                    item.id
                                )
                                carContext.getCarService(ScreenManager::class.java).popToRoot()
                            }.build()
                        )
                    }
                    itemList.setOnItemsVisibilityChangedListener { i, _ ->
                        val index = max(i, 0)
                        val markerPosition = state.items.getOrNull(index)?.markerPosition

                        if (markerPosition != null) {
                            moveToMarker(markerPosition)
                        }
                    }
                } else {
                    itemList.setNoItemsMessage(getString(R.string.search_nothing_found))
                }
                template.setItemList(itemList.build())
            }
        }

        return template.build()
    }

    private fun handleSearchResult(directoryObjects: List<DirectoryObject>) {
        val directoryObjectsWithMarker = directoryObjects.filter { it.markerPosition != null }
        state = PlaceListScreenState.Result(directoryObjectsWithMarker)

        if (directoryObjectsWithMarker.isEmpty()) return
        val markers = directoryObjectsWithMarker.map {
            val options = MarkerOptions(
                position = it.markerPosition!!,
                icon = markerImage,
                iconWidth = LogicalPixel(16f),
            )
            Marker(options)
        }
        mapController.addMarkers(markers)
        val firstObject = directoryObjectsWithMarker.first()
        moveToMarker(firstObject.markerPosition!!)
        invalidate()
    }

    private fun moveToMarker(markerPosition: GeoPointWithElevation) {
        mapController.moveCamera(
            GeoPoint(markerPosition.latitude, markerPosition.longitude)
        )
    }

    private fun makeAddress(directoryObject: DirectoryObject): String {
        val region = directoryObject.address?.drillDown?.firstOrNull { it.type == "region" }
        val districtArea =
            directoryObject.address?.drillDown?.firstOrNull { it.type == "district_area" }
        val district = directoryObject.address?.drillDown?.firstOrNull { it.type == "district" }
        val street =
            directoryObject.address?.components?.firstOrNull { it.asStreetAddress != null }?.asStreetAddress?.street
        return listOfNotNull(
            street, district?.name, districtArea?.name, region?.name
        ).joinToString()
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

    private companion object {
        const val placeListLimit = 6
    }
}

sealed class PlaceListScreenState {
    data object Loading : PlaceListScreenState()
    data object Error : PlaceListScreenState()
    data class Result(val items: List<DirectoryObject>) : PlaceListScreenState()
}
