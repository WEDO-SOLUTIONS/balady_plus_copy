import Foundation
import DGis

struct MarkerId {
    init(_ id: String) {
        self.id = id
    }

    let id: String
}

private struct ModelId {
    init(_ id: String) {
        self.id = id
    }

    let id: String
}

class ObjectTapHandler {
    class Events {
        static let onObjectTap = "onObjectTap"
        static let objectTapError = "ObjectTapError"
        static let onMarkerWithPhotoTap = "onMarkerWithPhotoTap"
        static let onIoTap = "onIoTap"
        static let onIdleTap = "onIdleTap"
        static let onRoadEventTap = "onRoadEventTap"
        static let onMarkerTap = "onMarkerTap"
        static let onModelTap = "onModelTap"
        static let onPolygonTap = "onPolygonTap"
        static let onCircleTap = "onCircleTap"
        static let onPolylineTap = "onPolylineTap"
        static let onClusterTap = "onClusterTap"
        static let onMyLocationTap = "onMyLocationTap"
    }
    
    private struct PhotoData {
        let photoUrl: String
        let isPanoramic: Bool
        let azimuth: Double
    }
    
    private struct PolygonId {
        init(_ id: String) {
            self.id = id
        }

        let id: String
    }
    
    private struct CircleId {
        init(_ id: String) {
            self.id = id
        }

        let id: String
    }
    
    private struct PolylineId {
        init(_ id: String) {
            self.id = id
        }

        let id: String
    }
    
    private let map: Map
    private let routeHandler: RouteHandler?
    private let mapObjectManager: MapObjectManager
    private let panoramasObjectManager: MapObjectManager
    private let imageFactory: IImageFactory
    private let modelFactory: IModelFactory
    private let flutterApi: FlutterMapApi
    private let eventChannel: DgisStreamHandler
    private let ioObjectManager: MapObjectManager
    private let registrar: FlutterPluginRegistrar
    private let objectsQueue: DispatchQueue
    
    private var lastTappedSearchMarker: Marker?
    private var currentRoadEvent: RoadEvent?
    private var markerImage: Image?
    private lazy var panoramaMarkerImage: Image = self.imageFactory.make(image: UIImage(named: "ic_marker_point")!)
    private lazy var panoramaMarkerSelected: Image = self.imageFactory.make(image: UIImage(named: "ic_street_view_marker")!)
    private var iconWidth: LogicalPixel?
    
    var source: DgisSource?
    private var cancelable: Array<Cancellable> = []

    private var markers: Dictionary<String, (Marker, String?)> = [:]
    private var models: Dictionary<String, (ModelMapObject, String?)> = [:]
    private var managers: Dictionary<String, MapObjectManager> = [:]
    private lazy var modelManager = MapObjectManager(map: self.map)
    private var polygons: Dictionary<String, (Polygon, String?)> = [:]
    private var circles: Dictionary<String, (Circle, String?)> = [:]
    private var polylines: Dictionary<String, (Polyline, String?)> = [:]
    private var clusters: Dictionary<String, SimpleClusterObject> = [:]
    private var panoramasMarkers: Array<Marker> = []
    private var ioLayerMarkers: Array<Marker> = []
    
    private var iconCache: Dictionary<String, Image> = [:]
    private var modelDataCache: Dictionary<String, ModelData> = [:]

    private var selectedPanorama: Marker?
    
    init(
        map: Map,
        objectManager: MapObjectManager,
        panoramasMapObjectManager: MapObjectManager,
        ioObjectManager: MapObjectManager,
        imageFactory: IImageFactory,
        modelFactory: IModelFactory,
        routeHandler: RouteHandler?,
        eventChannel: DgisStreamHandler,
        registrar: FlutterPluginRegistrar
    ) {
        self.map = map
        self.mapObjectManager = objectManager
        self.panoramasObjectManager = panoramasMapObjectManager
        self.imageFactory = imageFactory
        self.routeHandler = routeHandler
        self.eventChannel = eventChannel
        self.ioObjectManager = ioObjectManager
        self.objectsQueue = DispatchQueue(
            label: "com.mapness.markers-queue",
            qos: .userInitiated // check the performance of search
        )
        self.registrar = registrar
        self.modelFactory = modelFactory
        self.flutterApi = FlutterMapApi(binaryMessenger: registrar.messenger())
    }
    
    func cancel() {
        cancelable.forEach { $0.cancel() }
        cancelable.removeAll()
    }
     func objectLongTapListener(_ objectInfo: DGis.RenderedObjectInfo) {
            let tappedObject = objectInfo.item.item

            switch tappedObject {
            case is Marker:
                self.onMarkerTap(tappedObject as! Marker)
                return
            case let model as ModelMapObject:
                if let id = model.userData as? ModelId {
                    self.onModelTap(id.id)
                    return
                }
            case let polygon as Polygon:
                if let id = polygon.userData as? PolygonId {
                    eventChannel.success([
                        "event": Events.onPolygonTap,
                        "id": id.id,
                    ] as [String : Any])
                    return
                }
            case let circle as Circle:
                if let id = circle.userData as? CircleId {
                    eventChannel.success([
                        "event": Events.onCircleTap,
                        "id": id.id,
                    ] as [String : Any])
                    return
                }
            case let polyline as Polyline:
                if let id = polyline.userData as? PolylineId {
                    eventChannel.success([
                        "event": Events.onPolylineTap,
                        "id": id.id,
                    ] as [String : Any])
                    return
                }
            case is GeometryMapObject:
                let mapObject = tappedObject as! GeometryMapObject

                if mapObject.objectAttributes.attributeNames.contains(where: { $0 == "DESCRIPTION"}) {
                    eventChannel.success(mapObject.objectAttributes.mapIdle(objectInfo.closestMapPoint))
                    return
                }

                if mapObject.objectAttributes.attributeNames.contains(where: { $0 == "OPPORTUNITYDESCRIPTION"}) {
                    eventChannel.success(mapObject.objectAttributes.mapIo(objectInfo.closestMapPoint))
                    return
                }
                return
            case is MyLocationMapObject:
                guard let myLocation = tappedObject as? MyLocationMapObject else { return }
                self.sendDgisMyLocationEvent(objectInfo.closestMapPoint)
                return
            case is DgisMapObject:
                guard let mapObject = tappedObject as? DgisMapObject else { return }
                self.onDgisObjectTap(mapObject, objectInfo)
                return
            case let cluster as SimpleClusterObject:
                if let id = cluster.userData as? MapObjectManagerMessage {
                    let clusterId = UUID().uuidString
                    self.clusters[clusterId] = cluster
                    eventChannel.success([
                        "event": Events.onClusterTap,
                        "id": id.id,
                        "cluster": cluster.toMap(id: clusterId)
                    ] as [String : Any])
                }
                return
            case is RouteMapObject:
                self.routeHandler?.onRouteTap(tappedObject as! RouteMapObject)
                return
            case is RoadEventMapObject:
                self.onRoadEventTap(tappedObject as! RoadEventMapObject)
                return
            default:
                self.eventChannel.error(code: Events.objectTapError)
            }
        }

