package com.dgis.map.android_auto

import android.text.SpannableString
import android.text.Spanned
import android.util.Log
import androidx.car.app.CarContext
import androidx.car.app.annotations.ExperimentalCarApi
import androidx.car.app.constraints.ConstraintManager
import androidx.car.app.model.Action
import androidx.car.app.model.ActionStrip
import androidx.car.app.model.DistanceSpan
import androidx.car.app.model.ItemList
import androidx.car.app.model.ListTemplate
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.car.app.navigation.model.MapWithContentTemplate
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.dgis.map.R
import com.dgis.map.android_auto.settings.SettingsScreen
import com.dgis.map.android_auto.utils.AndroidAutoUtils
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import ru.dgis.sdk.Duration
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.distance
import ru.dgis.sdk.routing.RouteSearchPoint
import java.util.concurrent.TimeUnit
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine
import kotlin.math.min
import kotlin.time.DurationUnit
import kotlin.time.toDuration

class FavouritesPreviewScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
    private val favourites: FavouritesParams,
) : CarMapScreen(carContext, mapController) {

    private val itemsLimit = carContext.getCarService(ConstraintManager::class.java)
        .getContentLimit(ConstraintManager.CONTENT_LIMIT_TYPE_LIST)

    private var homeWorkEstimates: HomeWorkEstimates? = null
    private var estimatesJob: Job? = null
    private var getEstimatesTimestamp: Long? = null

    init {
        lifecycle.addObserver(
            object : DefaultLifecycleObserver {
                override fun onStart(owner: LifecycleOwner) {
                    getEstimates()
                }

                override fun onDestroy(owner: LifecycleOwner) {
                    estimatesJob?.cancel()
                }
            }
        )
    }

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
        return "$title • ${getDurationString(estimate.inSeconds)}"
    }

    private fun getEstimates() {
        val home = favourites.home
        val work = favourites.work
        if (home == null && work == null) return

        val myLocation = mapController.getMyLocation() ?: return
        val currentTime = System.currentTimeMillis()
        if (getEstimatesTimestamp != null
            && currentTime - getEstimatesTimestamp!! < TimeUnit.MINUTES.toMillis(5)
        ) {
            return
        }
        getEstimatesTimestamp = currentTime

        val startPoint = RouteSearchPoint(GeoPoint(myLocation.latitude, myLocation.longitude))
        val points = mutableListOf<RouteSearchPoint>()
        if (home != null) {
            val coordinates = home.coordinates
            val finishPoint =
                RouteSearchPoint(GeoPoint(coordinates.latitude, coordinates.longitude))
            points.add(finishPoint)
        }
        if (work != null) {
            val coordinates = work.coordinates
            val finishPoint =
                RouteSearchPoint(GeoPoint(coordinates.latitude, coordinates.longitude))
            points.add(finishPoint)
        }

        estimatesJob?.cancel()
        // Root coroutine: without a handler a throw from the SDK route search (e.g. a router
        // closed with the session) would reach the default uncaught handler and kill the process.
        val exceptionHandler = CoroutineExceptionHandler { _, e ->
            Log.e("FavouritesPreviewScreen", "Home/work estimates failed", e)
        }
        estimatesJob = CoroutineScope(Dispatchers.IO + exceptionHandler).launch {
            val durations = points.map {
                async {
                    suspendCoroutine { continuation ->
                        mapController.getRouteDuration(startPoint, it) { duration ->
                            continuation.resume(duration)
                        }
                    }
                }
            }.awaitAll()

            val homeWorkEstimates = when (durations.size) {
                2 -> HomeWorkEstimates(
                    home = durations[0],
                    work = durations[1]
                )

                1 -> if (home != null) HomeWorkEstimates(home = durations[0]) else
                    HomeWorkEstimates(work = durations[0])

                else -> null
            }
            if (homeWorkEstimates == null) return@launch

            withContext(Dispatchers.Main) {
                this@FavouritesPreviewScreen.homeWorkEstimates = homeWorkEstimates
                invalidate()
            }
        }
    }

    fun getDurationString(seconds: Long): String {
        val duration = seconds.toDuration(DurationUnit.SECONDS)
        val hours = duration.inWholeHours
        val minutes = duration.inWholeMinutes
        val remainingMinutes = minutes % 60

        val hoursString = getString(R.string.hoursShort)
        val minutesString = getString(R.string.minutesShort)

        return when {
            hours > 0 -> {
                var time = "$hours $hoursString"
                if (remainingMinutes > 0) {
                    time += " $remainingMinutes $minutesString"
                }
                time
            }
            minutes <= 1 -> {
                "1 $minutesString"
            }
            else -> {
                "$remainingMinutes $minutesString"
            }
        }
    }
}

data class HomeWorkEstimates(
    val home: Duration? = null,
    val work: Duration? = null,
)
