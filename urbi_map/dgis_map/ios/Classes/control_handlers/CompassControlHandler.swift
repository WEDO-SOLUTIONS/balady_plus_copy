import Foundation
import DGis

class CompassControlHandler {
    private class Events {
        static let compassBearingChanged = "compassBearingChanged"
    }
    
    private var cancelable: Array<Cancellable> = []
    private var compassControlModel: CompassControlModel?
    
    init(map: Map, eventChannel: DgisStreamHandler) {
        self.compassControlModel = CompassControlModel(map: map)
        self.cancelable.append(self.compassControlModel!.bearingChannel.sinkOnMainThread { bearing in
            eventChannel.success([
                "event": Events.compassBearingChanged,
                "value": bearing.value,
            ])
        })
    }
    
    func onClicked() {
        self.compassControlModel?.onClicked()
    }
    
    func cancel() {
        self.cancelable.forEach { $0.cancel() }
        self.cancelable.removeAll()
    }
}