    func objectTapListener(_ objectInfo: DGis.RenderedObjectInfo) {
        let tappedObject = objectInfo.item.item

        // Dynamic-POI markers open the POI card on short tap (and update
        // the selected-state). All other markers stay on the long-press-only
        // contract introduced in iter4 — short taps on them fall through.
        switch tappedObject {
        case let marker as Marker:
            if let markerId = (marker.userData as? MarkerId)?.id, markerId.hasPrefix("dynamic_poi_") {
                self.onMarkerTap(marker)
            }
            return
        case let model as ModelMapObject:
            if let id = model.userData as? ModelId {
                self.onModelTap(id.id)
            }
            return
        case let cluster as SimpleClusterObject:
            if let id = cluster.userData as? MapObjectManagerMessage {
                let clusterId = UUID().uuidString
                self.clusters[clusterId] = cluster
                eventChannel.success([
                    "event": Events.onClusterTap,
                    "id": id.id,
                    "cluster": cluster.toMap(id: clusterId)
                ] as [String : Any])
            }
            return

        default:
            self.eventChannel.error(code: Events.objectTapError)
        }
    }
    
    // MARK: Handlers
    
    private func getManager(_ managerId: String?) -> MapObjectManager {
        if let id = managerId, let manager = self.managers[id] {
            return manager
        }
        return self.mapObjectManager
    }
    
    private func removeAllObjects<T: DGis.SimpleMapObject>(_ managerId: String?,_ objects: inout Dictionary<String, (T, String?)>, completion: @escaping (Result<Void, any Error>) -> Void) {
        // Sync threading memory access
        self.objectsQueue.sync {
            let hasManager = managerId != nil && self.managers[managerId!] != nil
            if (hasManager) {
                let filtered = objects.filter { $0.value.1 != managerId }
                objects.removeAll()
                objects.merge(filtered) { (_, new) in new }
            } else {
                objects.removeAll()
            }
        }

        self.objectsQueue.async {
            self.getManager(managerId).removeAll()
            completion(Result.success(()))
        }
    }
    
    // MARK: Marker
    private func getImage(fromAsset assetPath: String, isSvg: Bool, size: CGSize, completion: @escaping (Result<Void, any Error>) -> Void) -> Image? {
        if let cachedIcon = iconCache[assetPath] {
            return cachedIcon
        }

        let assetKey = registrar.lookupKey(forAsset: assetPath)
        guard let path = Bundle.main.path(forResource: assetKey, ofType: nil),
            let url = URL(string: "file://\(path)"),
            let data = try? Data(contentsOf: url) else {
            completion(
                Result.failure(
                FlutterError(
                    code: "Error loading asset for marker",
                    message: nil,
                    details: nil
                )))
            return nil
        }

        let image: Image
        if isSvg {
            // That it was possible to process lottie animation, it was easier to implement a new model and stretch it
            if path.contains(".json") {
                image = imageFactory.make(lottieData: data, size: size)
            } else {
                image = imageFactory.make(svgData: data, size: size)
            }
        } else {
            // PNG path: route through UIImage at the device's native pixel scale
            // and hand the SDK a `make(image:)` factory call. The (pngData:size:)
            // overload either silently fails (`.zero`) or rasterises in raw pixels
            // (logical-pt size) — both produced the clipped/zoomed Al Masjid Al
            // Haram bug. UIImage(data:scale:) carries the correct logical-px ↔
            // physical-px ratio, and SDK's `make(image:)` honours it.
            let scale = UIScreen.main.scale > 0 ? UIScreen.main.scale : 1.0
            if let uiImage = UIImage(data: data, scale: scale) {
                image = imageFactory.make(image: uiImage)
            } else {
                image = imageFactory.make(pngData: data, size: size)
            }
        }

        iconCache[assetPath] = image
        return image
    }
    
