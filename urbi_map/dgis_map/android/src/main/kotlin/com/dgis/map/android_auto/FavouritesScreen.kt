package com.dgis.map.android_auto

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.ScreenManager
import androidx.car.app.annotations.ExperimentalCarApi
import androidx.car.app.constraints.ConstraintManager
import androidx.car.app.model.Action
import androidx.car.app.model.ActionStrip
import androidx.car.app.model.ItemList
import androidx.car.app.model.ListTemplate
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import com.dgis.map.R
import com.dgis.map.map_api.FavouriteItemMessage
import kotlin.math.min

class FavouritesScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
    favourites: List<FavouriteItem>,
) : Screen(carContext) {

    private val itemsLimit = carContext.getCarService(ConstraintManager::class.java)
        .getContentLimit(ConstraintManager.CONTENT_LIMIT_TYPE_LIST)

    private val itemList: ItemList

    private val actionStrip: ActionStrip
        get() {
            val closeAction = Action.Builder().setIcon(buildCarIcon(R.drawable.close_36))
                .setOnClickListener { carContext.getCarService(ScreenManager::class.java).pop() }
                .build()
            return ActionStrip.Builder().addAction(closeAction).build()
        }

    private val noFavourites: Row
        get() {
            val language = mapController.getLanguage()
            val row = Row.Builder()
            if (language == Language.ENGLISH) {
                row.setTitle(getString(R.string.no_favourites_title))
                    .addText(getString(R.string.no_favourites_subtitle))
            } else {
                row.setTitle(getString(R.string.no_favourites_title))
            }
            return row.build()
        }

    init {
        val itemList = ItemList.Builder()

        if (favourites.isNotEmpty()) {
            for (i in 0 until min(favourites.size, itemsLimit)) {
                val item = favourites[i]
                itemList.addItem(
                    Row.Builder()
                        .setImage(buildCarIcon(R.drawable.bookmark_circle), Row.IMAGE_TYPE_LARGE)
                        .setTitle(item.title)
                        .addText(item.subtitle)
                        .setOnClickListener { onFavouriteTap(item) }.build()
                )
            }
        } else {
            itemList.addItem(noFavourites)
        }

        this.itemList = itemList.build()
    }

    @ExperimentalCarApi
    override fun onGetTemplate(): Template {
        return ListTemplate.Builder().setHeaderAction(Action.BACK)
            .setTitle(getString(R.string.favourites_title)).setActionStrip(actionStrip)
            .setSingleList(itemList).build()
    }

    private fun onFavouriteTap(item: FavouriteItem) {
        screenManager.push(
            RoutePreviewScreen(carContext, mapController, item.toRoutePreviewParams())
        )
    }
}
