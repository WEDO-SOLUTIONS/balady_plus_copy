package com.dgis.map.android_auto

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.Action
import androidx.car.app.model.ActionStrip
import androidx.car.app.model.CarIcon
import androidx.car.app.model.GridItem
import androidx.car.app.model.GridTemplate
import androidx.car.app.model.ItemList
import androidx.car.app.model.Template
import androidx.core.graphics.drawable.IconCompat
import com.dgis.map.R

class CategorySearchScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
) : Screen(carContext) {

    private val actionStrip: ActionStrip by lazy {
        val actionStrip = ActionStrip.Builder()
        val searchAction =
            Action.Builder()
                .setTitle(getString(R.string.enter_from_keyboard))
                .setIcon(
                    CarIcon.Builder(
                        IconCompat.createWithResource(carContext, R.drawable.keyboard)
                    ).build()
                )
                .setOnClickListener { screenManager.push(SearchScreen(carContext, mapController)) }
                .build()
        actionStrip.addAction(searchAction).build()
    }

    private val itemList: ItemList by lazy {
        val itemList = ItemList.Builder()
        val history = GridItem.Builder().setTitle(getString(R.string.search_history))
            .setImage(buildCarIcon(R.drawable.history)).setOnClickListener {
                openHistory()
            }.build()
        itemList.addItem(history)
        itemList.build()
    }

    override fun onGetTemplate(): Template {
        val template = GridTemplate.Builder()
            .setHeaderAction(Action.BACK)
            .setTitle(getString(R.string.back))
            .setActionStrip(actionStrip)
            .setSingleList(itemList)
        return template.build()
    }

    private fun openHistory() {
        // open search history
    }
}