    func mapMarker(_ marker: MarkerMessage, completion: @escaping (Result<Void, any Error>) -> Void) -> Marker? {
        var markerImage: Image? = nil

        if let svgPath = marker.options.icon?.svgPath {
            markerImage = getImage(fromAsset: svgPath, isSvg: true, size: .zero, completion: completion)
        }
        else if let pngPath = marker.options.icon?.pngPath {
            // Rasterize the PNG at the device's physical pixel resolution that
            // matches the marker's logical iconWidth. Passing the logical width
            // alone (as the SDK did before) decoded the bitmap at logical size,
            // which the SDK then upscaled 2-3× on hi-DPI screens — clipped /
            // zoomed marker. Passing .zero loads nothing on the iOS factory.
            // Multiplying by UIScreen.scale gives a 1:1 px → logical-pt mapping.
            let scale = UIScreen.main.scale
            let pixelSize = CGSize(
                width: marker.options.icon!.width * Double(scale),
                height: marker.options.icon!.width * Double(scale)
            )
            NSLog("[MakkahPinDebug.iOS] addMarker pngPath=\(pngPath) width=\(marker.options.icon!.width) px=\(pixelSize)")
            markerImage = getImage(fromAsset: pngPath, isSvg: false, size: pixelSize, completion: completion)
        }
        else if let pngData = marker.options.icon?.pngData {
            let data = pngData.data
            let scale = UIScreen.main.scale
            markerImage = imageFactory.make(pngData: data, size: CGSize(
                width: marker.options.icon!.width * Double(scale),
                height: marker.options.icon!.width * Double(scale)
            ))
        }
        else {
            completion(Result.failure(
                    FlutterError(
                        code: "No icon provided for marker",
                        message: nil,
                        details: nil
                    )))
                    return nil
        }

        let options = MarkerOptions(
            position: marker.options.position.geoPointWithElevation,
            icon: markerImage,
            iconMapDirection: marker.options.icon?.iconMapDirection.map {
                MapDirection(value: $0.degree)
            },
            anchor: marker.options.anchor.map {
                Anchor(x: Float($0.x), y: Float($0.y))
            } ?? Anchor(x: 0.5, y: 0.5),
            text: marker.options.text,
            textStyle: marker.options.textStyle?.textStyle,
            iconWidth: (marker.options.icon?.width).map {
                LogicalPixel(value: Float($0))
            } ?? LogicalPixel(value: 0),
            userData: MarkerId(marker.id),
            zIndex: ZIndex(value: UInt32(marker.options.zIndex ?? 0)),
            animatedAppearance: marker.options.animatedAppearance ?? false
        )
        
        do {
            let createdMarker = try Marker(options: options)
            // Honor isVisible at construction time. Android already does this
            // (`visible = (marker.options.isVisible ?: true)`); the iOS pigeon
            // constructor does not accept an isVisible argument, so apply it
            // immediately after creation. Without this, dynamic-POI markers
            // briefly flash visible at low zoom before the post-add visibility
            // sweep can hide them.
            if let isVisible = marker.options.isVisible {
                createdMarker.isVisible = isVisible
            }
            return createdMarker
        } catch {
            completion(
                Result.failure(
                FlutterError(
                    code: "Error creating marker \(error.localizedDescription)",
                    message: nil,
                    details: nil
                ))
            )
        }

        return nil
    }

    func addMarker(_ marker: MarkerMessage, to managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let markerObject = mapMarker(marker, completion: completion) else {
            return
        }
        
        self.objectsQueue.async {
            self.markers[marker.id] = (markerObject, managerId)
            self.getManager(managerId).addObject(item: markerObject)
            completion(Result.success(()))
        }
    }
    
    func setMarkerOptions(_ id: String, options: ChangeMarkerOptionsMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        var markerImage: Image? = nil
        
        if let svgPath = options.icon?.svgPath {
            markerImage = getImage(fromAsset: svgPath, isSvg: true, size: .zero, completion: completion)
        }
        else if let pngPath = options.icon?.pngPath {
            let scale = UIScreen.main.scale
            let pixelSize = CGSize(
                width: options.icon!.width * Double(scale),
                height: options.icon!.width * Double(scale)
            )
            NSLog("[MakkahPinDebug.iOS] setMarkerOptions pngPath=\(pngPath) width=\(options.icon!.width) px=\(pixelSize)")
            markerImage = getImage(fromAsset: pngPath, isSvg: false, size: pixelSize, completion: completion)
        }
        else if let pngData = options.icon?.pngData {
            let data = pngData.data
            let scale = UIScreen.main.scale
            markerImage = imageFactory.make(pngData: data, size: CGSize(
                width: options.icon!.width * Double(scale),
                height: options.icon!.width * Double(scale)
            ))
        }
        
        if let position = options.position {
            self.markers[id]?.0.position = position.geoPointWithElevation
        }
        if let markerImage {
            self.markers[id]?.0.icon = markerImage
        }
        if let iconMapDirection = options.icon?.iconMapDirection {
            self.markers[id]?.0.iconMapDirection = MapDirection(value: iconMapDirection.degree)
        }
        if let anchor = options.anchor {
            self.markers[id]?.0.anchor = Anchor(x: Float(anchor.x), y: Float(anchor.y))
        }
        if let text = options.text {
            self.markers[id]?.0.text = text
        }
        if let textStyle = options.textStyle?.textStyle {
            self.markers[id]?.0.textStyle = textStyle
        }
        if let iconWidth = options.icon?.width {
            self.markers[id]?.0.iconWidth = LogicalPixel(value: Float(iconWidth))
        }
        if let zIndex = options.zIndex {
            self.markers[id]?.0.zIndex = ZIndex(value: UInt32(zIndex))
        }
        if let animatedAppearance = options.animatedAppearance {
            self.markers[id]?.0.animatedAppearance = animatedAppearance
        }
        if let iconOpacity = options.icon?.iconOpacity {
            self.markers[id]?.0.iconOpacity = Opacity(value: Float(iconOpacity))
        }
        if let isVisible = options.isVisible {
            self.markers[id]?.0.isVisible = isVisible
        }
    }
    
    func addMarkers(_ markers: [MarkerMessage], to managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectsQueue.async {
            var markerObjects = [String:Marker]()
            for marker in markers {
                guard let markerObject = self.mapMarker(marker, completion: completion) else {
                    return
                }
                markerObjects[marker.id] = markerObject
            }
            
            markerObjects.forEach { id, object in
                self.markers[id] = (object, managerId)
            }
            self.getManager(managerId).addObjects(objects: Array(markerObjects.values))
            completion(Result.success(()))
        }
    }
    
    func removeMarker(_ id: String, from managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectsQueue.async {
            if let markerObject = self.markers.removeValue(forKey: id) {
                self.getManager(managerId).removeObject(item: markerObject.0)
                completion(Result.success(()))
            }
        }
    }
    
    func removeAllMarkers(from managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        removeAllObjects(managerId, &self.markers, completion: completion)
    }
    
