package com.dgis.map

import android.content.Context
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
import ru.dgis.sdk.coordinates.bearing
import ru.dgis.sdk.directory.RubricId
import ru.dgis.sdk.directory.SearchManager
import ru.dgis.sdk.geometry.PolygonGeometry
import ru.dgis.sdk.map.*
import ru.dgis.sdk.platform.Locale
import ru.dgis.sdk.platform.getLocaleManager
import ru.dgis.sdk.routing.BriefRouteInfoSearchPoints
import ru.dgis.sdk.routing.RouteSearchPoint
import java.io.FileNotFoundException
import kotlin.math.round
import kotlin.math.roundToInt
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
    private var routeHandler: RouteHandler? = null
    private var weatherHandler: WeatherHandler? = null
    private val navigationManager = DgisMapInitializer.getNavigationManager()
    private val navigationHandler by unsafeLazy {
        NavigationHandler(
            sdkContext = sdkContext,
            navigationManager = navigationManager,
            eventSink = eventSink,
            map = map!!,
        )
    }
    private val packagesHandler by unsafeLazy {
        PackagesHandler(
            sdkContext = sdkContext,
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

    private val androidAutoHandler = AndroidAutoHandler(context, eventSink)

    private val closables = mutableListOf<AutoCloseable>()

    init {
        val messenger = ProxyBinaryMessenger(binaryMessenger, nameSuffix = "map_$id")
        MapApi.setUp(messenger, this)
    }

    override fun getView() = mapView

    override fun dispose() {
        map?.close()
        routeHandler?.close()
        zoomControlHandler?.close()
        locationControlHandler?.close()
        indoorControlHandler?.close()
        searchHandler?.close()
        visibleRectHandler?.close()
        compassControlHandler?.close()
        trafficAndParkingControlHandler?.close()
        packagesHandler.close()
        androidAutoHandler.close()
    }

    override fun initialize(result: Result<InitializeMessage>) {
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
    override fun zoomDown(type: ZoomControlMessage, result: VoidResult) {
        zoomControlHandler?.onZoomDown(type)
        result.success()
    }

    override fun zoomUp(type: ZoomControlMessage, result: VoidResult) {
        zoomControlHandler?.onZoomUp(type)

        result.success()
    }

    override fun toggleFollowState(result: VoidResult) {
        locationControlHandler?.toggleFollowState()

        result.success()
    }

    override fun followNavigation(result: VoidResult) {
        navigationHandler.followNavigation()

        result.success()
    }

    override fun selectIndoorLevel(index: Long, result: VoidResult) {
        indoorControlHandler?.selectIndoorLevel(index)

        result.success()
    }

    override fun moveCameraToActiveRoute(index: Long, result: VoidResult) {
        routeHandler?.moveCameraToActiveRoute(index)

        result.success()
    }

    override fun loadStyles(asset: String, result: VoidResult) {
        val styleAsset =
            FlutterInjector
                .instance()
                .flutterLoader()
                .getLookupKeyForAsset(asset)

        val builder = StyleBuilder(sdkContext)
        closables.add(builder.loadStyle(File.fromAsset(sdkContext, styleAsset)).apply {
            onResult {
                map?.style = it
                result.success()
            }
            onError {
                result.error(FileNotFoundException("Failed to load style Error: ${it.message}"))
            }
        })
    }

    override fun overrideLocales(locales: List<String>, result: VoidResult) {
        getLocaleManager(sdkContext).overrideLocales(
            locales.map {
                val parts = it.split("-")
                Locale(parts[0], parts[1])
            }
        )

        result.success()
    }

    override fun setCameraPosition(
        cameraPosition: CameraPositionMessage,
        result: VoidResult
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
        result.success()
    }

    override fun setCameraPositionPoint(
        cameraPosition: CameraPositionPointMessage,
        result: VoidResult
    ) {
        val map = map ?: kotlin.run {
            result.error(IllegalArgumentException("Map has not been initialized"))
            return
        }

        map.camera.positionPoint =
            CameraPositionPoint(x = cameraPosition.x.toFloat(), y = cameraPosition.y.toFloat())
        result.success()
    }

    override fun setCameraPadding(
        cameraPadding: CameraSetPaddingMessage,
        result: VoidResult
    ) {
        val map = map ?: kotlin.run {
            result.error(IllegalArgumentException("Map has not been initialized"))
            return
        }

        map.camera.padding = Padding(
            left = cameraPadding.leftPadding.toInt(),
            right = cameraPadding.rightPadding.toInt(),
            bottom = cameraPadding.bottomPadding.toInt(),
            top = cameraPadding.topPadding.toInt(),
        )
        result.success()
    }

    override fun setMapAttributeBool(name: String, value: Boolean, result: VoidResult) {
        map?.setAttribute(name, AttributeValue(value))
        result.success()
    }

    override fun setMapAttributeString(
        name: String,
        value: String,
        result: VoidResult
    ) {
        map?.setAttribute(name, AttributeValue(value))
        result.success()
    }

    override fun moveCamera(
        cameraPosition: CameraPositionMessage,
        duration: Double,
        animationType: CameraAnimationTypeMessage,
        result: VoidResult
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
                result.success()
            }
            onError { error ->
                result.error(error)
            }
        }
        this.closables.add(moveFuture)
    }

    override fun getCameraPosition(result: Result<CameraPositionMessage>) {
        val map = map ?: kotlin.run {
            result?.error(IllegalArgumentException("Map has not been initialized"))
            return
        }

        result.success(
            CameraPositionMessage
                .Builder()
                .setPoint(map.camera.position.point.toMessage())
                .setZoom(map.camera.position.zoom.value.toDouble())
                .setTilt(map.camera.position.tilt.value.toDouble())
                .setBearing(map.camera.position.bearing.value)
                .build()
        )
    }

    override fun getCameraVisibleArea(result: Result<PolygonGeometryMessage>) {
        val map = map ?: kotlin.run {
            result.error(IllegalArgumentException("Map has not been initialized"))
            return
        }

        val area = map.camera.visibleArea
        if (area is PolygonGeometry) {
            val polygonArea = area as PolygonGeometry
            val contours = polygonArea.contours.map { element -> element.map { e -> e.toMessage() } }
            result.success(
                PolygonGeometryMessage
                    .Builder()
                    .setContours(contours)
                    .build()
            )
        } else {
            result.error(IllegalArgumentException("Area is not PolygonGeometry"))
        }

    }

    override fun getNearestObjects(result: Result<List<RenderedObjectMessage>>) {
        objectTapHandler?.getNearestObjects(result)
    }
    override fun calcPositionForRoute(
        options: CalcPositionOptionsMessage,
        result: Result<CameraPositionMessage>
    ) {
        navigationHandler.calcPositionForRoute(options, result)
    }

    override fun calcPositionForMarkers(
        markers: List<String>,
        options: CalcPositionOptionsMessage,
        result: Result<CameraPositionMessage>
    ) {
        objectTapHandler?.calcPositionForMarkers(markers, options, result)
    }

    override fun calcPositionForPolygons(
        polygons: List<String>,
        options: CalcPositionOptionsMessage,
        result: Result<CameraPositionMessage>
    ) {
        objectTapHandler?.calcPositionForPolygons(polygons, options, result)
    }

    override fun calcPositionForPolylines(
        polylines: List<String>,
        options: CalcPositionOptionsMessage,
        result: Result<CameraPositionMessage>
    ) {
        objectTapHandler?.calcPositionForPolylines(polylines, options, result)
    }

    override fun searchByObjectId(
        objectId: DgisObjectIdMessage,
        result: Result<DirectoryObjectMessage>
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
                map = map,
                logicalPixel = LogicalPixel(value = 50f),
                maxZoom = Zoom(value = 18f)
            ),
            routeHandler = routeHandler,
            eventSink = eventSink,
            sdkContext = sdkContext,
            api = FlutterMapApi(binaryMessenger)
        )
        mapView.addObjectTappedCallback(objectTapHandler::objectTapListener)
        this.objectTapHandler = objectTapHandler
    }

    override fun getDistanceTo(
        points: List<DistanceRequestMessage>,
        result: Result<List<DistanceResponseMessage>>
    ) {
        searchHandler?.getDistanceTo(points, result)
    }

    override fun search(
        queryText: String,
        categories: SearchCategoriesMessage?,
        spatialRestriction: List<GeoPointMessage>?,
        weekTime: WeekTimeSearchMessage?,
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Long,
        result: Result<SearchResultMessage>
    ) {
        searchHandler?.search(
            queryText = queryText,
            categories = categories?.categories?.flatMap {
                it.category.toRubrics()
            },
            spatialRestriction = spatialRestriction?.map {
                it.toGeoPoint()
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
        spatialRestriction: List<GeoPointMessage>?,
        weekTime: WeekTimeSearchMessage?,
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Long,
        result: Result<SearchResultMessage>
    ) {
        searchHandler?.searchByQuery(
            queryId = query,
            spatialRestriction = spatialRestriction?.map {
                it.toGeoPoint()
            },
            searchGeoRect = searchRect?.toGeoRect(),
            weekTimeMessage = weekTime,
            sortingType = sortingType,
            pageSize = pageSize.toInt(),
            result = result
        )
    }

    override fun searchByCategory(
        category: SearchCategoryMessage,
        spatialRestriction: List<GeoPointMessage>?,
        weekTime: WeekTimeSearchMessage?,
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Long,
        result: Result<SearchResultMessage>
    ) {
        if (category == SearchCategoryMessage.PARKS) {
            searchHandler?.searchByParkCategory(
                searchGeoRect = searchRect?.toGeoRect(),
                spatialRestriction = spatialRestriction?.map {
                    it.toGeoPoint()
                },
                weekTimeMessage = weekTime,
                sortingType = sortingType,
                pageSize = pageSize.toInt(),
                result = result
            )
            return
        }

        if (category == SearchCategoryMessage.BEACHES) {
            searchHandler?.searchByBeachCategory(
                searchGeoRect = searchRect?.toGeoRect(),
                spatialRestriction = spatialRestriction?.map {
                    it.toGeoPoint()
                },
                weekTimeMessage = weekTime,
                sortingType = sortingType,
                pageSize = pageSize.toInt(),
                result = result
            )
            return
        }

        searchHandler?.searchByCategories(
            categories = category.toRubrics(),
            spatialRestriction = spatialRestriction?.map {
                it.toGeoPoint()
            },
            searchGeoRect = searchRect?.toGeoRect(),
            weekTimeMessage = weekTime,
            sortingType = sortingType,
            pageSize = pageSize.toInt(),
            result = result
        )
    }

    override fun searchByRubrics(
        rubrics: MutableList<Long>,
        spatialRestriction: MutableList<GeoPointMessage>?,
        weekTime: WeekTimeSearchMessage?,
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Long,
        result: Result<SearchResultMessage>
    ) {
        searchHandler?.searchByCategories(
            categories = rubrics.map { RubricId(it) },
            spatialRestriction = spatialRestriction?.map {
                it.toGeoPoint()
            },
            searchGeoRect = searchRect?.toGeoRect(),
            weekTimeMessage = weekTime,
            sortingType = sortingType,
            pageSize = pageSize.toInt(),
            result = result
        )
    }

    override fun fetchNextPage(pageId: PageIdMessage, result: Result<PageMessage>) {
        searchHandler?.fetchNextPage(pageId, result)
    }

    override fun fetchPrevPage(pageId: PageIdMessage, result: Result<PageMessage>) {
        searchHandler?.fetchPrevPage(pageId, result)
    }

    override fun releasePage(pageId: PageIdMessage, result: VoidResult) {
        searchHandler?.releasePage(pageId, result)
    }

    override fun fetchSuggests(
        queryText: String,
        allowedResultTypes: List<SuggestedTypeMessage_>?,
        searchRect: GeoRectMessage?,
        result: Result<SuggestResultMessage>
    ) {
        searchHandler?.fetchSuggests(
            queryText = queryText,
            allowedResultTypes = allowedResultTypes,
            searchGeoRect = searchRect?.toGeoRect(),
            result = result
        )
    }

    // --- MARKER ---
    override fun setMarkerOptions(
        options: MarkerOptionsMessageOld,
        result: VoidResult
    ) {
        objectTapHandler?.setMarkerOptions(
            svgAsset = options.svgAsset,
            size = Size(options.width.roundToInt(), options.height.roundToInt()),
            iconWidth = options.iconWidth,
            sdkContext = sdkContext,
            result = result
        )
    }

    override fun addMarker(
        marker: MarkerMessage,
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.addMarker(marker, manager?.id, result)
    }

    override fun addMarkers(
        markers: List<MarkerMessage>,
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.addMarkers(markers, manager?.id, result)
    }

    override fun removeMarker(
        id: String,
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.removeMarker(id, manager?.id, result)
    }

    override fun removeAllMarkers(
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.removeAllMarkers(manager?.id, result)
    }

    // --- MAP OBJECT ---
    override fun createMapObjectManagerWithClustering(
        message: ClusteringMapObjectManagerOptionsMessage,
        layerId: String?,
        result: Result<MapObjectManagerMessage>
    ) {
        objectTapHandler?.createClusteringMapObjectManager(message, layerId, result)
    }

    override fun createMapObjectManager(
        layerId: String?,
        result: Result<MapObjectManagerMessage>
    ) {
        objectTapHandler?.createMapObjectManager(layerId, result)
    }

    override fun removeMapObjectManager(
        manager: MapObjectManagerMessage,
        result: VoidResult
    ) {
        objectTapHandler?.removeMapObjectManager(manager, result)
    }

    override fun setMapObjectManagerIsVisible(
        isVisible: Boolean,
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.setMapObjectManagerIsVisible(isVisible, manager)
        result.success()
    }

    override fun setClusterIcon(id: String, icon: String, result: VoidResult) {
        objectTapHandler?.setClusterIcon(icon, id, result)
    }

    override fun releaseCluster(id: String, result: VoidResult) {
        objectTapHandler?.releaseCluster(id)
        result.success()
    }

    // --- POLYGON ---
    override fun addPolygon(
        polygon: PolygonMessage,
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.addPolygon(polygon, manager?.id, result)
    }

    override fun addPolygons(
        polygons: List<PolygonMessage>,
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.addPolygons(polygons, manager?.id, result)
    }

    override fun removePolygon(
        id: String,
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.removePolygon(id, manager?.id, result)
    }

    override fun removeAllPolygons(
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.removeAllPolygons(manager?.id, result)
    }

    // --- POLYLINE ---
    override fun addPolyline(
        polyline: PolylineMessage,
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.addPolyline(polyline, manager?.id, result)
    }

    override fun addPolylines(
        polylines: List<PolylineMessage>,
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.addPolylines(polylines, manager?.id, result)
    }

    override fun removePolyline(
        id: String,
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.removePolyline(id, manager?.id, result)
    }

    override fun removeAllPolylines(
        manager: MapObjectManagerMessage?,
        result: VoidResult
    ) {
        objectTapHandler?.removeAllPolylines(manager?.id, result)
    }

    override fun setRouteParams(
        params: RouteEditorRouteParamsMessage,
        result: VoidResult
    ) {
        routeHandler?.setRouteParams(params);
        result.success()
    }

    override fun hideRoutes(result: VoidResult) {
        routeHandler?.setRoutesVisible(false)
        result.success()
    }

    override fun showRoutes(result: VoidResult) {
        routeHandler?.setRoutesVisible(true)
        result.success()
    }

    override fun startNavigation(speedRangeZoom: SpeedRangeZoom, result: VoidResult) {
        val routeHandler = routeHandler ?: kotlin.run {
            result?.error(Exception("RouteHandler not initialized"))
            return
        }
        routeHandler.setRoutesVisible(false)
        navigationHandler.startNavigation(
            finishPoint = routeHandler.finishPoint,
            options = routeHandler.options,
            route = routeHandler.selectedRoute,
            speedRangeZoom = speedRangeZoom,
            result = result
        )
    }

    override fun startNavigationSimulation(
        speedRangeZoom: SpeedRangeZoom,
        result: VoidResult
    ) {
        val routeHandler = routeHandler ?: kotlin.run {
            result?.error(Exception("RouteHandler not initialized"))
            return
        }
        routeHandler.setRoutesVisible(false)
        navigationHandler.startSimulation(
            finishPoint = routeHandler.finishPoint,
            options = routeHandler.options,
            route = routeHandler.selectedRoute,
            speedRangeZoom = speedRangeZoom,
            result = result
        )
    }

    override fun simulationSpeed(speed: Double) {
        navigationHandler.simulationSettings(speed)
    }

    override fun saveNavigationState(result: Result<ByteArray>) {
        navigationHandler.saveNavigationState(result = result)
    }

    override fun getCurrentNavigationState(result: Result<NavigationStateMessage>) {
        navigationHandler.getCurrentNavigationState(result)
    }

    override fun restoreNavigationState(
        state: ByteArray,
        speedRangeZoom: SpeedRangeZoom,
        result: VoidResult
    ) {
        navigationHandler.restoreNavigationState(
            state = state,
            speedRangeZoom = speedRangeZoom,
            result = result
        )
    }

    override fun stopNavigation(result: VoidResult) {
        navigationHandler.stopNavigation()
        result.success()
    }

    override fun addPanoramasMarkers(
        message: AddMarkersWithPhotoMessage,
        result: VoidResult
    ) {
        objectTapHandler?.addPanoramasMarkers(message)
        result.success()
    }

    override fun showPanoramasMarkers(result: VoidResult) {
        objectTapHandler?.showPanoramasMarkers()
        result.success()
    }

    override fun hidePanoramasMarkers(result: VoidResult) {
        objectTapHandler?.hidePanoramasMarkers()
        result.success()
    }

    override fun removePanoramasMarkers(result: VoidResult) {
        objectTapHandler?.removePanoramasMarkers()
        result.success()
    }

    override fun setHighlighted(
        objectIds: List<DgisObjectIdMessage>,
        result: VoidResult
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

    override fun onLocationPermissionGranted(
        desiredAccuracy: DesiredAccuracyMessage,
        result: VoidResult
    ) {
        locationSource.onPermissionGranted()
        locationSource.setDesiredAccuracy(desiredAccuracy.toSdkAccuracy())
        result.success()
    }

    override fun overlappedBy(
        outerRect: GeoRectMessage,
        innerRect: GeoRectMessage,
        result: Result<Long>
    ) {
        val outer = outerRect.toGeoRect()

        val inner = innerRect.toGeoRect()

        val isOverlapped = if (outer.contains(inner)) 1L else 0
        result?.success(isOverlapped)
    }

    override fun contains(
        rect: GeoRectMessage,
        point: GeoPointMessage,
        result: Result<Boolean>
    ) {
        result?.success(rect.toGeoRect().contains(point.toGeoPoint()))
    }

    override fun containsRect(
        outer: GeoRectMessage,
        inner: GeoRectMessage,
        result: Result<Boolean>
    ) {
        result?.success(outer.toGeoRect().contains(inner.toGeoRect()))
    }

    override fun pointBearing(
        from: GeoPointMessage,
        to: GeoPointMessage,
        result: Result<Double>
    ) {
        result?.success(from.toGeoPoint().bearing(to.toGeoPoint()).value)
    }

    override fun setPanoramaMarkerAzimuth(
        message: MarkerAzimuthMessage,
        result: VoidResult
    ) {
        objectTapHandler?.setPanoramasAzimuth(message.degree)
        result.success()
    }

    override fun onCompassClicked(result: VoidResult) {
        compassControlHandler?.onClicked()
        result.success()
    }

    override fun onTrafficAndParkingAttached(result: VoidResult) {
        trafficAndParkingControlHandler?.onAttachToMap()
        result.success()
    }

    override fun onTrafficAndParkingDetached(result: VoidResult) {
        trafficAndParkingControlHandler?.onDetachFromMap()
        result.success()
    }

    override fun onParkingClicked(result: VoidResult) {
        trafficAndParkingControlHandler?.onParkingClicked()
        result.success()
    }

    override fun onTrafficClicked(result: VoidResult) {
        trafficAndParkingControlHandler?.onTrafficClicked()
        result.success()
    }

    override fun setPanoramasPaddings(
        message: CameraSetPaddingMessage,
        result: VoidResult
    ) {
        map?.let {
            objectTapHandler?.setPanoramasPadding(it, message)
        }
        result.success()
    }

    override fun unselectPanorama(result: VoidResult) {
        objectTapHandler?.unselectPanorama()
        result.success()
    }

    override fun showEsriIOLayer(
        message: Messages.AddLayerPointObjectsMessage,
        result: VoidResult
    ) {
        objectTapHandler?.addIoMarkers(message, result)
    }

    override fun removeEsriIOLayer(result: VoidResult) {
        objectTapHandler?.removeAllMarkers(null, result)
    }

    override fun moveCameraToSelectedPanorama(result: VoidResult) {
        map?.let {
            objectTapHandler?.moveCameraToSelectedPanorama(it)
        }
        result.success()
    }

    override fun setAppearance(appearance: MapAppearanceMessage, result: VoidResult) {
        when (appearance) {
            MapAppearanceMessage.DAY -> mapView.setTheme(MapTheme.defaultTheme)
            MapAppearanceMessage.NIGHT -> mapView.setTheme(MapTheme.defaultDarkTheme)
            MapAppearanceMessage.SYSTEM -> print("todo") // mapView.setTheme("day", "night")
        }

        result.success()
    }

    override fun setZoomRestrictions(min: Double?, max: Double?, result: VoidResult) {
        map?.let { map ->
            map.camera.zoomRestrictions = CameraZoomRestrictions(
                minZoom = min?.let {
                    Zoom(it.toFloat())
                } ?: Zoom(0f),
                maxZoom = max?.let {
                    Zoom(it.toFloat())
                } ?: Zoom(20f)
            )
        }
        result.success()
    }

    override fun setPublicTransportActiveRoute(routeIndex: Long, result: VoidResult) {
        routeHandler?.setActiveRouteIndex(routeIndex)
        result.success()
    }

    override fun startFreeRoam(speedRangeZoom: SpeedRangeZoom, result: VoidResult) {
        navigationHandler.startFreeRoam(speedRangeZoom = speedRangeZoom)
        result.success()
    }

    override fun stopFreeRoam(result: VoidResult) {
        navigationHandler.stopFreeRoam()
        result.success()
    }

    override fun toggleVoiceInstruction(
        toggleType: SoundToggleType,
        result: VoidResult
    ) {
        navigationHandler.toggleVoiceInstruction(toggleType)
        result.success()
    }

    override fun setNavigatorVolume(volume: Long, result: VoidResult) {
        navigationHandler.setNavigatorVolume(volume.toInt())
        result.success()
    }

    override fun toggleRoadCameras(roadCameras: Boolean, result: VoidResult) {
        navigationHandler.toggleRoadCameras(roadCameras)
        result.success()
    }

    override fun toggleOverSpeeding(overSpeeding: Boolean, result: VoidResult) {
        navigationHandler.toggleOverSpeeding(overSpeeding)
        result.success()
    }

    override fun muteOtherSounds(mute: Boolean, result: VoidResult) {
        navigationHandler.muteOtherSounds(mute)
        result.success()
    }

    private fun onMapReady(map: DgisMap, result: Result<InitializeMessage>) {
        map.graphicsPreset = GraphicsPreset.IMMERSIVE
        this.map = map

        val mapSource = MyLocationMapObjectSource(
            sdkContext,
            MyLocationControllerSettings(
                bearingSource = BearingSource.AUTO,
            ),
        )
        map.addSource(mapSource)

        routeHandler = RouteHandler(map, sdkContext, eventSink, locationSource, navigationHandler)
        zoomControlHandler = ZoomControlHandler(map, eventSink)
        locationControlHandler = LocationControlHandler(map, eventSink)
        indoorControlHandler = IndoorControlHandler(map, eventSink)
        visibleRectHandler = VisibleRectHandler(map, eventSink)
        searchHandler = SearchHandler(
            map,
            SearchManager.createOnlineManager(sdkContext),
            locationSource,
        )
        compassControlHandler = CompassControlHandler(map, eventSink)
        trafficAndParkingControlHandler =
            TrafficAndParkingControlHandler(sdkContext, map, eventSink)
        setupTapHandler()
        weatherHandler = WeatherHandler(sdkContext, map)
        result.success(
            InitializeMessage.Builder()
                .setWasInitialized(true)
                .setErrorDescription("")
                .build()
        )
    }

    override fun findBriefRouteInfos(
        routeSearchOptions: RouteSearchOptionsMessage,
        startPoint: RouteSearchPointMessage?,
        finishPoint: RouteSearchPointMessage?,
        result: Result<MutableList<BriefRouteInfoMessage>>
    ) {
        val searchOptions = routeSearchOptions.toRouteSearchOptions()

        val startSearchPoint = startPoint?.toRouteSearchPoint() ?: locationSource.lastLocation.let {
            return@let RouteSearchPoint(
                coordinates = GeoPoint(it?.latitude ?: .0, it?.longitude ?: .0),
                objectId = DgisObjectId(
                    objectId = 0,
                    entranceId = 0
                )
            )
        }
        val finishSearchPoint =
            finishPoint?.toRouteSearchPoint() ?: locationSource.lastLocation.let {
                return@let RouteSearchPoint(
                    coordinates = GeoPoint(it?.latitude ?: .0, it?.longitude ?: .0),
                    objectId = DgisObjectId(
                        objectId = 0,
                        entranceId = 0
                    )
                )
            }
        val briefRouteInfoSearchPoints = listOf(
            BriefRouteInfoSearchPoints(
                startPoint = startSearchPoint,
                finishPoint = finishSearchPoint
            )
        )
        routeHandler?.findBriefRouteInfos(
            routeSearchOptions = searchOptions,
            searchPoints = briefRouteInfoSearchPoints
        )?.apply {
            onResult { res ->
                val map = res.mapNotNull {
                    it?.toBriefRouteInfoMessage()
                }.toMutableList()

                result?.success(map)
            }
            onError { error ->
                result?.error(error)
            }
        }
    }

    override fun toggleHeatmap(message: WeatherMapMessage, result: Result<Boolean>) {
        weatherHandler?.toggleHeatmap(message, result)
    }

    override fun betterRouteResponse(
        response: BetterRouteResponseMessage,
        result: VoidResult
    ) {
        navigationHandler.betterRouteResponse(response)
        result.success()
    }

    override fun getBetterRouteSettings(result: Result<BetterRouteSettingsMessage>) {
        navigationHandler.getBetterRouteSettings(result)
    }

    override fun setBetterRouteSettings(
        message: BetterRouteSettingsMessage,
        result: VoidResult
    ) {
        navigationHandler.setBetterRouteSettings(message)
        result.success()
    }

    override fun listPackages(result: Result<List<PackageMessage>>) {
        packagesHandler.listPackages(result)
    }

    override fun installPackage(id: String, result: VoidResult) {
        packagesHandler.installPackage(id, result)
    }

    override fun listVoices(result: Result<List<VoiceMessage>>) {
        packagesHandler.listVoices(result)
    }

    override fun voicePlayWelcome(id: String, result: VoidResult) {
        packagesHandler.voicePlayWelcome(id, result)
    }

    override fun installVoice(id: String, result: VoidResult) {
        packagesHandler.installVoice(id, result)
    }

    override fun setNavigatorVoice(id: String, result: VoidResult) {
        navigationHandler.setNavigatorVoice(id, result)
    }
}
