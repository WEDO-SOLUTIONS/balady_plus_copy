import Foundation
import DGis

class VisibleRectHandler {
    private class Events {
        static let visibleRectChanged = "visibleRectChanged"
        static let cameraPositionChanged = "cameraPositionChanged"
        static let cameraStateChanged = "cameraStateChanged"
    }
    
    private var cancelable: Array<Cancellable> = []
    
    init(map: Map, eventChannel: DgisStreamHandler) {
        cancelable.append(map.camera.changed.sink { [weak self] change in
            if change.changeReasons.contains(.visibleRect) {
                self?.visibleRectChanged(map: map, eventChannel: eventChannel)
            }
            if change.changeReasons.contains(.position) {
                self?.cameraPositionChanged(position: map.camera.position, eventChannel: eventChannel)
            }
            if change.changeReasons.contains(.state) {
                self?.stateChanged(state: map.camera.state, eventChannel: eventChannel)
            }
        })
    }
    
    func stateChanged(state: CameraState, eventChannel: DgisStreamHandler) {
        eventChannel.success([
            "event": Events.cameraStateChanged,
            "state": {
                switch state {
                    case .busy:
                        return "busy"
                    case .fly:
                        return "fly"
                    case .free:
                        return "free"
                }
            }()
        ])
    }
    
    func cameraPositionChanged(position: CameraPosition, eventChannel: DgisStreamHandler) {
        eventChannel.success([
            "event": Events.cameraPositionChanged,
            "point": [
                "latitude": position.point.latitude.value,
                "longitude": position.point.longitude.value
            ],
            "zoom": position.zoom.value,
            "tilt": position.tilt.value,
            "bearing": position.bearing.value
        ])
    }
    
    func visibleRectChanged(map: Map, eventChannel: DgisStreamHandler) {
        let visibleRect = map.camera.visibleRect
        let zoom = map.camera.position.zoom
        
        eventChannel.success([
            "event": Events.visibleRectChanged,
            "visibleRect": [
                "northEastLat": visibleRect.northEastPoint.latitude.value,
                "northEastLon": visibleRect.northEastPoint.longitude.value,
                "southWestLat": visibleRect.southWestPoint.latitude.value,
                "southWestLon": visibleRect.southWestPoint.longitude.value,
            ],
            "zoom": zoom.value,
        ])
    }
    
    func cancel() {
        cancelable.forEach { $0.cancel() }
        cancelable.removeAll()
    }
}
