import Foundation
import DGis

class ObjectTapHandler {
    class Events {
        static let onObjectTap = "onObjectTap"
        static let objectTapError = "ObjectTapError"
        static let onMarkerWithPhotoTap = "onMarkerWithPhotoTap"
        static let onIoTap = "onIoTap"
        static let onIdleTap = "onIdleTap"
        static let onMarkerTap = "onMarkerTap"
        static let onPolygonTap = "onPolygonTap"
        static let onPolylineTap = "onPolylineTap"
        static let onClusterTap = "onClusterTap"
    }
    
    private struct PhotoData {
        let photoUrl: String
        let isPanoramic: Bool
        let azimuth: Double
    }
    
    private struct MarkerId {
        init(_ id: String) {
            self.id = id
        }

        let id: String
    }
    
    private struct PolygonId {
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
    private let flutterApi: FlutterMapApi
    private let eventChannel: DgisStreamHandler
    private let ioObjectManager: MapObjectManager
    private let registrar: FlutterPluginRegistrar
    private let objectsQueue: DispatchQueue
    
    private var lastTappedSearchMarker: Marker?
    private var markerImage: Image?
    private lazy var panoramaMarkerImage: Image = self.imageFactory.make(image: UIImage(named: "ic_marker_point")!)
    private lazy var panoramaMarkerSelected: Image = self.imageFactory.make(image: UIImage(named: "ic_street_view_marker")!)
    private var iconWidth: LogicalPixel?
    
    private var source: DgisSource?

    private var markers: Dictionary<String, Marker> = [:]
    private var managers: Dictionary<String, MapObjectManager> = [:]
    private var polygons: Dictionary<String, Polygon> = [:]
    private var polylines: Dictionary<String, Polyline> = [:]
    private var panoramasMarkers: Array<Marker> = []
    private var ioLayerMarkers: Array<Marker> = []
    
    private var iconCache: Dictionary<String, Image> = [:]

    private var selectedPanorama: Marker?
    
    init(
        map: Map,
        objectManager: MapObjectManager,
        panoramasMapObjectManager: MapObjectManager,
        ioObjectManager: MapObjectManager,
        imageFactory: IImageFactory,
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
            label: "com.mapness.panoramas.markers-queue",
            qos: .utility
        )
        self.registrar = registrar
        self.flutterApi = FlutterMapApi(binaryMessenger: registrar.messenger())
    }
    
