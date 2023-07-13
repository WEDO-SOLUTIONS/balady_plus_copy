import Foundation
import DGis

class ObjectTapHandler {
    class Events {
        static let onObjectTap = "onObjectTap"
        static let objectTapError = "ObjectTapError"
        static let onMarkerWithPhotoTap = "onMarkerWithPhotoTap"
        static let onIoTap = "onIoTap"
        static let onIdleTap = "onIdleTap"
    }

    private struct PhotoData {
        let photoUrl: String
        let isPanoramic: Bool
        let azimuth: Double
    }
    
    
    private let routeHandler: RouteHandler?
    private let mapObjectManager: MapObjectManager
    private let panoramasObjectManager: MapObjectManager
    private let imageFactory: IImageFactory
    private let eventChannel: DgisStreamHandler
    private let markersQueue: DispatchQueue

    private var lastTappedSearchMarker: Marker?
    private var markerImage: Image?
    private lazy var panoramaMarkerImage: Image = self.imageFactory.make(image: UIImage(named: "ic_marker_point")!)
    private lazy var panoramaMarkerSelected: Image = self.imageFactory.make(image: UIImage(named: "ic_street_view_marker")!)
    private var iconWidth: LogicalPixel?

    private var source: DgisSource?

    private var panoramasMarkers: Array<Marker> = []

    private var selectedPanorama: Marker?
    
    init(
        objectManager: MapObjectManager,
        panoramasMapObjectManager: MapObjectManager,
        imageFactory: IImageFactory,
        routeHandler: RouteHandler?,
        eventChannel: DgisStreamHandler
    ) {
        self.mapObjectManager = objectManager
        self.panoramasObjectManager = panoramasMapObjectManager
        self.imageFactory = imageFactory
        self.routeHandler = routeHandler
        self.eventChannel = eventChannel
        self.markersQueue = DispatchQueue(
            label: "com.mapness.panoramas.markers-queue",
            qos: .utility
        )
    }

    func objectTapListener(_ objectInfo: DGis.RenderedObjectInfo) {
        let tappedObject = objectInfo.item.item

        switch tappedObject {
        case is Marker:
            self.onMarkerTap(tappedObject as! Marker)
            return
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
        case is DgisMapObject:
            guard let mapObject = tappedObject as? DgisMapObject else { return }
            self.onDgisObjectTap(mapObject, objectInfo)
            return
        case is SimpleClusterObject:
            let clusterObject = (tappedObject as! SimpleClusterObject)
            let mainObject = clusterObject.objectCount > 0 ? clusterObject.objects[0] : nil
            guard let marker = mainObject as? Marker else {
                self.eventChannel.error(code: Events.objectTapError)
                return
            }
            self.onMarkerTap(marker)
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
        imageFactory: IImageFactory,
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
    
    func addMarker(_ geoPoint: GeoPointMessage, completion: @escaping (FlutterError?) -> Void) {
        guard let markerImage = self.markerImage, let iconWidth = self.iconWidth else {
            completion(FlutterError(
                code: "Error adding marker",
                message: "Call setMarkerOptions method first",
                details: nil)
            )
            return
        }

        let options = MarkerOptions(
            position: GeoPointWithElevation(
                latitude: Latitude(value: geoPoint.latitude.doubleValue),
                longitude: Longitude(value: geoPoint.longitude.doubleValue)
            ),
            icon: markerImage,
            anchor: Anchor(x: 0.5, y: 1),
            iconWidth: iconWidth
        )
        
        let marker = Marker(options: options)

        self.markersQueue.sync {
            self.mapObjectManager.removeAll()
            self.mapObjectManager.addObject(item: marker)
        }

        completion(nil)
    }

    func removeAllMarkers() {
        self.markersQueue.sync {
            self.mapObjectManager.removeAll()
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
        self.markersQueue.sync { [weak self] in
            var newObjects: Array<Marker> = []
            message.markers.forEach { it in
                guard let self = self else { return }

                let geoPoint = it.position.point
                let elevation = it.position.elevation
                let photoData = PhotoData(photoUrl: it.photoUrl, isPanoramic: it.isPanoramic.boolValue, azimuth: it.azimuth.doubleValue);

                let opts = MarkerOptions(
                    position: GeoPointWithElevation(
                        latitude: Latitude(value: geoPoint.latitude.doubleValue),
                        longitude: Longitude(value: geoPoint.longitude.doubleValue),
                        elevation: Elevation(value: elevation.floatValue)
                    ),
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
        self.markersQueue.sync {
            self.panoramasObjectManager.isVisible = true
        }
    }

    func hidePanoramasMarkers() {
        self.markersQueue.sync {
            self.panoramasObjectManager.isVisible = false
        }
    }

    func removePanoramasMarkers() {
        self.markersQueue.sync {
            self.panoramasMarkers.removeAll()
            self.panoramasObjectManager.removeAll()
        }
    }

    func setPanoramasPadding(map: Map, message: CameraSetPaddingMessage) {
        map.camera.setPadding(padding: Padding(left: UInt32(truncating: message.leftPadding),
                                               top: UInt32(truncating: message.topPadding),
                                               right: UInt32(truncating: message.rightPadding),
                                               bottom: UInt32(truncating: message.bottomPadding)))
    }

    func moveCameraToSelectedPanorama(map: Map) {
        guard let panorama = self.selectedPanorama else { return }

        var desiredPosition = map.camera.position
        desiredPosition.point = GeoPoint(
            latitude: Latitude(value: panorama.position.latitude.value),
            longitude: Longitude(value: panorama.position.longitude.value)
        )

        map.camera.move(position: desiredPosition)
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
            ],
        ])
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
        ])
    }
}