    // MARK: 3D Model

    private func getModelData(fromAsset modelPath: String, completion: @escaping (Result<Void, any Error>) -> Void) -> ModelData? {
        if let cachedModel = modelDataCache[modelPath] {
            return cachedModel
        }

        let assetKey = registrar.lookupKey(forAsset: modelPath)
        guard let assetPath = Bundle.main.path(forResource: assetKey, ofType: nil),
              let data = try? Data(contentsOf: URL(fileURLWithPath: assetPath)) else {
            completion(Result.failure(
                FlutterError(
                    code: "Error loading asset for 3D model",
                    message: "Failed to find model asset <\(modelPath)> with key <\(assetKey)>.",
                    details: nil
                )
            ))
            return nil
        }

        let modelData = modelFactory.make(modelData: data)
        modelDataCache[modelPath] = modelData
        return modelData
    }

    private func mapModel(_ model: ModelMapObjectMessage, completion: @escaping (Result<Void, any Error>) -> Void) -> ModelMapObject? {
        guard let modelData = getModelData(fromAsset: model.options.modelPath, completion: completion) else {
            return nil
        }

        let options = ModelMapObjectOptions(
            position: model.options.position.geoPointWithElevation,
            data: modelData,
            size: model.options.size.modelSize,
            mapDirection: model.options.mapDirection.map {
                MapDirection(value: $0.degree)
            },
            opacity: Opacity(value: Float(model.options.opacity ?? 1.0)),
            visible: model.options.isVisible ?? true,
            userData: ModelId(model.id),
            levelId: model.options.levelId?.toLevelId()
        )

        do {
            let modelObject = try ModelMapObject(options: options)
            if let zIndex = model.options.zIndex {
                modelObject.zIndex = ZIndex(value: UInt32(zIndex))
            }
            return modelObject
        } catch {
            completion(
                Result.failure(
                    FlutterError(
                        code: "Error creating 3D model \(error.localizedDescription)",
                        message: nil,
                        details: nil
                    )
                )
            )
            return nil
        }
    }

    func addModel(_ model: ModelMapObjectMessage, to managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let modelObject = mapModel(model, completion: completion) else {
            return
        }

        self.objectsQueue.async {
            self.models[model.id] = (modelObject, managerId)
            self.modelManager.addObject(item: modelObject)
            completion(Result.success(()))
        }
    }

    func setModelOptions(_ id: String, options: ChangeModelMapObjectOptionsMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let modelObject = self.models[id]?.0 else {
            completion(Result.success(()))
            return
        }

        if let position = options.position {
            modelObject.position = position.geoPointWithElevation
        }
        if let modelPath = options.modelPath {
            guard let modelData = getModelData(fromAsset: modelPath, completion: completion) else {
                return
            }
            modelObject.modelData = modelData
        }
        if let size = options.size {
            modelObject.size = size.modelSize
        }
        if let mapDirection = options.mapDirection {
            modelObject.mapDirection = MapDirection(value: mapDirection.degree)
        }
        if let opacity = options.opacity {
            modelObject.opacity = Opacity(value: Float(opacity))
        }
        if let isVisible = options.isVisible {
            modelObject.isVisible = isVisible
        }
        if let zIndex = options.zIndex {
            modelObject.zIndex = ZIndex(value: UInt32(zIndex))
        }

        completion(Result.success(()))
    }

    func addModels(_ models: [ModelMapObjectMessage], to managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectsQueue.async {
            var modelObjects = [String: ModelMapObject]()
            for model in models {
                guard let modelObject = self.mapModel(model, completion: completion) else {
                    return
                }
                modelObjects[model.id] = modelObject
            }

            modelObjects.forEach { id, object in
                self.models[id] = (object, managerId)
            }
            self.modelManager.addObjects(objects: Array(modelObjects.values))
            completion(Result.success(()))
        }
    }

    func removeModel(_ id: String, from managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectsQueue.async {
            if let modelObject = self.models.removeValue(forKey: id) {
                self.modelManager.removeObject(item: modelObject.0)
            }
            completion(Result.success(()))
        }
    }

    func removeAllModels(from managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectsQueue.async {
            let hasManager = managerId != nil && self.managers[managerId!] != nil
            if hasManager {
                let removed = self.models.filter { $0.value.1 == managerId }
                removed.values.forEach { self.modelManager.removeObject(item: $0.0) }
                removed.keys.forEach { self.models.removeValue(forKey: $0) }
            } else {
                self.modelManager.removeAll()
                self.models.removeAll()
            }
            completion(Result.success(()))
        }
    }

    // MARK: Cluster
    
    func createClusteringMapObjectManager(_ options: ClusteringMapObjectManagerOptionsMessage, _ layerId: String?, completion: @escaping (Result<MapObjectManagerMessage, any Error>) -> Void) {
        let managerId = UUID().uuidString
        let managerMessage = MapObjectManagerMessage(id: managerId)
        
        let manager = MapObjectManager.withClustering(
            map: self.map,
            logicalPixel: LogicalPixel(value: Float(options.logicalPixel)),
            maxZoom: Zoom(value: Float(options.maxZoom)),
            clusterRenderer: FlutterClusterRenderer(
                api: self.flutterApi,
                registrar: self.registrar,
                imageFactory: self.imageFactory,
                manager: managerMessage,
                objectsQueue: objectsQueue
            ),
            minZoom: options.minZoom.map {
                Zoom(value: Float($0))
            } ?? Zoom(value: 0),
            layerId: layerId
        )
        
        self.objectsQueue.async {
            self.managers[managerId] = manager
            completion(Result.success(managerMessage))
        }
    }
    
    func releaseCluster(_ id: String) {
        self.clusters.removeValue(forKey: id)
    }
    
