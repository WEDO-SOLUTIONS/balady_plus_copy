package com.dgis.map.control_handlers

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import android.util.Size
import com.dgis.map.FlutterClusterRenderer
import com.dgis.map.R
import com.dgis.map.extensions.toGeoPoint
import com.dgis.map.extensions.toGeoPointWithElevation
import com.dgis.map.extensions.toMap
import com.dgis.map.extensions.toMessage
import com.dgis.map.extensions.toTextStyle
import com.dgis.map.extensions.unsafeLazy
import com.dgis.map.map_api.*
import com.dgis.map.user_data.PhotoData
import io.flutter.FlutterInjector
import io.flutter.plugin.common.EventChannel.EventSink
import java.io.FileNotFoundException
import java.lang.IllegalArgumentException
import java.util.*
import java.util.concurrent.Executors
import ru.dgis.sdk.Context
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.LevelId
import ru.dgis.sdk.Meter
import ru.dgis.sdk.ScreenSize
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.map.*
import ru.dgis.sdk.road_events.RoadEventType
import ru.dgis.sdk.geometry.ComplexGeometry
import ru.dgis.sdk.geometry.PointGeometry

class ObjectTapHandler(
        private val map: ru.dgis.sdk.map.Map,
        private val mapObjectManager: MapObjectManager,
        private val panoramasObjectManager: MapObjectManager,
        private val ioObjectManager: MapObjectManager,
        private val routeHandler: RouteHandler?,
        private val sdkContext: Context,
        private val androidContext: android.content.Context,
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
    private val mapObjectsExecutorService by unsafeLazy { Executors.newSingleThreadExecutor() }

    data class MarkerId(val id: String)

    private data class PolygonId(val id: String)

    private data class PolylineId(val id: String)

    private data class CircleId(val id: String)

    private data class ModelId(val id: String)

    private val markers = mutableMapOf<String, Pair<Marker, String?>>()
    private val models = mutableMapOf<String, Pair<ModelMapObject, String?>>()
    private val polygons = mutableMapOf<String, Pair<Polygon, String?>>()
    private val circles = mutableMapOf<String, Pair<Circle, String?>>()
    private val polylines = mutableMapOf<String, Pair<Polyline, String?>>()
    private val clusters = mutableMapOf<String, SimpleClusterObject>()
    private val ioLayerMarkers = mutableListOf<Marker>()
    private val managers = mutableMapOf<String, MapObjectManager>()
    private val managerLayerIds = mutableMapOf<String, String?>()
    private val defaultModelManager by unsafeLazy { MapObjectManager(map) }

    private val iconCache = mutableMapOf<String, Image>()
    private val modelDataCache = mutableMapOf<String, ModelData>()

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
        //            else -> eventSink.error("ClassCastException", "tapped object class is not
        // supported", null)
        //        }
        // Dynamic-POI markers open the POI card on short tap (and update
        // the selected-state). All other markers stay on the long-press-only
        // contract introduced in iter4 — short taps on them fall through.
        when (val tappedObject = roi.item.item) {
            is Marker -> {
                val markerId = (tappedObject.userData as? MarkerId)?.id
                if (markerId != null && markerId.startsWith("dynamic_poi_")) {
                    onMarkerTap(tappedObject)
                }
                return
            }
            is ModelMapObject -> {
                val userData = tappedObject.userData
                if (userData is ModelId) {
                    onModelTap(userData.id)
                }
                return
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

            else ->
                    eventSink.error(
                            "ClassCastException",
                            "No suitable handler for tapped object: " + tappedObject.javaClass,
                            null,
                    )
        }
    }
    fun objectLongTapListener(roi: RenderedObjectInfo) {
        when (val tappedObject = roi.item.item) {
            is Marker -> {
                onMarkerTap(tappedObject)
                return
            }
            is ModelMapObject -> {
                val userData = tappedObject.userData

                if (userData is ModelId) {
                    onModelTap(userData.id)
                    return
                }
            }
            is Polygon -> {
                val userData = tappedObject.userData

                if (userData is PolygonId) {
                    onPolygonTap(userData.id)
                    return
                }
            }
            is Circle -> {
                val userData = tappedObject.userData

                if (userData is CircleId) {
                    onCircleTap(userData.id)
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
            is MyLocationMapObject -> {
                sendDgisMyLocationEvent(roi.closestMapPoint)
                return
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
            else ->
                    eventSink.error(
                            "ClassCastException",
                            "No suitable handler for tapped object: " + tappedObject.javaClass,
                            null,
                    )
        }
    }

    /// --- HELPERS ---
    private fun getManager(managerId: String?): MapObjectManager {
        if (managerId != null && managers[managerId] != null) {
            return managers[managerId]!!
        }
        return this.mapObjectManager
    }

    private fun <T : SimpleMapObject> getObjectsFromPair(
            objects: MutableMap<String, Pair<T, String?>>
    ): List<SimpleMapObject> {
        return objects.values.map { it.first }.toList()
    }

    private fun <T> removeAllObjects(
            managerId: String?,
            objects: MutableMap<String, Pair<T, String?>>,
            callback: (Result<Unit>) -> Unit
    ) {
        mapObjectsExecutorService.submit {
            getManager(managerId).removeAll()
            val hasManager = managerId != null && managers[managerId] != null
            if (hasManager) {
                val filtered = objects.filter { it.value.second != managerId }.toMutableMap()
                objects.clear()
                objects.putAll(filtered)
            } else {
                objects.clear()
            }
            callback(Result.success(Unit))
        }
    }

    // --- MARKER ---

    fun getImageFromBytes(imageBytes: ByteArray, size: Int): Image? {
        // Шаг 1: Преобразование байтов в Bitmap
        val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)

        val scaledBitmap =
                if (bitmap != null) {
                    Bitmap.createScaledBitmap(bitmap, size, size, true)
                } else {
                    null
                }

        // Шаг 2: Использование метода imageFromBitmap для получения объекта Image
        return if (scaledBitmap != null) {
            imageFromBitmap(sdkContext, scaledBitmap)
        } else {
            null
        }
    }

    private fun getImageFromAsset(
            assetPath: String,
            size: Size,
            callback: (Result<Unit>) -> Unit
    ): Image? {
        if (iconCache.containsKey(assetPath)) {
            return iconCache[assetPath]
        }

        return try {
            val assetKey =
                    FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(assetPath)
            val markerImage = imageFromAsset(sdkContext, assetKey, size)

            iconCache[assetPath] = markerImage
            markerImage
        } catch (e: FileNotFoundException) {
            callback(Result.failure(e))
            null
        }
    }

    // PNG asset path: read bytes, decode + scale via BitmapFactory, then go
    // through `imageFromBitmap`. The SDK's `imageFromAsset(..., Size)` overload
    // mis-handles raster PNGs — Size(width, width) draws clipped/zoomed on
    // hi-DPI, and Size(0, 0) yields no image at all. The bitmap path is the
    // same one `pngData` already uses successfully.
    private fun getPngImageFromAsset(
            assetPath: String,
            widthLogical: Int,
            callback: (Result<Unit>) -> Unit
    ): Image? {
        if (iconCache.containsKey(assetPath)) {
            return iconCache[assetPath]
        }

        return try {
            val assetKey =
                    FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(assetPath)
            val pixelSize = (widthLogical * androidContext.resources.displayMetrics.density).toInt()
            val stream: java.io.InputStream = androidContext.assets.open(assetKey)
            val bytes = stream.use { it.readBytes() }
            val image = getImageFromBytes(bytes, if (pixelSize > 0) pixelSize else widthLogical)
            if (image != null) {
                iconCache[assetPath] = image
            }
            image
        } catch (e: FileNotFoundException) {
            callback(Result.failure(e))
            null
        }
    }

    private fun mapMarker(marker: MarkerMessage, callback: (Result<Unit>) -> Unit): Marker {
        var markerImage: Image? = null
        if (marker.options.icon != null) {

            val iconOptions = marker.options.icon

            val svgPath = iconOptions.svgPath
            val pngPath = iconOptions.pngPath
            val pngData = iconOptions.pngData

            if (svgPath != null) {
                markerImage = getImageFromAsset(svgPath, Size(0, 0), callback)
            } else if (pngPath != null) {
                Log.d(
                    "MakkahPinDebug.Android",
                    "addMarker pngPath=$pngPath width=${iconOptions.width}"
                )
                markerImage = getPngImageFromAsset(pngPath, iconOptions.width.toInt(), callback)
            } else if (pngData != null) {
                // Same density fix as getPngImageFromAsset above: pngData
                // was scaled to the raw logical width, with no density
                // multiplier, then stretched by the SDK to iconWidth logical
                // points on-screen — blurry/pixelated on hi-DPI screens.
                val data = pngData
                val pixelSize = (iconOptions.width * androidContext.resources.displayMetrics.density).toInt()
                markerImage = getImageFromBytes(data, if (pixelSize > 0) pixelSize else iconOptions.width.toInt())
            }
        }

        val options =
                MarkerOptions(
                        position = marker.options.position.toGeoPointWithElevation(),
                        icon = markerImage,
                        iconMapDirection =
                                marker.options.icon?.iconMapDirection?.let {
                                    MapDirection(it.degree)
                                },
                        anchor =
                                marker.options.anchor?.let {
                                    Anchor(it.x.toFloat(), it.y.toFloat())
                                }
                                        ?: Anchor(0.5f, 0.5f),
                        text = marker.options.text,
                        textStyle = marker.options.textStyle?.toTextStyle(),
                        iconWidth = marker.options.icon?.let { LogicalPixel(it.width.toFloat()) }
                                        ?: LogicalPixel(0f),
                        userData = MarkerId(marker.id),
                        animatedAppearance = marker.options.animatedAppearance ?: false,
                        zIndex = ZIndex(marker.options.zIndex?.toInt() ?: 0),
            visible = (marker.options.isVisible ?: true),
            iconOpacity = Opacity(marker.options.icon?.iconOpacity?.toFloat() ?: 1.0f)
        )

        return Marker(options)
    }

    fun addMarker(marker: MarkerMessage, managerId: String?, callback: (Result<Unit>) -> Unit) {
        val markerObject = mapMarker(marker, callback) ?: return

        mapObjectsExecutorService.submit {
            markers[marker.id] = Pair(markerObject, managerId)
            getManager(managerId).addObject(markerObject)
            callback(Result.success(Unit))
        }
    }

    fun setMarkerOptions(
            id: String,
            options: ChangeMarkerOptionsMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        var markerImage: Image? = null
        if (options.icon != null) {
            val iconOptions = options.icon

            val svgPath = iconOptions.svgPath
            val pngPath = iconOptions.pngPath
            val pngData = iconOptions.pngData

            if (svgPath != null) {
                markerImage = getImageFromAsset(svgPath, Size(0, 0), callback)
            } else if (pngPath != null) {
                Log.d(
                    "MakkahPinDebug.Android",
                    "setMarkerOptions pngPath=$pngPath width=${iconOptions.width}"
                )
                markerImage = getPngImageFromAsset(pngPath, iconOptions.width.toInt(), callback)
            } else if (pngData != null) {
                // Same density fix as mapMarker's pngData branch above.
                val data = pngData
                val pixelSize = (iconOptions.width * androidContext.resources.displayMetrics.density).toInt()
                markerImage = getImageFromBytes(data, if (pixelSize > 0) pixelSize else iconOptions.width.toInt())
            }
        }

        options.position?.let { position ->
            markers[id]?.first?.position = position.toGeoPointWithElevation()
        }
        markerImage?.let { image -> markers[id]?.first?.icon = image }
        options.icon?.iconMapDirection?.let { iconMapDirection ->
            markers[id]?.first?.iconMapDirection = MapDirection(iconMapDirection.degree)
        }
        options.anchor?.let { anchor ->
            markers[id]?.first?.anchor = Anchor(anchor.x.toFloat(), anchor.y.toFloat())
        }
        options.text?.let { text -> markers[id]?.first?.text = text }
        options.textStyle?.let { textStyle ->
            markers[id]?.first?.textStyle = textStyle.toTextStyle()
        }
        options.icon?.width?.let { iconWidth ->
            markers[id]?.first?.iconWidth = LogicalPixel(iconWidth.toFloat())
        }
        options.zIndex?.let { zIndex -> markers[id]?.first?.zIndex = ZIndex(zIndex.toInt()) }
        options.icon?.iconOpacity?.let { iconOpacity ->
            markers[id]?.first?.iconOpacity = Opacity(iconOpacity.toFloat())
        }
        options.animatedAppearance?.let { animatedAppearance ->
            markers[id]?.first?.animatedAppearance = animatedAppearance
        }
        options.isVisible?.let { isVisible ->
            markers[id]?.first?.isVisible = isVisible
        }

        // If an icon change was requested but markerImage is still null,
        // getImageFromAsset/getPngImageFromAsset already invoked `callback`
        // with a failure above — calling it again here would double-invoke
        // it (mirrors the pattern addMarker/mapMarker use elsewhere in this
        // file to avoid the same double-callback after a failed icon load).
        val iconChangeFailed =
                (options.icon?.svgPath != null || options.icon?.pngPath != null) && markerImage == null
        if (!iconChangeFailed) {
            callback(Result.success(Unit))
        }
    }

    fun addMarkers(
            markers: List<MarkerMessage>,
            managerId: String?,
            callback: (Result<Unit>) -> Unit
    ) {
        val markerObjects = mutableMapOf<String, Pair<Marker, String?>>()
        for (marker in markers) {
            val markerObject = mapMarker(marker, callback) ?: return
            markerObjects[marker.id] = Pair(markerObject, managerId)
        }

        mapObjectsExecutorService.submit {
            this.markers.putAll(markerObjects)
            getManager(managerId).addObjects(getObjectsFromPair(markerObjects))
            callback(Result.success(Unit))
        }
    }

    fun removeMarker(id: String, managerId: String?, callback: (Result<Unit>) -> Unit) {
        mapObjectsExecutorService.submit {
            markers.remove(id)?.also { getManager(managerId).removeObject(it.first) }
            callback(Result.success(Unit))
        }
    }

    fun removeAllMarkers(managerId: String?, callback: (Result<Unit>) -> Unit) {
        removeAllObjects(managerId, markers, callback)
    }

    /// --- 3D MODEL ---

    private fun getModelDataFromAsset(
            modelPath: String,
            callback: (Result<Unit>) -> Unit
    ): ModelData? {
        modelDataCache[modelPath]?.let { return it }

        return try {
            val asset = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(modelPath)
            val bytes = androidContext.assets.open(asset).use { it.readBytes() }
            val modelData = createModelData(sdkContext, bytes)
            modelDataCache[modelPath] = modelData
            modelData
        } catch (e: Exception) {
            callback(Result.failure(e))
            null
        }
    }

    private fun ModelSizeMessage.toModelSize(): ModelSize =
            when (type) {
                ModelSizeTypeMessage.LOGICAL_PIXEL -> ModelSize(LogicalPixel(value.toFloat()))
                ModelSizeTypeMessage.SCALE -> ModelSize(ModelScale(value.toFloat()))
            }

    private fun mapModel(
            model: ModelMapObjectMessage,
            callback: (Result<Unit>) -> Unit
    ): ModelMapObject? {
        val modelData = getModelDataFromAsset(model.options.modelPath, callback) ?: return null

        val options =
                ModelMapObjectOptions(
                        position = model.options.position.toGeoPointWithElevation(),
                        data = modelData,
                        size = model.options.size.toModelSize(),
                        mapDirection =
                                model.options.mapDirection?.let {
                                    MapDirection(it.degree)
                                },
                        opacity = Opacity(model.options.opacity?.toFloat() ?: 1.0f),
                        visible = model.options.isVisible ?: true,
                        userData = ModelId(model.id),
                        levelId = model.options.levelId?.let { LevelId(value = it.value) },
                )

        return try {
            ModelMapObject(options).also { modelObject ->
                model.options.zIndex?.let { zIndex -> modelObject.zIndex = ZIndex(zIndex.toInt()) }
            }
        } catch (e: Exception) {
            callback(Result.failure(e))
            null
        }
    }

    fun addModel(
            model: ModelMapObjectMessage,
            managerId: String?,
            callback: (Result<Unit>) -> Unit
    ) {
        val modelObject = mapModel(model, callback) ?: return

        mapObjectsExecutorService.submit {
            models[model.id] = Pair(modelObject, managerId)
            defaultModelManager.addObject(modelObject)
            callback(Result.success(Unit))
        }
    }

    fun setModelOptions(
            id: String,
            options: ChangeModelMapObjectOptionsMessage,
            callback: (Result<Unit>) -> Unit
    ) {
        val modelObject = models[id]?.first
        if (modelObject == null) {
            callback(Result.success(Unit))
            return
        }

        options.position?.let { position ->
            modelObject.position = position.toGeoPointWithElevation()
        }
        options.modelPath?.let { modelPath ->
            val modelData = getModelDataFromAsset(modelPath, callback) ?: return
            modelObject.modelData = modelData
        }
        options.size?.let { size -> modelObject.size = size.toModelSize() }
        options.mapDirection?.let { mapDirection ->
            modelObject.mapDirection = MapDirection(mapDirection.degree)
        }
        options.opacity?.let { opacity -> modelObject.opacity = Opacity(opacity.toFloat()) }
        options.isVisible?.let { isVisible -> modelObject.isVisible = isVisible }
        options.zIndex?.let { zIndex -> modelObject.zIndex = ZIndex(zIndex.toInt()) }
        callback(Result.success(Unit))
    }

    fun addModels(
            models: List<ModelMapObjectMessage>,
            managerId: String?,
            callback: (Result<Unit>) -> Unit
    ) {
        val modelObjects = mutableMapOf<String, Pair<ModelMapObject, String?>>()
        for (model in models) {
            val modelObject = mapModel(model, callback) ?: return
            modelObjects[model.id] = Pair(modelObject, managerId)
        }

        mapObjectsExecutorService.submit {
            this.models.putAll(modelObjects)
            defaultModelManager.addObjects(getObjectsFromPair(modelObjects))
            callback(Result.success(Unit))
        }
    }

    fun removeModel(id: String, managerId: String?, callback: (Result<Unit>) -> Unit) {
        mapObjectsExecutorService.submit {
            models.remove(id)?.also { defaultModelManager.removeObject(it.first) }
            callback(Result.success(Unit))
        }
    }

    fun removeAllModels(managerId: String?, callback: (Result<Unit>) -> Unit) {
        mapObjectsExecutorService.submit {
            val hasManager = managerId != null && managers[managerId] != null
            if (hasManager) {
                val removed = models.filter { it.value.second == managerId }
                removed.values.forEach { defaultModelManager.removeObject(it.first) }
                removed.keys.forEach { models.remove(it) }
            } else {
                defaultModelManager.removeAll()
                models.clear()
            }
            callback(Result.success(Unit))
        }
    }

    /// --- MAP OBJECT ---
    fun createClusteringMapObjectManager(
            message: ClusteringMapObjectManagerOptionsMessage,
            layerId: String?,
            callback: (Result<MapObjectManagerMessage>) -> Unit?
    ) {
        val managerId = UUID.randomUUID().toString()
        val managerMessage = MapObjectManagerMessage(id = managerId)

        val manager =
                MapObjectManager.withClustering(
                        map = this.map,
                        logicalPixel = LogicalPixel(value = message.logicalPixel.toFloat()),
                        maxZoom = Zoom(value = message.maxZoom.toFloat()),
                        minZoom = Zoom(value = message.minZoom?.toFloat() ?: 0f),
                        layerId = layerId,
                        clusterRenderer =
                                FlutterClusterRenderer(
                                        sdkContext = sdkContext,
                                        api = this.api,
                                        manager = managerMessage
                                ),
                )

        mapObjectsExecutorService.submit {
            this.managers[managerId] = manager
            this.managerLayerIds[managerId] = layerId
            callback(Result.success(managerMessage))
        }
    }

    fun createMapObjectManager(
            layerId: String?,
            callback: (Result<MapObjectManagerMessage>) -> Unit
    ) {
        val managerId = UUID.randomUUID().toString()
        val managerMessage = MapObjectManagerMessage(id = managerId)

        val manager =
                MapObjectManager.withGeneralization(
                        map = this.map,
                        logicalPixel = LogicalPixel(value = 100f),
                        maxZoom = Zoom(value = 18f),
                        layerId = layerId,
                )

        mapObjectsExecutorService.submit {
            this.managers[managerId] = manager
            this.managerLayerIds[managerId] = layerId
            callback(Result.success(managerMessage))
        }
    }

    fun removeMapObjectManager(manager: MapObjectManagerMessage, callback: (Result<Unit>) -> Unit) {
        mapObjectsExecutorService.submit {
            this.managers.remove(manager.id)
            this.managerLayerIds.remove(manager.id)
            val removed = models.filter { it.value.second == manager.id }
            removed.values.forEach { defaultModelManager.removeObject(it.first) }
            removed.keys.forEach { models.remove(it) }
            callback(Result.success(Unit))
        }
    }

    fun setMapObjectManagerIsVisible(
            isVisible: Boolean,
            manager: MapObjectManagerMessage?,
    ) {
        getManager(manager?.id).isVisible = isVisible
        if (manager == null) {
            defaultModelManager.isVisible = isVisible
        }
    }

    /// --- CLUSTER ---

    fun setClusterIcon(icon: String, clusterId: String, callback: (Result<Unit>) -> Unit) {
        val cluster = this.clusters[clusterId]
        if (cluster == null) {
            callback(
                    Result.failure(
                            IllegalArgumentException(
                                    "Cluster with given id not found or already released"
                            )
                    )
            )
            return
        }

        var markerImage: Image? = null
        if (icon in iconCache) {
            markerImage = iconCache[icon]
        } else {
            try {
                val asset = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(icon)

                markerImage = imageFromAsset(sdkContext, asset, Size(0, 0))
                iconCache[icon] = markerImage
            } catch (e: FileNotFoundException) {
                callback(Result.failure(e))
                return
            }
        }

        cluster.setIcon(markerImage)
    }

    fun releaseCluster(clusterId: String) {
        this.clusters.remove(clusterId)
    }

    /// --- POLYGON ---

    private fun mapPolygon(polygon: PolygonMessage): Polygon {
        val options =
                PolygonOptions(
                        contours =
                                polygon.options.contours.map { contour ->
                                    // TODO: fix force unwrap
                                    contour.points.map { it.toGeoPoint() }
                                },
                        color = polygon.options.color?.let { Color(argb = it.toInt()) } ?: Color(),
                        strokeWidth =
                                polygon.options.strokeWidth?.let { LogicalPixel(it.toFloat()) }
                                        ?: LogicalPixel(0f),
                        strokeColor = polygon.options.strokeColor?.let { Color(argb = it.toInt()) }
                                        ?: Color(),
                        userData = PolygonId(polygon.id)
                )

        return Polygon(options)
    }

    fun addPolygon(polygon: PolygonMessage, manager: String?, callback: (Result<Unit>) -> Unit) {
        val polygonObject = mapPolygon(polygon)

        mapObjectsExecutorService.submit {
            polygons[polygon.id] = Pair(polygonObject, manager)
            getManager(manager).addObject(polygonObject)
            callback(Result.success(Unit))
        }
    }

    fun addPolygons(
        polygons: List<PolygonMessage>,
        managerId: String?,
        callback: (Result<Unit>) -> Unit
    ) {
        val polygonObjects = mutableMapOf<String, Pair<Polygon, String?>>()
        for (polygon in polygons) {
            val polygonObject = mapPolygon(polygon)
            polygonObjects[polygon.id] = Pair(polygonObject, managerId)
        }

        mapObjectsExecutorService.submit {
            this.polygons.putAll(polygonObjects)
            getManager(managerId).addObjects(getObjectsFromPair(polygonObjects))
            callback(Result.success(Unit))
        }
    }

    fun removePolygon(id: String, managerId: String?, callback: (Result<Unit>) -> Unit) {
        mapObjectsExecutorService.submit {
            polygons.remove(id)?.also { getManager(managerId).removeObject(it.first) }
            callback(Result.success(Unit))
        }
    }

    fun removeAllPolygons(managerId: String?, callback: (Result<Unit>) -> Unit) {
        removeAllObjects(managerId, polygons, callback)
    }

    /// --- CIRCLE ---
    private fun mapCircle(circle: CircleMessage): Circle {
        val options =
            CircleOptions(
                position = circle.options.position.toGeoPoint(),
                radius = Meter(circle.options.radius.toFloat()),
                color = circle.options.color?.let { Color(argb = it.toInt()) } ?: Color(),
                strokeWidth =
                circle.options.strokeWidth?.let { LogicalPixel(it.toFloat()) }
                    ?: LogicalPixel(0f),
                strokeColor = circle.options.strokeColor?.let { Color(argb = it.toInt()) }
                    ?: Color(),
                userData = CircleId(circle.id)
            )

        return Circle(options)
    }

    fun addCircle(circle: CircleMessage, manager: String?, callback: (Result<Unit>) -> Unit) {
        val circleObject = mapCircle(circle)

        mapObjectsExecutorService.submit {
            circles[circle.id] = Pair(circleObject, manager)
            getManager(manager).addObject(circleObject)
            callback(Result.success(Unit))
        }
    }

    fun addCircles(
        circles: List<CircleMessage>,
        managerId: String?,
        callback: (Result<Unit>) -> Unit
    ) {
        val circleObjects = mutableMapOf<String, Pair<Circle, String?>>()
        for (circle in circles) {
            val polygonObject = mapCircle(circle) ?: return
            circleObjects[circle.id] = Pair(polygonObject, managerId)
        }

        mapObjectsExecutorService.submit {
            this.circles.putAll(circleObjects)
            getManager(managerId).addObjects(getObjectsFromPair(circleObjects))
            callback(Result.success(Unit))
        }
    }

    fun removeCircle(id: String, managerId: String?, callback: (Result<Unit>) -> Unit) {
        mapObjectsExecutorService.submit {
            circles.remove(id)?.also { getManager(managerId).removeObject(it.first) }
            callback(Result.success(Unit))
        }
    }

    fun removeAllCircles(managerId: String?, callback: (Result<Unit>) -> Unit) {
        removeAllObjects(managerId, circles, callback)
    }

    /// --- POLYLINE ---

    private fun mapPolyline(polyline: PolylineMessage): Polyline {
        val color = polyline.options.color?.let { Color(argb = it.toInt()) } ?: Color()
        val options =
                PolylineOptions(
                        points = polyline.options.points.map { it.toGeoPoint() },
                        width = polyline.options.width?.let { LogicalPixel(it.toFloat()) }
                                        ?: LogicalPixel(1f),
                        zIndex = polyline.options.zIndex?.let { ZIndex(it.toInt()) } ?: ZIndex(0),
                        userData = PolylineId(polyline.id),
                        gradientPolylineOptions =
                                GradientPolylineOptions(
                                        borderWidth =
                                                polyline.options.borderWidth?.let {
                                                    LogicalPixel(it.toFloat())
                                                }
                                                        ?: LogicalPixel(0f),
                                        borderColor =
                                                polyline.options.borderColor?.let {
                                                    Color(argb = it.toInt())
                                                }
                                                        ?: Color(),
                                        colors = listOf(color),
                                        colorIndices =
                                                ByteArray(polyline.options.points.size) { 0 },
                                )
                )

        return Polyline(options)
    }

    fun addPolyline(
            polyline: PolylineMessage,
            managerId: String?,
            callback: (Result<Unit>) -> Unit
    ) {
        val polylineObject = mapPolyline(polyline) ?: return

        mapObjectsExecutorService.submit {
            polylines[polyline.id] = Pair(polylineObject, managerId)
            getManager(managerId).addObject(polylineObject)
            callback(Result.success(Unit))
        }
    }

    fun addPolylines(
            polylines: List<PolylineMessage>,
            managerId: String?,
            callback: (Result<Unit>) -> Unit
    ) {
        val polylineObjects = mutableMapOf<String, Pair<Polyline, String?>>()
        for (polyline in polylines) {
            val polylineObject = mapPolyline(polyline)
            polylineObjects[polyline.id] = Pair(polylineObject, managerId)
        }

        mapObjectsExecutorService.submit {
            this.polylines.putAll(polylineObjects)
            getManager(managerId).addObjects(getObjectsFromPair(polylineObjects))
            callback(Result.success(Unit))
        }
    }

    fun removePolyline(id: String, managerId: String?, callback: (Result<Unit>) -> Unit) {
        mapObjectsExecutorService.submit {
            polylines.remove(id)?.also { getManager(managerId).removeObject(it.first) }
            callback(Result.success(Unit))
        }
    }

    fun removeAllPolylines(managerId: String?, callback: (Result<Unit>) -> Unit) {
        removeAllObjects(managerId, polylines, callback)
    }

    /// --- OTHER ---

    fun addIoMarkers(message: AddLayerPointObjectsMessage, callback: (Result<Unit>) -> Unit) {
        val markerImage = markerImage
        val iconWidth = iconWidth

        if (markerImage == null || iconWidth == null) {
            callback(
                    Result.failure(
                            Exception("Error adding marker. Call setMarkerOptions method first")
                    )
            )
            return
        }

        val options =
                MarkerOptions(
                        position = GeoPointWithElevation(latitude = 0.0, longitude = 0.0),
                        icon = markerImage,
                        iconWidth = iconWidth,
                        anchor = Anchor(0.5f, 1f)
                )

        val markers =
                message.objects.filterNotNull().map {
                    val position =
                            GeoPointWithElevation(
                                    latitude = it.position.latitude,
                                    longitude = it.position.longitude
                            )
                    Marker(options.copy(position = position, userData = it.attributes))
                }
        mapObjectsExecutorService.submit {
            ioObjectManager.removeAndAddObjects(ioLayerMarkers, markers)
            ioLayerMarkers.clear()
            ioLayerMarkers.addAll(markers)
            callback(Result.success(Unit))
        }
    }

    fun showLastSearchMarker() {
        lastTappedSearchMarker?.iconOpacity = Opacity(1.0f)
    }

    fun setHighlighted(objectIds: List<DgisObjectId>, callback: (Result<Unit>) -> Unit) {
        for (source in map.sources) {
            val mSource = source as? DgisSource
            if (mSource != null) {
                this.source = mSource
                break
            }
        }
        val source = this.source
        if (source == null) {
            callback(Result.failure(Exception("Map source is null")))
            return
        }

        source.setHighlighted(source.highlightedObjects, false)
        source.setHighlighted(objectIds, true)

        callback(Result.success(Unit))
    }

    fun addPanoramasMarkers(message: AddMarkersWithPhotoMessage) {
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
        mapObjectsExecutorService.submit { panoramasObjectManager.isVisible = true }
    }

    fun hidePanoramasMarkers() {
        mapObjectsExecutorService.submit { panoramasObjectManager.isVisible = false }
    }

    fun removePanoramasMarkers() {
        mapObjectsExecutorService.submit {
            panoramasMarkers.clear()
            panoramasObjectManager.removeAll()
        }
    }

    fun setPanoramasPadding(map: ru.dgis.sdk.map.Map, message: CameraSetPaddingMessage) {
        map.camera.padding =
                Padding(
                        left = message.leftPadding.toInt(),
                        top = message.topPadding.toInt(),
                        right = message.rightPadding.toInt(),
                        bottom = message.topPadding.toInt()
                )
    }

    fun moveCameraToSelectedPanorama(map: ru.dgis.sdk.map.Map) {
        selectedPanorama?.let {
            map.camera.move(
                    position =
                            map.camera.position.copy(
                                    point =
                                            GeoPoint(
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
            callback: (Result<CameraPositionMessage>) -> Unit
    ) {
        calcPositionForObjects(
                objects = markers.mapNotNull { this.markers[it]?.first },
                options = options,
                callback = callback
        )
    }

    fun calcPositionForPolygons(
            polygons: List<String>,
            options: CalcPositionOptionsMessage,
            callback: (Result<CameraPositionMessage>) -> Unit
    ) {
        calcPositionForObjects(
                objects = polygons.mapNotNull { this.polygons[it]?.first },
                options = options,
                callback = callback
        )
    }

    fun calcPositionForPolylines(
            polylines: List<String>,
            options: CalcPositionOptionsMessage,
            callback: (Result<CameraPositionMessage>) -> Unit
    ) {
        calcPositionForObjects(
                objects = polylines.mapNotNull { this.polylines[it]?.first },
                options = options,
                callback = callback
        )
    }

    fun calcPositionForGeoPoints(
            points: List<GeoPointMessage>,
            options: CalcPositionOptionsMessage,
            callback: (Result<CameraPositionMessage>) -> Unit
    ) {
        if (points.isEmpty()) {
            val pos = map.camera.position
            callback(Result.success(CameraPositionMessage(
                point = GeoPointMessage(pos.point.latitude.value, pos.point.longitude.value),
                zoom = pos.zoom.value.toDouble(),
                tilt = pos.tilt.value.toDouble(),
                bearing = pos.bearing.value
            )))
            return
        }

        val objects: List<SimpleMapObject> = if (points.size > 1) {
            listOf(Polyline(PolylineOptions(points = points.map { it.toGeoPoint() })))
        } else {
            listOf(Circle(CircleOptions(position = points.first().toGeoPoint(), radius = Meter(500f))))
        }

        calcPositionForObjects(objects = objects, options = options, callback = callback)
    }

    fun calcPositionForPoints(
        area: GeometryMessage,
        options: CalcPositionOptionsMessage,
        callback: (Result<CameraPosition>) -> Unit
    ) {
        val geometry = ComplexGeometry(
            geometries = listOf(
                PointGeometry(point = area.bounds.northEast.toGeoPoint()),
                PointGeometry(point = area.bounds.southWest.toGeoPoint()),
            )
        )

        val position = calcPosition(camera = map.camera, geometry = geometry)
        callback(Result.success(position))
    }

    private fun calcPositionForObjects(
            objects: List<SimpleMapObject>,
            options: CalcPositionOptionsMessage,
            callback: (Result<CameraPositionMessage>) -> Unit
    ) {
        val cameraPosition =
                calcPosition(
                        camera = map.camera,
                        objects = objects,
                        screenArea =
                                options.screenArea?.let {
                                    Padding(
                                            left = it.leftPadding.toInt(),
                                            top = it.topPadding.toInt(),
                                            right = it.rightPadding.toInt(),
                                            bottom = it.bottomPadding.toInt()
                                    )
                                },
                        tilt = options.tilt?.let { Tilt(it.toFloat()) },
                        bearing = options.bearing?.let { Bearing(it) },
                        size =
                                options.size?.let {
                                    ScreenSize(width = it.width.toInt(), height = it.height.toInt())
                                }
                )

        callback(
                Result.success(
                        CameraPositionMessage(
                                point = cameraPosition.point.toMessage(),
                                zoom = cameraPosition.zoom.value.toDouble(),
                                tilt = cameraPosition.tilt.value.toDouble(),
                                bearing = cameraPosition.bearing.value,
                        )
                )
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
        eventSink.success(mapOf("event" to Events.onMarkerTap.name, "id" to id))
    }

    private fun onModelTap(id: String) {
        eventSink.success(mapOf("event" to Events.onModelTap.name, "id" to id))
    }

    private fun onRoadEventTap(event: RoadEventMapObject) {
        when (event.event.type) {
            RoadEventType.ROAD_RESTRICTION -> {
                eventSink.success(
                        mapOf(
                                "event" to Events.onRoadEventTap.name,
                                "dgisObjectId" to
                                        mapOf(
                                                "objectId" to event.id.objectId,
                                                "entranceId" to event.id.entranceId,
                                        ),
                                "title" to event.event.name,
                                "description" to event.event.description,
                                "startTime" to
                                        event.event
                                                .schedule
                                                ?.startTime
                                                ?.timeFromEpoch
                                                ?.inMilliseconds,
                                "finishTime" to
                                        event.event
                                                .schedule
                                                ?.finishTime
                                                ?.timeFromEpoch
                                                ?.inMilliseconds,
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
        eventSink.success(mapOf("event" to Events.onPolygonTap.name, "id" to id))
    }

    private fun onCircleTap(id: String) {
        eventSink.success(mapOf("event" to Events.onCircleTap.name, "id" to id))
    }

    private fun onPolylineTap(id: String) {
        eventSink.success(mapOf("event" to Events.onPolylineTap.name, "id" to id))
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
                        "latlng" to
                                mapOf(
                                        "latitude" to marker.position.latitude.value,
                                        "longitude" to marker.position.longitude.value,
                                ),
                        "photoData" to
                                mapOf(
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

    private fun sendDgisObjectEvent(
            id: DgisObjectId,
            position: GeoPointWithElevation,
            levelId: LevelId? = null
    ) {
        eventSink.success(
                mapOf(
                        "event" to Events.onObjectTap.name,
                        "dgisObjectId" to
                                mapOf(
                                        "objectId" to id.objectId,
                                        "entranceId" to id.entranceId,
                                ),
                        "levelId" to levelId?.value,
                        "latlng" to
                                mapOf(
                                        "latitude" to position.latitude.value,
                                        "longitude" to position.longitude.value,
                                ),
                )
        )
    }

    private fun sendDgisMyLocationEvent(position: GeoPointWithElevation) {
        eventSink.success(
                mapOf(
                        "event" to Events.onMyLocationTap.name,
                        "latlng" to
                                mapOf(
                                        "latitude" to position.latitude.value,
                                        "longitude" to position.longitude.value,
                                ),
                )
        )
    }

    fun getNearestObjects(callback: (Result<List<RenderedObjectMessage>>) -> Unit) {
        val cameraPosition = map.camera.position
        val screenPoint = map.camera.projection.mapToScreen(cameraPosition.point)
        if (screenPoint == null) {
            callback(Result.failure(IllegalArgumentException("Map has not been initialized")))
        }

        renderedObjectsCloseable =
                map.getRenderedObjects(screenPoint!!, ScreenDistance(1F)).apply {
                    onResult { objects ->
                        callback(
                                Result.success(
                                        objects
                                                .filter { it.item.item is DgisMapObject }
                                                .map<RenderedObjectInfo, RenderedObjectMessage> {
                                                    RenderedObjectMessage(
                                                            objectId =
                                                                    (it.item.item as DgisMapObject)
                                                                            .id.toMessage(),
                                                            closestMapPoint =
                                                                    it.closestMapPoint.toMessage(),
                                                            levelId = it.item.levelId?.value?.toLong(),
                                                    )
                                                }
                                                .toList()
                                )
                        )
                    }
                    onError { callback(Result.failure(it)) }
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
                val opts = MarkerOptions(it.position.toGeoPointWithElevation(), icon = icon)
                val marker = Marker(opts)

                val photoData =
                        PhotoData(
                                photoUrl = it.photoUrl,
                                isPanoramic = it.isPanoramic,
                                azimuth = it.azimuth
                        )
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
    onRoadEventTap,
    onMarkerTap,
    onModelTap,
    onPolygonTap,
    onCircleTap,
    onPolylineTap,
    onClusterTap,
    onMyLocationTap,
}

private fun Attributes.mapIo(point: GeoPointWithElevation): Map<String, Any> =
        mapOf(
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

private fun Attributes.mapIdle(point: GeoPointWithElevation): Map<String, Any> =
        mapOf(
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
