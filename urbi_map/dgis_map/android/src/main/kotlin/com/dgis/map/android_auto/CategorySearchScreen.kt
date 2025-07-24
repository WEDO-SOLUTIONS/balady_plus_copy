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
    MOSQUE, GAS_STATION, HYPERMARKET, TO_EAT, HOTEL;

    val titleResId: Int
        get() {
            return when (this) {
                MOSQUE -> R.string.search_mosque
                GAS_STATION -> R.string.search_gas_station
                HYPERMARKET -> R.string.search_hypermarket
                TO_EAT -> R.string.search_to_eat
                HOTEL -> R.string.search_hotel
            }
        }

    val iconResId: Int
        get() {
            return when (this) {
                MOSQUE -> R.drawable.mosque
                GAS_STATION -> R.drawable.gas_station
                HYPERMARKET -> R.drawable.hypermarket
                TO_EAT -> R.drawable.to_eat
                HOTEL -> R.drawable.hotel
            }
        }

    val query: Map<Language, String>
        get() {
            return when (this) {
                MOSQUE -> mapOf(
                    Language.ENGLISH to "Mosques",
                    Language.ARABIC to "المساجد",
                )

                GAS_STATION -> mapOf(
                    Language.ENGLISH to "Fuel",
                    Language.ARABIC to "وقود",
                )

                HYPERMARKET -> mapOf(
                    Language.ENGLISH to "Market",
                    Language.ARABIC to "سوق",
                )

                TO_EAT -> mapOf(
                    Language.ENGLISH to "Eat out",
                    Language.ARABIC to "مطاعم",
                )

                HOTEL -> mapOf(
                    Language.ENGLISH to "Hotels",
                    Language.ARABIC to "فنادق",
                )
            }
        }
}