    func setClusterIcon(_ icon: String, for clusterId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let cluster = self.clusters[clusterId] else {
            completion(Result.failure(
                    FlutterError(
                code: "Error setting icon for cluster",
                message: "Cluster not found or already released",
                details: nil)
            ))
            return
        }
        
        var markerImage: Image? = nil
        if let cachedIcon = iconCache[icon] {
            markerImage = cachedIcon
        } else {
            let assetKey = registrar.lookupKey(forAsset: icon)
            
            guard let assetPath = Bundle.main.path(forResource: assetKey, ofType: nil),
                  let url = URL(string: "file://\(assetPath)"),
                  let data = try? Data(contentsOf: url) else {
                completion(Result.failure(
                    FlutterError(
                        code: "Error loading asset for marker",
                        message: nil,
                        details: nil
                    )))
                return
            }
            
            let image = imageFactory.make(svgData: data, size: .zero)
            markerImage = image
            iconCache[icon] = image
        }
        
        cluster.setIcon(icon: markerImage)
    }
    
    // MARK: Map Object
    
    func createMapObjectManager(_ layerId: String?, completion: @escaping (Result<MapObjectManagerMessage,any Error >) -> Void) {
        let managerId = UUID().uuidString
        let managerMessage = MapObjectManagerMessage(id: managerId)
        
        let manager = MapObjectManager.withGeneralization(
            map: self.map,
            logicalPixel: LogicalPixel(value: 100),
            maxZoom: Zoom(value: 18),
            layerId: layerId
        )
        self.objectsQueue.async {
            self.managers[managerId] = manager
            completion(Result.success(managerMessage))
        }
    }

    func removeMapObjectManager(_ manager: MapObjectManagerMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectsQueue.async {
            self.managers.removeValue(forKey: manager.id)
            let removed = self.models.filter { $0.value.1 == manager.id }
            removed.values.forEach { self.modelManager.removeObject(item: $0.0) }
            removed.keys.forEach { self.models.removeValue(forKey: $0) }
            completion(Result.success(()))
        }
    }
    
    func setMapObjectManagerIsVisible(_ isVisible: Bool, for managerId: String?,  completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectsQueue.async {
            self.getManager(managerId).isVisible = isVisible
            if managerId == nil {
                self.modelManager.isVisible = isVisible
            }
            completion(Result.success(()))
        }
    }
    
    //MARK:  Polygons
    
    private func mapPolygon(_ polygon: PolygonMessage, completion: @escaping (Result<Void, any Error>) -> Void) -> Polygon? {
        let options = PolygonOptions(
            // TODO : fix force unwrap
            contours: polygon.options.contours.map { contour in
                contour.points.compactMap {
                    GeoPoint(
                        latitude: Latitude(value: $0.latitude),
                      longitude: Longitude(value: $0.longitude)
                  )
                }            },
            color: polygon.options.color.map {
                Color(argb: UInt32($0))
            } ?? Color(),
            strokeWidth: polygon.options.strokeWidth.map {
                LogicalPixel(value: Float($0))
            } ?? LogicalPixel(value: 0),
            strokeColor: polygon.options.strokeColor.map {
                Color(argb: UInt32($0))
            } ?? Color(),
            userData: PolygonId(polygon.id)
        )
        
        do {
            return try Polygon(options: options)
        } catch {
            completion(
                Result.failure(
                FlutterError(
                    code: "Error creating polygon \(error.localizedDescription)",
                    message: nil,
                    details: nil
                ))
            )
        }
        
        return nil
    }
    
    func addPolygon(_ polygon: PolygonMessage, to managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let polygonObject = mapPolygon(polygon, completion: completion) else {
            return
        }
        
        self.objectsQueue.async {
            self.polygons[polygon.id] = (polygonObject, managerId)
            self.getManager(managerId).addObject(item: polygonObject)
            completion(Result.success(()))
        }
    }
    
    func addPolygons(_ polygons: [PolygonMessage], to managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        var polygonObjects = [String:Polygon]()
        for polygon in polygons {
            guard let polygonObject = mapPolygon(polygon, completion: completion) else {
                return
            }
            polygonObjects[polygon.id] = polygonObject
        }
        
        self.objectsQueue.async {
            polygonObjects.forEach { id, object in
                self.polygons[id] = (object, managerId)
            }
            self.getManager(managerId).addObjects(objects: Array(polygonObjects.values))
            completion(Result.success(()))
        }
    }
    
    func removePolygon(_ id: String, from managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectsQueue.async {
            if let polygonObject = self.polygons.removeValue(forKey: id) {
                self.getManager(managerId).removeObject(item: polygonObject.0)
                completion(Result.success(()))
            }
        }
    }
    
    func removeAllPolygons(from managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        removeAllObjects(managerId, &self.polygons, completion: completion)
    }
    
    // MARK: Circle
    
    private func mapCircle(_ circle: CircleMessage, completion: @escaping (Result<Void, any Error>) -> Void) -> Circle? {
        let options = CircleOptions(
            // TODO : fix force unwrap
            position: circle.options.position.geoPoint,
            radius: Meter(value: Float(circle.options.radius)),
            color: circle.options.color.map {
                Color(argb: UInt32($0))
            } ?? Color(),
            strokeWidth: circle.options.strokeWidth.map {
                LogicalPixel(value: Float($0))
            } ?? LogicalPixel(value: 0),
            strokeColor: circle.options.strokeColor.map {
                Color(argb: UInt32($0))
            } ?? Color(),
            userData: PolygonId(circle.id)
        )
        
        do {
            return try Circle(options: options)
        } catch {
            completion(
                Result.failure(
                FlutterError(
                    code: "Error creating circle \(error.localizedDescription)",
                    message: nil,
                    details: nil
                ))
            )
        }
        
        return nil
    }
    
    func addCircle(_ circle: CircleMessage, to managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let circleObject = mapCircle(circle, completion: completion) else {
            return
        }
        
        self.objectsQueue.async {
            self.circles[circle.id] = (circleObject, managerId)
            self.getManager(managerId).addObject(item: circleObject)
            completion(Result.success(()))
        }
    }
    
