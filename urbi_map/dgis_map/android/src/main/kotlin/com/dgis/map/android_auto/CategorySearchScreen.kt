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

        SearchCategory.entries.forEach {
            itemList.addItem(
                GridItem.Builder().setTitle(getString(it.titleResId))
                    .setImage(buildCarIcon(it.iconResId)).setOnClickListener {
                        openPlacesList(it)
                    }.build()
            )
        }

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
        screenManager.push(SearchHistoryScreen(carContext, mapController))
    }

    private fun openPlacesList(category: SearchCategory) {
        val query = category.query[mapController.getLanguage()] ?: return
        val title = getString(category.titleResId)
        screenManager.push(PlaceListScreen(carContext, mapController, query, title))
    }
}

enum class SearchCategory {
    MOSQUES, FUEL, MARKETS, EAT_OUT, HOTELS;

    val titleResId: Int
        get() {
            return when (this) {
                MOSQUES -> R.string.search_mosques
                FUEL -> R.string.search_fuel
                MARKETS -> R.string.search_market
                EAT_OUT -> R.string.search_eat_out
                HOTELS -> R.string.search_hotels
            }
        }

    val iconResId: Int
        get() {
            return when (this) {
                MOSQUES -> R.drawable.mosque
                FUEL -> R.drawable.gas_station
                MARKETS -> R.drawable.market
                EAT_OUT -> R.drawable.eat_out
                HOTELS -> R.drawable.hotel
            }
        }

    val query: Map<Language, String>
        get() {
            return when (this) {
                MOSQUES -> mapOf(
                    Language.ENGLISH to "Mosques",
                    Language.ARABIC to "المساجد",
                )

                FUEL -> mapOf(
                    Language.ENGLISH to "Fuel",
                    Language.ARABIC to "وقود",
                )

                MARKETS -> mapOf(
                    Language.ENGLISH to "Market",
                    Language.ARABIC to "سوق",
                )

                EAT_OUT -> mapOf(
                    Language.ENGLISH to "Eat out",
                    Language.ARABIC to "مطاعم",
                )

                HOTELS -> mapOf(
                    Language.ENGLISH to "Hotels",
                    Language.ARABIC to "فنادق",
                )
            }
        }
}
