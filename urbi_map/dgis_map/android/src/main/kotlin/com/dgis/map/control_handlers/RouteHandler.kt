package com.dgis.map.control_handlers

import com.dgis.map.FusedLocationSource
import com.dgis.map.control_handlers.public_transport.PublicTransportHandler
import com.dgis.map.extensions.toExcludedArea
import com.dgis.map.extensions.toMessage
import com.dgis.map.map_api.*
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.Context
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.Future
import ru.dgis.sdk.LevelId
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.geometry.ComplexGeometry
import ru.dgis.sdk.geometry.PointGeometry
import ru.dgis.sdk.map.DefaultRasterUrlTemplate
import ru.dgis.sdk.map.Map as DgisMap
import ru.dgis.sdk.map.RasterTileSource
import ru.dgis.sdk.map.RasterUrlTemplate
import ru.dgis.sdk.map.RouteEditorSource
import ru.dgis.sdk.map.RouteMapObject
import ru.dgis.sdk.map.Source
import ru.dgis.sdk.map.Zoom
import ru.dgis.sdk.map.calcPosition
import ru.dgis.sdk.routing.*
import kotlin.collections.mutableListOf

class RouteHandler(
        private val map: DgisMap,
        sdkContext: Context,
        private val eventSink: EventChannel.EventSink,
        private val locationSource: FusedLocationSource,
        private val navigationHandler: NavigationHandler,
        private val indoorControlHandler: IndoorControlHandler? = null,
) : AutoCloseable {
    private val closeables = mutableListOf<AutoCloseable>()

    private var routeEditorSource: RouteEditorSource
    private var routesEditor: RouteEditor
    private var publicTransportHandler: PublicTransportHandler
    private var trafficRouter: TrafficRouter

    var options: RouteSearchOptions? = null
        private set

    var finishPoint: RouteSearchPoint? = null
        private set

    val selectedRoute: TrafficRoute?
        get() {
            val selectedRouteIndex = routesEditor.activeRouteIndex?.value?.toInt() ?: return null
            return routesEditor.routesInfo.routes[selectedRouteIndex]
        }

    init {
        val routesEditor = RouteEditor(sdkContext)
        this.routeEditorSource = RouteEditorSource(sdkContext, routesEditor)

        this.trafficRouter = TrafficRouter(sdkContext)
        publicTransportHandler = PublicTransportHandler(eventSink, this)

        closeables.add(
                routesEditor.routesInfoChannel.connect {
                    if (options?.isPublicTransport == true) {
                        publicTransportHandler.onRoutesChanged()
                    }
                    this.onRoutesInfoChanged(it)
                }
        )
        closeables.add(
                routesEditor.activeRouteIndexChannel.connect {
                    if (options?.isPublicTransport == true) {
                        publicTransportHandler.onActiveRouteChanged()
                    }
                    this.onActiveRouteChanged(it)
                }
        )

        this.routesEditor = routesEditor
        map.addSource(routeEditorSource)
    }

    private enum class Events {
        onRoutesInfoChanged,
        onActiveRouteChanged,
    }

    override fun close() {
        publicTransportHandler.stopDurationUpdates()
        closeables.forEach { it.close() }
        closeables.clear()
    }

    private fun createRouteSearchPoint(point: RouteEditorRoutePointMessage): RouteSearchPoint {
        return RouteSearchPoint(
            coordinates =
                GeoPoint(
                    point.point.latitude,
                    point.point.longitude
                ),
            objectId =
                DgisObjectId(
                    objectId = point.objectId?.objectId ?: 0,
                    entranceId = point.objectId?.entranceId
                        ?: 0,
                ),
            levelId = point.levelId?.let { LevelId(it) }
        )
    }

    private fun getCurrentLevelId(): LevelId? {
        return indoorControlHandler?.currentLevelId
    }

    fun setRouteParams(params: RouteEditorRouteParamsMessage) {
        val startPoint =
                if (params.startPoint == null) {
                    locationSource.lastLocation?.let {
                        RouteSearchPoint(
                            coordinates = GeoPoint(it.latitude, it.longitude),
                            levelId = getCurrentLevelId()
                        )
                    }
                } else {
                    createRouteSearchPoint(params.startPoint!!)
                }
        val finishPoint =
                if (params.finishPoint == null) {
                    locationSource.lastLocation?.let {
                        RouteSearchPoint(
                            coordinates = GeoPoint(it.latitude, it.longitude),
                            levelId = getCurrentLevelId()
                        )
                    }
                } else {
                    createRouteSearchPoint(params.finishPoint!!)
                }

        if (startPoint == null || finishPoint == null) {
            return
        }

        this.options = getRouteSearchOptions(params.options, params.searchParams)
        this.finishPoint = finishPoint

        val intermediatePoints = params.intermediatePoints?.map { it ->
            createRouteSearchPoint(it)
        }
        val routeEditorParams =
                RouteEditorRouteParams(
                    startPoint,
                    finishPoint,
                    options!!,
                    intermediatePoints ?: mutableListOf())
        routesEditor.setRouteParams(routeEditorParams)
        setShowOnlyActiveRoute(params.showOnlyActiveRoute ?: true)
    }

    fun setRoutesVisible(visible: Boolean) {
        routeEditorSource.setRoutesVisible(visible)
    }

    fun setShowOnlyActiveRoute(visible: Boolean) {
        routeEditorSource.setShowOnlyActiveRoute(visible)
    }

    fun setActiveRouteIndex(index: Long) {
        this.routesEditor.setActiveRouteIndex(RouteIndex(index))
    }

    fun onRouteTap(route: RouteMapObject) {
        if (navigationHandler.isNavigating) {
            navigationHandler.onRouteTap(route)
        } else {
            this.routesEditor.setActiveRouteIndex(route.routeIndex)
        }
    }

    private fun getRouteSearchOptions(
        opts: RouteSearchOptionsMessage,
        searchParams: CarRouteSearchOptionParamsMessage?,
    ): RouteSearchOptions {
        val avoidTollRoads = searchParams?.avoidTollRoads ?: false
        val avoidUnpavedRoads = searchParams?.avoidUnpavedRoads ?: false
        val excludedAreas = (searchParams?.excludedAreas ?: emptyList()).map { it.toExcludedArea() }
        val carOptions = CarRouteSearchOptions(
            avoidTollRoads = avoidTollRoads,
            avoidUnpavedRoads = avoidUnpavedRoads,
            excludedAreas = excludedAreas,
        )

        return when (opts) {
            RouteSearchOptionsMessage.CAR -> 
                RouteSearchOptions(carOptions)

            RouteSearchOptionsMessage.BICYCLE ->
                RouteSearchOptions(BicycleRouteSearchOptions())

            RouteSearchOptionsMessage.PEDESTRIAN ->
                RouteSearchOptions(PedestrianRouteSearchOptions())

            RouteSearchOptionsMessage.TRUCK -> 
                RouteSearchOptions(TruckRouteSearchOptions(carOptions))

            RouteSearchOptionsMessage.SCOOTER ->
                RouteSearchOptions(ScooterRouteSearchOptions())

            RouteSearchOptionsMessage.PUBLIC_TRANSPORT ->
                RouteSearchOptions(PublicTransportRouteSearchOptions())

            RouteSearchOptionsMessage.TAXI -> 
                RouteSearchOptions(TaxiRouteSearchOptions(carOptions))
        }
    }

    fun moveCameraToActiveRoute(index: Long) {
        val route = routesEditor.routesInfo.routes[index.toInt()]

        val geometries = route.route.geometry.entries.map { entry -> PointGeometry(entry.value) }

        ComplexGeometry(geometries).apply {
            val oldPosition = calcPosition(map.camera, this)

            // Need add zoom value to route may contain the screen
            val newPosition = oldPosition.copy(zoom = Zoom(oldPosition.zoom.value - 1))

            this@RouteHandler.map.camera.move(newPosition)
        }
    }

    private fun onActiveRouteChanged(index: RouteIndex?) {
        if (index == null) return
        val route = routesEditor.routesInfo.routes[index.value.toInt()]

        val geometries = route.route.geometry.entries.map { entry -> PointGeometry(entry.value) }
        ComplexGeometry(geometries).apply {
            this@RouteHandler.map.camera.move(calcPosition(map.camera, this))
        }

        eventSink.success(
                mapOf(
                        "event" to Events.onActiveRouteChanged.name,
                        "index" to index.value,
                )
        )
    }

    companion object {
        private fun getPedestrianRouteData(route: Route): Triple<Int, Int, List<Int>> {
            return Triple(
                    first =
                    route.roadSubtypes.entries
                            .filter {
                                it.value == RoadSubtype.STAIRWAY_DOWN ||
                                        it.value == RoadSubtype.STAIRWAY_UP
                            }
                            .size,
                    second = route.obstacles.entries.size,
                    third = route.altitudes.entries.map { it.value.toInt() }
            )
        }

        fun mapRouteInfo(route: TrafficRoute): Map<String, Any> {
            val (stairwayCount, gateCount, altitudes) = getPedestrianRouteData(route.route)

            val distance = route.route.geometry.last?.point?.distance?.meters ?: 0.0
            val duration =
                    route.route.geometry.first?.point?.let {
                        route.traffic.durations.calculateDuration(it).inSeconds
                    }
                            ?: 0

            return mapOf(
                    "distance" to distance,
                    "duration" to duration,
                    "stairwayCount" to stairwayCount,
                    "gateCount" to gateCount,
                    "altitudes" to altitudes
            )
        }
    }

    private fun onRoutesInfoChanged(routesInfo: RouteEditorRoutesInfo) {
        if (routesInfo.routes.isNotEmpty()) {
            val geometries =
                    routesInfo
                            .routes
                            .map { route ->
                                route.route.geometry.entries.map { entry ->
                                    PointGeometry(entry.value)
                                }
                            }
                            .flatten()
            ComplexGeometry(geometries).apply {
                this@RouteHandler.map.camera.move(calcPosition(map.camera, this))
            }

            val mappedRoutes = routesInfo.routes.map(::mapRouteInfo)

            eventSink.success(
                    mapOf("event" to Events.onRoutesInfoChanged.name, "routes" to mappedRoutes)
            )
        }
    }

    fun getActivePublicTransportRoute(): TrafficRoute? {
        val route =
                routesEditor.activeRouteIndex?.let {
                    routesEditor.routesInfo.routes[it.value.toInt()]
                }
        if (route == null || route.route.publicTransportTransfers.isEmpty) {
            return null
        }
        return route
    }

    fun getPublicTransportRoutes(): List<TrafficRoute> {
        return routesEditor.routesInfo.routes.filter { !it.route.publicTransportTransfers.isEmpty }
    }

    fun findBriefRouteInfos(
            searchPoints: List<BriefRouteInfoSearchPoints>,
            routeSearchOptions: RouteSearchOptions
    ): Future<List<BriefRouteInfo?>> {
        return trafficRouter.findBriefRouteInfos(searchPoints, routeSearchOptions)
    }

    fun findRoute(
        startPoint: RouteSearchPoint,
        finishPoint: RouteSearchPoint,
        routeSearchOptions: RouteSearchOptions,
        intermediatePoints: List<RouteSearchPoint>?,
        callback: (Result<FindRouteResultMessage>)->Unit
    ) {
        val routesFuture =  trafficRouter.findRoute(
            startPoint = startPoint,
            finishPoint = finishPoint,
            routeSearchOptions = routeSearchOptions,
            intermediatePoints = intermediatePoints ?: listOf(),
        )



        closeables.add(
            routesFuture.apply {
            onResult { response ->
                val routeInfoMessages = response.map { route -> routeInfoMessages(route) }
                val result = FindRouteResultMessage(routes = routeInfoMessages)
                callback(Result.success(result))
            }
            onError { error ->
                callback(Result.failure(error))
            }
        })
    }

    private fun routeInfoMessages(route: TrafficRoute): RouteInfoMessage {
        val distance = (route.route.geometry.last?.point?.distance?.millimeters ?: 0) / 1000.0
        
        var duration = 0.0
        route.route.geometry.first?.let { first ->
            duration = route.traffic.durations.calculateDuration(first.point).inSeconds.toDouble()
        }
        
        val (stairwayCount, gateCount, altitudes) = getPedestrianRouteData(route.route)
        
        val publicTransportTransfers = route.route.publicTransportTransfers.entries.map { transfer ->
            transfer.toMessage().value
        }
        
        return RouteInfoMessage(
            distance = distance,
            duration = duration,
            stairwayCount = stairwayCount.toLong(),
            gateCount = gateCount.toLong(),
            altitudes = altitudes.map { it.toLong() },
            publicTransportTransfers = publicTransportTransfers,
        )
    }

    fun getLastLocation(): GeoPointMessage? {
        return locationSource.lastLocation?.let {
            GeoPointMessage(
                latitude  = it.latitude,
                        longitude = it.longitude,
            )
        }
    }

    fun createRasterTileDataSource_(
            context: Context,
            sublayerName: String,
            urlTemplate: String
    ): Source {
        return RasterTileSource(
                context,
                sublayerName,
                RasterUrlTemplate(DefaultRasterUrlTemplate(urlTemplate))
        )
    }
}
