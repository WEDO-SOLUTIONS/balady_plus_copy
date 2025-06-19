package com.dgis.map.android_auto.settings

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.Action
import androidx.car.app.model.ItemList
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import com.dgis.map.R
import com.dgis.map.android_auto.CarMapController
import com.dgis.map.android_auto.buildCarIcon
import com.dgis.map.android_auto.getString

class VolumeSettingsScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
) : Screen(carContext) {
    private var currentVolumeIndex: Int = 0

    init {
        currentVolumeIndex = mapController.volumeValue
    }

    override fun onGetTemplate(): Template {
        val itemListBuilder = ItemList.Builder()
        
        // Add volume options
        itemListBuilder.addItem(
            Row.Builder()
                .setTitle(getString(R.string.volume_standard))
                .setImage(
                    buildCarIcon(R.drawable.settings_volume_standard),
                    Row.IMAGE_TYPE_ICON
                )
                .build()
        )
        itemListBuilder.addItem(
            Row.Builder()
                .setTitle(getString(R.string.volume_quiet))
                .setImage(
                    buildCarIcon(R.drawable.settings_volume_quiet),
                    Row.IMAGE_TYPE_ICON
                )
                .build()
        )
        itemListBuilder.addItem(
            Row.Builder()
                .setTitle(getString(R.string.volume_minimum))
                .setImage(
                    buildCarIcon(R.drawable.settings_volume_min),
                    Row.IMAGE_TYPE_ICON
                )
                .build()
        )

        
        itemListBuilder.setSelectedIndex(currentVolumeIndex)
        itemListBuilder.setOnSelectedListener { index ->
            updateVolume(index)
        }

        // Return the template
        return androidx.car.app.model.ListTemplate.Builder()
            .setTitle(getString(R.string.settings_prompts_volume))
            .setHeaderAction(Action.BACK)
            .setSingleList(itemListBuilder.build())
            .build()
    }

    private fun updateVolume(newIndex: Int) {
        currentVolumeIndex = newIndex
        mapController.volumeValue = newIndex
        invalidate()
    }
} 