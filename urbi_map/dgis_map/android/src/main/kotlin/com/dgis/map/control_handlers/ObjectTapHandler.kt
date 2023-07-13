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
    private val markerExecutorService by unsafeLazy {
        Executors.newSingleThreadExecutor()
    }

    private val ioLayerMarkers = mutableListOf<Marker>();

    fun objectTapListener(roi: RenderedObjectInfo) {
        when (val tappedObject = roi.item.item) {
            is Marker -> {
                onMarkerTap(tappedObject)
                return
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

    fun addMarker(geoPoint: GeoPointMessage, result: Result<Void>?) {
        val markerImage = markerImage
        val iconWidth = iconWidth

        if (markerImage == null || iconWidth == null) {
            result?.error(Exception("Error adding marker. Call setMarkerOptions method first"))
            return
        }

        val options = MarkerOptions(
            position = GeoPointWithElevation(
                latitude = geoPoint.latitude,
                longitude = geoPoint.longitude,
            ),
            icon = markerImage,
            iconWidth = iconWidth,
            anchor = Anchor(0.5f, 1f)
        )

        val marker = Marker(options)

        markerExecutorService.submit {
            mapObjectManager.removeAll()
            mapObjectManager.addObject(marker)
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
        markerExecutorService.submit {
            ioObjectManager.removeAndAddObjects(ioLayerMarkers, markers)
            ioLayerMarkers.clear()
            ioLayerMarkers.addAll(markers)
            result?.success(null)
        }
    }

    fun removeAllMarkers() {
        markerExecutorService.submit {
            mapObjectManager.removeAll()
            ioObjectManager.removeAll()
            ioLayerMarkers.clear()
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
        markerExecutorService.submit(
            AddMarkersTask(
                mapObjectManager = panoramasObjectManager,
                message = message,
                markers = panoramasMarkers,
                icon = panoramaMarkerImage,
            )
        )
    }

    fun showPanoramasMarkers() {
        markerExecutorService.submit {
            panoramasObjectManager.isVisible = true
        }
    }

    fun hidePanoramasMarkers() {
        markerExecutorService.submit {
            panoramasObjectManager.isVisible = false
        }
    }

    fun removePanoramasMarkers() {
        markerExecutorService.submit {
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
        }
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
        markerExecutorService.shutdown()
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
