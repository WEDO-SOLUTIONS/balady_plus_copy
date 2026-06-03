import Foundation
import DGis

class LocationControlHandler {
    private class Events {
        static let locationEnabledEvent = "locationEnabledEvent"
        static let locationFollowEvent = "locationFollowEvent"
    }
    
    private let map: Map
    private let model: MyLocationControlModel
    private var cancelable: Array<Cancellable> = []
    
    init(map: Map, eventChannel: DgisStreamHandler) {
        self.model = MyLocationControlModel(map: map)
        self.map = map
        
        cancelable.append(model.isEnabledChannel.sinkOnMainThread {
            value in
            eventChannel.success([
                "event": Events.locationEnabledEvent,
                "value": value
            ])
        })
        cancelable.append(model.followStateChannel.sinkOnMainThread {
            followState in
            eventChannel.success([
                "event": Events.locationFollowEvent,
                "value": followState.rawValue
            ])
        })
    }
    
    func toggleFollowState() {
        model.onClicked()
    }
    
    func cancel() {
        cancelable.forEach { $0.cancel() }
        cancelable.removeAll()
    }
}
