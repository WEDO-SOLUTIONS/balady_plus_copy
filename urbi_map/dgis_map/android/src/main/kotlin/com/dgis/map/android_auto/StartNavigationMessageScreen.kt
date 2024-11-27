package com.dgis.map.android_auto

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.CarIcon
import androidx.car.app.model.MessageTemplate
import androidx.car.app.model.Template
import com.dgis.map.R


class StartNavigationMessageScreen(carContext: CarContext) : Screen(carContext) {

    override fun onGetTemplate(): Template {
        val icon = CarIcon.Builder(buildCarIcon(R.drawable.logo)).build()
        return MessageTemplate.Builder(getString(R.string.start_navigation_message)).setIcon(icon)
            .build()
    }
}
