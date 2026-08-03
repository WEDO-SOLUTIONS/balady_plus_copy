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
            model.stateChannel.sink { [weak self] state in
                if state == State.routeSearch && self?.prevState == .navigation {
                    self?.emit(Events.stateRouteResearch)
                } else {
                    self?.emit(Events.stateNone)
                }
                self?.prevState = state
            },
            model.locationAvailableChannel.sink { [weak self] locationAvailable in
                if !locationAvailable && model.state != .finished && model.state != .disabled {
                    self?.emit(Events.stateGpsLost)
                } else {
                    self?.emit(Events.stateNone)
                }
            }
        ])
    }

    private func emit(_ state: String) {
        self.eventChannel.success([
            "event": Events.messageEvent,
            "state": state,
        ])

        NotificationCenter.default.post(
            name: .dgisNavigationMessageTick,
            object: nil,
            userInfo: ["state": state]
        )
    }
    
    func cancel() {
        self.cancelable.forEach { $0.cancel() }
        self.cancelable.removeAll()
    }
}
