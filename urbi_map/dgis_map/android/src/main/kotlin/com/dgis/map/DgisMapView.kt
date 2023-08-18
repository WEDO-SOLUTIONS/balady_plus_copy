package com.dgis.map

import android.content.Context
import android.location.Location
import android.util.Size
import android.view.LayoutInflater
import com.dgis.map.control_handlers.*
import com.dgis.map.extensions.*
import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.*
import io.flutter.FlutterInjector
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.platform.PlatformView
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.Duration
import ru.dgis.sdk.File
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.GeoRect
import ru.dgis.sdk.directory.DirectoryFilter
import ru.dgis.sdk.directory.ObjectType
import ru.dgis.sdk.directory.SearchManager
import ru.dgis.sdk.directory.SearchQueryBuilder
import ru.dgis.sdk.getLocaleManager
import ru.dgis.sdk.map.*
import ru.dgis.sdk.positioning.DefaultLocationSource
import ru.dgis.sdk.positioning.LocationChangeListener
import ru.dgis.sdk.positioning.LocationSource
import java.io.FileNotFoundException
import kotlin.collections.Map
import kotlin.math.round
import kotlin.math.roundToInt
import com.dgis.map.map_api.Messages.Result as ApiResult
import ru.dgis.sdk.map.Map as DgisMap

