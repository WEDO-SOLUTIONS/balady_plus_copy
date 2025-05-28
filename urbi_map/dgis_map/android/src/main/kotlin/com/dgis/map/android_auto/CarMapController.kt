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
import java.lang.Exception
import java.util.Locale
import ru.dgis.sdk.map.Map as DgisMap

class CarMapController(
    private val sharedPrefs: SharedPrefs,
    private val flutterLoader: FlutterLoader,
) : AutoCloseable {
    private val closeables = mutableListOf<AutoCloseable>()
    private val sdkContext = DgisMapInitializer.getSdkContext()
    private val locationSource = DgisMapInitializer.getLocationSource()
    private val searchHandler = CarSearchHandler(SearchManager.createOnlineManager(sdkContext))
    private var navigationHandler =
        CarNavigationHandler(DgisMapInitializer.getNavigationManager(), searchHandler)
    private val routeEditor = RouteEditor(sdkContext)
    private val routeEditorSource = RouteEditorSource(sdkContext, routeEditor).apply {
        setShowOnlyActiveRoute(true)
    }

    private var map: DgisMap? = null

    private var mapObjectManager: MapObjectManager? = null
    private var myLocationControlModel: MyLocationControlModel? = null
    private var zoomControlModel: ZoomControlModel? = null
    private var trafficControlModel: TrafficControlModel? = null

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

    fun toggleTrafficControl() {
        trafficControlModel?.onClicked()
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
        val options = RouteSearchOptions(CarRouteSearchOptions())
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

    fun setCameraPadding(padding: Padding){
        val map = this.map ?: return
        map.camera.padding = padding
    }

    override fun close() {
        closeables.forEach(AutoCloseable::close)
        map?.close()
    }
}
