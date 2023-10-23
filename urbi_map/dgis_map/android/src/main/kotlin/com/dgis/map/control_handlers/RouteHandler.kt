package com.dgis.map.control_handlers

import android.content.res.Resources
import com.dgis.map.FusedLocationSource
import com.dgis.map.control_handlers.public_transport.PublicTransportHandler
import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.RouteEditorRouteParamsMessage
import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.Context
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.geometry.ComplexGeometry
import ru.dgis.sdk.geometry.PointGeometry
import ru.dgis.sdk.map.Padding
import ru.dgis.sdk.map.RouteEditorSource
import ru.dgis.sdk.map.RouteMapObject
import ru.dgis.sdk.map.calcPosition
import ru.dgis.sdk.positioning.DefaultLocationSource
import ru.dgis.sdk.routing.*
import ru.dgis.sdk.map.Map as DgisMap

class RouteHandler(
    private val map: DgisMap,
    sdkContext: Context,
    private val eventSink: EventChannel.EventSink,
    private val locationSource: FusedLocationSource,
) : AutoCloseable {
    private val closables = mutableListOf<AutoCloseable>()

    private var routeEditorSource: RouteEditorSource
    private var routesEditor: RouteEditor
    private var publicTransportHandler: PublicTransportHandler

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
        this.routeEditorSource = RouteEditorSource(
            sdkContext, routesEditor,
        )

        publicTransportHandler = PublicTransportHandler(eventSink, this)

        closables.add(routesEditor.routesInfoChannel.connect {
            if (options?.isPublicTransport == true) {
                publicTransportHandler.onRoutesChanged()
            }
            this.onRoutesInfoChanged(it)
        })
        closables.add(routesEditor.activeRouteIndexChannel.connect {
            if (options?.isPublicTransport == true) {
                publicTransportHandler.onActiveRouteChanged()
            }
            this.onActiveRouteChanged(it)
        })

        this.routesEditor = routesEditor

        map.addSource(routeEditorSource)
    }

    private enum class Events {
        onRouteChanged,
    }

    override fun close() {
        closables.forEach { it.close() }
        closables.clear()
    }

    fun setRouteParams(params: RouteEditorRouteParamsMessage) {
        val startPoint = if (params.startPoint == null) {
            locationSource.lastLocation?.let {
                RouteSearchPoint(GeoPoint(it.latitude, it.longitude))
            }
        } else {
            RouteSearchPoint(GeoPoint(params.startPoint!!.latitude, params.startPoint!!.longitude))
        }
        val finishPoint = if (params.finishPoint == null) {
            locationSource.lastLocation?.let {
                RouteSearchPoint(GeoPoint(it.latitude, it.longitude))
            }
        } else {
            RouteSearchPoint(
                GeoPoint(
                    params.finishPoint!!.latitude,
                    params.finishPoint!!.longitude
                )
            )
        }

        if (startPoint == null || finishPoint == null) {
            return
        }

        this.options = getRouteSearchOptions(params.options)
        this.finishPoint = finishPoint

        val routeEditorParams = RouteEditorRouteParams(
            startPoint,
            finishPoint,
            options!!,
            mutableListOf()
        )
        routesEditor.setRouteParams(routeEditorParams)
        routeEditorSource.setRoutesVisible(true)
        routeEditorSource.setShowOnlyActiveRoute(routeEditorParams.routeSearchOptions.isPublicTransport)
    }

    fun setRoutesVisible(visible: Boolean) {
        routeEditorSource.setRoutesVisible(visible)
    }

    fun setActiveRouteIndex(index: Long) {
        this.routesEditor.setActiveRouteIndex(RouteIndex(index))
    }

    fun onRouteTap(route: RouteMapObject) {
        this.routesEditor.setActiveRouteIndex(route.routeIndex)
    }

    private fun getRouteSearchOptions(opts: Messages.RouteSearchOptionsMessage): RouteSearchOptions {
        return when (opts) {
            Messages.RouteSearchOptionsMessage.CAR -> RouteSearchOptions(CarRouteSearchOptions())
            Messages.RouteSearchOptionsMessage.BICYCLE -> RouteSearchOptions(
                BicycleRouteSearchOptions()
            )
            Messages.RouteSearchOptionsMessage.PEDESTRIAN -> RouteSearchOptions(
                PedestrianRouteSearchOptions()
            )
            Messages.RouteSearchOptionsMessage.TRUCK -> RouteSearchOptions(
                TruckRouteSearchOptions(
                    CarRouteSearchOptions()
                )
            )
            Messages.RouteSearchOptionsMessage.SCOOTER -> RouteSearchOptions(
                ScooterRouteSearchOptions()
            )
            Messages.RouteSearchOptionsMessage.PUBLIC_TRANSPORT -> RouteSearchOptions(
                PublicTransportRouteSearchOptions()
            )
            Messages.RouteSearchOptionsMessage.TAXI -> RouteSearchOptions(
                TaxiRouteSearchOptions(
                    CarRouteSearchOptions()
                )
            )
        }
    }

    private fun onActiveRouteChanged(index: RouteIndex?) {
        if (index == null) return
        val route = routesEditor.routesInfo.routes[index.value.toInt()]

        val (stairwayCount, gateCount, altitudes) = getPedestrianRouteData(route.route)

        val distance = route.route.geometry.last?.point?.distance?.meters ?: 0.0
        val duration = route.route.geometry.first?.point?.let {
            route.traffic.durations.calculateDuration(
                it
            ).inSeconds
        } ?: 0

        eventSink.success(
            mapOf(
                "event" to Events.onRouteChanged.name,
                "distance" to distance,
                "duration" to duration,
                "stairwayCount" to stairwayCount,
                "gateCount" to gateCount,
                "altitudes" to altitudes,
            )
        )

        val geometries = route.route.geometry.entries
            .map { entry ->
                PointGeometry(entry.value)
            }
        val density = Resources.getSystem().displayMetrics.density
        val padding = (50 * density).toInt().let { dpQuantity ->
            Padding(dpQuantity, dpQuantity, dpQuantity, dpQuantity)
        }
        ComplexGeometry(geometries).apply {
            this@RouteHandler.map.camera.padding = padding
            this@RouteHandler.map.camera.move(calcPosition(map.camera, this))
        }
    }

    private fun onRoutesInfoChanged(routesInfo: RouteEditorRoutesInfo) {
        if (routesInfo.routes.isNotEmpty()) {
            val geometries = routesInfo.routes
                .map { route ->
                    route.route.geometry.entries
                        .map { entry ->
                            PointGeometry(entry.value)
                        }
                }.flatten()
            val density = Resources.getSystem().displayMetrics.density
            val padding = (50 * density).toInt().let { dpQuantity ->
                Padding(dpQuantity, dpQuantity, dpQuantity, dpQuantity)
            }
            ComplexGeometry(geometries).apply {
                this@RouteHandler.map.camera.padding = padding
                this@RouteHandler.map.camera.move(calcPosition(map.camera, this))
            }
        }
    }

    private fun getPedestrianRouteData(route: Route): Triple<Int, Int, List<Int>> {
        return Triple(
            first = route.roadSubtypes.entries.filter { it.value == RoadSubtype.STAIRWAY }.size,
            second = route.obstacles.entries.size,
            third = route.altitudes.entries.map { it.value.toInt() }
        )
    }

    fun getActivePublicTransportRoute(): TrafficRoute? {
        val route = routesEditor.activeRouteIndex?.let {
            routesEditor.routesInfo.routes[it.value.toInt()]
        }
        if (route == null || route.route.publicTransportTransfers.isEmpty) {
            return null
        }
        return route
    }

    fun getPublicTransportRoutes(): List<TrafficRoute> {
        return routesEditor.routesInfo.routes.filter {
            !it.route.publicTransportTransfers.isEmpty
        }
    }
}
