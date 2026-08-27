package com.dgis.map

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.widget.FrameLayout
import com.dgis.map.control_handlers.*
import com.dgis.map.extensions.*
import com.dgis.map.map_api.*
import android.util.Log
import io.flutter.FlutterInjector
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.platform.PlatformView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import java.io.FileNotFoundException
import kotlin.math.round
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.Duration
import ru.dgis.sdk.File
import ru.dgis.sdk.LevelId
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.bearing
import ru.dgis.sdk.directory.DirectoryObject
import ru.dgis.sdk.directory.RubricId
import ru.dgis.sdk.directory.SearchHistory
import ru.dgis.sdk.directory.SearchManager
import ru.dgis.sdk.geometry.PolygonGeometry
import ru.dgis.sdk.map.*
import ru.dgis.sdk.map.Map as DgisMap
import ru.dgis.sdk.platform.Locale
import ru.dgis.sdk.platform.getLocaleManager
import ru.dgis.sdk.routing.BriefRouteInfoSearchPoints
import ru.dgis.sdk.routing.RouteSearchOptions
import ru.dgis.sdk.routing.RouteSearchPoint

class DgisMapView(
        private val sdkContext: ru.dgis.sdk.Context,
        private val binaryMessenger: BinaryMessenger,
        private val id: Int,
        private val context: Context,
        private val locationSource: FusedLocationSource,
) : PlatformView, MapApi {

    private val mapView: MapView =
            LayoutInflater.from(context).inflate(R.layout.map_view_layout, null) as MapView

    // BALADY-3755: the map is hosted in a container we own so the MapView can
    // be re-attached to the window after the app returns from background.
    // When Android drops the GL surface while the app is backgrounded, the
    // SDK's renderer sometimes comes back in a state where the camera,
    // markers and polylines still draw but the vector tile layers never do
    // (map background + markers only). Re-adding the view forces a full
    // surfaceDestroyed/surfaceCreated cycle which re-initializes tile
    // rendering while preserving the Map object (camera, sources, layers).
    private val container: FrameLayout = FrameLayout(context).also { it.addView(mapView) }

    private var stoppedWhileInBackground = false
    private val lifecycleCallbacks = object : Application.ActivityLifecycleCallbacks {
        override fun onActivityStopped(activity: Activity) {
            stoppedWhileInBackground = true
        }

        override fun onActivityResumed(activity: Activity) {
            if (!stoppedWhileInBackground) {
                return
            }
            stoppedWhileInBackground = false
            container.post {
                if (mapView.parent === container) {
                    container.removeView(mapView)
                    container.addView(mapView)
                }
            }
        }

        override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) = Unit
        override fun onActivityStarted(activity: Activity) = Unit
        override fun onActivityPaused(activity: Activity) = Unit
        override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) = Unit
        override fun onActivityDestroyed(activity: Activity) = Unit
    }

    private var map: DgisMap? = null

    private var zoomControlHandler: ZoomControlHandler? = null
    private var locationControlHandler: LocationControlHandler? = null
    private var indoorControlHandler: IndoorControlHandler? = null
    private var objectTapHandler: ObjectTapHandler? = null
    private var visibleRectHandler: VisibleRectHandler? = null
    private var searchHandler: SearchHandler? = null
    private var routeHandler: RouteHandler? = null
    private var weatherHandler: WeatherHandler? = null
    private var satelliteHandler: SatelliteHandler? = null
    private val navigationManager = DgisMapInitializer.getNavigationManager().also { navManager ->
        // Apply persisted sound setting immediately, before any navigation starts.
        // The SDK enables all sound categories by default. We read from Flutter's
        // SharedPreferences and default to OFF if the key is not set.
        val flutterPrefs = context.getSharedPreferences("FlutterSharedPreferences", android.content.Context.MODE_PRIVATE)
        val key = "flutter.voice_instruction_index"
        val voiceIndex = if (flutterPrefs.contains(key)) flutterPrefs.getLong(key, 0).toInt() else 0
        if (voiceIndex == 0) {
            navManager.soundNotificationSettings.enabledSoundCategories =
                java.util.EnumSet.noneOf(ru.dgis.sdk.navigation.SoundCategory::class.java)
        }
    }
    private val navigationHandlerLazy = unsafeLazy {
        NavigationHandler(
                sdkContext = sdkContext,
                navigationManager = navigationManager,
                eventSink = eventSink,
                map = map!!,
                appContext = context,
        )
    }
    private val navigationHandler by navigationHandlerLazy
    private val packagesHandler by unsafeLazy {
        PackagesHandler(
                sdkContext = sdkContext,
                eventSink = eventSink,
        )
    }
    private var compassControlHandler: CompassControlHandler? = null
    private var trafficAndParkingControlHandler: TrafficAndParkingControlHandler? = null

    /** Event stream to Flutter */
    private lateinit var eventChannel: EventChannel
    private val eventSink = QueuingEventSink()
    private val eventStreamHandler = DgisStreamHandler(eventSink)

    private val androidAutoHandler = AndroidAutoHandler(context, eventSink)

    private val closables = mutableListOf<AutoCloseable>()

    private var soundUpdateJob: kotlinx.coroutines.Job? = null

    private fun getCurrentLevelId(): LevelId? {
        return indoorControlHandler?.currentLevelId
    }

    init {
        val messenger = ProxyBinaryMessenger(binaryMessenger, nameSuffix = "map_$id")
        MapApi.setUp(messenger, this)

        // BALADY-3755: watch for background -> foreground transitions.
        (context.applicationContext as? Application)
                ?.registerActivityLifecycleCallbacks(lifecycleCallbacks)

        // Listen for sound changes from Android Auto and forward them to Flutter
        soundUpdateJob = CoroutineScope(Dispatchers.Main).launch {
            for (toggleType in SoundUpdateNotifier.events) {
                val isSoundOn = toggleType != SoundToggleType.NONE
                eventSink.success(
                    mapOf(
                        "event" to "soundOnEvent",
                        "value" to isSoundOn,
                    )
                )
            }
        }
    }

    override fun getView() = container

    override fun dispose() {
        (context.applicationContext as? Application)
                ?.unregisterActivityLifecycleCallbacks(lifecycleCallbacks)
        soundUpdateJob?.cancel()
        // The navigation handler subscribes to the shared NavigationManager's channels;
        // it must be closed before the map, otherwise a late state event (e.g. FINISHED)
        // touches the already-closed map and crashes with "Access to closed Java object".
        if (navigationHandlerLazy.isInitialized()) {
            navigationHandler.close()
        }
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

    override fun initialize(callback: (Result<InitializeMessage>) -> Unit) {
        try {
            // Setup channel to handle call from Flutter
            eventChannel = EventChannel(binaryMessenger, "com.dgis.map_view_events_$id")
            eventChannel.setStreamHandler(eventStreamHandler)
            mapView.getMapAsync { map -> onMapReady(map, callback) }
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }
    override fun zoomDown(type: ZoomControlMessage, callback: (Result<Unit>) -> Unit) {
        zoomControlHandler?.onZoomDown(type)
        callback(Result.success(Unit))
    }

    override fun zoomUp(type: ZoomControlMessage, callback: (Result<Unit>) -> Unit) {
        zoomControlHandler?.onZoomUp(type)

        callback(Result.success(Unit))
    }

    override fun toggleFollowState(callback: (Result<Unit>) -> Unit) {
        locationControlHandler?.toggleFollowState()

        callback(Result.success(Unit))
    }

    override fun followNavigation(callback: (Result<Unit>) -> Unit) {
        navigationHandler.followNavigation()

        callback(Result.success(Unit))
    }

    override fun startFollowNavigation(callback: (Result<Unit>) -> Unit) {
        navigationHandler.startFollowNavigation()

        callback(Result.success(Unit))
    }

    override fun stopFollowNavigation(callback: (Result<Unit>) -> Unit) {
        navigationHandler.stopFollowNavigation()

        callback(Result.success(Unit))
    }

    override fun selectIndoorLevel(index: Long, callback: (Result<Unit>) -> Unit) {
        indoorControlHandler?.selectIndoorLevel(index)

        callback(Result.success(Unit))
    }

    override fun setIndoorFloorPlansEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        val handler = indoorControlHandler
        if (handler != null) {
            handler.setIndoorFloorPlansEnabled(enabled)
        } else {
            map?.indoorManager?.setIndoorState(
                if (enabled) IndoorManagerState.ENABLED else IndoorManagerState.DISABLED
            )
        }

        callback(Result.success(Unit))
    }

    override fun moveCameraToActiveRoute(index: Long, callback: (Result<Unit>) -> Unit) {
        routeHandler?.moveCameraToActiveRoute(index)

        callback(Result.success(Unit))
    }

    override fun setActiveRouteIndex(index: Long, callback: (Result<Unit>) -> Unit) {
        routeHandler?.setActiveRouteIndex(index)

        callback(Result.success(Unit))
    }

    override fun loadStyles(asset: String, callback: (Result<Unit>) -> Unit) {
        val styleAsset = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(asset)

        val builder = StyleBuilder(sdkContext)
        closables.add(
                builder.loadStyle(File.fromAsset(sdkContext, styleAsset)).apply {
                    onResult {
                        map?.style = it
                        callback(Result.success(Unit))
                    }
                    onError {
                        callback(
                                Result.failure(
                                        FileNotFoundException(
                                                "Failed to load style Error: ${it.message}"
                                        )
                                )
                        )
                    }
                }
        )
    }

    override fun overrideLocales(locales: List<String>, callback: (Result<Unit>) -> Unit) {
        getLocaleManager(sdkContext)
                .overrideLocales(
                        locales.map {
                            val parts = it.split("-")
                            Locale(parts[0], parts[1])
                        }
                )

        callback(Result.success(Unit))
    }

    override fun setCameraPosition(
            cameraPosition: CameraPositionMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        val map =
                map
                        ?: kotlin.run {
                            callback(
                                    Result.failure(
                                            IllegalArgumentException("Map has not been initialized")
                                    )
                            )
                            return
                        }

        map.camera.position =
                map.camera.position.copy(
                        point = cameraPosition.point.toGeoPoint(),
                        zoom = Zoom(cameraPosition.zoom.toFloat()),
                        tilt = Tilt(cameraPosition.tilt.toFloat()),
                        bearing = Bearing(cameraPosition.bearing)
                )
        callback(Result.success(Unit))
    }

    override fun setCameraPositionPoint(
            cameraPosition: CameraPositionPointMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        val map =
                map
                        ?: kotlin.run {
                            callback(
                                    Result.failure(
                                            IllegalArgumentException("Map has not been initialized")
                                    )
                            )
                            return
                        }

        map.camera.positionPoint =
                CameraPositionPoint(x = cameraPosition.x.toFloat(), y = cameraPosition.y.toFloat())
        callback(Result.success(Unit))
    }

    override fun setCameraPadding(
            cameraPadding: CameraSetPaddingMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        val map =
                map
                        ?: kotlin.run {
                            callback(
                                    Result.failure(
                                            IllegalArgumentException("Map has not been initialized")
                                    )
                            )
                            return
                        }

        map.camera.padding =
                Padding(
                        left = cameraPadding.leftPadding.toInt(),
                        right = cameraPadding.rightPadding.toInt(),
                        bottom = cameraPadding.bottomPadding.toInt(),
                        top = cameraPadding.topPadding.toInt(),
                )
        callback(Result.success(Unit))
    }

    override fun setMapAttributeBool(
            name: String,
            value: Boolean,
            callback: (Result<Unit>) -> Unit
    ) {
        map?.setAttribute(name, AttributeValue(value))
        callback(Result.success(Unit))
    }

    override fun setMapAttributeString(
            name: String,
            value: String,
            callback: (Result<Unit>) -> Unit
    ) {
        map?.setAttribute(name, AttributeValue(value))
        callback(Result.success(Unit))
    }

    override fun moveCamera(
            cameraPosition: CameraPositionMessage,
            duration: Double,
            animationType: CameraAnimationTypeMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        val cameraPosition =
                CameraPosition(
                        point = cameraPosition.point.toGeoPoint(),
                        zoom = Zoom(cameraPosition.zoom.toFloat()),
                        tilt = Tilt(cameraPosition.tilt.toFloat()),
                        bearing = Bearing(cameraPosition.bearing),
                )
        val duration = Duration.ofMilliseconds(round(duration * 1000).toLong())
        val animationType =
                when (animationType) {
                    CameraAnimationTypeMessage.DEFAULT_TYPE -> CameraAnimationType.DEFAULT
                    CameraAnimationTypeMessage.LINEAR -> CameraAnimationType.LINEAR
                    CameraAnimationTypeMessage.SHOW_BOTH_POSITIONS ->
                            CameraAnimationType.SHOW_BOTH_POSITIONS
                }

        moveCameraNative(cameraPosition, duration, animationType, callback)
    }

    private fun moveCameraNative(
            cameraPosition: CameraPosition,
            duration: Duration,
            animationType: CameraAnimationType,
            callback: (Result<Unit>) -> Unit
    ) {
        val map =
                map
                        ?: kotlin.run {
                            callback(
                                    Result.failure(
                                            IllegalArgumentException("Map has not been initialized")
                                    )
                            )
                            return
                        }
        val moveFuture =
                map.camera.move(cameraPosition, duration, animationType).apply {
                    onResult { callback(Result.success(Unit)) }
                    onError { error -> callback(Result.failure(error)) }
                }
        this.closables.add(moveFuture)
    }

    override fun getCameraPosition(callback: (Result<CameraPositionMessage>) -> Unit) {
        val map =
                map
                        ?: kotlin.run {
                            callback(
                                    Result.failure(
                                            IllegalArgumentException("Map has not been initialized")
                                    )
                            )
                            return
                        }

        callback(
                Result.success(
                        CameraPositionMessage(
                                point = map.camera.position.point.toMessage(),
                                zoom = map.camera.position.zoom.value.toDouble(),
                                tilt = map.camera.position.tilt.value.toDouble(),
                                bearing = map.camera.position.bearing.value
                        )
                )
        )
    }

    override fun getCameraVisibleArea(callback: (Result<PolygonGeometryMessage>) -> Unit) {
        val map =
                map
                        ?: kotlin.run {
                            callback(
                                    Result.failure(
                                            IllegalArgumentException("Map has not been initialized")
                                    )
                            )
                            return
                        }

        val area = map.camera.visibleArea
        if (area is PolygonGeometry) {
            val polygonArea = area as PolygonGeometry
            val contours =
                    polygonArea.contours.map { element -> element.map { e -> e.toMessage() } }
            callback(Result.success(PolygonGeometryMessage(contours = contours)))
        } else {
            callback(Result.failure(IllegalArgumentException("Area is not PolygonGeometry")))
        }
    }

    override fun getNearestObjects(callback: (Result<List<RenderedObjectMessage>>) -> Unit) {
        objectTapHandler?.getNearestObjects(callback)
    }
    override fun calcPositionForRoute(
            options: CalcPositionOptionsMessage,
            callback: (Result<CameraPositionMessage>) -> Unit
    ) {
        navigationHandler.calcPositionForRoute(options, callback)
    }

    override fun calcPositionForMarkers(
            markers: List<String>,
            options: CalcPositionOptionsMessage,
            callback: (Result<CameraPositionMessage>) -> Unit
    ) {
        objectTapHandler?.calcPositionForMarkers(markers, options, callback)
    }

    override fun calcPositionForPolygons(
            polygons: List<String>,
            options: CalcPositionOptionsMessage,
            callback: (Result<CameraPositionMessage>) -> Unit
    ) {
        objectTapHandler?.calcPositionForPolygons(polygons, options, callback)
    }

    override fun calcPositionForPolylines(
            polylines: List<String>,
            options: CalcPositionOptionsMessage,
            callback: (Result<CameraPositionMessage>) -> Unit
    ) {
        objectTapHandler?.calcPositionForPolylines(polylines, options, callback)
    }

    override fun calcPositionForGeoPoints(
            points: List<GeoPointMessage>,
            options: CalcPositionOptionsMessage,
            callback: (Result<CameraPositionMessage>) -> Unit
    ) {
        objectTapHandler?.calcPositionForGeoPoints(points, options, callback)
    }

    override fun animateToRepresentativeArea(
            area: GeometryMessage,
            options: CalcPositionOptionsMessage,
            duration: Double,
            animationType: CameraAnimationTypeMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.calcPositionForPoints(area, options) { positionResult ->
            positionResult.fold(
                    onSuccess = { cameraPosition ->
                        val duration = Duration.ofMilliseconds(round(duration * 1000).toLong())
                        val animationType =
                                when (animationType) {
                                    CameraAnimationTypeMessage.DEFAULT_TYPE ->
                                            CameraAnimationType.DEFAULT
                                    CameraAnimationTypeMessage.LINEAR -> CameraAnimationType.LINEAR
                                    CameraAnimationTypeMessage.SHOW_BOTH_POSITIONS ->
                                            CameraAnimationType.SHOW_BOTH_POSITIONS
                                }
                        // If we successfully got the CameraPosition, move the camera
                        moveCameraNative(cameraPosition, duration, animationType, callback)
                    },
                    onFailure = { error ->
                        // If calcPositionForPoints failed, propagate the error immediately
                        callback(Result.failure(error))
                    }
            )
        }
    }

    override fun searchByObjectId(
            objectId: DgisObjectIdMessage,
            callback: (Result<DirectoryObjectMessage>) -> Unit
    ) {
        searchHandler?.searchByDirectoryObjectId(
                DgisObjectId(objectId = objectId.objectId, entranceId = objectId.entranceId),
                callback,
        )
    }

    private fun setupTapHandler() {
        val map = map ?: return

        val objectTapHandler =
                ObjectTapHandler(
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
                        androidContext = context,
                        api = FlutterMapApi(binaryMessenger)
                )
        mapView.addObjectTappedCallback(objectTapHandler::objectTapListener)
        mapView.addObjectLongTouchCallback(objectTapHandler::objectLongTapListener)
        this.objectTapHandler = objectTapHandler
    }

    override fun getDistanceTo(
            points: List<DistanceRequestMessage>,
            callback: (Result<List<DistanceResponseMessage>>) -> Unit
    ) {
        searchHandler?.getDistanceTo(points, callback)
    }

    override fun search(
            queryText: String,
            rubrics: List<Long>?,
            spatialRestriction: List<GeoPointMessage>?,
            weekTime: WeekTimeSearchMessage?,
            searchRect: GeoRectMessage?,
            sortingType: SortingTypeMessage,
            pageSize: Long,
            locale: String?,
            callback: (Result<SearchResultMessage>) -> Unit
    ) {
        searchHandler?.search(
                queryText = queryText,
                rubricIds = rubrics?.map { RubricId(it) },
                spatialRestriction = spatialRestriction?.map { it.toGeoPoint() },
                searchGeoRect = searchRect?.toGeoRect(),
                weekTimeMessage = weekTime,
                sortingType = sortingType,
                pageSize = pageSize.toInt(),
                locale = locale,
                callback = callback
        )
    }

    override fun searchByQuery(
            query: SearchQueryMessage,
            spatialRestriction: List<GeoPointMessage>?,
            weekTime: WeekTimeSearchMessage?,
            searchRect: GeoRectMessage?,
            sortingType: SortingTypeMessage,
            pageSize: Long,
            locale: String?,
            callback: (Result<SearchResultMessage>) -> Unit
    ) {
        searchHandler?.searchByQuery(
                queryId = query,
                spatialRestriction = spatialRestriction?.map { it.toGeoPoint() },
                searchGeoRect = searchRect?.toGeoRect(),
                weekTimeMessage = weekTime,
                sortingType = sortingType,
                pageSize = pageSize.toInt(),
                locale = locale,
                callback = callback
        )
    }

    override fun searchByRubrics(
            rubrics: List<Long>,
            spatialRestriction: List<GeoPointMessage>?,
            weekTime: WeekTimeSearchMessage?,
            searchRect: GeoRectMessage?,
            sortingType: SortingTypeMessage,
            pageSize: Long,
            locale: String?,
            callback: (Result<SearchResultMessage>) -> Unit
    ) {
        searchHandler?.searchByRubrics(
                rubricIds = rubrics.map { RubricId(it) },
                spatialRestriction = spatialRestriction?.map { it.toGeoPoint() },
                searchGeoRect = searchRect?.toGeoRect(),
                weekTimeMessage = weekTime,
                sortingType = sortingType,
                pageSize = pageSize.toInt(),
                locale = locale,
                callback = callback
        )
    }

    override fun fetchNextPage(pageId: PageIdMessage, callback: (Result<PageMessage>) -> Unit) {
        searchHandler?.fetchNextPage(pageId, callback)
    }

    override fun fetchPrevPage(pageId: PageIdMessage, callback: (Result<PageMessage>) -> Unit) {
        searchHandler?.fetchPrevPage(pageId, callback)
    }

    override fun releasePage(pageId: PageIdMessage, callback: (Result<Unit>) -> Unit) {
        searchHandler?.releasePage(pageId, callback)
    }

    override fun fetchSuggests(
            queryText: String,
            allowedResultTypes: List<SuggestedTypeMessage_>?,
            searchRect: GeoRectMessage?,
            locale: String?,
            suggestorType: SuggestorTypeEnum?,
            limit: Long?,
            callback: (Result<SuggestResultMessage>) -> Unit
    ) {
        searchHandler?.fetchSuggests(
                queryText = queryText,
                allowedResultTypes = allowedResultTypes,
                searchGeoRect = searchRect?.toGeoRect(),
                locale = locale,
                suggestorType = suggestorType,
                limit = limit?.toInt(),
                callback = callback
        )
    }

    // --- MARKER ---

    override fun addMarker(
            marker: MarkerMessage,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.addMarker(marker, manager?.id, callback)
    }

    override fun setMarkerOptions(
            id: String,
            options: ChangeMarkerOptionsMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.setMarkerOptions(id, options, callback)
    }

    override fun addMarkers(
            markers: List<MarkerMessage>,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.addMarkers(markers, manager?.id, callback)
    }

    override fun removeMarker(
            id: String,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.removeMarker(id, manager?.id, callback)
    }

    override fun removeAllMarkers(
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.removeAllMarkers(manager?.id, callback)
    }

    // --- MAP OBJECT ---
    override fun createMapObjectManagerWithClustering(
            message: ClusteringMapObjectManagerOptionsMessage,
            layerId: String?,
            callback: (Result<MapObjectManagerMessage>) -> Unit
    ) {
        objectTapHandler?.createClusteringMapObjectManager(message, layerId, callback)
    }

    override fun createMapObjectManager(
            layerId: String?,
            callback: (Result<MapObjectManagerMessage>) -> Unit
    ) {
        objectTapHandler?.createMapObjectManager(layerId, callback)
    }

    override fun removeMapObjectManager(
            manager: MapObjectManagerMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.removeMapObjectManager(manager, callback)
    }

    override fun setMapObjectManagerIsVisible(
            isVisible: Boolean,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.setMapObjectManagerIsVisible(isVisible, manager)
        callback(Result.success(Unit))
    }

    override fun setClusterIcon(id: String, icon: String, callback: (Result<Unit>) -> Unit) {
        objectTapHandler?.setClusterIcon(icon, id, callback)
    }

    override fun releaseCluster(id: String, callback: (Result<Unit>) -> Unit) {
        objectTapHandler?.releaseCluster(id)
        callback(Result.success(Unit))
    }

    // --- POLYGON ---
    override fun addPolygon(
            polygon: PolygonMessage,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.addPolygon(polygon, manager?.id, callback)
    }

    override fun addPolygons(
            polygons: List<PolygonMessage>,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.addPolygons(polygons, manager?.id, callback)
    }

    override fun removePolygon(
            id: String,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.removePolygon(id, manager?.id, callback)
    }

    override fun removeAllPolygons(
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.removeAllPolygons(manager?.id, callback)
    }

    // --- POLYGON ---
    override fun addCircle(
            circle: CircleMessage,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.addCircle(circle, manager?.id, callback)
    }

    override fun addCircles(
            circles: List<CircleMessage>,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.addCircles(circles, manager?.id, callback)
    }

    override fun removeCircle(
            id: String,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.removeCircle(id, manager?.id, callback)
    }

    override fun removeAllCircles(
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.removeAllCircles(manager?.id, callback)
    }

    // --- POLYLINE ---
    override fun addPolyline(
            polyline: PolylineMessage,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.addPolyline(polyline, manager?.id, callback)
    }

    override fun addPolylines(
            polylines: List<PolylineMessage>,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.addPolylines(polylines, manager?.id, callback)
    }

    override fun removePolyline(
            id: String,
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.removePolyline(id, manager?.id, callback)
    }

    override fun removeAllPolylines(
            manager: MapObjectManagerMessage?,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.removeAllPolylines(manager?.id, callback)
    }

    override fun setRouteParams(
            params: RouteEditorRouteParamsMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        routeHandler?.setRouteParams(params)
        callback(Result.success(Unit))
    }

    override fun hideRoutes(callback: (Result<Unit>) -> Unit) {
        routeHandler?.setRoutesVisible(false)
        callback(Result.success(Unit))
    }

    override fun showRoutes(callback: (Result<Unit>) -> Unit) {
        routeHandler?.setRoutesVisible(true)
        callback(Result.success(Unit))
    }

    override fun startNavigation(speedRangeZoom: List<SpeedRangeZoom>, callback: (Result<Unit>) -> Unit) {
        val routeHandler =
                routeHandler
                        ?: kotlin.run {
                            callback(Result.failure(Exception("RouteHandler not initialized")))
                            return
                        }
        val isPublicTransport = routeHandler.options?.isPublicTransport ?: false
        routeHandler.setRoutesVisible(isPublicTransport)
        if (isPublicTransport) {
            routeHandler.setShowOnlyActiveRoute(true)
        }

        navigationHandler.startNavigation(
                finishPoint = routeHandler.finishPoint,
                options = routeHandler.options,
                route = routeHandler.selectedRoute,
                speedRangeZoom = speedRangeZoom,
                callback = callback
        )
    }

    override fun startNavigationSimulation(
            speedRangeZoom: List<SpeedRangeZoom>,
            callback: (Result<Unit>) -> Unit
    ) {
        val routeHandler =
                routeHandler
                        ?: kotlin.run {
                            callback(Result.failure(Exception("RouteHandler not initialized")))
                            return
                        }
        routeHandler.setRoutesVisible(false)
        navigationHandler.startSimulation(
                finishPoint = routeHandler.finishPoint,
                options = routeHandler.options,
                route = routeHandler.selectedRoute,
                speedRangeZoom = speedRangeZoom,
                callback = callback
        )
    }

    override fun simulationSpeed(speed: Double) {
        navigationHandler.simulationSettings(speed)
    }

    override fun saveNavigationState(callback: (Result<ByteArray>) -> Unit) {
        navigationHandler.saveNavigationState(callback = callback)
    }

    override fun getCurrentNavigationState(callback: (Result<NavigationStateMessage>) -> Unit) {
        navigationHandler.getCurrentNavigationState(callback)
    }

    override fun restoreNavigationState(
            state: ByteArray,
            speedRangeZoom: List<SpeedRangeZoom>,
            callback: (Result<Unit>) -> Unit
    ) {
        navigationHandler.restoreNavigationState(
                state = state,
                speedRangeZoom = speedRangeZoom,
                callback = callback
        )
    }

    override fun stopNavigation(callback: (Result<Unit>) -> Unit) {
        navigationHandler.stopNavigation()
        callback(Result.success(Unit))
    }

    override fun addPanoramasMarkers(
            message: AddMarkersWithPhotoMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.addPanoramasMarkers(message)
        callback(Result.success(Unit))
    }

    override fun showPanoramasMarkers(callback: (Result<Unit>) -> Unit) {
        objectTapHandler?.showPanoramasMarkers()
        callback(Result.success(Unit))
    }

    override fun hidePanoramasMarkers(callback: (Result<Unit>) -> Unit) {
        objectTapHandler?.hidePanoramasMarkers()
        callback(Result.success(Unit))
    }

    override fun removePanoramasMarkers(callback: (Result<Unit>) -> Unit) {
        objectTapHandler?.removePanoramasMarkers()
        callback(Result.success(Unit))
    }

    override fun setHighlighted(
            objectIds: List<DgisObjectIdMessage>,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.setHighlighted(
                objectIds =
                        objectIds.map {
                            DgisObjectId(
                                    objectId = it.objectId,
                                    entranceId = it.entranceId,
                            )
                        },
                callback = callback,
        )
    }

    override fun onLocationPermissionGranted(
            desiredAccuracy: DesiredAccuracyMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        Log.d("HuaweiLocationProvider", "Huawei Location  onLocationPermissionGranted")
        locationSource.onPermissionGranted()
        locationSource.setDesiredAccuracy(desiredAccuracy.toSdkAccuracy())
        callback(Result.success(Unit))
    }

    override fun overlappedBy(
            outerRect: GeoRectMessage,
            innerRect: GeoRectMessage,
            callback: (Result<Long>) -> Unit
    ) {
        val outer = outerRect.toGeoRect()

        val inner = innerRect.toGeoRect()

        val isOverlapped = if (outer.contains(inner)) 1L else 0
        callback(Result.success(isOverlapped))
    }

    override fun contains(
            rect: GeoRectMessage,
            point: GeoPointMessage,
            callback: (Result<Boolean>) -> Unit
    ) {
        callback(Result.success(rect.toGeoRect().contains(point.toGeoPoint())))
    }

    override fun containsRect(
            outer: GeoRectMessage,
            inner: GeoRectMessage,
            callback: (Result<Boolean>) -> Unit,
    ) {
        callback(Result.success(outer.toGeoRect().contains(inner.toGeoRect())))
    }

    override fun pointBearing(
            from: GeoPointMessage,
            to: GeoPointMessage,
            callback: (Result<Double>) -> Unit,
    ) {
        callback(Result.success(from.toGeoPoint().bearing(to.toGeoPoint()).value))
    }

    override fun setPanoramaMarkerAzimuth(
            message: MapDirectionMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.setPanoramasAzimuth(message.degree)
        callback(Result.success(Unit))
    }

    override fun onCompassClicked(callback: (Result<Unit>) -> Unit) {
        compassControlHandler?.onClicked()
        callback(Result.success(Unit))
    }

    override fun onTrafficAndParkingAttached(callback: (Result<Unit>) -> Unit) {
        trafficAndParkingControlHandler?.onAttachToMap()
        callback(Result.success(Unit))
    }

    override fun onTrafficAndParkingDetached(callback: (Result<Unit>) -> Unit) {
        trafficAndParkingControlHandler?.onDetachFromMap()
        callback(Result.success(Unit))
    }

    override fun onParkingClicked(callback: (Result<Unit>) -> Unit) {
        trafficAndParkingControlHandler?.onParkingClicked()
        callback(Result.success(Unit))
    }

    override fun onTrafficClicked(callback: (Result<Unit>) -> Unit) {
        trafficAndParkingControlHandler?.onTrafficClicked()
        callback(Result.success(Unit))
    }

    override fun setPanoramasPaddings(
            message: CameraSetPaddingMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        map?.let { objectTapHandler?.setPanoramasPadding(it, message) }
        callback(Result.success(Unit))
    }

    override fun unselectPanorama(callback: (Result<Unit>) -> Unit) {
        objectTapHandler?.unselectPanorama()
        callback(Result.success(Unit))
    }

    override fun showEsriIOLayer(
            message: AddLayerPointObjectsMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        objectTapHandler?.addIoMarkers(message, callback)
    }

    override fun removeEsriIOLayer(callback: (Result<Unit>) -> Unit) {
        objectTapHandler?.removeAllMarkers(null, callback)
    }

    override fun moveCameraToSelectedPanorama(callback: (Result<Unit>) -> Unit) {
        map?.let { objectTapHandler?.moveCameraToSelectedPanorama(it) }
        callback(Result.success(Unit))
    }

    override fun setAppearance(appearance: MapAppearanceMessage, callback: (Result<Unit>) -> Unit) {
        when (appearance) {
            MapAppearanceMessage.DAY -> mapView.setTheme(MapTheme.defaultTheme)
            MapAppearanceMessage.NIGHT -> mapView.setTheme(MapTheme.defaultDarkTheme)
            MapAppearanceMessage.SYSTEM -> print("todo") // mapView.setTheme("day", "night")
        }

        callback(Result.success(Unit))
    }

    override fun setZoomRestrictions(min: Double?, max: Double?, callback: (Result<Unit>) -> Unit) {
        map?.let { map ->
            map.camera.zoomRestrictions =
                    CameraZoomRestrictions(
                            minZoom = min?.let { Zoom(it.toFloat()) } ?: Zoom(0f),
                            maxZoom = max?.let { Zoom(it.toFloat()) } ?: Zoom(20f)
                    )
        }
        callback(Result.success(Unit))
    }

    override fun setPublicTransportActiveRoute(routeIndex: Long, callback: (Result<Unit>) -> Unit) {
        routeHandler?.setActiveRouteIndex(routeIndex)
        callback(Result.success(Unit))
    }

    override fun startFreeRoam(speedRangeZoom: List<SpeedRangeZoom>, callback: (Result<Unit>) -> Unit) {
        navigationHandler.startFreeRoam(speedRangeZoom = speedRangeZoom)
        callback(Result.success(Unit))
    }

    override fun stopFreeRoam(callback: (Result<Unit>) -> Unit) {
        navigationHandler.stopFreeRoam()
        callback(Result.success(Unit))
    }

    override fun toggleVoiceInstruction(
            toggleType: SoundToggleType,
            callback: (Result<Unit>) -> Unit
    ) {
        navigationHandler.toggleVoiceInstruction(toggleType)
        callback(Result.success(Unit))
    }

    override fun favouritesUpdateNotification(
        favouritesState: FavouritesStateMessage,
        callback: (Result<Unit>) -> Unit
    ) {
        FavouritesUpdateNotifier.sendEvent(favouritesState)
        callback(Result.success(Unit))
    }

    override fun authorizationNotification(
            isAuthorized: Boolean,
            callback: (Result<Unit>) -> Unit
    ) {
        UserAuthorizedNotifier.sendEvent(isAuthorized)
        callback(Result.success(Unit))
    }

    override fun setNavigatorVolume(volume: Long, callback: (Result<Unit>) -> Unit) {
        navigationHandler.setNavigatorVolume(volume.toInt())
        callback(Result.success(Unit))
    }

    override fun toggleRoadCameras(roadCameras: Boolean, callback: (Result<Unit>) -> Unit) {
        navigationHandler.toggleRoadCameras(roadCameras)
        callback(Result.success(Unit))
    }

    override fun toggleOverSpeeding(overSpeeding: Boolean, callback: (Result<Unit>) -> Unit) {
        navigationHandler.toggleOverSpeeding(overSpeeding)
        callback(Result.success(Unit))
    }

    override fun muteOtherSounds(mute: Boolean, callback: (Result<Unit>) -> Unit) {
        navigationHandler.muteOtherSounds(mute)
        callback(Result.success(Unit))
    }

    private fun onMapReady(map: DgisMap, callback: (Result<InitializeMessage>) -> Unit) {
        // Don't set graphics preset to IMMERSIVE at initialization
        // It will be set conditionally in NavigationHandler.setupCamera based on traffic state
        // This preserves traffic layer colors when freeroam starts
        this.map = map

        val mapSource =
                MyLocationMapObjectSource(
                        sdkContext,
                        MyLocationControllerSettings(
                                bearingSource = BearingSource.AUTO,
                        ),
                )
        map.addSource(mapSource)

        indoorControlHandler = IndoorControlHandler(map, eventSink)
        routeHandler = RouteHandler(map, sdkContext, eventSink, locationSource, navigationHandler, indoorControlHandler)
        zoomControlHandler = ZoomControlHandler(map, eventSink)
        locationControlHandler = LocationControlHandler(map, eventSink)
        visibleRectHandler = VisibleRectHandler(map, eventSink)
        searchHandler =
                SearchHandler(
                        map,
                        SearchManager.createOnlineManager(sdkContext),
                        locationSource,
                        SearchHistory(DgisMapInitializer.getSdkContext()),
                )
        compassControlHandler = CompassControlHandler(map, eventSink)
        trafficAndParkingControlHandler =
                TrafficAndParkingControlHandler(sdkContext, map, eventSink)
        setupTapHandler()
        weatherHandler = WeatherHandler(sdkContext, map)
        satelliteHandler = SatelliteHandler(sdkContext, map)

        callback(Result.success(InitializeMessage(wasInitialized = true, errorDescription = "")))
    }

    override fun findBriefRouteInfos(
            routeSearchOptions: RouteSearchOptionsMessage,
            startPoint: RouteSearchPointMessage?,
            finishPoint: RouteSearchPointMessage?,
            callback: (Result<List<BriefRouteInfoMessage>>) -> Unit
    ) {
        val searchOptions = routeSearchOptions.toRouteSearchOptions()

        val startSearchPoint =
                startPoint?.toRouteSearchPoint()
                        ?: locationSource.lastLocation.let {
                            return@let RouteSearchPoint(
                                    coordinates = GeoPoint(it?.latitude ?: .0, it?.longitude ?: .0),
                                    objectId = DgisObjectId(objectId = 0, entranceId = 0),
                                    levelId = getCurrentLevelId()
                            )
                        }
        val finishSearchPoint =
                finishPoint?.toRouteSearchPoint()
                        ?: locationSource.lastLocation.let {
                            return@let RouteSearchPoint(
                                    coordinates = GeoPoint(it?.latitude ?: .0, it?.longitude ?: .0),
                                    objectId = DgisObjectId(objectId = 0, entranceId = 0),
                                    levelId = getCurrentLevelId()
                            )
                        }
        val briefRouteInfoSearchPoints =
                listOf(
                        BriefRouteInfoSearchPoints(
                                startPoint = startSearchPoint,
                                finishPoint = finishSearchPoint
                        )
                )
        routeHandler?.findBriefRouteInfos(
                        routeSearchOptions = searchOptions,
                        searchPoints = briefRouteInfoSearchPoints
                )
                ?.apply {
                    onResult { res ->
                        val map = res.mapNotNull { it?.toBriefRouteInfoMessage() }.toMutableList()

                        callback(Result.success(map))
                    }
                    onError { error -> callback(Result.failure(error)) }
                }
    }

    override fun findRoute(
            startPoint: RouteSearchPointMessage,
            finishPoint: RouteSearchPointMessage,
            navType: RouteSearchOptionsMessage,
            intermediatePoints: List<RouteSearchPointMessage>?,
            callback: (Result<FindRouteResultMessage>) -> Unit
    ) {
        val routeSearchOptions = navType.toRouteSearchOptions()
        val startSearchPoint = startPoint.toRouteSearchPoint()
        val finishSearchPoint = finishPoint.toRouteSearchPoint()

        routeHandler?.findRoute(
            startPoint = startSearchPoint,
            finishPoint = finishSearchPoint,
            routeSearchOptions = routeSearchOptions,
            intermediatePoints = intermediatePoints?.map { it.toRouteSearchPoint() },
            callback = callback
        )
    }

    override fun toggleHeatmap(message: WeatherMapMessage, callback: (Result<Boolean>) -> Unit) {
        weatherHandler?.toggleHeatmap(message, callback)
    }

    override fun toggleSatellite(message: SatelliteMapMessage, callback: (Result<Boolean>) -> Unit) {
        satelliteHandler?.toggleSatellite(message, callback)
    }

    override fun betterRouteResponse(
            response: BetterRouteResponseMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        navigationHandler.betterRouteResponse(response)
        callback(Result.success(Unit))
    }

    override fun getBetterRouteSettings(callback: (Result<BetterRouteSettingsMessage>) -> Unit) {
        navigationHandler.getBetterRouteSettings(callback)
    }

    override fun setBetterRouteSettings(
            message: BetterRouteSettingsMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        navigationHandler.setBetterRouteSettings(message)
        callback(Result.success(Unit))
    }

    override fun setBetterRouteEnabled(enabled: Boolean, callback: (Result<Unit>) -> Unit) {
        navigationHandler.setBetterRouteEnabled(enabled)
        callback(Result.success(Unit))
    }

    override fun getCarConnectionState(callback: (Result<Boolean>) -> Unit) {
        val connected = androidAutoHandler.getConnectionState()
        callback(Result.success(connected))
    }

    override fun listPackages(callback: (Result<List<PackageMessage>>) -> Unit) {
        packagesHandler.listPackages(callback)
    }

    override fun installPackage(id: String, callback: (Result<Unit>) -> Unit) {
        packagesHandler.installPackage(id, callback)
    }

    override fun listVoices(callback: (Result<List<VoiceMessage>>) -> Unit) {
        packagesHandler.listVoices(callback)
    }

    override fun voicePlayWelcome(id: String, callback: (Result<Unit>) -> Unit) {
        packagesHandler.voicePlayWelcome(id, callback)
    }

    override fun installVoice(id: String, callback: (Result<Unit>) -> Unit) {
        packagesHandler.installVoice(id, callback)
    }

    override fun setNavigatorVoice(id: String, callback: (Result<Unit>) -> Unit) {
        navigationHandler.setNavigatorVoice(id, callback)
    }

    override fun setMaxFps(maxFps: Long?, callback: (Result<Unit>) -> Unit) {
        mapView.maxFps = maxFps?.toInt()?.let { Fps(it) }
        callback(Result.success(Unit))
    }

    override fun getSearchHistoryItems(callback: (Result<List<SearchHistoryDirectoryObjectMessage>>) -> Unit) {
        val searchHandler = this.searchHandler ?: return callback(
            Result.failure(
                FlutterError(
                    code = "IllegalArgumentException",
                    message = "Search Handler was not initialized properly"
                )
            )
        )

        runBlocking {
            callback(Result.success(searchHandler.getSearchHistoryItems()))
        }
    }

    override fun addSearchHistoryItem(
        item: SearchHistoryDirectoryObjectMessage,
        callback: (Result<Unit>) -> Unit
    ) {
        val searchHandler = this.searchHandler ?: return callback(
            Result.failure(
                FlutterError(
                    code = "IllegalArgumentException",
                    message = "Search Handler was not initialized properly"
                )
            )
        )
        val objectId = item.id?.objectId ?: return run {
            searchHandler.addQuerySearchHistoryItem(queryText = item.title)
            callback(Result.success(Unit))
        }
        val entranceId = item.id.entranceId
        val directoryObject: DirectoryObject = runBlocking<DirectoryObject?> {
            return@runBlocking searchHandler.searchByDirectoryObjectIdSync(
                objectId = DgisObjectId(
                    objectId = objectId,
                    entranceId = item.id.entranceId,
                )
            )
        } ?: return callback(
            Result.failure(
                FlutterError(
                    code = "SEARCH_HISTORY_ERROR",
                    message = "Failed to get directory object of id",
                    details = "objectId: $objectId, entranceId: $entranceId",
                )
            )
        )

        searchHandler.addDirectoryObjectSearchHistoryItem(directoryObject = directoryObject)
        callback(Result.success(Unit))
    }

    override fun removeSearchHistoryItem(index: Long, callback: (Result<Unit>) -> Unit) {
        val searchHandler = this.searchHandler ?: return callback(
            Result.failure(
                FlutterError(
                    code = "IllegalArgumentException",
                    message = "Search Handler was not initialized properly"
                )
            )
        )

        runBlocking {
            val items = searchHandler.getRawSearchHistoryItems()
            searchHandler.removeSearchHistoryItem(item = items[index.toInt()])
            callback(Result.success(Unit))
        }
    }

    override fun clearSearchHistoryItems(callback: (Result<Unit>) -> Unit) {
        val searchHandler = this.searchHandler ?: return callback(
            Result.failure(
                FlutterError(
                    code = "IllegalArgumentException",
                    message = "Search Handler was not initialized properly"
                )
            )
        )

        searchHandler.clearSearchHistory()
        callback(Result.success(Unit))
    }
}
