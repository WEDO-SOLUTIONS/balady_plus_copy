package com.dgis.map.android_auto

import android.location.Location
import com.dgis.map.DgisMapInitializer
import io.flutter.embedding.engine.loader.FlutterLoader
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.Duration
import ru.dgis.sdk.File
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.directory.DirectoryObject
import ru.dgis.sdk.directory.SearchManager
import ru.dgis.sdk.directory.Suggest
import ru.dgis.sdk.geometry.ComplexGeometry
import ru.dgis.sdk.geometry.PointGeometry
import ru.dgis.sdk.map.AttributeValue
import ru.dgis.sdk.map.BearingSource
import ru.dgis.sdk.map.CameraAnimationType
import ru.dgis.sdk.map.CameraPosition
import ru.dgis.sdk.map.CameraZoomRestrictions
import ru.dgis.sdk.map.LogicalPixel
import ru.dgis.sdk.map.MapObjectManager
import ru.dgis.sdk.map.Marker
import ru.dgis.sdk.map.MyLocationControlModel
import ru.dgis.sdk.map.MyLocationControllerSettings
import ru.dgis.sdk.map.MyLocationMapObjectSource
import ru.dgis.sdk.map.Padding
import ru.dgis.sdk.map.RouteEditorSource
import ru.dgis.sdk.map.StyleBuilder
import ru.dgis.sdk.map.Tilt
import ru.dgis.sdk.map.Zoom
import ru.dgis.sdk.map.ZoomControlButton
import ru.dgis.sdk.map.ZoomControlModel
import ru.dgis.sdk.map.calcPosition
import ru.dgis.sdk.map.setAttribute
import ru.dgis.sdk.navigation.RouteBuildOptions
import ru.dgis.sdk.navigation.getVoiceManager
import ru.dgis.sdk.platform.Locale as SdkLocale
import ru.dgis.sdk.platform.getLocaleManager
import ru.dgis.sdk.positioning.DesiredAccuracy
import ru.dgis.sdk.routing.CarRouteSearchOptions
import ru.dgis.sdk.routing.RouteEditor
import ru.dgis.sdk.routing.RouteEditorRouteParams
import ru.dgis.sdk.routing.RouteEditorRoutesInfo
import ru.dgis.sdk.routing.RouteSearchOptions
import ru.dgis.sdk.routing.RouteSearchPoint
import ru.dgis.sdk.traffic.TrafficControlModel
import ru.dgis.sdk.traffic.TrafficControlStatus
import java.lang.Exception
import java.util.Locale
import ru.dgis.sdk.map.Map as DgisMap
import com.dgis.map.map_api.SoundToggleType

