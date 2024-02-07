package com.dgis.map.control_handlers

import android.util.Size
import com.dgis.map.FlutterClusterRenderer
import com.dgis.map.R
import com.dgis.map.extensions.toGeoPoint
import com.dgis.map.extensions.toGeoPointWithElevation
import com.dgis.map.extensions.toMap
import com.dgis.map.extensions.toMessage
import com.dgis.map.extensions.toTextStyle
import com.dgis.map.extensions.unsafeLazy
import com.dgis.map.map_api.Messages.*
import com.dgis.map.user_data.PhotoData
import io.flutter.FlutterInjector
import io.flutter.plugin.common.EventChannel.EventSink
import ru.dgis.sdk.Context
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.LevelId
import ru.dgis.sdk.ScreenSize
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.map.*
import ru.dgis.sdk.road_events.RoadEventType
import java.io.FileNotFoundException
import java.lang.IllegalArgumentException
import java.util.*
import java.util.concurrent.Executors

class ObjectTapHandler(
    private val map: ru.dgis.sdk.map.Map,
    private val mapObjectManager: MapObjectManager,
    private val panoramasObjectManager: MapObjectManager,
    private val ioObjectManager: MapObjectManager,
    private val routeHandler: RouteHandler?,
    private val sdkContext: Context,
    private val eventSink: EventSink,
    private val api: FlutterMapApi,
) : AutoCloseable {
    private var source: DgisSource? = null
    private var markerImage: Image? = null
    private val panoramaMarkerImage by unsafeLazy {
        imageFromResource(sdkContext, R.drawable.ic_marker_point)
    }
    private val panoramaMarkerSelected by unsafeLazy {
        imageFromResource(sdkContext, R.drawable.ic_street_view_marker)
    }

    private var iconWidth: LogicalPixel? = null

    private var lastTappedSearchMarker: Marker? = null
    private val panoramasMarkers = mutableListOf<Marker>()
    private var selectedPanorama: Marker? = null
    private val mapObjectsExecutorService by unsafeLazy {
        Executors.newSingleThreadExecutor()
    }

    data class MarkerId(val id: String);
    private data class PolygonId(val id: String);
    private data class PolylineId(val id: String);

    private var markers = mutableMapOf<String, Pair<Marker, String?>>();
    private val polygons = mutableMapOf<String, Polygon>();
    private val polylines = mutableMapOf<String, Polyline>();
    private val clusters = mutableMapOf<String, SimpleClusterObject>();
    private val ioLayerMarkers = mutableListOf<Marker>();
    private val managers = mutableMapOf<String, MapObjectManager>()

    private val iconCache = mutableMapOf<String, Image>()

    private var renderedObjectsCloseable: AutoCloseable? = null

    fun objectTapListener(roi: RenderedObjectInfo) {
//        when (val tappedObject = roi.item.item) {
//            is Marker -> {
//                onMarkerTap(tappedObject)
//                return
//            }
//            is DgisMapObject -> {
//                return
//            }
//            else -> eventSink.error("ClassCastException", "tapped object class is not supported", null)
//        }
        when (val tappedObject = roi.item.item) {
            is Marker -> {
                onMarkerTap(tappedObject)
                return
            }
            is Polygon -> {
                val userData = tappedObject.userData

                if (userData is PolygonId) {
                    onPolygonTap(userData.id)
                    return
                }
            }
            is Polyline -> {
                val userData = tappedObject.userData

                if (userData is PolylineId) {
                    onPolylineTap(userData.id)
                    return
                }
            }
            is GeometryMapObject -> {
                val attrs = tappedObject.objectAttributes

                if (attrs.attributeNames.contains("OPPORTUNITYDESCRIPTION")) {
                    eventSink.success(attrs.mapIo(roi.closestMapPoint))
                    return
                }

                if (attrs.attributeNames.contains("DESCRIPTION")) {
                    eventSink.success(attrs.mapIdle(roi.closestMapPoint))
                    return
                }
            }
            is DgisMapObject -> {
                onDgisMapObjectTap(tappedObject, roi)
                return
            }
            is RouteMapObject -> {
                routeHandler?.onRouteTap(tappedObject)
            }
            is SimpleClusterObject -> {
                val userData = tappedObject.userData

                if (userData is MapObjectManagerMessage) {
                    val clusterId = UUID.randomUUID().toString()
                    this.clusters[clusterId] = tappedObject
                    onClusterTap(userData.id, tappedObject, clusterId)
                    return
                }
            }
            is RoadEventMapObject -> {
                onRoadEventTap(tappedObject)
            }
            else -> eventSink.error(
                "ClassCastException",
                "No suitable handler for tapped object: " + tappedObject.javaClass,
                null,
            )
        }
    }

    fun setMarkerOptions(
        svgAsset: String,
        size: Size,
        iconWidth: Double,
        sdkContext: Context,
        result: Result<Void>?
    ) {
        try {
            val asset =
                FlutterInjector
                    .instance()
                    .flutterLoader()
                    .getLookupKeyForAsset(svgAsset)

            markerImage = imageFromAsset(sdkContext, asset, size)
            this.iconWidth = LogicalPixel(iconWidth.toFloat())

            result?.success(null)
        } catch (e: FileNotFoundException) {
            result?.error(e)
        }
    }

    private fun mapMarker(marker: MarkerMessage, result: Result<Void>?): Marker? {
        var markerImage: Image? = null
        if (marker.options.icon != null) {
            if (marker.options.icon!!.path in iconCache) {
                markerImage = iconCache[marker.options.icon!!.path]
            } else {
                try {
                    val asset =
                        FlutterInjector
                            .instance()
                            .flutterLoader()
                            .getLookupKeyForAsset(marker.options.icon!!.path)

                    markerImage = imageFromAsset(sdkContext, asset, Size(0, 0))
                    iconCache[marker.options.icon!!.path] = markerImage
                } catch (e: FileNotFoundException) {
                    result?.error(e)
                    return null
                }
            }
        }

        val options = MarkerOptions(
            position = marker.options.position.toGeoPointWithElevation(),
            icon = markerImage,
            iconMapDirection = marker.options.icon?.iconMapDirection?.let {
                MapDirection(it.degree)
            },
            anchor = marker.options.anchor?.let {
                Anchor(it.x.toFloat(), it.y.toFloat())
            } ?: Anchor(0.5f, 0.5f),
            text = marker.options.text,
            textStyle = marker.options.textStyle?.toTextStyle(),
            iconWidth = marker.options.icon?.let {
                LogicalPixel(it.width.toFloat())
            } ?: LogicalPixel(0f),
            userData = MarkerId(marker.id),
            animatedAppearance = marker.options.animatedAppearance ?: false,
            zIndex = ZIndex(marker.options.zIndex?.toInt() ?: 0)
        )

        return Marker(options)
    }

    fun addMarker(marker: MarkerMessage, manager: MapObjectManagerMessage?, result: Result<Void>?) {
        val markerObject = mapMarker(marker, result) ?: return

        mapObjectsExecutorService.submit {
            markers[marker.id] = Pair(markerObject, manager?.id)
            if (manager != null && managers[manager.id] != null) {
                managers[manager.id]!!.addObject(markerObject)
            } else {
                mapObjectManager.addObject(markerObject)
            }
            result?.success(null)
        }
    }

    fun addMarkers(markers: List<MarkerMessage>, manager: MapObjectManagerMessage?, result: Result<Void>?) {
        val markerObjects = mutableMapOf<String, Pair<Marker, String?>>()
        for (marker in markers) {
            val markerObject = mapMarker(marker, result) ?: return
            markerObjects[marker.id] = Pair(markerObject, manager?.id)
        }

        mapObjectsExecutorService.submit {
            this.markers.putAll(markerObjects)
            if (manager != null && managers[manager.id] != null) {
                managers[manager.id]!!.addObjects(markerObjects.values.map { it.first }.toList())
            } else {
                mapObjectManager.addObjects(markerObjects.values.map { it.first }.toList())
            }
            result?.success(null)
        }
    }

    fun removeMarker(id: String, manager: MapObjectManagerMessage?, result: Result<Void>?) {
        mapObjectsExecutorService.submit {
            markers.remove(id)?.also {
                if (manager != null && managers[manager.id] != null) {
                    managers[manager.id]!!.removeObject(it.first)
                } else {
                    mapObjectManager.removeObject(it.first)
                }
            }
            result?.success(null)
        }
    }

    fun createClusteringMapObjectManager(
        message: ClusteringMapObjectManagerOptionsMessage,
        layerId: String?,
        result: Result<MapObjectManagerMessage>?
    ) {
        val managerId = UUID.randomUUID().toString()
        val managerMessage = MapObjectManagerMessage.Builder()
            .setId(managerId)
            .build()

        val manager = MapObjectManager.withClustering(
            map = this.map,
            logicalPixel = LogicalPixel(value = message.logicalPixel.toFloat()),
            maxZoom = Zoom(value = message.maxZoom.toFloat()),
            minZoom = Zoom(value = message.minZoom?.toFloat() ?: 0f),
            layerId = layerId,
            clusterRenderer = FlutterClusterRenderer(
                sdkContext = sdkContext,
                api = this.api,
                manager = managerMessage
            ),
        )

        mapObjectsExecutorService.submit {
            this.managers[managerId] = manager
            result?.success(managerMessage)
        }
    }

    fun createMapObjectManager(layerId: String?, result: Result<MapObjectManagerMessage>?) {
        val managerId = UUID.randomUUID().toString()
        val managerMessage = MapObjectManagerMessage.Builder()
                .setId(managerId)
                .build()

        val manager = MapObjectManager.withGeneralization(
            map = this.map,
            logicalPixel = LogicalPixel(value = 40f),
            maxZoom = Zoom(value = 18f),
            layerId = layerId,
        )

        mapObjectsExecutorService.submit {
            this.managers[managerId] = manager
            result?.success(managerMessage)
        }
    }

    fun removeMapObjectManager(message: MapObjectManagerMessage, result: Result<Void>?) {
        mapObjectsExecutorService.submit {
            this.managers.remove(message.id).also {
                result?.success(null)
            }
        }
    }

    fun setClusterIcon(icon: String, clusterId: String, result: Result<Void>?) {
        val cluster = this.clusters[clusterId];
        if (cluster == null) {
            result?.error(IllegalArgumentException("Cluster with given id not found or already released"))
            return
        }

        var markerImage: Image? = null
        if (icon in iconCache) {
            markerImage = iconCache[icon]
        } else {
            try {
                val asset =
                    FlutterInjector
                        .instance()
                        .flutterLoader()
                        .getLookupKeyForAsset(icon)

                markerImage = imageFromAsset(sdkContext, asset, Size(0, 0))
                iconCache[icon] = markerImage
            } catch (e: FileNotFoundException) {
                result?.error(e)
                return
            }
        }

        cluster.setIcon(markerImage)
    }

    fun releaseCluster(clusterId: String) {
        this.clusters.remove(clusterId)
    }

    fun setMapObjectManagerIsVisible(
        isVisible: Boolean,
        manager: MapObjectManagerMessage?,
    ) {
        if (manager != null) {
            this.managers[manager.id]?.isVisible = isVisible
        } else {
            this.mapObjectManager.isVisible = isVisible
        }
    }

    private fun mapPolygon(polygon: PolygonMessage): Polygon {
        val options = PolygonOptions(
            contours = polygon.options.contours.map { contour ->
                contour.map {
                    it.toGeoPoint()
                }
            },
            color = polygon.options.color?.let {
                Color(argb = it.toInt())
            } ?: Color(),
            strokeWidth = polygon.options.strokeWidth?.let {
                LogicalPixel(it.toFloat())
            } ?: LogicalPixel(0f),
            strokeColor = polygon.options.strokeColor?.let {
                Color(argb =  it.toInt())
            } ?: Color(),
            userData = PolygonId(polygon.id)
        )

        return Polygon(options)
    }

    fun addPolygon(polygon: PolygonMessage, result: Result<Void>?) {
        val polygonObject = mapPolygon(polygon)

        mapObjectsExecutorService.submit {
            polygons[polygon.id] = polygonObject
            mapObjectManager.addObject(polygonObject)
            result?.success(null)
        }
    }

    fun addPolygons(polygons: List<PolygonMessage>, result: Result<Void>?) {
        val polygonObjects = polygons.associateBy({
             it.id
        }, {
            mapPolygon(it)
        })

        mapObjectsExecutorService.submit {
            this.polygons.putAll(polygonObjects)
            mapObjectManager.addObjects(polygonObjects.values.toList())
            result?.success(null)
        }
    }

    fun removePolygon(id: String, result: Result<Void>?) {
        mapObjectsExecutorService.submit {
            polygons.remove(id)?.also {
                mapObjectManager.removeObject(it)
            }
            result?.success(null)
        }
    }
    private fun mapPolyline(polyline: PolylineMessage): Polyline {
        val options = PolylineOptions(
            points = polyline.options.points.map {
                it.toGeoPoint()
            },
            color = polyline.options.color?.let {
                Color(argb = it.toInt())
            } ?: Color(),
            width = polyline.options.width?.let {
                LogicalPixel(it.toFloat())
            } ?: LogicalPixel(1f),
            userData = PolylineId(polyline.id),
        )

        return Polyline(options)
    }

    fun addPolyline(polyline: PolylineMessage, result: Result<Void>?) {
        val polylineObject = mapPolyline(polyline)

        mapObjectsExecutorService.submit {
            polylines[polyline.id] = polylineObject
            mapObjectManager.addObject(polylineObject)
            result?.success(null)
        }
    }

    fun addPolylines(polylines: List<PolylineMessage>, result: Result<Void>?) {
        val polylineObjects = polylines.associateBy({
            it.id
        }, {
            mapPolyline(it)
        })

        mapObjectsExecutorService.submit {
            this.polylines.putAll(polylineObjects)
            mapObjectManager.addObjects(polylineObjects.values.toList())
            result?.success(null)
        }
    }

    fun removePolyline(id: String, result: Result<Void>?) {
        mapObjectsExecutorService.submit {
            polylines.remove(id)?.also {
                mapObjectManager.removeObject(it)
            }
            result?.success(null)
        }
    }

    fun addIoMarkers(message: AddLayerPointObjectsMessage, result: Result<Void>?) {
        val markerImage = markerImage
        val iconWidth = iconWidth

        if (markerImage == null || iconWidth == null) {
            result?.error(Exception("Error adding marker. Call setMarkerOptions method first"))
            return
        }

        val options = MarkerOptions(
            position = GeoPointWithElevation(latitude = 0.0, longitude = 0.0),
            icon = markerImage,
            iconWidth = iconWidth,
            anchor = Anchor(0.5f, 1f)
        )

        val markers = message.objects.filterNotNull().map{
            val position = GeoPointWithElevation(
                latitude = it.position.latitude,
                longitude = it.position.longitude
            )
            Marker(options.copy(position = position, userData = it.attributes))
        }
        mapObjectsExecutorService.submit {
            ioObjectManager.removeAndAddObjects(ioLayerMarkers, markers)
            ioLayerMarkers.clear()
            ioLayerMarkers.addAll(markers)
            result?.success(null)
        }
    }

    fun removeAllMarkers(manager: MapObjectManagerMessage?) {
        mapObjectsExecutorService.submit {
            if (manager != null && managers[manager.id] != null) {
                managers[manager.id]!!.removeAll()
                markers = markers.filter { it.value.second == manager.id }.toMutableMap()
            } else {
                mapObjectManager.removeAll()
                markers.clear()
            }
        }
    }

    fun removeAllPolygons() {
        mapObjectsExecutorService.submit {
            mapObjectManager.removeObjects(polygons.values.toList())
            polygons.clear()
        }
    }
    fun removeAllPolylines() {
        mapObjectsExecutorService.submit {
            mapObjectManager.removeObjects(polylines.values.toList())
            polylines.clear()
        }
    }

    fun showLastSearchMarker() {
        lastTappedSearchMarker?.iconOpacity = Opacity(1.0f)
    }

    fun setHighlighted(
        objectIds: List<DgisObjectId>,
        result: Result<Void>?
    ) {
        for (source in map.sources) {
            val mSource = source as? DgisSource
            if (mSource != null) {
                this.source = mSource
                break
            }
        }
        val source = this.source
        if (source == null) {
            result?.error(Exception("Map source is null"))
            return
        }

        source.setHighlighted(source.highlightedObjects, false)
        source.setHighlighted(objectIds, true)

        result?.success(null)
    }

    fun addPanoramasMarkers(
        message: AddMarkersWithPhotoMessage
    ) {
        mapObjectsExecutorService.submit(
            AddMarkersTask(
                mapObjectManager = panoramasObjectManager,
                message = message,
                markers = panoramasMarkers,
                icon = panoramaMarkerImage,
            )
        )
    }

    fun showPanoramasMarkers() {
        mapObjectsExecutorService.submit {
            panoramasObjectManager.isVisible = true
        }
    }

    fun hidePanoramasMarkers() {
        mapObjectsExecutorService.submit {
            panoramasObjectManager.isVisible = false
        }
    }

    fun removePanoramasMarkers() {
        mapObjectsExecutorService.submit {
            panoramasMarkers.clear()
            panoramasObjectManager.removeAll()
        }
    }

    fun setPanoramasPadding(map: ru.dgis.sdk.map.Map, message: CameraSetPaddingMessage) {
        map.camera.padding = Padding(
            left = message.leftPadding.toInt(),
            top = message.topPadding.toInt(),
            right = message.rightPadding.toInt(),
            bottom = message.topPadding.toInt()
        )
    }

    fun moveCameraToSelectedPanorama(map: ru.dgis.sdk.map.Map) {
        selectedPanorama?.let {
            map.camera.move(
                position = map.camera.position.copy(
                    point = GeoPoint(
                        latitude = it.position.latitude,
                        longitude = it.position.longitude
                    ),
                )
            )
        }
    }

    private fun selectPanorama(marker: Marker) {
        if (selectedPanorama != null) {
            unselectPanorama()
        }

        selectedPanorama = marker
        selectedPanorama?.icon = panoramaMarkerSelected
        selectedPanorama?.anchor = Anchor(x = 0.5f, y = 0.95f)

        val data = marker.userData
        if (data is PhotoData) {
            selectedPanorama?.iconMapDirection = MapDirection(value = data.azimuth)
        }
    }

    fun unselectPanorama() {
        selectedPanorama?.icon = panoramaMarkerImage
        selectedPanorama?.anchor = Anchor(x = 0.5f, y = 0.5f)
        selectedPanorama?.iconMapDirection = null
        selectedPanorama = null
    }

    fun setPanoramasAzimuth(degrees: Double) {
        selectedPanorama?.iconMapDirection = MapDirection(value = degrees)
    }

    fun calcPositionForMarkers(
        markers: List<String>,
        options: CalcPositionOptionsMessage,
        result: Result<CameraPositionMessage>?
    ) {
        calcPositionForObjects(
            objects =  markers.mapNotNull { this.markers[it]?.first },
            options = options,
            result = result
        )
    }

    fun calcPositionForPolygons(
        polygons: List<String>,
        options: CalcPositionOptionsMessage,
        result: Result<CameraPositionMessage>?
    ) {
        calcPositionForObjects(
            objects =  polygons.mapNotNull { this.polygons[it] },
            options = options,
            result = result
        )
    }

    fun calcPositionForPolylines(
        polylines: List<String>,
        options: CalcPositionOptionsMessage,
        result: Result<CameraPositionMessage>?
    ) {
        calcPositionForObjects(
            objects =  polylines.mapNotNull { this.polylines[it] },
            options = options,
            result = result
        )
    }

    private fun calcPositionForObjects(
        objects: List<SimpleMapObject>,
        options: CalcPositionOptionsMessage,
        result: Result<CameraPositionMessage>?
    ) {
        val cameraPosition = calcPosition(
            camera = map.camera,
            objects = objects,
            screenArea = options.screenArea?.let {
                Padding(
                    left = it.leftPadding.toInt(),
                    top = it.topPadding.toInt(),
                    right = it.rightPadding.toInt(),
                    bottom = it.bottomPadding.toInt()
                )
            },
            tilt = options.tilt?.let {
                Tilt(it.toFloat())
            },
            bearing = options.bearing?.let {
                Bearing(it)
            },
            size = options.size?.let {
                ScreenSize(
                    width = it.width.toInt(),
                    height = it.height.toInt()
                )
            }
        )

        result?.success(
            CameraPositionMessage
                .Builder()
                .setPoint(cameraPosition.point.toMessage())
                .setZoom(cameraPosition.zoom.value.toDouble())
                .setTilt(cameraPosition.tilt.value.toDouble())
                .setBearing(cameraPosition.bearing.value)
                .build()
        )
    }

    private fun onDgisMapObjectTap(mapObject: DgisMapObject, roi: RenderedObjectInfo) {
        sendDgisObjectEvent(mapObject.id, roi.closestMapPoint, roi.item.levelId)
    }

    private fun onMarkerTap(marker: Marker) {
        when (val userData = marker.userData) {
            is PhotoData -> onMarkerWithPhotoTap(marker, userData)
            is DgisObjectId -> onSearchMarkerTap(marker, userData)
            is MarkerId -> onMarkerTap(userData.id)
        }
    }

    private fun onMarkerTap(id: String) {
        eventSink.success(
            mapOf(
                "event" to Events.onMarkerTap.name,
                "id" to id
            )
        )
    }

    private fun onRoadEventTap(event: RoadEventMapObject) {
        when (event.event.type) {
            RoadEventType.ROAD_RESTRICTION -> {
                eventSink.success(
                    mapOf(
                        "event" to Events.onRoadEventTap.name,
                        "title" to event.event.name,
                        "description" to event.event.description,
                        "startTime" to event.event.schedule?.startTime?.timeFromEpoch?.inSeconds,
                        "finishTime" to event.event.schedule?.finishTime?.timeFromEpoch?.inSeconds,
                        "latitude" to event.event.location.latitude.value,
                        "longitude" to event.event.location.longitude.value,
                    )
                )
            }
            else -> {}
        }
    }

    private fun onClusterTap(id: String, cluster: SimpleClusterObject, clusterId: String) {
        eventSink.success(
            mapOf(
                "event" to Events.onClusterTap.name,
                "id" to id,
                "cluster" to cluster.toMap(clusterId),
            )
        )
    }

    private fun onPolygonTap(id: String) {
        eventSink.success(
            mapOf(
                "event" to Events.onPolygonTap.name,
                "id" to id
            )
        )
    }

    private fun onPolylineTap(id: String) {
        eventSink.success(
            mapOf(
                "event" to Events.onPolylineTap.name,
                "id" to id
            )
        )
    }

    private fun onSearchMarkerTap(marker: Marker, id: DgisObjectId) {
        this.lastTappedSearchMarker?.iconOpacity = Opacity(1f)

        marker.iconOpacity = Opacity(0f)
        this.lastTappedSearchMarker = marker

        sendDgisObjectEvent(id, marker.position)
    }

    private fun onMarkerWithPhotoTap(marker: Marker, photoData: PhotoData) {
        selectPanorama(marker)
        eventSink.success(
            mapOf(
                "event" to Events.onMarkerWithPhotoTap.name,
                "latlng" to mapOf(
                    "latitude" to marker.position.latitude.value,
                    "longitude" to marker.position.longitude.value,
                ),
                "photoData" to mapOf(
                    "photoUrl" to photoData.photoUrl,
                    "isPanoramic" to photoData.isPanoramic,
                    "azimuth" to photoData.azimuth,
                ),
            )
        )
    }

    override fun close() {
        panoramasMarkers.clear()
        mapObjectsExecutorService.shutdown()
    }

    private fun sendDgisObjectEvent(id: DgisObjectId, position: GeoPointWithElevation, levelId: LevelId? = null) {
        eventSink.success(
            mapOf(
                "event" to Events.onObjectTap.name,
                "dgisObjectId" to mapOf(
                    "objectId" to id.objectId,
                    "entranceId" to id.entranceId,
                ),
                "levelId" to levelId?.value,
                "latlng" to mapOf(
                    "latitude" to position.latitude.value,
                    "longitude" to position.longitude.value,
                ),
            )
        )
    }

    fun getNearestObjects(result: Result<List<RenderedObjectMessage>>) {
        val cameraPosition = map.camera.position
        val screenPoint = map.camera.projection.mapToScreen(cameraPosition.point)
        if (screenPoint == null) {
            result.error(IllegalArgumentException("Map has not been initialized"))
        }

        renderedObjectsCloseable = map.getRenderedObjects(screenPoint!!, ScreenDistance(1F)).apply {
            onResult { objects ->
                result.success(
                    objects
                        .filter {
                            it.item.item is DgisMapObject
                        }
                        .map<RenderedObjectInfo, RenderedObjectMessage> {
                            RenderedObjectMessage.Builder()
                                .setObject((it.item.item as DgisMapObject).id.toMessage())
                                .setClosestMapPoint(it.closestMapPoint.toMessage())
                                .build()
                        }
                        .toList()
                )
            }
            onError {
                result.error(it)
            }
        }
    }


    private class AddMarkersTask(
        private val mapObjectManager: MapObjectManager,
        private val message: AddMarkersWithPhotoMessage,
        private val markers: MutableList<Marker>,
        private val icon: Image?
    ) : Runnable {

        override fun run() {
            val newObjects = mutableListOf<Marker>()
            message.markers.forEach {
                val opts = MarkerOptions(
                    it.position.toGeoPointWithElevation(),
                    icon = icon
                )
                val marker = Marker(opts)

                val photoData = PhotoData(
                        photoUrl = it.photoUrl,
                        isPanoramic = it.isPanoramic,
                        azimuth = it.azimuth)
                marker.userData = photoData
                newObjects.add(marker)
            }
            mapObjectManager.addObjects(newObjects)
            markers.addAll(newObjects)
        }
    }
}

