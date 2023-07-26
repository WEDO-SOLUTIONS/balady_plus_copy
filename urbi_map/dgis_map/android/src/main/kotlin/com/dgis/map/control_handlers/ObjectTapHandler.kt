package com.dgis.map.control_handlers

import android.util.Size
import com.dgis.map.R
import com.dgis.map.extensions.unsafeLazy
import com.dgis.map.map_api.Messages.*
import com.dgis.map.user_data.PhotoData
import io.flutter.FlutterInjector
import io.flutter.plugin.common.EventChannel.EventSink
import ru.dgis.sdk.Context
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.Latitude
import ru.dgis.sdk.coordinates.Longitude
import ru.dgis.sdk.geometry.Elevation
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.map.*
import java.io.FileNotFoundException
import java.util.concurrent.Executors

class ObjectTapHandler(
    private val mapObjectManager: MapObjectManager,
    private val panoramasObjectManager: MapObjectManager,
    private val ioObjectManager: MapObjectManager,
    private val routeHandler: RouteHandler?,
    private val sdkContext: Context,
    private val eventSink: EventSink,
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

    private data class MarkerId(val id: Int);
    private data class PolygonId(val id: Int);

    private data class PolylineId(val id: Int);

    private val markers = mutableMapOf<Int, Marker>();
    private val polygons = mutableMapOf<Int, Polygon>();
    private val polylines = mutableMapOf<Int, Polyline>();
    private val ioLayerMarkers = mutableListOf<Marker>();

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
//            is DgisMapObject -> {
//                onDgisMapObjectTap(tappedObject, roi)
//                return
//            }
            is RouteMapObject -> {
                routeHandler?.onRouteTap(tappedObject)
            }
            is SimpleClusterObject -> {
                val mainObject = if (tappedObject.objectCount > 0) tappedObject.objects[0] else null
                if (mainObject is Marker) {
                    onMarkerTap(mainObject)
                    return
                } else {
                    eventSink.error(
                        "ClusteredObjectNoMarkers",
                        "Clustered object has no markers",
                        null,
                    )
                    return
                }
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

    private fun mapTextPlacement(placementMessage: TextPlacementMessage): TextPlacement {
        return when (placementMessage) {
            TextPlacementMessage.NO_LABEL -> TextPlacement.NO_LABEL
            TextPlacementMessage.BOTTOM_CENTER -> TextPlacement.BOTTOM_CENTER
            TextPlacementMessage.BOTTOM_RIGHT -> TextPlacement.BOTTOM_RIGHT
            TextPlacementMessage.BOTTOM_LEFT -> TextPlacement.BOTTOM_LEFT
            TextPlacementMessage.CIRCLE_BOTTOM_RIGHT -> TextPlacement.CIRCLE_BOTTOM_LEFT
            TextPlacementMessage.RIGHT_BOTTOM -> TextPlacement.RIGHT_BOTTOM
            TextPlacementMessage.RIGHT_CENTER -> TextPlacement.RIGHT_CENTER
            TextPlacementMessage.RIGHT_TOP -> TextPlacement.RIGHT_TOP
            TextPlacementMessage.CIRCLE_TOP_RIGHT -> TextPlacement.CIRCLE_TOP_RIGHT
            TextPlacementMessage.TOP_CENTER -> TextPlacement.TOP_CENTER
            TextPlacementMessage.TOP_RIGHT -> TextPlacement.TOP_RIGHT
            TextPlacementMessage.TOP_LEFT -> TextPlacement.TOP_LEFT
            TextPlacementMessage.CIRCLE_TOP_LEFT -> TextPlacement.CIRCLE_TOP_LEFT
            TextPlacementMessage.LEFT_TOP -> TextPlacement.LEFT_TOP
            TextPlacementMessage.LEFT_CENTER -> TextPlacement.LEFT_CENTER
            TextPlacementMessage.LEFT_BOTTOM -> TextPlacement.LEFT_BOTTOM
            TextPlacementMessage.CIRCLE_BOTTOM_LEFT -> TextPlacement.CIRCLE_BOTTOM_LEFT
            TextPlacementMessage.CENTER_CENTER -> TextPlacement.CENTER_CENTER
        }
    }

    private fun mapTextStyle(style: MarkerTextStyleMessage): TextStyle {
        return TextStyle(
            fontSize = style.fontSize?.let {
                LogicalPixel(value = it.toFloat())
            } ?: LogicalPixel(8f),
            color = style.color?.let {
                Color(argb = it.toInt())
            } ?: Color(),
            strokeWidth = style.strokeWidth?.let {
                LogicalPixel(it.toFloat())
            } ?: LogicalPixel(0.35f),
            strokeColor = style.strokeColor?.let {
                Color(argb = it.toInt())
            } ?: Color(),
            textPlacement = style.textPlacement?.let {
                mapTextPlacement(it.placement)
            } ?: TextPlacement.BOTTOM_CENTER,
            textOffset = style.textOffset?.let {
                LogicalPixel(it.toFloat())
            } ?: LogicalPixel(0f),
            fontName = style.fontName
        )
    }

    private fun mapMarker(marker: MarkerMessage, result: Result<Void>?): Marker? {
        var markerImage: Image? = null
        if (marker.options.icon != null) {
            try {
                val asset =
                    FlutterInjector
                        .instance()
                        .flutterLoader()
                        .getLookupKeyForAsset(marker.options.icon!!.path)

                markerImage = imageFromAsset(sdkContext, asset, Size(0, 0))
            } catch (e: FileNotFoundException) {
                result?.error(e)
                return null
            }
        }

        val options = MarkerOptions(
            position = GeoPointWithElevation(
                latitude = Latitude(marker.options.position.latitude),
                longitude = Longitude(marker.options.position.longitude),
            ),
            icon = markerImage,
            iconMapDirection = marker.options.icon?.iconMapDirection?.let {
                MapDirection(it.degree)
            },
            anchor = marker.options.anchor?.let {
                Anchor(it.x.toFloat(), it.y.toFloat())
            } ?: Anchor(0.5f, 0.5f),
            text = marker.options.text,
            textStyle = marker.options.textStyle?.let {
                mapTextStyle(it)
            },
            iconWidth = marker.options.icon?.let {
                LogicalPixel(it.width.toFloat())
            } ?: LogicalPixel(0f),
            userData = MarkerId(marker.id.toInt()),
        )

        return Marker(options)
    }

    fun addMarker(marker: MarkerMessage, result: Result<Void>?) {
        val markerObject = mapMarker(marker, result) ?: return

        mapObjectsExecutorService.submit {
            markers[marker.id.toInt()] = markerObject
            mapObjectManager.addObject(markerObject)
            result?.success(null)
        }
    }

    fun addMarkers(markers: List<MarkerMessage>, result: Result<Void>?) {
        val markerObjects = mutableMapOf<Int, Marker>()
        for (marker in markers) {
            val markerObject = mapMarker(marker, result) ?: return
            markerObjects[marker.id.toInt()] = markerObject
        }

        mapObjectsExecutorService.submit {
            this.markers.putAll(markerObjects)
            mapObjectManager.addObjects(markerObjects.values.toList())
            result?.success(null)
        }
    }

    fun removeMarker(id: Long, result: Result<Void>?) {
        mapObjectsExecutorService.submit {
            markers.remove(id.toInt())?.also {
                mapObjectManager.removeObject(it)
            }
            result?.success(null)
        }
    }

    private fun mapPolygon(polygon: PolygonMessage): Polygon {
        val options = PolygonOptions(
            contours = polygon.options.contours.map { contour ->
                contour.map {
                    GeoPoint(
                        latitude = Latitude(it.latitude),
                        longitude = Longitude(it.longitude),
                    )
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
            userData = PolygonId(polygon.id.toInt())
        )

        return Polygon(options)
    }

    fun addPolygon(polygon: PolygonMessage, result: Result<Void>?) {
        val polygonObject = mapPolygon(polygon)

        mapObjectsExecutorService.submit {
            polygons[polygon.id.toInt()] = polygonObject
            mapObjectManager.addObject(polygonObject)
            result?.success(null)
        }
    }

    fun addPolygons(polygons: List<PolygonMessage>, result: Result<Void>?) {
        val polygonObjects = polygons.associateBy({
             it.id.toInt()
        }, {
            mapPolygon(it)
        })

        mapObjectsExecutorService.submit {
            this.polygons.putAll(polygonObjects)
            mapObjectManager.addObjects(polygonObjects.values.toList())
            result?.success(null)
        }
    }

    fun removePolygon(id: Long, result: Result<Void>?) {
        mapObjectsExecutorService.submit {
            polygons.remove(id.toInt())?.also {
                mapObjectManager.removeObject(it)
            }
            result?.success(null)
        }
    }
    private fun mapPolyline(polyline: PolylineMessage): Polyline {
        val options = PolylineOptions(
            points = polyline.options.points.map {
                GeoPoint(
                    latitude = Latitude(it.latitude),
                    longitude = Longitude(it.longitude),
                )
            },
            color = polyline.options.color?.let {
                Color(argb = it.toInt())
            } ?: Color(),
            width = polyline.options.width?.let {
                LogicalPixel(it.toFloat())
            } ?: LogicalPixel(1f),
            userData = PolylineId(polyline.id.toInt()),
        )

        return Polyline(options)
    }

    fun addPolyline(polyline: PolylineMessage, result: Result<Void>?) {
        val polylineObject = mapPolyline(polyline)

        mapObjectsExecutorService.submit {
            polylines[polyline.id.toInt()] = polylineObject
            mapObjectManager.addObject(polylineObject)
            result?.success(null)
        }
    }

    fun addPolylines(polylines: List<PolylineMessage>, result: Result<Void>?) {
        val polylineObjects = polylines.associateBy({
            it.id.toInt()
        }, {
            mapPolyline(it)
        })

        mapObjectsExecutorService.submit {
            this.polylines.putAll(polylineObjects)
            mapObjectManager.addObjects(polylineObjects.values.toList())
            result?.success(null)
        }
    }

    fun removePolyline(id: Long, result: Result<Void>?) {
        mapObjectsExecutorService.submit {
            polylines.remove(id.toInt())?.also {
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

    fun removeAllMarkers() {
        mapObjectsExecutorService.submit {
            mapObjectManager.removeObjects(markers.values.toList())
            markers.clear()
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
        val source = source
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
        map.camera.setPadding(
            Padding(
                left = message.leftPadding.toInt(),
                top = message.topPadding.toInt(),
                right = message.rightPadding.toInt(),
                bottom = message.topPadding.toInt()
            )
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

    private fun onDgisMapObjectTap(mapObject: DgisMapObject, roi: RenderedObjectInfo) {
        source = roi.item.source as DgisSource

        sendDgisObjectEvent(mapObject.id, roi.closestMapPoint)
    }

    private fun onMarkerTap(marker: Marker) {
        when (val userData = marker.userData) {
            is PhotoData -> onMarkerWithPhotoTap(marker, userData)
            is DgisObjectId -> onSearchMarkerTap(marker, userData)
            is MarkerId -> onMarkerTap(userData.id)
        }
    }

    private fun onMarkerTap(id: Int) {
        eventSink.success(
            mapOf(
                "event" to Events.onMarkerTap.name,
                "id" to id
            )
        )
    }

    private fun onPolygonTap(id: Int) {
        eventSink.success(
            mapOf(
                "event" to Events.onPolygonTap.name,
                "id" to id
            )
        )
    }

    private fun onPolylineTap(id: Int) {
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

    private fun sendDgisObjectEvent(id: DgisObjectId, position: GeoPointWithElevation) {
        eventSink.success(
            mapOf(
                "event" to Events.onObjectTap.name,
                "dgisObjectId" to mapOf(
                    "objectId" to id.objectId,
                    "entranceId" to id.entranceId,
                ),
                "latlng" to mapOf(
                    "latitude" to position.latitude.value,
                    "longitude" to position.longitude.value,
                ),
            )
        )
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
                val geoPoint = it.position.point
                val elevation = it.position.elevation
                val opts = MarkerOptions(
                    GeoPointWithElevation(
                        latitude = geoPoint.latitude,
                        longitude = geoPoint.longitude,
                        elevation = Elevation(elevation.toFloat())
                    ),
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