class CarMapController(
    private val sharedPrefs: SharedPrefs,
    private val flutterLoader: FlutterLoader,
) : AutoCloseable {
    private val closeables = mutableListOf<AutoCloseable>()
    private val sdkContext = DgisMapInitializer.getSdkContext()
    private val locationSource = DgisMapInitializer.getLocationSource()
    private val searchHandler = CarSearchHandler(SearchManager.createOnlineManager(sdkContext))
    private var navigationHandler =
        CarNavigationHandler(DgisMapInitializer.getNavigationManager(), searchHandler, sharedPrefs)
    private val routeEditor = RouteEditor(sdkContext)
    private val routeEditorSource = RouteEditorSource(sdkContext, routeEditor).apply {
        setShowOnlyActiveRoute(true)
    }

    private var map: DgisMap? = null

    private var mapObjectManager: MapObjectManager? = null
    private var myLocationControlModel: MyLocationControlModel? = null
    private var zoomControlModel: ZoomControlModel? = null
    private var trafficControlModel: TrafficControlModel? = null

    private val parkingAttrName = "parkingOn"

    init {
        closeables.add(
            routeEditor.routesInfoChannel.connect(::onRoutesInfoChanged)
        )
    }

    fun onMapReady(map: DgisMap, locale: Locale) {
        this.map = map

        val mapSource = MyLocationMapObjectSource(
            sdkContext, MyLocationControllerSettings(bearingSource = BearingSource.AUTO)
        )
        map.addSource(mapSource)
        map.setAttribute("camerasOn", AttributeValue(true))

        myLocationControlModel = MyLocationControlModel(map)
        zoomControlModel = ZoomControlModel(map)
        trafficControlModel = TrafficControlModel(map)

        setZoomRestrictions()
        setupLocale(locale)
        setupNavigatorVoice(locale)
        setupLocation()

        navigationHandler.addMap(map)
        map.addSource(routeEditorSource)

        mapObjectManager = MapObjectManager.withGeneralization(
            map = map,
            logicalPixel = LogicalPixel(value = 8f),
            maxZoom = Zoom(value = 18f),
            layerId = "920277"
        )

        setStyle()
        settingsInit()
    }

    private fun setStyle() {
        val builder = StyleBuilder(sdkContext)
        val stylePath = flutterLoader.getLookupKeyForAsset("packages/map_styles/src/styles.2gis")
        closeables.add(builder.loadStyle(
            File.fromAsset(sdkContext, stylePath)
        ).apply {
            onResult { map?.style = it }
        })
    }

    private fun setZoomRestrictions() {
        map?.camera?.zoomRestrictions = CameraZoomRestrictions(minZoom = Zoom(5.5f))
    }

    private fun setupLocale(locale: Locale) {
        val sdkLocale = SdkLocale(locale.language, "SA")
        getLocaleManager(sdkContext).overrideLocales(listOf(sdkLocale))
    }

    private fun setupNavigatorVoice(locale: Locale) {
        var voiceId = sharedPrefs.getString(SharedPrefs.navigatorVoiceKey)
        if (voiceId == null) {
            voiceId = when (locale.language) {
                "ar" -> "voice-saud"
                else -> "voice-daniel"
            }
        }

        val voice = getVoiceManager(sdkContext).voices.firstOrNull { it.id == voiceId } ?: return

        if (!voice.info.installed) {
            closeables.add(voice.progressChannel.connect { progress ->
                if (progress.toInt() == 100) {
                    navigationHandler.setNavigationVoice(voice.navigationVoice)
                }
            })
            voice.install()
        } else {
            navigationHandler.setNavigationVoice(voice.navigationVoice)
        }
    }

    private fun setupLocation() {
        showMyLocation()
    }

    fun onLocationOPermissionGranted() {
        locationSource.apply {
            onPermissionGranted()
            setDesiredAccuracy(DesiredAccuracy.HIGH)
        }
    }

    fun zoomIn() {
        zoomControlModel?.setPressed(ZoomControlButton.ZOOM_IN, true)
        zoomControlModel?.setPressed(ZoomControlButton.ZOOM_IN, false)
    }

    fun zoomOut() {
        zoomControlModel?.setPressed(ZoomControlButton.ZOOM_OUT, true)
        zoomControlModel?.setPressed(ZoomControlButton.ZOOM_OUT, false)
    }

    fun followNavigation() {
        navigationHandler.followNavigation()
    }

    fun setNavigationListener(listener: CarNavigationHandler.NavigationListener) {
        navigationHandler.setListener(listener)
    }

    fun resetNavigationListener() {
        navigationHandler.resetNavigationListener()
    }

    fun startNavigationSimulation() {
        routeEditorSource.setRoutesVisible(false)
        navigationHandler.startNavigationSimulation()
    }

    fun showMyLocation() {
        myLocationControlModel?.onClicked()
    }

    fun stopNavigation() {
        navigationHandler.stopNavigation()
    }

    fun overviewRoute() {
        navigationHandler.overviewRoute()
    }

    fun acceptBetterRoute() {
        navigationHandler.acceptBetterRoute()
    }

    fun rejectBetterRoute() {
        navigationHandler.rejectBetterRoute()
    }

    fun searchByDirectoryObjectId(
        objectId: DgisObjectId,
        resultCallback: (result: DirectoryObject?) -> Unit,
        errorCallback: ((exception: Exception) -> Unit)? = null
    ) {
        searchHandler.searchByDirectoryObjectId(objectId, resultCallback, errorCallback)
    }

    fun search(
        queryText: String,
        pageSize: Int,
        resultCallback: (result: List<DirectoryObject>) -> Unit,
        errorCallback: ((exception: Exception) -> Unit)? = null
    ) {
        searchHandler.search(queryText, pageSize, resultCallback, errorCallback)
    }

    fun suggest(
        queryText: String,
        limit: Int,
        resultCallback: (result: List<Suggest>) -> Unit,
        errorCallback: ((exception: Exception) -> Unit)? = null
    ) {
        searchHandler.suggest(queryText, limit, resultCallback, errorCallback)
    }


    private fun settingsInit() {
        // Voice instructions
        navigationHandler.toggleVoiceInstruction(sharedPrefs.voiceInstructionsValue)

        // Traffic
        val trafficStatus = trafficControlModel?.stateChannel?.value?.status ?: TrafficControlStatus.DISABLED
        val currentTrafficValue = trafficStatus == TrafficControlStatus.ENABLED
        if (sharedPrefs.trafficValue != currentTrafficValue) {
            trafficControlModel?.onClicked()
        }

        // Parking
        if (sharedPrefs.parkingValue != isParkingOnNow) {
            onParkingClicked()
        }

        // Volume
        val volumeLevels = listOf(10, 30, 60) // Minimum, Quiet, Standard
        val volumeIndex = sharedPrefs.volumeValue
        val volume = volumeLevels.getOrElse(volumeIndex) { 30 }
        navigationHandler.setNavigatorVolume(volume)

        // Better road
        navigationHandler.setBetterRouteEnabled(sharedPrefs.suggestBetterRoad)
    }

    // -- Voice Instructions
    var voiceInstructions: SoundToggleType
        get() {
            return sharedPrefs.voiceInstructionsValue
        }
        set(value) {
            sharedPrefs.voiceInstructionsValue = value
            navigationHandler.toggleVoiceInstruction(value)
        }

    // -- Traffic
    val trafficEnabled: Boolean
        get() {
            return sharedPrefs.trafficValue
        }

    fun toggleTrafficControl() {
        trafficControlModel?.onClicked()
        sharedPrefs.trafficValue = !sharedPrefs.trafficValue
    }

    // -- Parking
    private var DgisMap.isParkingOn: Boolean
        get() {
            return attributes.getAttributeValue(parkingAttrName).asBoolean == true
        }
        private set(value) {
            attributes.setAttributeValue(parkingAttrName, AttributeValue(value))
        }

    val isParkingOnNow: Boolean?
        get() {
          val value = map?.isParkingOn
          if (value != sharedPrefs.parkingValue) {
              sharedPrefs.parkingValue = value == true
          }
            return value
        }

    fun onParkingClicked() {
        if (map != null) {
            sharedPrefs.parkingValue = !map!!.isParkingOn
            map!!.isParkingOn = !map!!.isParkingOn
        }
    }

    // -- Volume
    var volumeValue: Int
        get() {
            return sharedPrefs.volumeValue
        }
        set(value) {
            sharedPrefs.volumeValue = value
            val volumeLevels = listOf(10, 30, 60) // Minimum, Quiet, Standard
            val volume = volumeLevels.getOrElse(value) { 30 }
            navigationHandler.setNavigatorVolume(volume)
        }

    // -- Route Settings
    var avoidTollRoads: Boolean
        get() = sharedPrefs.avoidTollRoads
        set(value) {  sharedPrefs.avoidTollRoads = value }

    var avoidUnpavedRoads: Boolean
        get() = sharedPrefs.avoidUnpavedRoads
        set(value) { sharedPrefs.avoidUnpavedRoads = value }

    var suggestBetterRoad: Boolean
        get() {
            return sharedPrefs.suggestBetterRoad
        }
        set(value) {
            sharedPrefs.suggestBetterRoad = value
            navigationHandler.setBetterRouteEnabled(sharedPrefs.suggestBetterRoad)
        }

    fun setRouteParams(latitude: Double, longitude: Double, objectId: DgisObjectId? = null) {
        val startPoint = locationSource.lastLocation?.let {
            RouteSearchPoint(GeoPoint(it.latitude, it.longitude))
        } ?: return

        val finishPoint = if (objectId != null) RouteSearchPoint(
            GeoPoint(latitude, longitude),
            objectId = DgisObjectId(objectId.objectId, objectId.entranceId),
        ) else RouteSearchPoint(
            GeoPoint(latitude, longitude)
        )

        val options = RouteSearchOptions(
            CarRouteSearchOptions(
                avoidTollRoads = sharedPrefs.avoidTollRoads,
                avoidUnpavedRoads = sharedPrefs.avoidUnpavedRoads
            )
        )
        routeEditor.setRouteParams(
            RouteEditorRouteParams(startPoint, finishPoint, options)
        )
    }

    private fun onRoutesInfoChanged(routesInfo: RouteEditorRoutesInfo) {
        if (routesInfo.routes.isNotEmpty()) {
            map?.let {
                routeEditorSource.setRoutesVisible(true)
                val geometries = routesInfo.routes.map { route ->
                    route.route.geometry.entries.map { entry ->
                        PointGeometry(entry.value)
                    }
                }.flatten()
                val geometry = ComplexGeometry(geometries)
                val cameraPosition = calcPosition(camera = it.camera, geometry = geometry)
                it.camera.move(cameraPosition, animationType = CameraAnimationType.LINEAR)
            }

            // TODO(Sergei): remove startNavigation call when route overview screen is implemented
            startNavigation(routesInfo.routeParams)
        }
    }

    fun startNavigation(routeParams: RouteEditorRouteParams) {
        val selectedRouteIndex = routeEditor.activeRouteIndex?.value?.toInt() ?: return
        val selectedRoute = routeEditor.routesInfo.routes[selectedRouteIndex]

        routeEditorSource.setRoutesVisible(false)
        navigationHandler.startNavigation(
            routeBuildOptions = RouteBuildOptions(
                routeParams.finishPoint, routeParams.routeSearchOptions
            ),
            trafficRoute = selectedRoute,
        )
    }

    fun getMyLocation(): Location? {
        return locationSource.lastLocation
    }

    fun getCurrentNavigationState(): NavigationState {
        return navigationHandler.getCurrentNavigationState()
    }

    fun addMarkers(markers: List<Marker>) {
        val objectManager = this.mapObjectManager ?: return
        objectManager.addObjects(markers)
    }

    fun removeAllMarkers() {
        val objectManager = this.mapObjectManager ?: return
        objectManager.removeAll()
    }

    fun moveCamera(
        point: GeoPoint,
        zoom: Double = 17.0,
        tilt: Double = 0.0,
        bearing: Double = 0.0,
        duration: Long = 300,
        animationType: CameraAnimationType = CameraAnimationType.LINEAR,
    ) {
        val map = map ?: return
        closeables.add(
            map.camera.move(
                CameraPosition(
                    point = point,
                    zoom = Zoom(zoom.toFloat()),
                    tilt = Tilt(tilt.toFloat()),
                    bearing = Bearing(bearing),
                ),
                Duration.ofMilliseconds(duration), animationType,
            )
        )
    }

    fun setCameraPadding(padding: Padding) {
        val map = this.map ?: return
        map.camera.padding = padding
    }

    override fun close() {
        closeables.forEach(AutoCloseable::close)
        map?.close()
    }
}
