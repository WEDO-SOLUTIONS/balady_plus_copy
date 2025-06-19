package com.dgis.map.android_auto.settings

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.Action
import androidx.car.app.model.ItemList
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import com.dgis.map.R
import androidx.core.graphics.drawable.IconCompat
import androidx.car.app.model.CarIcon
import androidx.car.app.model.Toggle
import com.dgis.map.android_auto.CarMapController
import com.dgis.map.android_auto.getString

class SettingsScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
) : Screen(carContext) {

    private var isTrafficEnabled: Boolean = false
    private var isParkingEnabled: Boolean = false

    init {
        isParkingEnabled = mapController.isParkingOnNow == true
        isTrafficEnabled = mapController.trafficEnabled
    }

    override fun onGetTemplate(): Template {
        val trafficToggle = Toggle.Builder { _ ->
            toggleTrafficControl()
        }
            .setChecked(isTrafficEnabled)
            .build()

        val parkingToggle = Toggle.Builder { _ ->
            toggleParking()
        }
            .setChecked(isParkingEnabled)
            .build()

        val itemList = ItemList.Builder()
            .addItem(
                Row.Builder()
                    .setTitle(getString(R.string.settings_voice_instructions))
                    .setImage(
                        CarIcon.Builder(
                            IconCompat.createWithResource(carContext, R.drawable.settings_sound)
                        ).build(),
                        Row.IMAGE_TYPE_ICON
                    )
                    .setOnClickListener {
                        screenManager.push(VoiceInstructionsScreen(carContext, mapController))
                    }
                    .build()
            )
            .addItem(
                Row.Builder()
                    .setTitle(getString(R.string.settings_traffic)) 
                    .setImage(
                        CarIcon.Builder(
                            IconCompat.createWithResource(carContext, R.drawable.settings_traffic)
                        ).build(),
                        Row.IMAGE_TYPE_ICON
                    )
                    .setToggle(trafficToggle)
                    .build()
            )
            .addItem(
                Row.Builder()
                    .setTitle(getString(R.string.settings_parking))
                    .setImage(
                        CarIcon.Builder(
                            IconCompat.createWithResource(carContext, R.drawable.settings_parking)
                        ).build(),
                        Row.IMAGE_TYPE_ICON
                    )
                    .setToggle(parkingToggle)
                    .build()
            )
            .addItem(
                Row.Builder()
                    .setTitle(getString(R.string.settings_route))
                    .setImage(
                        CarIcon.Builder(
                            IconCompat.createWithResource(carContext, R.drawable.settings_route)
                        ).build(),
                        Row.IMAGE_TYPE_ICON
                    )
                    .setOnClickListener {
                        screenManager.push(RouteInstructionsScreen(carContext, mapController))
                    }
                    .build()
            )
            .addItem(
                Row.Builder()
                    .setTitle(getString(R.string.settings_prompts_volume))
                    .setImage(
                        CarIcon.Builder(
                            IconCompat.createWithResource(carContext, R.drawable.settings_volume)
                        ).build(),
                        Row.IMAGE_TYPE_ICON
                    )
                    .setOnClickListener {
                        screenManager.push(VolumeSettingsScreen(carContext, mapController))
                    }
                    .build()
            )
            .build()

        return androidx.car.app.model.ListTemplate.Builder()
            .setTitle(getString(R.string.settings_title))
            .setHeaderAction(Action.BACK)
            .setSingleList(itemList)
            .build()
    }

    private fun toggleTrafficControl() {
        mapController.toggleTrafficControl()
        isTrafficEnabled = !isTrafficEnabled
        invalidate()
    }

    private fun toggleParking() {
        mapController.onParkingClicked()
        isParkingEnabled = !isParkingEnabled
        invalidate()
    }
}
