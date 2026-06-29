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
import com.dgis.map.map_api.SoundToggleType

class VoiceInstructionsScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
) : Screen(carContext) {
    private var currentSoundType: SoundToggleType = SoundToggleType.ALL

    init {
        currentSoundType = mapController.voiceInstructions
    }

    private fun SoundToggleType.soundIcon(): Int {
        return when(this) {
            SoundToggleType.ALL -> R.drawable.settings_voice_all
            SoundToggleType.IMPORTANT -> R.drawable.settings_voice_important
            SoundToggleType.NONE -> R.drawable.settings_voice_off
        }
    }

    private fun SoundToggleType.title(): String {
        return when(this) {
            SoundToggleType.ALL -> getString(R.string.voice_instructions_all)
            SoundToggleType.IMPORTANT -> getString(R.string.voice_instructions_important)
            SoundToggleType.NONE -> getString(R.string.voice_instructions_none)
        }
    }

    override fun onGetTemplate(): Template {
        val entries = SoundToggleType.entries.reversed()
        val itemListBuilder = ItemList.Builder()
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
        itemListBuilder.setSelectedIndex(entries.indexOf(currentSoundType))
        itemListBuilder.setOnSelectedListener { index ->
            updateSoundType(entries[index])
        }

        // Return the template
        return androidx.car.app.model.ListTemplate.Builder()
            .setTitle(getString(R.string.settings_voice_instructions))
            .setHeaderAction(Action.BACK)
            .setSingleList(itemListBuilder.build())
            .build()
    }

    private fun updateSoundType(newType: SoundToggleType) {
        currentSoundType = newType
        mapController.voiceInstructions = newType
        invalidate()
    }

    fun refresh() {
        currentSoundType = mapController.voiceInstructions
        invalidate()
    }
} 