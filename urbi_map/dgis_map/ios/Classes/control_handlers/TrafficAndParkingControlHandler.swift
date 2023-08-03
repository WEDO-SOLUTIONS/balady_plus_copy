import Foundation
import DGis

class TrafficAndParkingControlHandler {
    private class Events {
        static let parkingStateChanged = "parkingStateChanged"
        static let trafficStateChanged = "trafficStateChanged"
    }
    
    private let parkingAttrName = "parkingOn"
    
    private let map: Map
    private let eventChannel: DgisStreamHandler
    private let trafficControlModel: TrafficControlModel

    private var cancelable: Array<Cancellable> = []
    
    init(map: Map, eventChannel: DgisStreamHandler) {
        self.map = map
        self.trafficControlModel = TrafficControlModel(map: map)
        self.eventChannel = eventChannel
    }
    
    func onAttachToMap() {
        self.cancelable.append(self.map.attributes.changed.sink { bearing in
            self.eventChannel.success([
                "event": Events.parkingStateChanged,
                "visible": self.isParkingOn(),
            ])
        })
        
        self.cancelable.append(self.trafficControlModel.stateChannel.sink { trafficState in
            self.eventChannel.success([
                "event": Events.trafficStateChanged,
                "status":  trafficState.status.rawValue,
                "score": trafficState.score ?? 0
            ])
        })
    }
    
    func onDetachFromMap() {
        cancel()
    }
    
    func onParkingClicked() {
        self.setParkingOn(!isParkingOn())
    }
    
    func onTrafficClicked() {
        self.trafficControlModel.onClicked()
    }
    
    func cancel() {
        self.cancelable.forEach { $0.cancel() }
        self.cancelable.removeAll()
    }
    
    private func isParkingOn() -> Bool {
        let isParkingOn = self.map.attributes.getAttributeValue(name: parkingAttrName)
        
        return isParkingOn == .boolean(true)
    }

    private func setParkingOn(_ isOn: Bool) {
        var oldValue: Bool?
        if case let .boolean(value) = self.map.attributes.getAttributeValue(name: parkingAttrName) {
            oldValue = value
        }
        if oldValue != isOn {
            self.map.attributes.setAttributeValue(
                name: parkingAttrName,
                value: .boolean(isOn)
            )
        }
    }
}