    func addCircles(_ circles: [CircleMessage], to managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        var circleObjects = [String:Circle]()
        for circle in circles {
            guard let circleObject = mapCircle(circle, completion: completion) else {
                return
            }
            circleObjects[circle.id] = circleObject
        }
        
        self.objectsQueue.async {
            circleObjects.forEach { id, object in
                self.circles[id] = (object, managerId)
            }
            self.getManager(managerId).addObjects(objects: Array(circleObjects.values))
            completion(Result.success(()))
        }
    }
    
    func removeCircle(_ id: String, from managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectsQueue.async {
            if let circleObject = self.circles.removeValue(forKey: id) {
                self.getManager(managerId).removeObject(item: circleObject.0)
                completion(Result.success(()))
            }
        }
    }
    
    func removeAllCircles(from managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        removeAllObjects(managerId, &self.circles, completion: completion)
    }
    
    // MARK: Polyline
    
    private func mapPolyline(_ polyline: PolylineMessage, completion: @escaping (Result<Void, any Error>) -> Void) -> Polyline? {
        let color = polyline.options.color.map {
            Color(argb: UInt32($0))
        } ?? Color()
        
        let options = PolylineOptions(
            points: polyline.options.points.map {
                GeoPoint(
                    latitude: Latitude(value: $0.latitude),
                    longitude: Longitude(value: $0.longitude)
                )
            },
            width: polyline.options.width.map {
                LogicalPixel(value: Float($0))
            } ?? LogicalPixel(value: 1),
            gradientPolylineOptions: GradientPolylineOptions(
                borderWidth: polyline.options.borderWidth.map { LogicalPixel(value: Float($0)) } ?? LogicalPixel(value: 0), 
                borderColor: polyline.options.borderColor.map { Color(argb: UInt32($0)) } ?? Color(),
                colors: [color],
                colorIndices: Data(Array(repeating: 0, count: polyline.options.points.count))
            ),
            userData: PolylineId(polyline.id),
            zIndex: ZIndex(value: UInt32(polyline.options.zIndex ?? 0))
            
        )
        
        do {
            return try Polyline(options: options)
        } catch {
            completion(
                Result.failure(
                FlutterError(
                    code: "Error creating polyline \(error.localizedDescription)",
                    message: nil,
                    details: nil
                ))
            )
        }
        
        return nil
    }
    
    func addPolyline(_ polyline: PolylineMessage, to managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let polylineObject = mapPolyline(polyline, completion: completion) else {
            return
        }
        
        self.objectsQueue.async {
            self.polylines[polyline.id] = (polylineObject, managerId)
            self.getManager(managerId).addObject(item: polylineObject)
            completion(Result.success(()))
        }
    }
    
    func addPolylines(_ polylines: [PolylineMessage], to managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        var polylineObjects = [String:Polyline]()
        for polyline in polylines {
            guard let polylineObject = mapPolyline(polyline, completion: completion) else {
                return
            }
            polylineObjects[polyline.id] = polylineObject
        }
        
        self.objectsQueue.async {
            polylineObjects.forEach { id, object in
                self.polylines[id] = (object, managerId)
            }
            self.getManager(managerId).addObjects(objects: Array(polylineObjects.values))
            completion(Result.success(()))
        }
    }
    
    func removePolyline(_ id: String, from managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectsQueue.async {
            if let polylineObject = self.polylines.removeValue(forKey: id) {
                self.getManager(managerId).removeObject(item: polylineObject.0)
                completion(Result.success(()))
            }
        }
    }
    
    func removeAllPolylines(from managerId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        removeAllObjects(managerId, &self.polylines, completion: completion)
    }
    
    // MARK: Other
    
    func addIoMarkers(_ message: AddLayerPointObjectsMessage, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let markerImage = self.markerImage, let iconWidth = self.iconWidth else {
            completion(Result.failure(
                    FlutterError(
                code: "Error adding marker",
                message: "Call setMarkerOptions method first",
                details: nil))
            )
            return
        }
        
        var markers = [Marker]()
        for marker in message.objects {
            // TODO fix forceunwrap
            let position = marker.position.geoPointWithElevation

            do {
                let marker = try Marker(options: MarkerOptions(
                    position: position,
                    icon: markerImage,
                    anchor: Anchor(x: 0.5, y: 1),
                    iconWidth: iconWidth,
                    userData: marker.attributes
                ))
                markers.append(marker)
            } catch {
                completion(Result.failure(
                    FlutterError(
                        code: "Error creating marker \(error.localizedDescription)",
                        message: nil,
                        details: nil
                    ))
                )
                return
            }
        }
        self.objectsQueue.async {
            self.ioObjectManager.removeAndAddObjects(
                objectsToRemove: self.ioLayerMarkers,
                objectsToAdd: markers
            )
            self.ioLayerMarkers.removeAll()
            self.ioLayerMarkers.append(contentsOf: markers)
            completion(Result.success(()))
        }
    }
    
    func setHighlighted(_ objects: [DgisObjectId], _ completion: @escaping (Result<Void, any Error>) -> Void) {
        for source in map.sources {
            let mSource = source as? DgisSource
            if mSource != nil {
                self.source = mSource
                break
            }
        }
        
        guard let source = self.source else {
            completion(Result.failure(
                    FlutterError(code: "Map source is null", message: nil, details: nil)))
            return
        }
        
        source.setHighlighted(directoryObjectIds: source.highlightedObjects, highlighted: false)
        source.setHighlighted(directoryObjectIds: objects, highlighted: true)
        
        completion(Result.success(()))
    }
    
    func addPanoramasMarkers(message: AddMarkersWithPhotoMessage) {
        self.objectsQueue.async {[weak self] in
                var newObjects: Array<Marker> = []
                message.markers.forEach { it in
                    guard let self = self else { return }
                    
                    let photoData = PhotoData(photoUrl: it.photoUrl, isPanoramic: it.isPanoramic, azimuth: it.azimuth);
                    
                    let opts = MarkerOptions(
                        position: (it.position.geoPointWithElevation),
                        icon: self.panoramaMarkerImage,
                        userData: photoData)
                    if let marker = try? Marker(options: opts) {
                        newObjects.append(marker)
                    }
                }
                self?.panoramasObjectManager.addObjects(objects: newObjects)
                self?.panoramasMarkers.append(contentsOf: newObjects)
            }
    }
    
