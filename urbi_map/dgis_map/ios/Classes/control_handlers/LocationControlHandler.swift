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
        
        cancelable.append(model.isEnabledChannel.sink {
            value in
            eventChannel.success([
                "event": Events.locationEnabledEvent,
                "value": value
            ])
        })
        cancelable.append(model.followStateChannel.sink {
            followState in
            eventChannel.success([
                "event": Events.locationFollowEvent,
                "value": followState.rawValue
            ])
        })
    }
    
    func setFollowState(state: FollowStateMessage) {
        let prevBehaviour = map.camera.behaviour.newBehaviour

        switch state {
        case .off:
            let behaviour = CameraBehaviour(
                position: nil,
                tilt: prevBehaviour.tilt
            )
            map.camera.setBehaviour(behaviour: behaviour)
        case .followPosition:
            let behaviour = CameraBehaviour(
                position: FollowPosition(bearing: .off, styleZoom: prevBehaviour.position?.styleZoom ?? .off),
                tilt: prevBehaviour.tilt
            )
            map.camera.setBehaviour(behaviour: behaviour)
        case .followDirection:
            let behaviour = CameraBehaviour(
                position: FollowPosition(bearing: .on, styleZoom: prevBehaviour.position?.styleZoom ?? .off),
                tilt: prevBehaviour.tilt
            )
            map.camera.setBehaviour(behaviour: behaviour)
        }
    }
    
    func cancel() {
        cancelable.forEach { $0.cancel() }
        cancelable.removeAll()
    }
}
