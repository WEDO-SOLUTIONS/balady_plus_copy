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
import ru.dgis.sdk.map.*
import ru.dgis.sdk.platform.Locale
import ru.dgis.sdk.platform.LocaleManager
import ru.dgis.sdk.platform.getLocaleManager
import ru.dgis.sdk.routing.BriefRouteInfoSearchPoints
import ru.dgis.sdk.routing.RouteSearchPoint
import java.io.FileNotFoundException
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
    private var routeHandler: RouteHandler? = null
    private var weatherHandler: WeatherHandler? = null
    private val navigationHandler by unsafeLazy {
        NavigationHandler(
            sdkContext = sdkContext,
            navigationView = mapView.findViewById(R.id.navigationView),
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

    private val closables = mutableListOf<AutoCloseable>()

    init {
        val messenger = ProxyBinaryMessenger(binaryMessenger, nameSuffix = "map_$id")
        MapApi.setup(messenger, this)
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
        packagesHandler?.close()
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

    override fun toggleFollowState(result: Messages.Result<Void>?) {
        locationControlHandler?.toggleFollowState()

        result?.success(null)
    }

    override fun followNavigation(result: Messages.Result<Void>?) {
        navigationHandler.followNavigation()

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
        getLocaleManager(sdkContext).overrideLocales(
            locales.map {
                val parts = it.split("-")
                Locale(parts[0], parts[1])
            }
        )

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

    override fun setCameraPositionPoint(
            cameraPosition: CameraPositionPointMessage,
            result: Messages.Result<Void>
    ) {
        val map = map ?: kotlin.run {
            result.error(IllegalArgumentException("Map has not been initialized"))
            return
        }

        map.camera.positionPoint = CameraPositionPoint(x = cameraPosition.x.toFloat(), y = cameraPosition.y.toFloat())
        result.success(null)
    }

    override fun setCameraPadding(
            cameraPadding: CameraSetPaddingMessage,
            result: Messages.Result<Void>
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
        result.success(null)
    }

    override fun setMapAttributeBool(name: String, value: Boolean, result: Messages.Result<Void>?) {
        map?.setAttribute(name, AttributeValue(value))
        result?.success(null)
    }

    override fun setMapAttributeString(name: String, value: String, result: Messages.Result<Void>?) {
        map?.setAttribute(name, AttributeValue(value))
        result?.success(null)
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

    override fun getNearestObjects(result: Messages.Result<List<RenderedObjectMessage>>) {
        objectTapHandler?.getNearestObjects(result)
    }

    override fun calcPositionForRoute(options: CalcPositionOptionsMessage, result: Messages.Result<CameraPositionMessage>?) {
        navigationHandler.calcPositionForRoute(options, result)
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
            result: Messages.Result<List<DistanceResponseMessage>>?
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
            result: Messages.Result<SearchResultMessage>?
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
            result: Messages.Result<SearchResultMessage>?
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
            result: Messages.Result<SearchResultMessage>?
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

    override fun searchByRubrics(rubrics: MutableList<Long>, spatialRestriction: MutableList<GeoPointMessage>?, weekTime: WeekTimeSearchMessage?, searchRect: GeoRectMessage?, sortingType: SortingTypeMessage, pageSize: Long, result: Messages.Result<SearchResultMessage>?) {
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
            allowedResultTypes: List<SuggestedTypeMessage_>?,
            searchRect: GeoRectMessage?,
            result: Messages.Result<SuggestResultMessage>?
    ) {
        searchHandler?.fetchSuggests(
                queryText = queryText,
                allowedResultTypes = allowedResultTypes,
                searchGeoRect = searchRect?.toGeoRect(),
                result = result
        )
    }
    // --- MARKER ---
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
        objectTapHandler?.addMarker(marker, manager?.id, result)
    }

    override fun addMarkers(markers: List<MarkerMessage>, manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.addMarkers(markers, manager?.id, result)
    }

    override fun removeMarker(id: String, manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.removeMarker(id, manager?.id, result)
    }

    override fun removeAllMarkers(manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.removeAllMarkers(manager?.id, result)
    }
    // --- MAP OBJECT ---
    override fun createMapObjectManagerWithClustering(
            message: ClusteringMapObjectManagerOptionsMessage,
            layerId: String?,
            result: Messages.Result<MapObjectManagerMessage>?
    ) {
        objectTapHandler?.createClusteringMapObjectManager(message, layerId, result)
    }

    override fun createMapObjectManager(
        layerId: String?,
        result: Messages.Result<MapObjectManagerMessage>?
    ) {
        objectTapHandler?.createMapObjectManager(layerId, result)
    }

    override fun removeMapObjectManager(
            manager: MapObjectManagerMessage,
            result: Messages.Result<Void>?
    ) {
        objectTapHandler?.removeMapObjectManager(manager, result)
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
    // --- POLYGON ---
    override fun addPolygon(polygon: PolygonMessage, manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.addPolygon(polygon, manager?.id, result)
    }

    override fun addPolygons(polygons: List<PolygonMessage>, manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.addPolygons(polygons,manager?.id, result)
    }

    override fun removePolygon(id: String,manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.removePolygon(id, manager?.id, result)
    }

    override fun removeAllPolygons(manager: MapObjectManagerMessage?,result: Messages.Result<Void>?) {
        objectTapHandler?.removeAllPolygons(manager?.id, result)
    }
    // --- POLYLINE ---
    override fun addPolyline(polyline: PolylineMessage,manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.addPolyline(polyline, manager?.id, result)
    }

    override fun addPolylines(polylines: List<PolylineMessage>,manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.addPolylines(polylines, manager?.id, result)
    }

    override fun removePolyline(id: String,manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.removePolyline(id, manager?.id, result)
    }

    override fun removeAllPolylines(manager: MapObjectManagerMessage?, result: Messages.Result<Void>?) {
        objectTapHandler?.removeAllPolylines(manager?.id, result)
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

    override fun showRoutes(result: Messages.Result<Void>?) {
        routeHandler?.setRoutesVisible(true)
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

    override fun containsRect(outer: GeoRectMessage, inner: GeoRectMessage, result: Messages.Result<Boolean>?) {
        result?.success(outer.toGeoRect().contains(inner.toGeoRect()))
    }

    override fun pointBearing(from: GeoPointMessage, to: GeoPointMessage, result: Messages.Result<Double>?) {
        result?.success(from.toGeoPoint().bearing(to.toGeoPoint()).value)
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

    override fun showEsriIOLayer(message: Messages.AddLayerPointObjectsMessage, result: Messages.Result<Void>?) {
        objectTapHandler?.addIoMarkers(message, result)
    }

    override fun removeEsriIOLayer(result: Messages.Result<Void>?) {
        objectTapHandler?.removeAllMarkers(null, result)
    }

    override fun moveCameraToSelectedPanorama(result: Messages.Result<Void>?) {
        map?.let {
            objectTapHandler?.moveCameraToSelectedPanorama(it)
        }
        result?.success(null)
    }

    override fun setAppearance(appearance: MapAppearanceMessage, result: Messages.Result<Void>?) {
        when (appearance) {
            MapAppearanceMessage.DAY -> mapView.setTheme(MapTheme.defaultTheme)
            MapAppearanceMessage.NIGHT -> mapView.setTheme(MapTheme.defaultDarkTheme)
            MapAppearanceMessage.SYSTEM -> print("todo") // mapView.setTheme("day", "night")
        }

        result?.success(null)
    }

    override fun setZoomRestrictions(min: Double?, max: Double?, result: Messages.Result<Void>?) {
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

    override fun toggleSound(enabled: Boolean, result: Messages.Result<Void>?) {
        navigationHandler.toggleSounds(enabled)
        result?.success(null)
    }

    private fun onMapReady(map: DgisMap, result: ApiResult<InitializeMessage>) {
        this.map = map

        val mapSource = MyLocationMapObjectSource(
            sdkContext,
            MyLocationController(
                bearingSource = BearingSource.AUTO,
            )
        )
        map.addSource(mapSource)

        routeHandler = RouteHandler(map, sdkContext, eventSink, locationSource, navigationHandler)
        zoomControlHandler = ZoomControlHandler(map, eventSink)
        locationControlHandler = LocationControlHandler(map, eventSink)
        indoorControlHandler = IndoorControlHandler(map, eventSink)
        visibleRectHandler = VisibleRectHandler(map, eventSink)
        searchHandler = SearchHandler(
            map,
            sdkContext,
            SearchManager.createOnlineManager(sdkContext),
            locationSource,
            DgisMapPlugin.vendorConfig,
        )
        compassControlHandler = CompassControlHandler(map, eventSink)
        trafficAndParkingControlHandler = TrafficAndParkingControlHandler(sdkContext, map, eventSink)
        setupTapHandler()
        weatherHandler = WeatherHandler(sdkContext,map)
        result.success(
                InitializeMessage.Builder()
                        .setWasInitialized(true)
                        .setErrorDescription("")
                        .build()
        )
    }

    override fun findBriefRouteInfos(routeSearchOptions: RouteSearchOptionsMessage,
                                     startPoint: RouteSearchPointMessage?,
                                     finishPoint: RouteSearchPointMessage?,
                                     result: Messages.Result<MutableList<BriefRouteInfoMessage>>?) {
        val searchOptions = routeSearchOptions.toRouteSearchOptions()

        val startSearchPoint = startPoint?.toRouteSearchPoint() ?: locationSource.lastLocation.let {
            return@let RouteSearchPoint(
                    coordinates = GeoPoint(it?.latitude ?: .0, it?.longitude ?: .0),
                    objectId = DgisObjectId(
                            objectId = 0,
                            entranceId = 0))
        }
        val finishSearchPoint = finishPoint?.toRouteSearchPoint()  ?: locationSource.lastLocation.let {
            return@let RouteSearchPoint(
                    coordinates = GeoPoint(it?.latitude ?: .0, it?.longitude ?: .0),
                    objectId = DgisObjectId(
                            objectId = 0,
                            entranceId = 0))
        }
        val briefRouteInfoSearchPoints = listOf(BriefRouteInfoSearchPoints(
                startPoint = startSearchPoint,
                finishPoint = finishSearchPoint))
        routeHandler?.findBriefRouteInfos(
                routeSearchOptions = searchOptions,
                searchPoints = briefRouteInfoSearchPoints)?.apply {
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

    override fun toggleHeatmap(message: WeatherMapMessage, result: Messages.Result<Boolean>?) {
        weatherHandler?.toggleHeatmap(message,result)
    }

    override fun betterRouteResponse(response: BetterRouteResponseMessage, result: Messages.Result<Void>?) {
        navigationHandler.betterRouteResponse(response)
        result?.success(null)
    }

    override fun getBetterRouteSettings(result: Messages.Result<BetterRouteSettingsMessage>?) {
        navigationHandler.getBetterRouteSettings(result)
    }

    override fun setBetterRouteSettings(
        message: BetterRouteSettingsMessage,
        result: Messages.Result<Void>?
    ) {
        navigationHandler.setBetterRouteSettings(message)
        result?.success(null)
    }

    override fun listPackages(result: Messages.Result<List<PackageMessage>>?) {
        packagesHandler.listPackages(result)
    }

    override fun installPackage(id: String, result: Messages.Result<Void>?) {
        packagesHandler.installPackage(id, result)
    }

    override fun listVoices(result: Messages.Result<List<PackageMessage>>?) {
        packagesHandler.listVoices(result)
    }

    override fun installVoice(id: String, result: Messages.Result<Void>?) {
        packagesHandler.installVoice(id, result)
    }

    override fun setNavigatorVoice(id: String, result: Messages.Result<Void>?) {
        navigationHandler.setNavigatorVoice(id, result)
    }
}