private enum class Events {
    onObjectTap,
    onMarkerWithPhotoTap,
    onIoTap,
    onIdleTap,
    onMarkerTap,
    onRoadEventTap,
    onClusterTap,
    onPolygonTap,
    onPolylineTap,
}

private fun Attributes.mapIo(point: GeoPointWithElevation): Map<String, Any> = mapOf(
    "event" to Events.onIoTap.name,
    "description" to (getAttributeValue("OPPORTUNITYDESCRIPTION").asString ?: ""),
    "area" to (getAttributeValue("TOTALSPACEINMETERS").asNumber ?: -1.0),
    "type" to (getAttributeValue("OPPORTUNITYTYPE").asString ?: ""),
    "status" to (getAttributeValue("STATUS").asString ?: ""),
    "price" to (getAttributeValue("RFPPRICE").asNumber ?: -1.0),
    "startDate" to (getAttributeValue("STARTDATE").asString ?: ""),
    "endDate" to (getAttributeValue("ENDDATE").asString ?: ""),
    "latitude" to point.latitude.value,
    "longitude" to point.longitude.value,
)

private fun Attributes.mapIdle(point: GeoPointWithElevation): Map<String, Any> = mapOf(
    "event" to Events.onIdleTap.name,
    "landuse" to (getAttributeValue("LANDUSE").asString ?: ""),
    "description" to (getAttributeValue("DESCRIPTION").asString ?: ""),
    "area" to (getAttributeValue("PARCELAREA").asNumber ?: -1.0),
    "parcelName" to (getAttributeValue("PARCELNAME").asString ?: ""),
    "phase" to (getAttributeValue("PHASE").asString ?: ""),
    "createdDate" to (getAttributeValue("CREATED_DATE").asString ?: ""),
    "amanaName" to (getAttributeValue("AMANANAME").asString ?: ""),
    "munName" to (getAttributeValue("MUNNAME").asString ?: ""),
    "status" to (getAttributeValue("STATUS").asString ?: ""),
    "streetName" to (getAttributeValue("STREETNAME").asString ?: ""),
    "planNo" to (getAttributeValue("PLANNO").asString ?: ""),
    "latitude" to point.latitude.value,
    "longitude" to point.longitude.value,
)
