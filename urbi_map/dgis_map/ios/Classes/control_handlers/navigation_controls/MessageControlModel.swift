import Foundation
import DGis

class MessageControlModel {
    private class Events {
        static let messageEvent = "messageEvent"
        static let stateGpsLost = "gpsLost"
        static let stateRouteResearch = "routeResearch"
        static let stateNone = "none"
    }
    
    private let model: Model
    private let eventChannel: DgisStreamHandler
    private var cancelable: Array<Cancellable> = []
    
    private var prevState: State? = nil
    
    init(model: Model, eventChannel: DgisStreamHandler) {
        self.model = model
        self.eventChannel = eventChannel
        
        cancelable.append(contentsOf: [
            model.stateChannel.sinkOnMainThread { [weak self] state in
                if state == State.routeSearch && self?.prevState == .navigation {
                    self?.eventChannel.success([
                        "event": Events.messageEvent,
                        "state": Events.stateRouteResearch,
                    ])
                } else {
                    self?.eventChannel.success([
                        "event": Events.messageEvent,
                        "state": Events.stateNone,
                    ])
                }
                self?.prevState = state
            },
            model.locationAvailableChannel.sinkOnMainThread { [weak self] locationAvailable in
                if !locationAvailable && model.state != .finished && model.state != .disabled {
                    self?.eventChannel.success([
                        "event": Events.messageEvent,
                        "state": Events.stateGpsLost,
                    ])
                } else {
                    self?.eventChannel.success([
                        "event": Events.messageEvent,
                        "state": Events.stateNone,
                    ])
                }
            }
        ])
    }
    
    func cancel() {
        self.cancelable.forEach { $0.cancel() }
        self.cancelable.removeAll()
    }
}
