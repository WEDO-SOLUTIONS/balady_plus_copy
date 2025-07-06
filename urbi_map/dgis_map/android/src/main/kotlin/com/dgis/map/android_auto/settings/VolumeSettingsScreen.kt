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
    private var currentVolume: NotificationVolume = NotificationVolume.Quiet

    init {
        currentVolume = mapController.volumeValue
    }

    private fun NotificationVolume.soundIcon(): Int {
        return when(this) {
            NotificationVolume.Minimum -> R.drawable.settings_volume_min
            NotificationVolume.Quiet -> R.drawable.settings_volume_quiet
            NotificationVolume.Standard -> R.drawable.settings_volume_standard
        }
    }

    private fun NotificationVolume.title(): String {
        return when(this) {
            NotificationVolume.Minimum -> getString(R.string.volume_minimum)
            NotificationVolume.Quiet -> getString(R.string.volume_quiet)
            NotificationVolume.Standard -> getString(R.string.volume_standard)
        }
    }

    override fun onGetTemplate(): Template {
        val itemListBuilder = ItemList.Builder()
        val entries = NotificationVolume.entries.reversed()
        for (option in entries) {
            itemListBuilder.addItem(
                Row.Builder()
                    .setTitle(option.title())
                    .setImage(
                        buildCarIcon(option.soundIcon()),
                        Row.IMAGE_TYPE_ICON
                    )
                    .build()
            )
        }

        
        itemListBuilder.setSelectedIndex(entries.indexOf(currentVolume))
        itemListBuilder.setOnSelectedListener { index ->
            updateVolume(entries[index])
        }

        // Return the template
        return androidx.car.app.model.ListTemplate.Builder()
            .setTitle(getString(R.string.settings_prompts_volume))
            .setHeaderAction(Action.BACK)
            .setSingleList(itemListBuilder.build())
            .build()
    }

    private fun updateVolume(value: NotificationVolume) {
        currentVolume = value
        mapController.volumeValue = value
        invalidate()
    }
} 