    func objectTapListener(_ objectInfo: DGis.RenderedObjectInfo) {
        let tappedObject = objectInfo.item.item
        
        switch tappedObject {
        case is Marker:
            self.onMarkerTap(tappedObject as! Marker)
            return
        case let polygon as Polygon:
            if let id = polygon.userData as? PolygonId {
                eventChannel.success([
                    "event": Events.onPolygonTap,
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
//        case is DgisMapObject:
//            guard let mapObject = tappedObject as? DgisMapObject else { return }
//            self.onDgisObjectTap(mapObject, objectInfo)
//            return
        case let cluster as SimpleClusterObject:
            if let id = cluster.userData as? MapObjectManagerMessage {
                eventChannel.success([
                    "event": Events.onClusterTap,
                    "id": id.id,
                    "cluster": cluster.toMap()
                ] as [String : Any])
            }
            return
        case is RouteMapObject:
            self.routeHandler?.onRouteTap(tappedObject as! RouteMapObject)
            return
        default:
            self.eventChannel.error(code: Events.objectTapError)
        }
    }
    
    func setMarkerOptions(
        assetKey: String,
        svgSize: CGSize,
        iconWidth: Float,
        completion: @escaping (FlutterError?) -> Void
    ) {
        guard let assetPath = Bundle.main.path(forResource: assetKey, ofType: nil),
              let url = URL(string: "file://\(assetPath)"),
              let data = try? Data(contentsOf: url) else {
            completion(
                FlutterError(
                    code: "Error loading asset for marker",
                    message: nil,
                    details: nil
                ))
            return
        }
        
        self.markerImage = imageFactory.make(svgData: data, size: svgSize)
        self.iconWidth = LogicalPixel(floatLiteral: iconWidth)
        
        completion(nil)
    }
    
    func mapMarker(_ marker: MarkerMessage, completion: @escaping (FlutterError?) -> Void) -> Marker? {
        var markerImage: Image? = nil
        if let icon = marker.options.icon?.path {
            if let cachedIcon = iconCache[icon] {
                markerImage = cachedIcon
            } else {
                let assetKey = registrar.lookupKey(forAsset: icon)
                
                guard let assetPath = Bundle.main.path(forResource: assetKey, ofType: nil),
                      let url = URL(string: "file://\(assetPath)"),
                      let data = try? Data(contentsOf: url) else {
                    completion(
                        FlutterError(
                            code: "Error loading asset for marker",
                            message: nil,
                            details: nil
                        ))
                    return nil
                }
                
                let image = imageFactory.make(svgData: data, size: .zero)
                markerImage = image
                iconCache[icon] = image
            }
        }

        let options = MarkerOptions(
            position: marker.options.position.geoPointWithElevation,
            icon: markerImage,
            iconMapDirection: marker.options.icon?.iconMapDirection.map {
                MapDirection(value: $0.degree.doubleValue)
            },
            anchor: marker.options.anchor.map {
                Anchor(x: $0.x.floatValue, y: $0.y.floatValue)
            } ?? Anchor(x: 0.5, y: 0.5),
            text: marker.options.text,
            textStyle: marker.options.textStyle?.textStyle,
            iconWidth: (marker.options.icon?.width).map {
                LogicalPixel(value: $0.floatValue)
            } ?? LogicalPixel(value: 0),
            userData: MarkerId(marker.id),
            animatedAppearance: false
        )

        return Marker(options: options)
    }
    
    func addMarker(_ marker: MarkerMessage, to manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        guard let markerObject = mapMarker(marker, completion: completion) else {
            return
        }
        
        self.objectsQueue.sync {
            self.markers[marker.id] = markerObject
            if let managerId = manager?.id, let manager = self.managers[managerId] {
                manager.addObject(item: markerObject)
            } else {
                self.mapObjectManager.addObject(item: markerObject)
            }
            completion(nil)
        }
    }
    
    func addMarkers(_ markers: [MarkerMessage], to manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        var markerObjects = [String:Marker]()
        for marker in markers {
            guard let markerObject = mapMarker(marker, completion: completion) else {
                return
            }
            markerObjects[marker.id] = markerObject
        }
        
        self.objectsQueue.sync {
            markerObjects.forEach { id, object in
                self.markers[id] = object
            }
            if let managerId = manager?.id, let manager = self.managers[managerId] {
                manager.addObjects(objects: Array(markerObjects.values))
            } else {
                self.mapObjectManager.addObjects(objects: Array(markerObjects.values))
            }
            completion(nil)
        }
    }
    
    func removeMarker(_ id: String, from manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectsQueue.sync {
            if let markerObject = self.markers.removeValue(forKey: id) {
                if let managerId = manager?.id, let manager = self.managers[managerId] {
                    manager.removeObject(item: markerObject)
                } else {
                    self.mapObjectManager.removeObject(item: markerObject)
                }
                completion(nil)
            }
        }
    }
    
    func createClusteringMapObjectManager(_ options: ClusteringMapObjectManagerOptionsMessage, completion: @escaping (MapObjectManagerMessage?, FlutterError?) -> Void) {
        let managerId = UUID().uuidString
        let managerMessage = MapObjectManagerMessage.make(withId: managerId)
        
        let manager = MapObjectManager.withClustering(
            map: self.map,
            logicalPixel: LogicalPixel(value: options.logicalPixel.floatValue),
            maxZoom: Zoom(value: options.maxZoom.floatValue),
            clusterRenderer: FlutterClusterRenderer(
                api: self.flutterApi,
                registrar: self.registrar,
                imageFactory: self.imageFactory,
                manager: managerMessage
            ),
            minZoom: options.minZoom.map {
                Zoom(value: $0.floatValue)
            } ?? Zoom(value: 0)
        )
        
        self.objectsQueue.sync {
            self.managers[managerId] = manager
            completion(managerMessage, nil)
        }
    }
    
    func removeMapObjectManager(_ manager: MapObjectManagerMessage, completion: @escaping (FlutterError?) -> Void) {
        self.objectsQueue.sync {
            if self.managers.removeValue(forKey: manager.id) != nil {
                completion(nil)
            }
        }
    }
    
    private func mapPolygon(_ polygon: PolygonMessage) -> Polygon {
        let options = PolygonOptions(
            contours: polygon.options.contours.map { contour in
                contour.map {
                    GeoPoint(
                        latitude: Latitude(value: $0.latitude.doubleValue),
                        longitude: Longitude(value: $0.longitude.doubleValue)
                    )
                }
            },
            color: polygon.options.color.map {
                Color(argb: UInt32($0.intValue))
            } ?? Color(),
            strokeWidth: polygon.options.strokeWidth.map {
                LogicalPixel(value: $0.floatValue)
            } ?? LogicalPixel(value: 0),
            strokeColor: polygon.options.strokeColor.map {
                Color(argb: UInt32($0.intValue))
            } ?? Color(),
            userData: PolygonId(polygon.id)
        )
        
        return Polygon(options: options)
    }
    
    func addPolygon(_ polygon: PolygonMessage, completion: @escaping (FlutterError?) -> Void) {
        let polygonObject = mapPolygon(polygon)
        
        self.objectsQueue.sync {
            self.polygons[polygon.id] = polygonObject
            self.mapObjectManager.addObject(item: polygonObject)
            completion(nil)
        }
    }
    
    func addPolygons(_ polygons: [PolygonMessage], completion: @escaping (FlutterError?) -> Void) {
        let polygonObjects = polygons.map {
            ($0.id, mapPolygon($0))
        }.reduce(into: [:]) { dict, pair in
            dict[pair.0] = pair.1
        }
        
        self.objectsQueue.sync {
            polygonObjects.forEach { id, object in
                self.polygons[id] = object
            }
            self.mapObjectManager.addObjects(objects: Array(polygonObjects.values))
            completion(nil)
        }
    }
    
    func removePolygon(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        self.objectsQueue.sync {
            if let polygonObject = self.polygons.removeValue(forKey: id) {
                self.mapObjectManager.removeObject(item: polygonObject)
                completion(nil)
            }
        }
    }
    
    private func mapPolyline(_ polyline: PolylineMessage) -> Polyline {
        let options = PolylineOptions(
            points: polyline.options.points.map {
                GeoPoint(
                    latitude: Latitude(value: $0.latitude.doubleValue),
                    longitude: Longitude(value: $0.longitude.doubleValue)
                )
            },
            width: polyline.options.width.map {
                LogicalPixel(value: $0.floatValue)
            } ?? LogicalPixel(value: 1),
            color: polyline.options.color.map {
                Color(argb: UInt32($0.intValue))
            } ?? Color(),
            userData: PolylineId(polyline.id)
        )
        
        return Polyline(options: options)
    }
    
    func addPolyline(_ polyline: PolylineMessage, completion: @escaping (FlutterError?) -> Void) {
        let polylineObject = mapPolyline(polyline)
        
        self.objectsQueue.sync {
            self.polylines[polyline.id] = polylineObject
            self.mapObjectManager.addObject(item: polylineObject)
            completion(nil)
        }
    }
    
    func addPolylines(_ polylines: [PolylineMessage], completion: @escaping (FlutterError?) -> Void) {
        let polylineObjects = polylines.map {
            ($0.id, mapPolyline($0))
        }.reduce(into: [:]) { dict, pair in
            dict[pair.0] = pair.1
        }
        
        self.objectsQueue.sync {
            polylineObjects.forEach { id, object in
                self.polylines[id] = object
            }
            self.mapObjectManager.addObjects(objects: Array(polylineObjects.values))
            completion(nil)
        }
    }
    
    func removePolyline(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        self.objectsQueue.sync {
            if let polylineObject = self.polylines.removeValue(forKey: id) {
                self.mapObjectManager.removeObject(item: polylineObject)
                completion(nil)
            }
        }
    }
    
    func addIoMarkers(_ message: AddLayerPointObjectsMessage, _ completion: @escaping (FlutterError?) -> Void) {
        guard let markerImage = self.markerImage, let iconWidth = self.iconWidth else {
            completion(FlutterError(
                code: "Error adding marker",
                message: "Call setMarkerOptions method first",
                details: nil)
            )
            return
        }
        
        let markers = message.objects.map{
            let position = $0.position.geoPointWithElevation

            return Marker(options: MarkerOptions(
                position: position,
                icon: markerImage,
                anchor: Anchor(x: 0.5, y: 1),
                iconWidth: iconWidth,
                userData: $0.attributes
            ))
        }
        self.objectsQueue.sync {
            self.ioObjectManager.removeAndAddObjects(objectsToRemove: ioLayerMarkers, objectsToAdd: markers)
            self.ioLayerMarkers.removeAll()
            self.ioLayerMarkers.append(contentsOf: markers)
            completion(nil)
        }
    }
    
    func removeAllMarkers(from manager: MapObjectManagerMessage?) {
        self.objectsQueue.sync {
            if let managerId = manager?.id, let manager = self.managers[managerId] {
                manager.removeObjects(objects: Array(self.markers.values))
            } else {
                self.mapObjectManager.removeObjects(objects: Array(self.markers.values))
            }
            self.markers.removeAll()
        }
    }
    
    func removeAllPolygons() {
        self.objectsQueue.sync {
            self.mapObjectManager.removeObjects(objects: Array(self.polygons.values))
            self.polygons.removeAll()
        }
    }
    
    func removeAllPolylines() {
        self.objectsQueue.sync {
            self.mapObjectManager.removeObjects(objects: Array(self.polylines.values))
            self.polylines.removeAll()
        }
    }
    
    func setHighlighted(_ objects: [DgisObjectId], _ completion: @escaping (FlutterError?) -> Void) {
        guard let source = self.source else {
            completion(FlutterError(code: "Map source is null", message: nil, details: nil))
            return
        }
        
        source.setHighlighted(directoryObjectIds: source.highlightedObjects, highlighted: false)
        source.setHighlighted(directoryObjectIds: objects, highlighted: true)
        
        completion(nil)
    }
    
    func addPanoramasMarkers(_ message: AddMarkersWithPhotoMessage) {
        self.objectsQueue.sync { [weak self] in
            var newObjects: Array<Marker> = []
            message.markers.forEach { it in
                guard let self = self else { return }
                
                let photoData = PhotoData(photoUrl: it.photoUrl, isPanoramic: it.isPanoramic.boolValue, azimuth: it.azimuth.doubleValue);
                
                let opts = MarkerOptions(
                    position: it.position.geoPointWithElevation,
                    icon: self.panoramaMarkerImage,
                    userData: photoData)
                let marker = Marker(options: opts)
                newObjects.append(marker)
            }
            self?.panoramasObjectManager.addObjects(objects: newObjects)
            self?.panoramasMarkers.append(contentsOf: newObjects)
        }
    }
    
    func showPanoramasMarkers() {
        self.objectsQueue.sync {
            self.panoramasObjectManager.isVisible = true
        }
    }
    
    func hidePanoramasMarkers() {
        self.objectsQueue.sync {
            self.panoramasObjectManager.isVisible = false
        }
    }
    
    func removePanoramasMarkers() {
        self.objectsQueue.sync {
            self.panoramasMarkers.removeAll()
            self.panoramasObjectManager.removeAll()
        }
    }
    
    func setPanoramasPadding(map: Map, message: CameraSetPaddingMessage) {
        map.camera.padding = Padding(
            left: UInt32(truncating: message.leftPadding),
            top: UInt32(truncating: message.topPadding),
            right: UInt32(truncating: message.rightPadding),
            bottom: UInt32(truncating: message.bottomPadding)
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
    
    private func onDgisObjectTap(_ mapObject: DgisMapObject, _ objectInfo: DGis.RenderedObjectInfo) {
        guard let source = objectInfo.item.source as? DgisSource else {
            self.eventChannel.error(code: Events.objectTapError)
            return
        }
        
        self.source = source
        
        self.sendDgisObjectEvent(mapObject.id, objectInfo.closestMapPoint)
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
    
    private func sendDgisObjectEvent(_ id: DgisObjectId, _ position: GeoPointWithElevation) {
        eventChannel.success([
            "event": Events.onObjectTap,
            "dgisObjectId": [
                "objectId": id.objectId,
                "entranceId": id.entranceId,
            ],
            "latlng": [
                "latitude": position.latitude.value,
                "longitude": position.longitude.value,
            ],
        ] as [String : Any])
    }
}
