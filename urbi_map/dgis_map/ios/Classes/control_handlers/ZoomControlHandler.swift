import Foundation
import DGis

class ZoomControlHandler {
    private class Events {
        static let zoomOutEvent = "zoomOutEvent"
        static let zoomInEvent = "zoomInEvent"
    }
    
    private let model: ZoomControlModel
    private var cancelable: Array<Cancellable> = []
    
    init(map: Map, eventChannel: DgisStreamHandler) {
        self.model = ZoomControlModel(map: map)
        
        cancelable.append(model.isEnabled(button: .zoomOut).sinkOnMainThread {
            value in
            eventChannel.success([
                "event": Events.zoomOutEvent,
                "value": value
            ])
        })
        cancelable.append(model.isEnabled(button: .zoomIn).sinkOnMainThread {
            value in
            eventChannel.success([
                "event": Events.zoomInEvent,
                "value": value
            ])
        })
    }
    
    func onZoomDown(_ type: ZoomControlMessage) {
        self.model.setPressed(button: type.toButton, value: true)
    }
    
    func onZoomUp(_ type: ZoomControlMessage) {
        self.model.setPressed(button: type.toButton, value: false)
    }
    
    func cancel() {
        cancelable.forEach { $0.cancel() }
        cancelable.removeAll()
    }
}

private extension ZoomControlMessage {
    var toButton: ZoomControlButton {
        get {
            switch(self) {
            case .zoomIn:
                return .zoomIn
            case .zoomOut:
                return .zoomOut
            @unknown default:
                fatalError("Unknown ZoomControlMessage type")
            }
        }
    }
}