    func showPanoramasMarkers() {
        self.objectsQueue.async {
            self.panoramasObjectManager.isVisible = true
        }
    }
    
    func hidePanoramasMarkers() {
        self.objectsQueue.async {
            self.panoramasObjectManager.isVisible = false
        }
    }
    
    func removePanoramasMarkers() {
        self.objectsQueue.async {
            self.panoramasMarkers.removeAll()
            self.panoramasObjectManager.removeAll()
        }
    }
    
    func setPanoramasPadding(map: Map, message: CameraSetPaddingMessage) {
        map.camera.padding = Padding(
            left: UInt32(message.leftPadding),
            top: UInt32( message.topPadding),
            right: UInt32(message.rightPadding),
            bottom: UInt32(message.bottomPadding)
        )
    }
    
    func moveCameraToSelectedPanorama(map: Map) {
        guard let panorama = self.selectedPanorama else { return }
        
        var desiredPosition = map.camera.position
        desiredPosition.point = GeoPoint(
            latitude: Latitude(value: panorama.position.latitude.value),
            longitude: Longitude(value: panorama.position.longitude.value)
        )
        
        let _ = map.camera.move(position: desiredPosition)
    }
    
    func selectPanorama(marker: Marker) {
        if (self.selectedPanorama != nil) {
            unselectPanorama()
        }
        self.selectedPanorama = marker
        self.selectedPanorama?.icon = panoramaMarkerSelected
        self.selectedPanorama?.anchor = Anchor(x: 0.5, y: 0.95)
        
        guard let photoData = marker.userData as? PhotoData else { return }
        self.selectedPanorama?.iconMapDirection = MapDirection(value: photoData.azimuth)
    }
    
    func unselectPanorama() {
        self.selectedPanorama?.icon = panoramaMarkerImage
        self.selectedPanorama?.anchor = Anchor(x: 0.5, y: 0.5)
        self.selectedPanorama?.iconMapDirection = nil
        self.selectedPanorama = nil
    }
    
    func setPanoramasAzimuth(degrees : Double) {
        selectedPanorama?.iconMapDirection = MapDirection(value: degrees)
    }
    
    func showLastSearchMarker() {
        self.lastTappedSearchMarker?.iconOpacity = Opacity(value: 1.0)
    }
    
