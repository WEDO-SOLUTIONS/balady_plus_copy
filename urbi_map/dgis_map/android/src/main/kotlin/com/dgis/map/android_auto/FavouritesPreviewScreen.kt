package com.dgis.map.android_auto

import android.text.SpannableString
import android.text.Spanned
import androidx.car.app.CarContext
import androidx.car.app.annotations.ExperimentalCarApi
import androidx.car.app.constraints.ConstraintManager
import androidx.car.app.model.Action
import androidx.car.app.model.ActionStrip
import androidx.car.app.model.DistanceSpan
import androidx.car.app.model.DurationSpan
import androidx.car.app.model.ItemList
import androidx.car.app.model.ListTemplate
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.car.app.navigation.model.MapWithContentTemplate
import com.dgis.map.R
import com.dgis.map.android_auto.settings.SettingsScreen
import com.dgis.map.android_auto.utils.AndroidAutoUtils
import ru.dgis.sdk.Duration
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.distance
import java.util.concurrent.TimeUnit
import kotlin.math.min

class FavouritesPreviewScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
    private val favourites: FavouritesParams,
    private val homeWorkEstimates: HomeWorkEstimates? = null,
) : CarMapScreen(carContext, mapController) {

    private val itemsLimit = carContext.getCarService(ConstraintManager::class.java)
        .getContentLimit(ConstraintManager.CONTENT_LIMIT_TYPE_LIST)

    private val actionStrip by lazy {
        val favouritesAction =
            Action.Builder()
                .setIcon(buildCarIcon(R.drawable.bookmark))
                .setOnClickListener {
                    screenManager.push(
                        FavouritesScreen(carContext, mapController, favourites.items)
                    )
                }
                .build()
        ActionStrip.Builder().addAction(favouritesAction).addAction(searchAction)
            .addAction(settingsAction).build()
    }

    private val itemSearch: Row
        get() {
            return Row.Builder().setImage(buildCarIcon(R.drawable.search))
                .setTitle(getString(R.string.search_title))
                .setOnClickListener {
                    screenManager.push(SearchScreen(carContext, mapController))
                }.build()
        }

    private val itemFavourites: Row
        get() {
            return Row.Builder().setImage(buildCarIcon(R.drawable.bookmark))
                .setTitle(getString(R.string.favourites_title))
                .setOnClickListener {
                    screenManager.push(
                        FavouritesScreen(
                            carContext,
                            mapController,
                            favourites.items
                        )
                    )
                }.build()
        }

    private val itemSettings: Row
        get() {
            return Row.Builder().setImage(buildCarIcon(R.drawable.settings))
                .setTitle(getString(R.string.settings_title))
                .setOnClickListener {
                    screenManager.push(SettingsScreen(carContext, mapController))
                }.build()
        }

    @ExperimentalCarApi
    override fun onGetTemplate(): Template {
        val template = MapWithContentTemplate.Builder()
        val contentTemplate = ListTemplate.Builder()
            .setSingleList(buildItemList()).setHeaderAction(Action.APP_ICON)
            .setTitle(getString(R.string.app)).build()
        template.setActionStrip(actionStrip).setContentTemplate(contentTemplate)
        template.setMapController(buildMapController())
        return template.build()
    }

    private fun buildItemList(): ItemList {
        val itemList = ItemList.Builder()

        val home = favourites.home
        val work = favourites.work
        val items = favourites.items
        val myLocation = mapController.getMyLocation()

        val isFavouritesEmpty = home == null && work == null && items.isEmpty()
        val showFavourites = myLocation != null && !isFavouritesEmpty

        if (showFavourites) {
            if (home != null) {
                itemList.addItem(
                    Row.Builder().setImage(buildCarIcon(R.drawable.home_36))
                        .setTitle(
                            buildTitleWithEstimate(
                                getString(R.string.favourites_home),
                                homeWorkEstimates?.home
                            )
                        )
                        .setOnClickListener { onFavouriteTap(home) }.build()
                )
            }
            if (work != null) {
                itemList.addItem(
                    Row.Builder().setImage(buildCarIcon(R.drawable.case_36))
                        .setTitle(
                            buildTitleWithEstimate(
                                getString(R.string.favourites_work),
                                homeWorkEstimates?.work
                            )
                        )
                        .setOnClickListener { onFavouriteTap(work) }.build()
                )
            }

            for (i in 0 until min(items.size, itemsLimit)) {
                val item = items[i]
                val geoPoint = GeoPoint(item.coordinates.latitude, item.coordinates.longitude)

                val distanceInMeters = geoPoint.distance(
                    GeoPoint(myLocation!!.latitude, myLocation.longitude)
                ).value.toDouble()
                val distanceSpan = DistanceSpan.create(
                    AndroidAutoUtils.createDistance(distanceInMeters)
                )

                val text = SpannableString("  \n${item.subtitle}")
                text.setSpan(distanceSpan, 0, 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE)

                val row = Row.Builder()
                if (item.iconResId != null) {
                    row.setImage(buildCarIcon(item.iconResId))
                }
                row.setTitle(item.title).addText(text)
                    .setOnClickListener { onFavouriteTap(item) }

                itemList.addItem(row.build())
            }
        } else {
            itemList.addItem(itemSearch).addItem(itemFavourites).addItem(itemSettings)
        }

        return itemList.build()
    }

    private fun onFavouriteTap(item: FavouriteItem) {
        screenManager.push(
            RoutePreviewScreen(carContext, mapController, item.toRoutePreviewParams())
        )
    }

    private fun buildTitleWithEstimate(title: String, estimate: Duration?): CharSequence {
        if (estimate == null) return title

        val result = SpannableString("$title •  ")
        val spanStart = result.length
        result.setSpan(
            DurationSpan.create(TimeUnit.SECONDS.toSeconds(estimate.inSeconds)),
            spanStart - 1,
            spanStart,
            Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
        )
        return result
    }
}

data class HomeWorkEstimates(
    val home: Duration? = null,
    val work: Duration? = null,
)
