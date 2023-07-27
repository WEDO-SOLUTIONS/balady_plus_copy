import Foundation
import DGis

class VisibleRectHandler {
    private class Events {
        static let visibleRectChanged = "visibleRectChanged"
    }
    
    private var cancelable: Array<Cancellable> = []
    
    init(map: Map, eventChannel: DgisStreamHandler) {
        cancelable.append(map.camera.visibleRectChannel.sink { [weak self] value in
            self?.visibleRectChanged(map: map, eventChannel: eventChannel)
        })
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