    func calcPosition(markers: [String], options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {
        calcPosition(
            objects: markers.compactMap { self.markers[$0]?.0 },
            options: options,
            completion: completion
        )
    }
    
    func calcPosition(polygons: [String], options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {
        calcPosition(
            objects: polygons.compactMap { self.polygons[$0]?.0 },
            options: options,
            completion: completion
        )
    }
    
    func calcPosition(polylines: [String], options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {
        calcPosition(
            objects: polylines.compactMap { self.polylines[$0]?.0 },
            options: options,
            completion: completion
        )
    }
    
    func calcPosition(area: GeometryMessage, options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPosition, any Error>) -> Void) {
            let geometry = ComplexGeometry(
                geometries: [
                    PointGeometry(point: area.bounds.northEast.geoPoint),
                    PointGeometry(point:  area.bounds.southWest.geoPoint)
                ]
            )
            let position = DGis.calcPosition(camera: map.camera, geometry: geometry)
            completion(Result.success(position))
    }
    
    func calcPosition(points: [GeoPointMessage], options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {
        if (points.isEmpty) {
            completion(
                Result.success(
                CameraPositionMessage(
                    point: map.camera.position.point.toMessage(),
                    zoom:  Double(map.camera.position.zoom.value),
                    tilt:  Double(map.camera.position.tilt.value),
                    bearing:  map.camera.position.bearing.value
                ))
            )
            return
        }

        let polylineOptions =
            PolylineOptions(
                points: points.map { $0.geoPoint }
            )
        
        let circleOptions = CircleOptions(position: points.first!.geoPoint, radius: Meter(500.0))
        
        // if there is only one point creating a polyline throws so we treat it as a circle
        let objects = [points.count > 1 ? try! Polyline(options: polylineOptions) : try! Circle(options: circleOptions)]

        calcPosition(objects: objects, options: options, completion: completion)
    }
    
    private func calcPosition(objects: [SimpleMapObject], options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {
        let cameraPosition = DGis.calcPosition(
            camera: map.camera,
            objects: objects,
            screenArea: options.screenArea.map {
                Padding(
                    left: UInt32($0.leftPadding),
                    top: UInt32($0.topPadding),
                    right: UInt32($0.rightPadding),
                    bottom: UInt32($0.bottomPadding)
                )
            },
            tilt: options.tilt.map {
                Tilt(value: Float($0))
            },
            bearing: options.bearing.map {
                Bearing(value: $0)
            },
            size: options.size.map {
                ScreenSize(
                    width: UInt32($0.width),
                    height: UInt32($0.height)
                )
            }
        )
        
        completion(
            Result.success(
            CameraPositionMessage(
                point: cameraPosition.point.toMessage(),
                zoom:  Double(cameraPosition.zoom.value),
                tilt:  Double(cameraPosition.tilt.value),
                bearing:  cameraPosition.bearing.value
            ))
        )
    }
    
    private func onDgisObjectTap(_ mapObject: DgisMapObject, _ objectInfo: DGis.RenderedObjectInfo) {
        guard let source = objectInfo.item.source as? DgisSource else {
            self.eventChannel.error(code: Events.objectTapError)
            return
        }
        
        self.sendDgisObjectEvent(mapObject.id, objectInfo.closestMapPoint, objectInfo.item.levelId)
    }
    
    private func onMarkerTap(_ marker: Marker) {
        switch marker.userData {
        case let d as PhotoData:
            onMarkerWithPhotoTap(marker, d)
            break
        case let id as DgisObjectId:
            onSearchMarkerTap(marker, id)
            break
        case let id as MarkerId:
            eventChannel.success([
                "event": Events.onMarkerTap,
                "id": id.id,
            ] as [String : Any])
        default:
            return
        }
    }
    
    private func onModelTap(_ id: String) {
        eventChannel.success([
            "event": Events.onModelTap,
            "id": id,
        ] as [String : Any])
    }

    // Handles taps for all RoadEventType categories (not just .roadRestriction) now that the
    // Road Events layer button shows every category — they all route to the same Dart-side card.
    private func onRoadEventTap(_ event: RoadEventMapObject) {
        self.currentRoadEvent = event.event
        eventChannel.success([
            "event": Events.onRoadEventTap,
            "dgisObjectId": [
                "objectId": event.id.objectId,
                "entranceId": event.id.entranceId,
            ],
            "title": event.event.name,
            "description": event.event.description,
            "startTime": (event.event.schedule?.startTime?.timeIntervalSince1970).map {
                Int($0 * 1000)
            },
            "finishTime": (event.event.schedule?.finishTime?.timeIntervalSince1970).map {
                Int($0 * 1000)
            },
            "latitude": event.event.location.latitude.value,
            "longitude": event.event.location.longitude.value,
            "type": Int(event.event.type.rawValue),
            "lanes": Int(event.event.lanes.rawValue),
            "availableActionTypes": event.event.availableActions.reduce(0) { $0 | (1 << Int($1.type.rawValue)) },
            "timestamp": event.event.timestamp.map { Int($0.timeIntervalSince1970 * 1000) },
        ] as [String : Any?])
    }

    // Looks up the matching RoadEventAction on the most recently tapped road event
    // (cached in currentRoadEvent) and invokes its .set() — used by the
    // "Still there" (.confirmation) / "Not anymore" (.disproof) feedback buttons.
    func setRoadEventAction(_ type: RoadEventActionType, completion: @escaping (Result<RoadEventActionResultMessage, any Error>) -> Void) {
        guard let action = self.currentRoadEvent?.availableActions.first(where: { $0.type == type }) else {
            completion(.failure(FlutterError(
                code: "ROAD_EVENT_ACTION_UNAVAILABLE",
                message: "No available RoadEventAction of type \(type) for the current road event",
                details: nil
            )))
            return
        }

        self.cancelable.append(
            action.set().sink(receiveValue: { result in
                completion(.success(result.toMessage()))
            }, failure: { error in
                completion(.failure(FlutterError(
                    code: "ROAD_EVENT_ACTION_ERROR",
                    message: error.description,
                    details: nil
                )))
            })
        )
    }

    private func onSearchMarkerTap(_ marker: Marker, _ id: DgisObjectId) {
        self.lastTappedSearchMarker?.iconOpacity = Opacity(value: 1.0)
        marker.iconOpacity = Opacity(value: 0.0)
        self.lastTappedSearchMarker = marker
        
        self.sendDgisObjectEvent(id, marker.position)
    }
    
    private func onMarkerWithPhotoTap(_ marker: Marker, _ photoData: PhotoData) {
        self.selectPanorama(marker: marker)
        eventChannel.success([
            "event": Events.onMarkerWithPhotoTap,
            "latlng": [
                "latitude": marker.position.latitude.value,
                "longitude": marker.position.longitude.value,
            ],
            "photoData": [
                "photoUrl": photoData.photoUrl,
                "isPanoramic": photoData.isPanoramic,
                "azimuth": photoData.azimuth,
            ] as [String : Any],
        ] as [String : Any])
    }
    
    private func sendDgisObjectEvent(_ id: DgisObjectId, _ position: GeoPointWithElevation, _ levelId: LevelId? = nil) {
        eventChannel.success([
            "event": Events.onObjectTap,
            "dgisObjectId": [
                "objectId": id.objectId,
                "entranceId": id.entranceId,
            ],
            "levelId": levelId?.value,
            "latlng": [
                "latitude": position.latitude.value,
                "longitude": position.longitude.value,
            ],
        ] as [String : Any?])
    }

    private func sendDgisMyLocationEvent(_ position: GeoPointWithElevation) {
        eventChannel.success([
            "event": Events.onMyLocationTap,
            "latlng": [
                "latitude": position.latitude.value,
                "longitude": position.longitude.value,
            ],
        ] as [String : Any])
    }
    
    func getNearestObjects(completion: @escaping (Result<[RenderedObjectMessage], any Error>) -> Void) {
        let cameraPosition = map.camera.position.point
        guard let screenPoint = map.camera.projection.mapToScreen(point: cameraPosition) else {
            completion(Result.failure( FlutterError(
                code: "IllegalArgumentException",
                message: "Camera was not initialized properly",
                details: nil
            )))
            return
        }


        self.cancelable.append(
            map.getRenderedObjects(centerPoint: screenPoint, radius: ScreenDistance(value: 1)).sink { renderedObjects in
                let objects = renderedObjects.filter {
                    $0.item.item is DgisMapObject
                }.map {
                    RenderedObjectMessage(
                        objectId: ($0.item.item as! DgisMapObject).id.toMessage(),
                        closestMapPoint: $0.closestMapPoint.toMessage(),
                        levelId: $0.item.levelId.map { Int64($0.value) }
                    )
                }

                completion(Result.success(objects))
            } failure: { _ in
                completion(Result.failure( FlutterError(
                    code: "IllegalArgumentException",
                    message: "Camera was not initialized properly",
                    details: nil
                )))
            }
        )
    }
}

private extension ModelSizeMessage {
    var modelSize: ModelSize {
        switch type {
        case .logicalPixel:
            return .logicalPixel(LogicalPixel(value: Float(value)))
        case .scale:
            return .scale(ModelScale(value: Float(value)))
        }
    }
}