class DgisMapView(
    private val sdkContext: ru.dgis.sdk.Context,
    private val binaryMessenger: BinaryMessenger,
    private val id: Int,
    private val context: Context,
    private val locationSource: FusedLocationSource,
) : PlatformView, MapApi {

    private val mapView: MapView =
        LayoutInflater.from(context).inflate(R.layout.map_view_layout, null) as MapView

    private var map: DgisMap? = null

    private var zoomControlHandler: ZoomControlHandler? = null
    private var locationControlHandler: LocationControlHandler? = null
    private var indoorControlHandler: IndoorControlHandler? = null
    private var objectTapHandler: ObjectTapHandler? = null
    private var visibleRectHandler: VisibleRectHandler? = null
    private var searchHandler: SearchHandler? = null
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
        zoomControlHandler?.close()
        locationControlHandler?.close()
        indoorControlHandler?.close()
        searchHandler?.close()
        locationSource.deactivate()
        visibleRectHandler?.close()
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
            point = cameraPosition.point.toGeoPoint(),
            zoom = Zoom(cameraPosition.zoom.toFloat()),
            tilt = Tilt(cameraPosition.tilt.toFloat()),
            bearing = Bearing(cameraPosition.bearing)
        )
        result.success(null)
    }

    override fun moveCamera(
        cameraPosition: CameraPositionMessage,
        duration: Double,
        animationType: CameraAnimationTypeMessage,
        result: Messages.Result<Void>
    ) {
        val map = map ?: kotlin.run {
            result.error(IllegalArgumentException("Map has not been initialized"))
            return
        }

        val cameraPosition = CameraPosition(
            point = cameraPosition.point.toGeoPoint(),
            zoom = Zoom(cameraPosition.zoom.toFloat()),
            tilt = Tilt(cameraPosition.tilt.toFloat()),
            bearing = Bearing(cameraPosition.bearing),
        )
        val duration = Duration.ofMilliseconds(round(duration * 1000).toLong())
        val animationType = when (animationType) {
            CameraAnimationTypeMessage.DEFAULT_ -> CameraAnimationType.DEFAULT
            CameraAnimationTypeMessage.LINEAR -> CameraAnimationType.LINEAR
            CameraAnimationTypeMessage.SHOW_BOTH_POSITIONS -> CameraAnimationType.SHOW_BOTH_POSITIONS
        }

        val moveFuture = map.camera.move(cameraPosition, duration, animationType).apply {
            onResult {
                result.success(null)
            }
            onError { error ->
                result.error(error)
            }
        }
        this.closables.add(moveFuture)
    }

    override fun getCameraPosition(result: Messages.Result<CameraPositionMessage>?) {
        val map = map ?: kotlin.run {
            result?.error(IllegalArgumentException("Map has not been initialized"))
            return
        }

        result?.success(
            CameraPositionMessage
                .Builder()
                .setPoint(map.camera.position.point.toMessage())
                .setZoom(map.camera.position.zoom.value.toDouble())
                .setTilt(map.camera.position.tilt.value.toDouble())
                .setBearing(map.camera.position.bearing.value)
                .build()
        )
    }

    override fun calcPositionForMarkers(
        markers: List<String>,
        options: CalcPositionOptionsMessage,
        result: Messages.Result<CameraPositionMessage>?
    ) {
        objectTapHandler?.calcPositionForMarkers(markers, options, result)
    }

    override fun calcPositionForPolygons(
        polygons: List<String>,
        options: CalcPositionOptionsMessage,
        result: Messages.Result<CameraPositionMessage>?
    ) {
        objectTapHandler?.calcPositionForPolygons(polygons, options, result)
    }

    override fun calcPositionForPolylines(
        polylines: List<String>,
        options: CalcPositionOptionsMessage,
        result: Messages.Result<CameraPositionMessage>?
    ) {
        objectTapHandler?.calcPositionForPolylines(polylines, options, result)
    }

    override fun searchByObjectId(
        objectId: DgisObjectIdMessage,
        result: Messages.Result<DirectoryObjectMessage>?
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
            map = map,
            mapObjectManager =
                MapObjectManager.withGeneralization(
                    map = map,
                    logicalPixel = LogicalPixel(value = 40f),
                    maxZoom = Zoom(value = 18f)
                ),
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
            eventSink = eventSink,
            sdkContext = sdkContext,
            api = FlutterMapApi(binaryMessenger)
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
        categories: SearchCategoriesMessage?,
        weekTime: WeekTimeSearchMessage?,
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Long,
        result: Messages.Result<SearchResultMessage>?
    ) {
        searchHandler?.search(
            queryText = queryText,
            categories = categories?.categories?.flatMap {
                it.category.toRubrics()
            },
            searchGeoRect = searchRect?.toGeoRect(),
            weekTimeMessage = weekTime,
            sortingType = sortingType,
            pageSize = pageSize.toInt(),
            result = result
        )
    }

    override fun searchByQuery(
        query: SearchQueryMessage,
        weekTime: WeekTimeSearchMessage?,
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Long,
        result: Messages.Result<SearchResultMessage>?
    ) {
        searchHandler?.searchByQuery(
            queryId = query,
            searchGeoRect = searchRect?.toGeoRect(),
            weekTimeMessage = weekTime,
            sortingType = sortingType,
            pageSize = pageSize.toInt(),
            result = result
        )
    }

    override fun searchByCategory(
        category: SearchCategoryMessage,
        weekTime: WeekTimeSearchMessage?,
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Long,
        result: Messages.Result<SearchResultMessage>?
    ) {
        if (category == SearchCategoryMessage.PARKS) {
            searchHandler?.searchByParkCategory(
                searchGeoRect = searchRect?.toGeoRect(),
                weekTimeMessage = weekTime,
                sortingType = sortingType,
                pageSize = pageSize.toInt(),
                result = result
            )
            return
        }

        searchHandler?.searchByCategories(
            categories = category.toRubrics(),
            searchGeoRect = searchRect?.toGeoRect(),
            weekTimeMessage = weekTime,
            sortingType = sortingType,
            pageSize = pageSize.toInt(),
            result = result
        )
    }

    override fun fetchNextPage(pageId: PageIdMessage, result: Messages.Result<PageMessage>?) {
        searchHandler?.fetchNextPage(pageId, result)
    }

    override fun fetchPrevPage(pageId: PageIdMessage, result: Messages.Result<PageMessage>?) {
        searchHandler?.fetchPrevPage(pageId, result)
    }

    override fun releasePage(pageId: PageIdMessage, result: Messages.Result<Void>?) {
        searchHandler?.releasePage(pageId, result)
    }

    override fun fetchSuggests(
        queryText: String,
        searchRect: GeoRectMessage?,
        result: Messages.Result<SuggestResultMessage>?
    ) {
        searchHandler?.fetchSuggests(
            queryText = queryText,
            searchGeoRect = searchRect?.toGeoRect(),
            result = result
        )
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

    override fun addMarker(marker: MarkerMessage, manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.addMarker(marker, manager, result)
    }

    override fun addMarkers(markers: List<MarkerMessage>, manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.addMarkers(markers, manager, result)
    }

    override fun removeMarker(id: String, manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.removeMarker(id, manager, result)
    }

    override fun removeAllMarkers(manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.removeAllMarkers(manager)
        result?.success(null)
    }

    override fun createMapObjectManagerWithClustering(
        message: ClusteringMapObjectManagerOptionsMessage,
        result: Messages.Result<MapObjectManagerMessage>?
    ) {
        objectTapHandler?.createClusteringMapObjectManager(message, result)
    }

    override fun removeMapObjectManager(
        id: MapObjectManagerMessage,
        result: Messages.Result<Void>?
    ) {
        objectTapHandler?.removeMapObjectManager(id, result)
    }

    override fun setMapObjectManagerIsVisible(
        isVisible: Boolean,
        manager: MapObjectManagerMessage?,
        result: Messages.Result<Void>?
    ) {
        objectTapHandler?.setMapObjectManagerIsVisible(isVisible, manager)
        result?.success(null)
    }

    override fun setClusterIcon(id: String, icon: String, result: Messages.Result<Void>?) {
        objectTapHandler?.setClusterIcon(icon, id, result)
    }

    override fun releaseCluster(id: String, result: Messages.Result<Void>?) {
        objectTapHandler?.releaseCluster(id)
        result?.success(null)
    }

    override fun addPolygon(polygon: PolygonMessage, result: Messages.Result<Void>?) {
        objectTapHandler?.addPolygon(polygon, result)
    }

    override fun addPolygons(polygons: List<PolygonMessage>, result: Messages.Result<Void>?) {
        objectTapHandler?.addPolygons(polygons, result)
    }

    override fun removePolygon(id: String, result: Messages.Result<Void>?) {
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

    override fun removePolyline(id: String, result: Messages.Result<Void>?) {
        objectTapHandler?.removePolyline(id, result)
    }

    override fun removeAllPolylines(result: Messages.Result<Void>?) {
        objectTapHandler?.removeAllPolylines()
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

    override fun onLocationPremissionGranted(
        desiredAccuracy: DesiredAccuracyMessage,
        result: Messages.Result<Void>?
    ) {
        locationSource.onPermissionGranted()
        locationSource.setDesiredAccuracy(desiredAccuracy.toSdkAccuracy())
        result?.success(null)
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

    override fun contains(
        rect: GeoRectMessage,
        point: GeoPointMessage,
        result: Messages.Result<Boolean>?
    ) {
        result?.success(rect.toGeoRect().contains(point.toGeoPoint()))
    }

    override fun setPanoramaMarkerAzimuth(
        message: MarkerAzimuthMessage,
        result: Messages.Result<Void>?
    ) {
        objectTapHandler?.setPanoramasAzimuth(message.degree)
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
        objectTapHandler?.removeAllMarkers(null)
        result?.success(null)
    }

    override fun moveCameraToSelectedPanorama(result: Messages.Result<Void>?) {
        map?.let {
            objectTapHandler?.moveCameraToSelectedPanorama(it)
        }
        result?.success(null)
    }

    override fun setAppearance(appearance: MapAppearanceMessage, result: Messages.Result<Void>?) {
        when (appearance) {
            MapAppearanceMessage.DAY -> mapView.setTheme("day", "night")
            MapAppearanceMessage.NIGHT -> mapView.setTheme("day")
            MapAppearanceMessage.SYSTEM -> mapView.setTheme("night")
        }

        result?.success(null)
    }

    override fun setZoomRestrictions(min: Double?, max: Double?, result: Messages.Result<Void>?) {
        map?.let {map ->
            map.camera.zoomRestrictions = CameraZoomRestrictions(
                minZoom = min?.let {
                    Zoom(it.toFloat())
                } ?: Zoom(0f),
                maxZoom = max?.let {
                    Zoom(it.toFloat())
                } ?: Zoom(20f)
            )
        }
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
