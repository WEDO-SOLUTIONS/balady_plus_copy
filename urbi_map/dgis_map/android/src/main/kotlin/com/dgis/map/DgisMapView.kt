package com.dgis.map

import android.content.Context
import android.location.Location
import android.util.Size
import android.view.LayoutInflater
import com.dgis.map.control_handlers.*
import com.dgis.map.extensions.toGeoRect
import com.dgis.map.extensions.toSdkAccuracy
import com.dgis.map.extensions.unsafeLazy
import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.*
import io.flutter.FlutterInjector
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.platform.PlatformView
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.File
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.GeoRect
import ru.dgis.sdk.directory.SearchManager
import ru.dgis.sdk.getLocaleManager
import ru.dgis.sdk.map.*
import ru.dgis.sdk.positioning.DefaultLocationSource
import ru.dgis.sdk.positioning.LocationChangeListener
import java.io.FileNotFoundException
import kotlin.collections.Map
import kotlin.math.roundToInt
import com.dgis.map.map_api.Messages.Result as ApiResult
import ru.dgis.sdk.map.Map as DgisMap

class DgisMapView(
    private val sdkContext: ru.dgis.sdk.Context,
    private val binaryMessenger: BinaryMessenger,
    private val id: Int,
    private val context: Context,
    creationParams: Map<*, *>?,
) : PlatformView, MapApi {

    private val mapView: MapView =
        LayoutInflater.from(context).inflate(R.layout.map_view_layout, null) as MapView

    private var map: DgisMap? = null

    private val locationSource by unsafeLazy { DefaultLocationSource(context) }

    private var zoomControlHandler: ZoomControlHandler? = null
    private var locationControlHandler: LocationControlHandler? = null
    private var indoorControlHandler: IndoorControlHandler? = null
    private var objectTapHandler: ObjectTapHandler? = null
    private var visibleRectHandler: VisibleRectHandler? = null
    private var searchHandler: SearchHandler? = null
    private var routeHandler: RouteHandler? = null
    private val navigationHandler by unsafeLazy {
        NavigationHandler(
            sdkContext = sdkContext,
            navigationView = mapView.findViewById(R.id.navigationView),
            eventSink = eventSink,
        )
    }
    private var compassControlHandler: CompassControlHandler? = null
    private var trafficAndParkingControlHandler: TrafficAndParkingControlHandler? = null

    /**
     * Event stream to Flutter
     */
    private lateinit var eventChannel: EventChannel
    private val eventSink = QueuingEventSink()
    private val eventStreamHandler = DgisStreamHandler(eventSink)

    private val closables = mutableListOf<AutoCloseable>()

    init {
        MapApi.setup(binaryMessenger, this)
    }

    override fun getView() = mapView

    override fun dispose() {
        map?.close()
        routeHandler?.close()
        zoomControlHandler?.close()
        locationControlHandler?.close()
        indoorControlHandler?.close()
        searchHandler?.close()
        locationSource.deactivate()
        visibleRectHandler?.close()
        compassControlHandler?.close()
        trafficAndParkingControlHandler?.close()
    }

    override fun initialize(result: ApiResult<InitializeMessage>) {
        try {
            // Setup channel to handle call from Flutter
            eventChannel = EventChannel(binaryMessenger, "com.dgis.map_view_events_$id")
            eventChannel.setStreamHandler(eventStreamHandler)
            mapView.getMapAsync { map ->
                onMapReady(map, result)
            }
        } catch (e: Exception) {
            result.error(e)
        }
    }

    override fun zoomDown(type: ZoomControlMessage, result: Messages.Result<Void>?) {
        zoomControlHandler?.onZoomDown(type)

        result?.success(null)
    }

    override fun zoomUp(type: ZoomControlMessage, result: Messages.Result<Void>?) {
        zoomControlHandler?.onZoomUp(type)

        result?.success(null)
    }

    override fun changeFollowState(result: Messages.Result<Void>?) {
        locationControlHandler?.onTap()

        result?.success(null)
    }

    override fun selectIndoorLevel(index: Long, result: Messages.Result<Void>?) {
        indoorControlHandler?.selectIndoorLevel(index)

        result?.success(null)
    }

    override fun loadStyles(asset: String, result: Messages.Result<Void>) {
        val styleAsset =
            FlutterInjector
                .instance()
                .flutterLoader()
                .getLookupKeyForAsset(asset)

        val builder = StyleBuilder(sdkContext)
        closables.add(builder.loadStyle(File.fromAsset(sdkContext, styleAsset)).apply {
            onResult {
                map?.style = it
                result.success(null)
            }
            onError {
                result.error(FileNotFoundException("Failed to load style Error: ${it.message}"))
            }
        })
    }

    override fun overrideLocales(locales: List<String>, result: Messages.Result<Void>?) {
        getLocaleManager(sdkContext).overrideLocales(locales)

        result?.success(null)
    }

    override fun setCameraPosition(
        cameraPosition: CameraPositionMessage,
        result: Messages.Result<Void>
    ) {
        val map = map ?: kotlin.run {
            result.error(IllegalArgumentException("Map has not been initialized"))
            return
        }

        map.camera.position = map.camera.position.copy(
            point = GeoPoint(
                latitude = cameraPosition.geoPoint.latitude,
                longitude = cameraPosition.geoPoint.longitude
            ),
            zoom = Zoom(cameraPosition.zoomValue.toFloat())
        )
        result.success(null)
    }

    override fun searchByObjectId(
        objectId: DgisObjectIdMessage,
        result: Messages.Result<ObjectInfoMessage>?
    ) {
        searchHandler?.searchByDirectoryObjectId(
            DgisObjectId(
                objectId = objectId.objectId,
                entranceId = objectId.entranceId
            ),
            result,
        )
    }

    private fun setupTapHandler() {
        val map = map ?: return

        val objectTapHandler = ObjectTapHandler(
            mapObjectManager = MapObjectManager(map),
            panoramasObjectManager =
            MapObjectManager.withGeneralization(
                map = map,
                logicalPixel = LogicalPixel(value = 20f),
                maxZoom = Zoom(value = 18f)
            ),
            ioObjectManager =
                MapObjectManager.withGeneralization(
                    map=map,
                    logicalPixel = LogicalPixel(value = 50f),
                    maxZoom = Zoom(value = 18f)
                ),
            routeHandler = routeHandler,
            eventSink = eventSink,
            sdkContext = sdkContext,
        )
        mapView.addObjectTappedCallback(objectTapHandler::objectTapListener)
        this.objectTapHandler = objectTapHandler
    }

    override fun getDistanceTo(
        points: List<DistanceRequestMessage>,
        result: Messages.Result<List<DistanceResponseMessage>>?
    ) {
        searchHandler?.getDistanceTo(points, result)
    }

    override fun search(
        queryText: String,
        searchMarker: MarkerIconMessage,
        weekTime: WeekTimeSearchMessage?,
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Long,
        result: Messages.Result<List<ObjectInfoMessage>>?
    ) {
        searchHandler?.search(
            queryText = queryText,
            searchMarker = searchMarker,
            searchGeoRect = searchRect?.toGeoRect(),
            weekTimeMessage = weekTime,
            sortingType = sortingType,
            pageSize = pageSize.toInt(),
            result = result
        )
    }

    override fun getNextPage(result: Messages.Result<List<ObjectInfoMessage>>?) {
        searchHandler?.getNextPage(result)
    }

    override fun setMarkerOptions(options: MarkerOptionsMessageOld, result: Messages.Result<Void>?) {
        objectTapHandler?.setMarkerOptions(
            svgAsset = options.svgAsset,
            size = Size(options.width.roundToInt(), options.height.roundToInt()),
            iconWidth = options.iconWidth,
            sdkContext = sdkContext,
            result = result
        )
    }

    override fun addMarker(marker: MarkerMessage, result: Messages.Result<Void>?) {
        objectTapHandler?.addMarker(marker, result)
    }

    override fun addMarkers(markers: List<MarkerMessage>, result: Messages.Result<Void>?) {
        objectTapHandler?.addMarkers(markers, result)
    }

    override fun removeMarker(id: Long, result: Messages.Result<Void>?) {
        objectTapHandler?.removeMarker(id, result)
    }

    override fun removeAllMarkers(result: Messages.Result<Void>?) {
        objectTapHandler?.removeAllMarkers()
        result?.success(null)
    }

    override fun addPolygon(polygon: PolygonMessage, result: Messages.Result<Void>?) {
        objectTapHandler?.addPolygon(polygon, result)
    }

    override fun addPolygons(polygons: List<PolygonMessage>, result: Messages.Result<Void>?) {
        objectTapHandler?.addPolygons(polygons, result)
    }

    override fun removePolygon(id: Long, result: Messages.Result<Void>?) {
        objectTapHandler?.removePolygon(id, result)
    }

    override fun removeAllPolygons(result: Messages.Result<Void>?) {
        objectTapHandler?.removeAllPolygons()
        result?.success(null)
    }

    override fun addPolyline(polyline: PolylineMessage, result: Messages.Result<Void>?) {
        objectTapHandler?.addPolyline(polyline, result)
    }

    override fun addPolylines(polylines: List<PolylineMessage>, result: Messages.Result<Void>?) {
        objectTapHandler?.addPolylines(polylines, result)
    }

    override fun removePolyline(id: Long, result: Messages.Result<Void>?) {
        objectTapHandler?.removePolyline(id, result)
    }

    override fun removeAllPolylines(result: Messages.Result<Void>?) {
        objectTapHandler?.removeAllPolylines()
        result?.success(null)
    }

    override fun setRouteParams(
        params: RouteEditorRouteParamsMessage,
        result: Messages.Result<Void>?
    ) {
        routeHandler?.setRouteParams(params);
        result?.success(null)
    }

    override fun hideRoutes(result: Messages.Result<Void>?) {
        routeHandler?.setRoutesVisible(false)
        result?.success(null)
    }

    override fun startNavigation(result: Messages.Result<Void>?) {
        val routeHandler = routeHandler ?: kotlin.run {
            result?.error(Exception("RouteHandler not initialized"))
            return
        }
        routeHandler.setRoutesVisible(false)
        navigationHandler.startNavigation(
            finishPoint = routeHandler.finishPoint,
            options = routeHandler.options,
            route = routeHandler.selectedRoute,
            result = result
        )
    }

    override fun startNavigationSimulation(result: Messages.Result<Void>?) {
        val routeHandler = routeHandler ?: kotlin.run {
            result?.error(Exception("RouteHandler not initialized"))
            return
        }
        routeHandler.setRoutesVisible(false)
        navigationHandler.startSimulation(
            finishPoint = routeHandler.finishPoint,
            options = routeHandler.options,
            route = routeHandler.selectedRoute,
            result = result
        )
    }

    override fun stopNavigation(result: Messages.Result<Void>?) {
        navigationHandler.stopNavigation()
        result?.success(null)
    }

    override fun removeSearchMarkers(result: Messages.Result<Void>?) {
        searchHandler?.removeSearchMarkers()
        result?.success(null)
    }

    override fun addPanoramasMarkers(
        message: AddMarkersWithPhotoMessage,
        result: Messages.Result<Void>?
    ) {
        objectTapHandler?.addPanoramasMarkers(message)
        result?.success(null)
    }

    override fun showPanoramasMarkers(result: Messages.Result<Void>?) {
        objectTapHandler?.showPanoramasMarkers()
        result?.success(null)
    }

    override fun hidePanoramasMarkers(result: Messages.Result<Void>?) {
        objectTapHandler?.hidePanoramasMarkers()
        result?.success(null)
    }

    override fun removePanoramasMarkers(result: Messages.Result<Void>?) {
        objectTapHandler?.removePanoramasMarkers()
        result?.success(null)
    }

    override fun setHighlighted(
        objectIds: List<DgisObjectIdMessage>,
        result: Messages.Result<Void>?
    ) {
        objectTapHandler?.setHighlighted(
            objectIds = objectIds.map {
                DgisObjectId(
                    objectId = it.objectId,
                    entranceId = it.entranceId,
                )
            },
            result = result,
        )
    }

    override fun fetchSuggests(
        queryText: String,
        searchRect: GeoRectMessage?,
        result: Messages.Result<List<SuggestMessage>>?
    ) {
        searchHandler?.fetchSuggests(
            queryText = queryText,
            searchGeoRect = searchRect?.toGeoRect(),
            result = result
        )
    }

    override fun showLastSearchMarker(result: Messages.Result<Void>?) {
        objectTapHandler?.showLastSearchMarker()
        result?.success(null)
    }

    override fun onLocationPremissionGranted(
        desiredAccuracy: DesiredAccuracyMessage,
        result: Messages.Result<Void>?
    ) {
        locationSource.onPermissionGranted()
        locationSource.setDesiredAccuracy(desiredAccuracy.toSdkAccuracy())
        locationSource.activate(object : LocationChangeListener {
            override fun onAvailabilityChanged(availability: Boolean) {
                // TODO(tharkahov): not used for now
            }

            override fun onLocationChanged(locations: Array<Location>) {
                // TODO(tharkahov): not used for now
            }
        })
        result?.success(null)
    }

    override fun searchBySuggest(
        index: Long,
        searchMarker: MarkerIconMessage,
        weekTime: WeekTimeSearchMessage?,
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Long,
        result: Messages.Result<List<ObjectInfoMessage>>?
    ) {
        searchHandler?.searchBySuggest(
            index = index.toInt(),
            searchMarker = searchMarker,
            searchGeoRect = searchRect?.toGeoRect(),
            weekTimeMessage = weekTime,
            sortingType = sortingType,
            pageSize = pageSize.toInt(),
            result = result
        )
    }

    override fun getSuggestObject(index: Long, result: Messages.Result<ObjectInfoMessage>?) {
        searchHandler?.getSuggestObject(index.toInt(), result)
    }

    override fun overlappedBy(
        outerRect: GeoRectMessage,
        innerRect: GeoRectMessage,
        result: Messages.Result<Long>?
    ) {
        val outer = outerRect.toGeoRect()

        val inner = innerRect.toGeoRect()

        val isOverlapped = if (outer.contains(inner)) 1L else 0
        result?.success(isOverlapped)
    }

    override fun getDirectoryDynamicFilters(
        result: Messages.Result<List<FlagFilterMessage>>?
    ) {
        searchHandler?.getDirectoryDynamicFilters(result)
    }

    override fun applyDirectoryFilters(
        filters: List<FlagFilterMessage>,
        isOpenFilter: WorkingFilterMessage,
        sortingType: SortingTypeMessage,
        result: Messages.Result<List<ObjectInfoMessage>>?
    ) {
        searchHandler?.applyDirectoryFilters(
            filters = filters,
            isOpenFilter = isOpenFilter,
            sortingType = sortingType,
            result = result
        )
    }

    override fun setPanoramaMarkerAzimuth(
        message: MarkerAzimuthMessage,
        result: Messages.Result<Void>?
    ) {
        objectTapHandler?.setPanoramasAzimuth(message.degree)
        result?.success(null)
    }

    override fun onCompassClicked(result: Messages.Result<Void>?) {
        compassControlHandler?.onClicked()
        result?.success(null)
    }

    override fun onTrafficAndParkingAttached(result: Messages.Result<Void>?) {
        trafficAndParkingControlHandler?.onAttachToMap()
        result?.success(null)
    }

    override fun onTrafficAndParkingDetached(result: Messages.Result<Void>?) {
        trafficAndParkingControlHandler?.onDetachFromMap()
        result?.success(null)
    }

    override fun onParkingClicked(result: Messages.Result<Void>?) {
        trafficAndParkingControlHandler?.onParkingClicked()
        result?.success(null)
    }

    override fun onTrafficClicked(result: Messages.Result<Void>?) {
        trafficAndParkingControlHandler?.onTrafficClicked()
        result?.success(null)
    }

    override fun setPanoramasPaddings(
        message: CameraSetPaddingMessage,
        result: Messages.Result<Void>?
    ) {
        map?.let {
            objectTapHandler?.setPanoramasPadding(it, message)
        }
        result?.success(null)
    }

    override fun unselectPanorama(result: Messages.Result<Void>?) {
        objectTapHandler?.unselectPanorama()
        result?.success(null)
    }

    override fun showEsriIOLayer(message: Messages.AddLayerPointObjectsMessage, result: Messages.Result<Void>?)
    {
        objectTapHandler?.addIoMarkers(message, result)
    }

    override fun removeEsriIOLayer(result: Messages.Result<Void>?)
    {
        objectTapHandler?.removeAllMarkers()
        result?.success(null)
    }

    override fun moveCameraToSelectedPanorama(result: Messages.Result<Void>?) {
        map?.let {
            objectTapHandler?.moveCameraToSelectedPanorama(it)
        }
        result?.success(null)
    }

    override fun setPublicTransportActiveRoute(routeIndex: Long, result: Messages.Result<Void>?) {
        routeHandler?.setActiveRouteIndex(routeIndex)
        result?.success(null)
    }

    override fun startFreeRoam(result: Messages.Result<Void>?) {
        navigationHandler.startFreeRoam()
        result?.success(null)
    }

    override fun stopFreeRoam(result: Messages.Result<Void>?) {
        navigationHandler.stopFreeRoam()
        result?.success(null)
    }

    override fun toggleSound(result: Messages.Result<Void>?) {
        navigationHandler.toggleSounds()
        result?.success(null)
    }

    private fun onMapReady(map: DgisMap, result: ApiResult<InitializeMessage>) {
        this.map = map

        val mapSource = MyLocationMapObjectSource(
            sdkContext,
            MyLocationDirectionBehaviour.FOLLOW_SATELLITE_HEADING,
            createSmoothMyLocationController()
        )
        map.addSource(mapSource)

        routeHandler = RouteHandler(map, sdkContext, eventSink, locationSource)
        zoomControlHandler = ZoomControlHandler(map, eventSink)
        locationControlHandler = LocationControlHandler(map, eventSink)
        indoorControlHandler = IndoorControlHandler(map, eventSink)
        visibleRectHandler = VisibleRectHandler(map, eventSink)
        searchHandler = SearchHandler(
            map,
            sdkContext,
            SearchManager.createOnlineManager(sdkContext),
            locationSource
        )
        compassControlHandler = CompassControlHandler(map, eventSink)
        trafficAndParkingControlHandler = TrafficAndParkingControlHandler(map, eventSink)
        setupTapHandler()

        result.success(
            InitializeMessage.Builder()
                .setWasInitialized(true)
                .setErrorDescription("")
                .build()
        )
    }
}
