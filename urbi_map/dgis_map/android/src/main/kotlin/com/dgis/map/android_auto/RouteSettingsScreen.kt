package com.dgis.map.android_auto

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.ScreenManager
import androidx.car.app.model.Action
import androidx.car.app.model.Header
import androidx.car.app.model.ItemList
import androidx.car.app.model.Pane
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.car.app.model.Toggle
import androidx.car.app.navigation.model.MapController
import androidx.car.app.navigation.model.MapTemplate
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.dgis.map.R
import ru.dgis.sdk.directory.DirectoryObject


class RouteSettingsScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
) : CarMapScreen(carContext, mapController) {
    private var avoidTollRoads = mapController.avoidTollRoads
    private var avoidUnpavedRoads = mapController.avoidUnpavedRoads
    private var suggestBetterRoute = mapController.suggestBetterRoad

    private val header by lazy {
        val closeAction = Action.Builder().setIcon(buildCarIcon(R.drawable.close_36))
            .setOnClickListener { carContext.getCarService(ScreenManager::class.java).pop() }
            .build()
        Header.Builder().setStartHeaderAction(Action.APP_ICON)
            .addEndHeaderAction(closeAction)
            .setTitle(getString(R.string.settings_route)).build()
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

        val templateMapController = MapController.Builder()
            .setMapActionStrip(buildMapActionStrip()).build()
        val pane = Pane.Builder()
            .addRow(
                Row.Builder().setTitle(getString(R.string.route_avoid_toll_roads))
                    .setToggle(avoidTollToggle).build()
            )
            .addRow(
                Row.Builder().setTitle(getString(R.string.route_avoid_unpaved_roads))
                    .setToggle(avoidUnpavedToggle).build()
            )
            .addRow(
                Row.Builder().setTitle(getString(R.string.route_suggest_better_route))
                    .setToggle(suggestBetterToggle).build()
            ).build()

        return MapTemplate.Builder().setMapController(templateMapController).setHeader(header)
            .setPane(pane).build()
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
