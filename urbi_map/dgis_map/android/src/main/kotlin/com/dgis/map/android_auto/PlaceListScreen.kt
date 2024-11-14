package com.dgis.map.android_auto

import android.text.SpannableString
import android.text.Spanned
import androidx.car.app.CarContext
import androidx.car.app.Screen
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
import com.dgis.map.R
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.Latitude
import ru.dgis.sdk.coordinates.Longitude
import ru.dgis.sdk.directory.DirectoryObject
import ru.dgis.sdk.geometry.distance
import kotlin.math.PI
import kotlin.math.min
import kotlin.math.round

class PlaceListScreen(
    carContext: CarContext, private val mapController: CarMapController, private val query: String
) : Screen(carContext) {

    var state: PlaceListScreenState = PlaceListScreenState.Loading

    init {
        val carLimit = carContext.getCarService(ConstraintManager::class.java)
            .getContentLimit(ConstraintManager.CONTENT_LIMIT_TYPE_PLACE_LIST)
        mapController.search(
            query, min(carLimit, placeListLimit),
            resultCallback = { directoryObjects ->
                state = PlaceListScreenState.Result(directoryObjects)
                invalidate()
            },
            errorCallback = {
                state = PlaceListScreenState.Error
                invalidate()
            },
        )
    }

    override fun onGetTemplate(): Template {
        val template = PlaceListNavigationTemplate.Builder()
        val header = Header.Builder().setStartHeaderAction(Action.BACK).setTitle(query).build()
        template.setHeader(header)
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
                val itemList =
                    ItemList.Builder().setNoItemsMessage(getString(R.string.searchNothingFound))
                for (item in state.items) {
                    val markerPosition = item.markerPosition ?: continue
                    val myLocation = mapController.getMyLocation() ?: continue

                    val address = makeAddress(item)
                    val text = SpannableString("  \n$address")

                    val distanceInMeters = markerPosition.distance(
                        GeoPoint(
                            Latitude(myLocation.latitude),
                            Longitude(myLocation.longitude)
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
                            carContext.getCarService(ScreenManager::class.java).pop()
                        }.build()
                    )
                }
                template.setItemList(itemList.build())
            }
        }

        return template.build()
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
        const val r = 6371
        const val p = PI / 180
        const val placeListLimit = 6
    }
}

sealed class PlaceListScreenState {
    object Loading : PlaceListScreenState()
    object Error : PlaceListScreenState()
    class Result(val items: List<DirectoryObject>) : PlaceListScreenState()
}