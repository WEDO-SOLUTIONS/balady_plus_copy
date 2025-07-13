package com.dgis.map.android_auto.settings

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.Action
import androidx.car.app.model.ItemList
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.car.app.model.Toggle
import com.dgis.map.R
import com.dgis.map.android_auto.CarMapController
import com.dgis.map.android_auto.buildCarIcon
import com.dgis.map.android_auto.getString

class RouteInstructionsScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
) : Screen(carContext) {
    private var avoidTollRoads: Boolean = false
    private var avoidUnpavedRoads: Boolean = false
    private var suggestBetterRoute: Boolean = false

    init {
        avoidTollRoads = mapController.avoidTollRoads
        avoidUnpavedRoads = mapController.avoidUnpavedRoads
        suggestBetterRoute = mapController.suggestBetterRoad
    }

    override fun onGetTemplate(): Template {
        val avoidTollToggle = Toggle.Builder { _ ->
            toggleAvoidTollRoads()
        }
            .setChecked(avoidTollRoads)
            .build()

        val avoidUnpavedToggle = Toggle.Builder { _ ->
            toggleAvoidUnpavedRoads()
        }
            .setChecked(avoidUnpavedRoads)
            .build()

        val suggestBetterToggle = Toggle.Builder { _ ->
            toggleSuggestBetterRoute()
        }
            .setChecked(suggestBetterRoute)
            .build()

        val itemList = ItemList.Builder()
            .addItem(
                Row.Builder()
                    .setTitle(getString(R.string.route_avoid_toll_roads))
                    .setImage(
                        buildCarIcon(R.drawable.settings_route_toll),
                        Row.IMAGE_TYPE_ICON
                    )
                    .setToggle(avoidTollToggle)
                    .build()
            )
            .addItem(
                Row.Builder()
                    .setTitle(getString(R.string.route_avoid_unpaved_roads))
                    .setImage(
                        buildCarIcon(R.drawable.settings_route_unpaven),
                        Row.IMAGE_TYPE_ICON
                    )
                    .setToggle(avoidUnpavedToggle)
                    .build()
            )
            .addItem(
                Row.Builder()
                    .setTitle(getString(R.string.route_suggest_better_route))
                    .setImage(
                        buildCarIcon(R.drawable.settings_route_better_road),
                        Row.IMAGE_TYPE_ICON
                    )
                    .setToggle(suggestBetterToggle)
                    .build()
            )
            .build()

        return androidx.car.app.model.ListTemplate.Builder()
            .setTitle(getString(R.string.settings_route))
            .setHeaderAction(Action.BACK)
            .setSingleList(itemList)
            .build()
    }

    private fun toggleAvoidTollRoads() {
        avoidTollRoads = !avoidTollRoads
        mapController.avoidTollRoads = avoidTollRoads
        invalidate()
    }

    private fun toggleAvoidUnpavedRoads() {
        avoidUnpavedRoads = !avoidUnpavedRoads
        mapController.avoidUnpavedRoads = avoidUnpavedRoads
        invalidate()
    }

    private fun toggleSuggestBetterRoute() {
        suggestBetterRoute = !suggestBetterRoute
        mapController.suggestBetterRoad = suggestBetterRoute
        invalidate()
    }
} 