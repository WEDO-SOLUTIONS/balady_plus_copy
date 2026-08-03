import Foundation
import DGis

class TrafficAndParkingConstants {
    // EVENTS
    public static let parkingStateChanged = "parkingStateChanged"
    public static let trafficStateChanged = "trafficStateChanged"
    
    // ATTRIBUTES
    public static let parkingAttrName = "parkingOn"
    public static let parkingFilterAttrName = "parkingFilter"
}

class TrafficAndParkingControlHandler {
    private class Events {
        static let parkingStateChanged = TrafficAndParkingConstants.parkingStateChanged
        static let trafficStateChanged = TrafficAndParkingConstants.trafficStateChanged
    }
    
    private let parkingAttrName = TrafficAndParkingConstants.parkingAttrName
    private let parkingFilterAttrName = TrafficAndParkingConstants.parkingFilterAttrName
    
    private let map: Map
    private let eventChannel: DgisStreamHandler
    private let trafficControlModel: TrafficControlModel
    // A single shared source: the SDK only supports one active RoadEventSource per map, so
    // Traffic and the explicit "Road Events" button both contribute categories into the same
    // instance instead of each owning their own.
    private let roadEventsSource: RoadEventSource

    private var trafficWantsRoadEvents = false
    private var buttonWantsRoadEvents = false

    private var cancelable: Array<Cancellable> = []

    init(sdk: Context, map: Map, eventChannel: DgisStreamHandler) {
        self.map = map
        self.trafficControlModel = TrafficControlModel(map: map)
        self.eventChannel = eventChannel
        self.roadEventsSource = RoadEventSource(context: sdk)
    }
    
    func onAttachToMap() {
        self.cancelable.append(self.map.attributes.changed.sink { attributes in
            if (attributes.contains(self.parkingAttrName) || attributes.contains(self.parkingFilterAttrName)) {
                var filterAttribute: String?
                if case let .string(value) = self.map.attributes.getAttributeValue(name: self.parkingFilterAttrName) {
                    filterAttribute = value
                }
                self.eventChannel.success([
                    "event": Events.parkingStateChanged,
                    "visible": self.isParkingOn(),
                    "filterAttribute": filterAttribute
                ])
            }
        })
        
        self.cancelable.append(self.trafficControlModel.stateChannel.sink { trafficState in
            switch trafficState.status {
            case .enabled:
                self.trafficWantsRoadEvents = true
                self.updateRoadEventsSource()
            case .disabled:
                self.trafficWantsRoadEvents = false
                self.updateRoadEventsSource()
            default:
                break
            }
            
            self.eventChannel.success([
                "event": Events.trafficStateChanged,
                "status":  trafficState.status.rawValue,
                "score": trafficState.score ?? 0
            ])
        })
    }
    
    private func updateRoadEventsSource() {
        var categories: RoadEventDisplayCategoryOptionSet = []
        if self.trafficWantsRoadEvents {
            categories.insert(.roadRestriction)
        }
        if self.buttonWantsRoadEvents {
            categories = [.camera, .comment, .accident, .roadRestriction, .roadWorks, .other, .user]
        }

        if categories.isEmpty {
            if self.map.sources.contains(roadEventsSource) {
                self.map.removeSource(source: roadEventsSource)
            }
            return
        }

        self.roadEventsSource.visibleEvents = categories
        if !self.map.sources.contains(roadEventsSource) {
            self.map.addSource(source: roadEventsSource)
        }
    }

    func addRoadEventSource() {
        self.buttonWantsRoadEvents = true
        self.updateRoadEventsSource()
    }

    func removeRoadEventSource() {
        self.buttonWantsRoadEvents = false
        self.updateRoadEventsSource()
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
