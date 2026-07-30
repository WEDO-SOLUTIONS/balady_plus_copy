package com.dgis.map.android_auto

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.database.ContentObserver
import android.graphics.Color
import android.location.LocationManager
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import androidx.core.content.ContextCompat
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
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import com.dgis.FlutterProvider
import com.dgis.map.map_api.HostFlutterApi
import com.dgis.map.R
import com.dgis.map.FavouritesUpdateNotifier
import com.dgis.map.android_auto.custom_renderer.CustomRenderer
import com.dgis.map.android_auto.custom_renderer.CustomRendererData
import com.dgis.map.android_auto.utils.AndroidAutoUtils
import com.dgis.map.map_api.FavouriteItemMessage
import com.dgis.map.map_api.FavouritesStateMessage
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.platform.Locale as SdkLocale
import java.util.concurrent.CompletableFuture
import kotlin.math.floor
import kotlin.math.max
import kotlin.math.round
import kotlin.time.Duration

class NavigationScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
    private val customRenderer: CustomRenderer,
) : CarMapScreen(carContext, mapController), CarNavigationHandler.NavigationListener,
    LocaleChangeListener {

    private val maneuverCardColor = CarColor.createCustom(
        Color.parseColor("#448B47"),
        Color.parseColor("#448B47")
    )
    private val betterRouteCloseButtonColor = CarColor.createCustom(
        Color.parseColor("#17181B"),
        Color.parseColor("#17181B")
    )

    private val navigationManager: NavigationManager
    private val carNotificationManager: CarNotificationManager
    private val appManager: AppManager
    private val hostFlutterApi: HostFlutterApi
    private var favouritesUpdateJob: Job? = null
    private val coroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    private val locationManager: LocationManager =
        carContext.getSystemService(android.content.Context.LOCATION_SERVICE) as LocationManager

    private val locationSettingsObserver = object : ContentObserver(Handler(Looper.getMainLooper())) {
        override fun onChange(selfChange: Boolean) {
            val newState = if (isLocationEnabled()) LocationState.AVAILABLE else LocationState.NOT_AVAILABLE
            if (newState != locationState) {
                locationState = newState
                invalidate()
            }
        }
    }

    private val locationModeReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == LocationManager.MODE_CHANGED_ACTION) {
                checkLocationPermissionAndState()
            }
        }
    }

    private fun registerLocationModeReceiver() {
        ContextCompat.registerReceiver(
            carContext,
            locationModeReceiver,
            IntentFilter(LocationManager.MODE_CHANGED_ACTION),
            ContextCompat.RECEIVER_NOT_EXPORTED
        )
    }

    private fun unregisterLocationModeReceiver() {
        try {
            carContext.unregisterReceiver(locationModeReceiver)
        } catch (_: IllegalArgumentException) {
            // Receiver was not registered.
        }
    }

    private fun hasLocationPermission(): Boolean {
        return carContext.checkSelfPermission(android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
    }

    private fun isLocationEnabled(): Boolean {
        return locationManager.isLocationEnabled
    }

    private fun checkLocationPermissionAndState() {
        if (!hasLocationPermission()) {
            if (isNavigation || isFreeRoam) {
                if (locationState != LocationState.NOT_AVAILABLE) {
                    locationState = LocationState.NOT_AVAILABLE
                    invalidate()
                }
            } else if (screenManager.top !is RequestPermissionScreen) {
                screenManager.push(
                    RequestPermissionScreen(carContext) {
                        mapController.onLocationOPermissionGranted()
                    }
                )
            }
        } else if (!isLocationEnabled()) {
            if (locationState != LocationState.NOT_AVAILABLE) {
                locationState = LocationState.NOT_AVAILABLE
                invalidate()
            }
        } else {
            if (locationState != LocationState.AVAILABLE) {
                locationState = LocationState.AVAILABLE
                invalidate()
            }
        }
    }

    private fun registerLocationSettingsObserver() {
        carContext.contentResolver.registerContentObserver(
            Settings.Secure.getUriFor(Settings.Secure.LOCATION_MODE),
            false,
            locationSettingsObserver
        )
    }

    private fun unregisterLocationSettingsObserver() {
        carContext.contentResolver.unregisterContentObserver(locationSettingsObserver)
    }

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
        hostFlutterApi = FlutterProvider.getHostFlutterApi(carContext)
        lifecycle.addObserver(
            object : DefaultLifecycleObserver {
                override fun onCreate(owner: LifecycleOwner) {
                    mapController.setNavigationListener(this@NavigationScreen)
                    checkLocationPermissionAndState()
                }

                override fun onResume(owner: LifecycleOwner) {
                    checkLocationPermissionAndState()
                    registerLocationSettingsObserver()
                    registerLocationModeReceiver()
                    tryToShowFavourites()
                }

                override fun onPause(owner: LifecycleOwner) {
                    unregisterLocationSettingsObserver()
                    unregisterLocationModeReceiver()
                }

                override fun onDestroy(owner: LifecycleOwner) {
                    mapController.resetNavigationListener()
                    favouritesUpdateJob?.cancel()
                    unregisterLocationSettingsObserver()
                    unregisterLocationModeReceiver()
                    coroutineScope.cancel()
                }
            }
        )

        getFavourites()

        favouritesUpdateJob = CoroutineScope(Dispatchers.Default).launch {
            for (favouritesMessage in FavouritesUpdateNotifier.events) {
                withContext(Dispatchers.Main) {
                    handleFavouritesMessage(favouritesMessage) {
                        favourites = it
                        tryToShowFavourites(forceUpdate = true)
                    }
                }
            }
        }

    }

    private var isEndTripShown: Boolean = false

    private var isBetterRouteAlertShown: Boolean = false

    // Guards the three-way SDK response so exactly one reply is sent per offer. A user tap that
    // lands at the same instant as the 10s host timeout, or a reply after the SDK already withdrew
    // the offer, would otherwise answer the same offer twice — which crashes the native SDK.
    private var betterRouteAwaitingResponse: Boolean = false

    private var navigationState = NavigationState.DISABLED
    private var locationState = LocationState.AVAILABLE

    private var step: Step? = null
    private var nextStep: Step? = null
    private var stepRemainingDistance: Distance? = null

    private var destination: Destination? = null
    private var destinationTravelEstimate: TravelEstimate? = null
    private var speedInfo = SpeedInfoModel()

    private var favourites: FavouritesParams? = null

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
        navigationTemplate.setBackgroundColor(maneuverCardColor)
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
                CoroutineScope(Dispatchers.Main).launch {
                    mapController.showMyLocation()
                }
                customRenderer.clear()
                showEndTrip()
            }

            NavigationState.DISABLED -> {
                CoroutineScope(Dispatchers.Main).launch {
                    mapController.showMyLocation()
                }
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
        if (lifecycle.currentState != Lifecycle.State.RESUMED) {
            carNotificationManager.notify(
                NavigationCarAppService.notificationId,
                getNavigationNotification(
                    "${distance.toString().replace("\\.0$".toRegex(), "")} $unitString",
                    maneuver.roadName,
                    maneuver.iconId,
                    shouldNotify,
                ),
            )
        }

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
            // SDK retracted the offer: drop the alert but do NOT send a response for an offer
            // that no longer exists.
            betterRouteAwaitingResponse = false
            dismissBetterRouteAlert()
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
        tryToShowFavourites()
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
        isBetterRouteAlertShown = false
        betterRouteAwaitingResponse = false
        dismissBetterRouteAlert()
        navigationManager.navigationEnded()
        val notification = NavigationCarAppService.getDefaultNotification(carContext)
        carNotificationManager.notify(NavigationCarAppService.notificationId, notification)
        mapController.stopNavigation()
        if (!bySystem) {
            tryToShowFavourites()
        } else {
            CoroutineScope(Dispatchers.Default).launch {
                // We should wait until the system completes the state changes
                delay(800)
                if (lifecycle.currentState == Lifecycle.State.RESUMED) {
                    withContext(Dispatchers.Main) {
                        tryToShowFavourites()
                    }
                }
            }
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
        try {
            appManager.showAlert(endTripAlert.build())
        } catch (e: Exception) {
            // Host can reject showAlert; the end-of-trip prompt is not worth crashing over.
            e.printStackTrace()
            isEndTripShown = false
        }
    }

    private fun showBetterRouteAlert(durationProfit: Int) {
        // Alerts with the same id are considered equal by the host: re-posting tears the
        // displayed alert down and re-creates it, dropping clicks that land in between. The
        // channel re-emits while the offer is active, so keep the first alert on screen until it
        // is answered or times out instead of replacing it on every emit.
        if (isBetterRouteAlertShown) return

        val minutes = max(round(durationProfit / 60.0).toInt(), 1)
        val title = CarText.create(getString(R.string.better_route_alert_title))
        val subtitle = CarText.create(getString(R.string.better_route_alert_subtitle, minutes))
        val closeAction =
            Action.Builder()
                .setTitle(getString(R.string.better_route_alert_close_action))
                .setFlags(Action.FLAG_DEFAULT)
                .setBackgroundColor(betterRouteCloseButtonColor)
                .setOnClickListener {
                    dismissBetterRouteAlert()
                    respondToBetterRouteOnce { mapController.rejectBetterRoute() }
                }
        val chooseAction =
            Action.Builder()
                .setTitle(getString(R.string.better_route_alert_choose_action))
                .setFlags(Action.FLAG_PRIMARY)
                .setBackgroundColor(CarColor.PRIMARY)
                .setOnClickListener {
                    dismissBetterRouteAlert()
                    respondToBetterRouteOnce { mapController.acceptBetterRoute() }
                }

        val betterRouteAlert =
            Alert.Builder(betterRouteAlertId, title, 10000)
                .setSubtitle(subtitle)
                .addAction(closeAction.build())
                .addAction(chooseAction.build())
                .setCallback(
                    object : AlertCallback {
                        override fun onCancel(reason: Int) {
                            isBetterRouteAlertShown = false
                            if (reason == AlertCallback.REASON_TIMEOUT) {
                                // The SDK expects a three-way response; the stock 2GIS prompt
                                // reports TIMEOUT when the user ignores the offer.
                                respondToBetterRouteOnce { mapController.timeoutBetterRoute() }
                            } else {
                                // The host pulled the alert for another reason (replaced,
                                // system-dismissed): stop awaiting so a later callback can't
                                // answer an offer that is already gone.
                                betterRouteAwaitingResponse = false
                            }
                        }

                        override fun onDismiss() {
                            isBetterRouteAlertShown = false
                        }
                    }
                )
        isBetterRouteAlertShown = true
        betterRouteAwaitingResponse = true
        try {
            appManager.showAlert(betterRouteAlert.build())
        } catch (e: Exception) {
            // The host can reject showAlert (rate limiting / unsupported head unit). Roll the
            // guards back so a later offer can still be shown, and never crash the process.
            e.printStackTrace()
            isBetterRouteAlertShown = false
            betterRouteAwaitingResponse = false
        }
    }

    // Sends at most one better-route reply per offer. Guards against a user tap racing the 10s
    // host timeout, and against replying to an offer the SDK already withdrew.
    private fun respondToBetterRouteOnce(response: () -> Unit) {
        if (!betterRouteAwaitingResponse) return
        betterRouteAwaitingResponse = false
        response()
    }

    private fun dismissBetterRouteAlert() {
        try {
            appManager.dismissAlert(betterRouteAlertId)
        } catch (e: Exception) {
            e.printStackTrace()
        }
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
                Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CW_WITH_ANGLE,
                    -> true

                else -> false
            }
        if (isRoundabout) {
            maneuver.setRoundaboutExitNumber(exitNumber ?: 1)
        }
        return maneuver.build()
    }

    private fun getFavourites(forceUpdate: Boolean = false) {
        FlutterProvider.getHostFlutterApi(carContext).getFavourites { result ->
            handleFavouritesMessage(result.getOrNull()) {
                favourites = it
                if (mapController.isMapReady) {
                    tryToShowFavourites(forceUpdate)
                }
            }
        }
    }

    private fun handleFavouritesMessage(
        favourites: FavouritesStateMessage?,
        onResult: (FavouritesParams?) -> Unit,
    ) {
        if (favourites == null) {
            onResult(null)
            return
        }

        val items = favourites.items
        val home = favourites.home
        val work = favourites.work
        if (items.isEmpty() && home == null && work == null) {
            onResult(FavouritesParams())
            return
        }

        val futures = items.mapIndexed { index, item ->
            CompletableFuture<Pair<Int, FavouriteItem>>().also { future ->
                handleFavouriteItem(item) { result ->
                    future.complete(index to result)
                }
            }
        }

        CompletableFuture.allOf(*futures.toTypedArray())
            .thenApply {
                futures.map { it.get() }
                    .sortedBy { it.first }
                    .map { it.second }
            }
            .thenAccept { results ->
                onResult(
                    FavouritesParams(
                        home = home?.toFavouriteItem(),
                        work = work?.toFavouriteItem(),
                        items = results
                    )
                )
            }
    }


    fun handleFavouriteItem(item: FavouriteItemMessage, onResult: (FavouriteItem) -> Unit) {
        val locale = mapController.getLocale()
        mapController.searchByDirectoryObjectIdWithLocale(
            DgisObjectId(objectId = item.id.toLong()),
            SdkLocale(locale.language, "SA"),
            resultCallback = { directoryObject ->
                if (directoryObject == null) {
                    onResult(item.toFavouriteItem())
                    return@searchByDirectoryObjectIdWithLocale
                }

                hostFlutterApi.getMarkerType(directoryObject.rubricIds.map { it.value }) { markerTypeResult ->
                    onResult(
                        FavouriteItem(
                            id = item.id,
                            title = directoryObject.title,
                            subtitle = directoryObject.makeAddressString(),
                            coordinates = GeoPoint(
                                latitude = item.coordinates.latitude,
                                longitude = item.coordinates.longitude
                            ),
                            iconResId = AndroidAutoUtils.getPoiIcon(markerTypeResult.getOrNull())
                        )
                    )
                }
            })
    }

    private fun tryToShowFavourites(forceUpdate: Boolean = false) {
        val favourites = this.favourites
        if (favourites == null) return

        if (screenManager.top is NavigationScreen && !isNavigation) {
            screenManager.push(
                FavouritesPreviewScreen(carContext, mapController, favourites)
            )
        } else if (screenManager.top is FavouritesPreviewScreen && forceUpdate) {
            screenManager.pop()
        } else if (screenManager.top is FavouritesScreen) {
            screenManager.pop()
            screenManager.push(
                FavouritesScreen(carContext, mapController, favourites.items)
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

    override fun onLocaleChanged() {
        getFavourites(forceUpdate = true)
    }
}
