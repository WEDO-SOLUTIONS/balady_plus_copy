package com.dgis.map.android_auto

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.Action
import androidx.car.app.model.ActionStrip
import androidx.car.app.model.CarColor
import androidx.car.app.model.CarIcon
import androidx.car.app.navigation.model.MapController
import androidx.car.app.navigation.model.PanModeListener
import androidx.core.graphics.drawable.IconCompat
import com.dgis.map.R
import com.dgis.map.android_auto.settings.SettingsScreen

abstract class CarMapScreen(carContext: CarContext, private val mapController: CarMapController) :
    Screen(carContext) {
    private var isPanMode: Boolean = false
    var panModeListener: PanModeListener = PanModeListener { isInPanMode ->
        this@CarMapScreen.isPanMode = isInPanMode
        invalidate()
    }

    fun buildMapActionStrip(navigation: Boolean = false): ActionStrip {
        val panIconBuilder = CarIcon.Builder(
            IconCompat.createWithResource(
                carContext, R.drawable.pan
            )
        )
        if (isPanMode) {
            panIconBuilder.setTint(CarColor.BLUE)
        }
        val panAction = Action.Builder(Action.PAN).setIcon(
            panIconBuilder.build()
        ).build()
        return ActionStrip.Builder().addAction(panAction).addAction(zoomInAction)
            .addAction(zoomOutAction).addAction(buildFollowMyLocationAction(navigation)).build()
    }

    fun buildMapController() =
        MapController.Builder().setMapActionStrip(buildMapActionStrip()).build()

    val searchAction =
        Action.Builder()
            .setIcon(
                CarIcon.Builder(
                    IconCompat.createWithResource(
                        carContext,
                        R.drawable.search
                    )
                )
                    .build()
            )
            .setOnClickListener {
                screenManager.push(CategorySearchScreen(carContext, mapController))
            }
            .build()

    val settingsAction =
        Action.Builder()
            .setIcon(buildCarIcon(R.drawable.settings))
            .setOnClickListener {
                screenManager.push(SettingsScreen(carContext, mapController))
            }
            .build()

    private val zoomInAction = Action.Builder().setIcon(buildCarIcon(R.drawable.zoom_plus))
        .setOnClickListener { mapController.zoomIn() }.build()

    private val zoomOutAction = Action.Builder().setIcon(buildCarIcon(R.drawable.zoom_minus))
        .setOnClickListener { mapController.zoomOut() }.build()

    private fun buildFollowMyLocationAction(navigation: Boolean) =
        Action.Builder().setIcon(buildCarIcon(R.drawable.location)).setOnClickListener {
            if (navigation) {
                mapController.followNavigation()
            } else {
                mapController.showMyLocation()
            }
        }.build()
}
