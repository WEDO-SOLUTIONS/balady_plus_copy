package com.dgis.map.android_auto

import android.graphics.Color
import androidx.car.app.AppManager
import androidx.car.app.CarContext
import androidx.car.app.model.Action
import androidx.car.app.model.ActionStrip
import androidx.car.app.model.Alert
import androidx.car.app.model.AlertCallback
import androidx.car.app.model.CarColor
import androidx.car.app.model.CarIcon
import androidx.car.app.model.CarText
import androidx.car.app.model.Distance
import androidx.car.app.model.Template
import androidx.car.app.navigation.NavigationManager
import androidx.car.app.navigation.NavigationManagerCallback
import androidx.car.app.navigation.model.Destination
import androidx.car.app.navigation.model.Maneuver
import androidx.car.app.navigation.model.MessageInfo
import androidx.car.app.navigation.model.NavigationTemplate
import androidx.car.app.navigation.model.RoutingInfo
import androidx.car.app.navigation.model.Step
import androidx.car.app.navigation.model.TravelEstimate
import androidx.car.app.navigation.model.Trip
import androidx.car.app.notification.CarAppExtender
import androidx.car.app.notification.CarNotificationManager
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.graphics.drawable.IconCompat
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.dgis.FlutterProvider
import com.dgis.map.R
import com.dgis.map.android_auto.custom_renderer.CustomRenderer
import com.dgis.map.android_auto.custom_renderer.CustomRendererData
import com.dgis.map.map_api.FavouritesStateMessage
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.routing.BriefRouteInfoSearchPoints
import ru.dgis.sdk.routing.RouteSearchPoint
import kotlin.math.floor
import kotlin.math.max
import kotlin.math.round

class NavigationScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
    private val customRenderer: CustomRenderer,
) : CarMapScreen(carContext, mapController), CarNavigationHandler.NavigationListener {

    private val navigationManager: NavigationManager
    private val carNotificationManager: CarNotificationManager
    private val appManager: AppManager

    init {
        navigationManager =
            carContext.getCarService(NavigationManager::class.java).apply {
                setNavigationManagerCallback(
                    object : NavigationManagerCallback {
                        override fun onStopNavigation() = stopNavigation(bySystem = true)
                        override fun onAutoDriveEnabled() =
                            mapController.startNavigationSimulation()
                    }
                )
            }
        carNotificationManager = CarNotificationManager.from(carContext)
        appManager = carContext.getCarService(AppManager::class.java)
        lifecycle.addObserver(
            object : DefaultLifecycleObserver {
                override fun onCreate(owner: LifecycleOwner) {
                    mapController.setNavigationListener(this@NavigationScreen)
                }

                override fun onResume(owner: LifecycleOwner) {
                    showFavourites()
                }

                override fun onDestroy(owner: LifecycleOwner) {
                    mapController.resetNavigationListener()
                }
            }
        )

        getFavourites()
    }

    private var isEndTripShown: Boolean = false

    private var navigationState = NavigationState.DISABLED
    private var locationState = LocationState.AVAILABLE

    private var step: Step? = null
    private var nextStep: Step? = null
    private var stepRemainingDistance: Distance? = null

    private var destination: Destination? = null
    private var destinationTravelEstimate: TravelEstimate? = null
    private var speedInfo = SpeedInfoModel()

    private var favourites: FavouritesStateMessage? = null

    private val isNavigation: Boolean
        get() = navigationState == NavigationState.NAVIGATION
                || navigationState == NavigationState.REROUTING

    private val isFreeRoam: Boolean
        get() = navigationState == NavigationState.FREE_ROAM

    override fun onGetTemplate(): Template {
        val actionStrip = ActionStrip.Builder()
        if (isNavigation) {
            actionStrip.addAction(routeOverviewAction)
        }
        actionStrip.addAction(searchAction)
        actionStrip.addAction(settingsAction)
        if (isNavigation) {
            actionStrip.addAction(buildStopNavigationAction())
        }

        val mapActionStrip = buildMapActionStrip(isNavigation)
        val navigationTemplate = NavigationTemplate.Builder()
        navigationTemplate.setBackgroundColor(CarColor.GREEN)
        navigationTemplate.setActionStrip(actionStrip.build())
        navigationTemplate.setMapActionStrip(mapActionStrip)
        navigationTemplate.setPanModeListener(panModeListener)

        if ((isNavigation || isFreeRoam) && locationState == LocationState.NOT_AVAILABLE) {
            navigationTemplate.setNavigationInfo(
                MessageInfo.Builder(getString(R.string.location_signal_lost_message))
                    .build()
            )
            navigationTemplate.setBackgroundColor(CarColor.RED)
        } else if (isNavigation) {
            if (navigationState == NavigationState.REROUTING) {
                navigationTemplate.setNavigationInfo(
                    MessageInfo.Builder(getString(R.string.rerouting_message)).build()
                )
            } else {
                if (destinationTravelEstimate != null) {
                    navigationTemplate.setDestinationTravelEstimate(destinationTravelEstimate!!)
                }

                if (step != null && stepRemainingDistance != null) {
                    val routingInfo = RoutingInfo.Builder()
                    routingInfo.setCurrentStep(step!!, stepRemainingDistance!!)
                    if (nextStep != null) {
                        routingInfo.setNextStep(nextStep!!)
                    }
                    navigationTemplate.setNavigationInfo(routingInfo.build())
                }
            }
        }

        return navigationTemplate.build()
    }

    override fun onNavigationStateChanged(state: NavigationState) {
        val prevState = navigationState
        navigationState = state
        when (state) {
            NavigationState.NAVIGATION -> {
                tryPopFavouritesPreview()
                navigationManager.navigationStarted()
            }

            NavigationState.FINISHED -> {
                customRenderer.clear()
                showEndTrip()
            }

            NavigationState.DISABLED -> {
                customRenderer.clear()
                if (prevState != NavigationState.DISABLED && !isEndTripShown) {
                    stopNavigation()
                }
            }

            NavigationState.REROUTING -> {
                tryPopFavouritesPreview()
                val tripBuilder = Trip.Builder()
                if (destination != null && destinationTravelEstimate != null) {
                    tripBuilder.addDestination(destination!!, destinationTravelEstimate!!)
                }
                tripBuilder.setLoading(true)
                try {
                    navigationManager.updateTrip(tripBuilder.build())
                } catch (_: Exception) {
                    // skip (when state is rerouting in freeroam, but navigation on route is not started)
                }
            }

            NavigationState.FREE_ROAM -> {
                // do nothing
            }
        }
        invalidate()
    }

    private fun tryPopFavouritesPreview() {
        val topScreen = screenManager.top
        if (topScreen is FavouritesPreviewScreen) {
            topScreen.finish()
        }
    }

    override fun onEtaUpdated(eta: EtaModel?) {
        if (eta == null) return

        val distance: Double
        val unit: Int

        if (eta.distance >= 1000) {
            distance = eta.distance / 1000.0
            unit = Distance.UNIT_KILOMETERS
        } else {
            distance = round(eta.distance / 10) * 10
            unit = Distance.UNIT_METERS
        }
        destinationTravelEstimate =
            TravelEstimate.Builder(
                Distance.create(distance, unit),
                eta.arrivalTime,
            )
                .setRemainingTimeSeconds(eta.duration)
                .build()
        destination =
            if (eta.destination != null) Destination.Builder().setName(eta.destination).build()
            else null
        invalidate()
    }

    override fun onManeuverUpdate(maneuver: ManeuverModel?, nextManeuver: ManeuverModel?) {
        if (navigationState == NavigationState.DISABLED || maneuver == null) {
            step = null
            nextStep = null
            stepRemainingDistance = null
            return
        }

        val previousStep = step
        step =
            Step.Builder(maneuver.roadName)
                .setManeuver(
                    getManeuverWithExitNumberAndAngle(
                        carContext,
                        maneuver.type,
                        maneuver.iconId,
                        maneuver.roundAboutExitNumber
                    )
                )
                .setRoad(maneuver.roadName)
                .build()
        val (distance, unit) = formatDistance(maneuver.distance)
        val remainingDistance = Distance.create(distance, unit)
        stepRemainingDistance = remainingDistance

        nextStep =
            if (nextManeuver == null) null
            else
                Step.Builder(nextManeuver.roadName)
                    .setManeuver(
                        getManeuverWithExitNumberAndAngle(
                            carContext,
                            nextManeuver.type,
                            nextManeuver.iconId,
                            nextManeuver.roundAboutExitNumber,
                        )
                    )
                    .setRoad(nextManeuver.roadName)
                    .build()

        // TODO(Sergei): move update trip and send notification to separate methods
        val tripBuilder = Trip.Builder()
        val stepTravelEstimate =
            TravelEstimate.Builder(remainingDistance, maneuver.arrivalTime).build()

        tripBuilder.addStep(step!!, stepTravelEstimate)
        if (destination != null && destinationTravelEstimate != null) {
            tripBuilder.addDestination(destination!!, destinationTravelEstimate!!)
        }
        tripBuilder.setLoading(false)
        tripBuilder.setCurrentRoad(maneuver.roadName)
        try {
            navigationManager.updateTrip(tripBuilder.build())
        } catch (_: Exception) {
            // skip (when maneuver update is performed before navigation state is updated)
        }

        val unitString =
            when (unit) {
                Distance.UNIT_KILOMETERS -> getString(R.string.kilometer)
                else -> getString(R.string.meter)
            }
        val shouldNotify =
            previousStep != null &&
                    (step?.road != previousStep.road ||
                            step?.maneuver?.type != previousStep.maneuver?.type)
        carNotificationManager.notify(
            NavigationCarAppService.notificationId,
            getNavigationNotification(
                "${distance.toString().replace("\\.0$".toRegex(), "")} $unitString",
                maneuver.roadName,
                maneuver.iconId,
                shouldNotify,
            ),
        )
        invalidate()
    }

    override fun onLocationStateChanged(state: LocationState) {
        locationState = state
        invalidate()
    }

    override fun onBetterRouteFound(durationProfit: Int?) {
        if (durationProfit != null) {
            showBetterRouteAlert(durationProfit)
        } else {
            appManager.dismissAlert(betterRouteAlertId)
        }
    }

    override fun onSpeedChanged(speed: Int) {
        speedInfo = speedInfo.copy(currentSpeed = speed)
        renderSpeedInfo()
    }

    override fun onSpeedLimitChanged(speedLimit: Int?) {
        speedInfo = speedInfo.copy(speedLimit = speedLimit)
        renderSpeedInfo()
    }

    override fun onSpeedLimitExceeded(exceeded: Boolean) {
        speedInfo = speedInfo.copy(speedLimitExceeded = exceeded)
        renderSpeedInfo()
    }

    fun onMapReady() {
        showFavourites()
    }

    private fun renderSpeedInfo() {
        if (!isNavigation && !isFreeRoam) return
        customRenderer.render(CustomRendererData(speedInfo))
    }

    private fun stopNavigation(bySystem: Boolean = false) {
        navigationState = NavigationState.DISABLED
        speedInfo = SpeedInfoModel()
        step = null
        nextStep = null
        stepRemainingDistance = null
        destination = null
        destinationTravelEstimate = null
        navigationManager.navigationEnded()
        val notification = NavigationCarAppService.getDefaultNotification(carContext)
        carNotificationManager.notify(NavigationCarAppService.notificationId, notification)
        mapController.stopNavigation()
        if (!bySystem) {
            showFavourites()
        }
    }

    private fun showEndTrip() {
        isEndTripShown = true
        val title = CarText.create(getString(R.string.end_trip_alert_title))
        val endTripAction =
            Action.Builder()
                .setTitle(getString(R.string.end_trip_alert_action))
                .setFlags(Action.FLAG_DEFAULT)
                .setBackgroundColor(CarColor.RED)
                .setOnClickListener {
                    appManager.dismissAlert(endTripAlertId)
                    stopNavigation()
                    invalidate()
                }

        val endTripAlert = Alert.Builder(endTripAlertId, title, 10000)

        if (destination?.name != null) {
            endTripAlert.setSubtitle(destination!!.name!!)
        }
        endTripAlert
            .addAction(endTripAction.build())
            .setCallback(
                object : AlertCallback {
                    override fun onCancel(reason: Int) {}
                    override fun onDismiss() {
                        isEndTripShown = false
                        invalidate()
                    }
                }
            )
        appManager.showAlert(endTripAlert.build())
    }

    private fun showBetterRouteAlert(durationProfit: Int) {
        val appManager = carContext.getCarService(AppManager::class.java)
        val title = CarText.create(getString(R.string.better_route_alert_title))
        val minutes = max(round(durationProfit / 60.0).toInt(), 1)
        val subtitle = CarText.create(getString(R.string.better_route_alert_subtitle, minutes))
        val closeAction =
            Action.Builder()
                .setTitle(getString(R.string.better_route_alert_close_action))
                .setOnClickListener {
                    mapController.rejectBetterRoute()
                    appManager.dismissAlert(betterRouteAlertId)
                }
        val chooseAction =
            Action.Builder()
                .setTitle(getString(R.string.better_route_alert_choose_action))
                .setBackgroundColor(CarColor.PRIMARY)
                .setOnClickListener {
                    mapController.acceptBetterRoute()
                    appManager.dismissAlert(betterRouteAlertId)
                }

        val betterRouteAlert =
            Alert.Builder(betterRouteAlertId, title, 10000)
                .setSubtitle(subtitle)
                .addAction(closeAction.build())
                .addAction(chooseAction.build())
        appManager.showAlert(betterRouteAlert.build())
    }

    private fun getManeuverWithExitNumberAndAngle(
        carContext: CarContext,
        type: Int,
        iconResourceId: Int,
        exitNumber: Int?,
    ): Maneuver {
        val icon =
            CarIcon.Builder(IconCompat.createWithResource(carContext, iconResourceId)).build()
        val maneuver = Maneuver.Builder(type).setIcon(icon)

        val isRoundabout =
            when (type) {
                Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CCW,
                Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CW,
                Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CCW_WITH_ANGLE,
                Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CW_WITH_ANGLE -> true

                else -> false
            }
        if (isRoundabout) {
            maneuver.setRoundaboutExitNumber(exitNumber ?: 1)
        }
        return maneuver.build()
    }

    private fun getFavourites() {
        FlutterProvider.getHostFlutterApi(carContext).getFavourites {
            favourites = it.getOrNull()
            if (mapController.isMapReady) {
                showFavourites()
            }
        }
    }

    private fun showFavourites() {
        val favourites = this.favourites
        if (favourites == null || screenManager.top !is NavigationScreen || isNavigation) return


        val myLocation = mapController.getMyLocation() ?: return
        val home = favourites.home
        val work = favourites.work
        val startPoint = RouteSearchPoint(GeoPoint(myLocation.latitude, myLocation.longitude))
        val points = mutableListOf<BriefRouteInfoSearchPoints>()
        if (home != null) {
            val coordinates = home.coordinates
            val finishPoint =
                RouteSearchPoint(GeoPoint(coordinates.latitude, coordinates.longitude))
            points.add(BriefRouteInfoSearchPoints(startPoint, finishPoint))
        }
        if (work != null) {
            val coordinates = work.coordinates
            val finishPoint =
                RouteSearchPoint(GeoPoint(coordinates.latitude, coordinates.longitude))
            points.add(BriefRouteInfoSearchPoints(startPoint, finishPoint))
        }

        if (points.isEmpty()) {
            screenManager.push(FavouritesPreviewScreen(carContext, mapController, favourites))
            return
        }

        mapController.getBriefRouteInfos(points) {
            val homeWorkEstimates = when (it?.size) {
                2 -> HomeWorkEstimates(
                    home = it[0]!!.duration,
                    work = it[1]!!.duration
                )

                1 -> if (home != null) HomeWorkEstimates(home = it[0]!!.duration) else
                    HomeWorkEstimates(work = it[0]!!.duration)

                else -> null
            }
            screenManager.push(
                FavouritesPreviewScreen(
                    carContext,
                    mapController,
                    favourites,
                    homeWorkEstimates
                )
            )
        }
    }

    private fun getNavigationNotification(
        title: String,
        text: String,
        iconResourceId: Int,
        shouldNotify: Boolean,
    ): NotificationCompat.Builder {
        return NotificationCompat.Builder(carContext, NavigationCarAppService.channelId)
            .setColorized(true)
            .setColor(Color.parseColor("#147674"))
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(IconCompat.createWithResource(carContext, iconResourceId))
            .setOnlyAlertOnce(!shouldNotify)
            .setOngoing(true)
            .setPriority(NotificationManagerCompat.IMPORTANCE_HIGH)
            .setCategory(NotificationCompat.CATEGORY_NAVIGATION)
            .extend(
                CarAppExtender.Builder()
                    .setColor(CarColor.PRIMARY)
                    .setSmallIcon(iconResourceId)
                    .setImportance(NotificationManagerCompat.IMPORTANCE_HIGH)
                    .build()
            )
    }

    private val routeOverviewAction =
        Action.Builder()
            .setIcon(
                CarIcon.Builder(
                    IconCompat.createWithResource(
                        carContext,
                        R.drawable.route
                    )
                )
                    .build()
            )
            .setOnClickListener { mapController.overviewRoute() }
            .build()


    private fun buildStopNavigationAction(): Action {
        return Action.Builder()
            .setTitle(getString(R.string.stop_navigation_action))
            .setOnClickListener { stopNavigation() }
            .build()
    }

    private companion object {
        const val endTripAlertId = 0
        const val betterRouteAlertId = 1

        fun formatDistance(meters: Double): Pair<Double, Int> {
            if (meters > 3000) {
                // Km, precision to integers
                val distanceKm = floor((meters / 1000))
                return Pair(distanceKm, Distance.UNIT_KILOMETERS)
            }

            if (meters > 1000) {
                // Km, precision to one decimal place
                val hundredsOfMeters = floor((meters / 100))
                val distanceKm = floor((hundredsOfMeters / 10))
                return Pair(distanceKm, Distance.UNIT_KILOMETERS)
            }

            if (meters > 500) {
                // M, precision to multiples of 100 meters
                val hundredsOfMeters = floor(meters / 100)
                val distanceM = hundredsOfMeters * 100
                return Pair(distanceM, Distance.UNIT_METERS)
            }

            if (meters > 250) {
                // M, precision to multiples of 50 meters
                val fiftiesOfMeters = floor(meters / 50)
                val distanceM = floor(fiftiesOfMeters * 50)
                return Pair(distanceM, Distance.UNIT_METERS)
            }

            if (meters == 0.0) {
                return Pair(meters, Distance.UNIT_METERS)
            }

            // M, precision to multiples of 10 meters
            val tensOfMeters = floor(max(1.0, meters / 10))
            val distanceM = floor(tensOfMeters * 10)
            return Pair(distanceM, Distance.UNIT_METERS)
        }
    }
}
