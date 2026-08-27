import DGis
import Foundation

class BriefPublicTransportModel {
    private let transfers: [PublicTransportTransferRouteLongEntry]
    
    enum TransportIconType {
        case ofType
        case combined
        case special
    }
    
    struct TransportIcon {
        let type: TransportIconType
        let value: String
        let color: UInt32?
        
        func toMap() -> [String: Any?] {
            return [
                "type": "\(type)",
                "value": value,
                "color": color
            ]
        }
    }
    
    struct Transport {
        let icon: TransportIcon
        let names: [String]
        
        func toMap() -> [String: Any?] {
            return [
                "icon": icon.toMap(),
                "names": names
            ]
        }
    }
    
    let duration: Int
    let transports: [Transport]
    let transferCount: Int
    let onFootDuration: Int
    let publicTransportTransferRouteLongEntry: Array<[String: Any?]>
    
    init(route: TrafficRoute, currentPosition: RoutePoint? = nil) {
        self.transfers = route.route.publicTransportTransfers.entries
        if let currentPosition = currentPosition {
            self.duration = Int(route.traffic.durations.calculateDuration(routePoint: currentPosition).rounded())
        } else {
            self.duration = route.estimatedDuration
        }
        self.transports = transfers.compactMap { entry in
            let transfer = entry.value
            
            guard let transportIcon = transfer.transportIcon else {
                return nil
            }
            
            return Transport(
                icon: transportIcon,
                names: transfer.transportNames
            )
        }
        self.transferCount = transfers.transferCount
        self.onFootDuration = route.onFootDuration
        self.publicTransportTransferRouteLongEntry = transfers.map { $0.toMap }
    }
    
    func toMap() -> [String: Any?]  {
        return [
            "duration": duration,
            "transports": transports.map { $0.toMap() },
            "transferCount": transferCount,
            "onFootDuration": onFootDuration,
            "publicTransportTransferRouteLongEntry": transfers.map { $0.toMap }
        ]
    }
}

extension TrafficRoute {
    var estimatedDuration: Int {
        return Int(
            traffic.durations.calculateDuration(
                routePoint: RoutePoint(distance: RouteDistance(millimeters: 0))
            ).rounded()
        )
    }
    
    var onFootDuration: Int {
        let durations = traffic.durations
        var result = 0
        
        for entry in route.publicTransportTransfers.entries {
            if entry.value.onFoot {
                result += Int(durations.calculateDuration(routePoint: entry.point).rounded())
            }
        }
        
        return result
    }
}

extension PublicTransportTransfer {
    var onFoot: Bool {
        return routeParts.isEmpty || routeParts.first!.transports.isEmpty
    }
    
    var transportTypes: Set<PublicTransportType> {
        if routeParts.isEmpty {
            return []
        }
        
        return Set(routeParts.first!.transports.map { $0.type })
    }
    
    var transportNames: [String] {
        if routeParts.isEmpty {
            return []
        }
        
        return Array(Set(routeParts.first!.transports.flatMap { $0.names }))
    }
    
    var firstTransport: PublicTransportInfo? {
        return routeParts.first?.transports.first
    }
    
    var color: UInt32? {
        return firstTransport?.color
    }
    
    var routeLogo: String? {
        return firstTransport?.routeLogo
    }
    
    var transportIcon: BriefPublicTransportModel.TransportIcon? {
        let types = transportTypes
        var icon: BriefPublicTransportModel.TransportIcon?
        
        switch types.count {
        case 1:
            if let firstType = types.first {
                icon = BriefPublicTransportModel.TransportIcon(
                    type: .ofType,
                    value: firstType.kotlinName,
                    color: firstType.isMetro ? color : nil
                )
            }
        default:
            icon = BriefPublicTransportModel.TransportIcon(
                type: .combined,
                value: "combined",
                color: nil
            )
        }
        
        if let routeLogo = routeLogo, !routeLogo.isEmpty {
            icon = BriefPublicTransportModel.TransportIcon(
                type: .special,
                value: routeLogo,
                color: nil
            )
        }
        
        return icon
    }
}

extension PublicTransportType {
    var isMetro: Bool {
        self == .metro ||
        self == .lightMetro ||
        self == .moscowCentralDiameters ||
        self == .moscowCentralRing
    }
    
    var kotlinName: String {
        switch (self) {
        case .bus:
            return "BUS"
        case .trolleybus:
            return "TROLLEYBUS"
        case .tram:
            return "tram"
        case .shuttleBus:
            return "SHUTTLE_BUS"
        case .metro:
            return "METRO"
        case .suburbanTrain:
            return "SUBURBAN_TRAIN"
        case .funicularRailway:
            return "FUNICULAR_RAILWAY"
        case .monorail:
            return "MONORAIL"
        case .waterwayTransport:
            return "WATERWAY_TRANSPORT"
        case .cableCar:
            return "CABLE_CAR"
        case .speedTram:
            return "SPEED_TRAM"
        case .premetro:
            return "PREMETRO"
        case .lightMetro:
            return "LIGHT_METRO"
        case .aeroexpress:
            return "AEROEXPRESS"
        case .moscowCentralRing:
            return "MOSCOW_CENTRAL_RING"
        case .moscowCentralDiameters:
            return "MOSCOW_CENTRAL_DIAMETERS"
        @unknown default:
            return "UNKNOWN"
        }
    }
}

extension [PublicTransportTransferRouteLongEntry] {
    var transferCount: Int {
        Swift.max(0, filter { !$0.value.onFoot }.count - 1)
    }
}

// - PUBLIC TRANSPORT FOR ROUTE

extension PublicTransportTransferRouteLongEntry {
    var toMessage: PublicTransportTransferRouteLongEntryMessage {
        let length = RouteDistanceMessage(millimeters: self.length.millimeters)
        let point = RoutePointMessage(
            distance: RouteDistanceMessage(millimeters: self.point.distance.millimeters)
        )
        
        let value = PublicTransportTransferMessage(
            startPointName: self.value.startPointName,
            finishPointName: self.value.finishPointName,
            routeParts: self.value.routeParts.map {
                PublicRoutePartMessage(
                    transports: $0.transports.map { $0.toMessage },
                    intermediateStops: $0.intermediateStops.map {
                        PublicTransportStopMessage(
                            coordinates: $0.coordinates.toMessage(),
                            name: $0.name
                        )
                    }
                )
            }
        )
        return PublicTransportTransferRouteLongEntryMessage(point: point, length: length, value: value)
    }
    
    var toMap: [String: Any?] {
        // Point property - RoutePoint with distance
        let point: [String: Any?] = [
            "distance": [
                "millimeters": self.point.distance.millimeters
            ]
        ]
        
        // Length property - RouteDistance
        let length: [String: Any?] = [
            "millimeters": self.length.millimeters
        ]
        
        // Value property - PublicTransportTransfer
        let value: [String: Any?] = [
            "startPointName": self.value.startPointName,
            "finishPointName": self.value.finishPointName,
            "routeParts": self.value.routeParts.map { routePart in
                [
                    "transports": routePart.transports.map { transport in
                        [
                            "type": transport.type.kotlinName,
                            "names": transport.names,
                            "suggestedCarNumbers": transport.suggestedCarNumbers,
                            "boardingSuggest": transport.boardingSuggest,
                            "routeLogo": transport.routeLogo,
                            "color": transport.color
                        ] as [String: Any?]
                    },
                    "intermediateStops": routePart.intermediateStops.map { stop in
                        [
//                            "coordinates": [ "latitude": 1, "longitude" : 1] as [String: Any?],
//                                "latitude": stop.coordinates.latitude,
//                                "longitude": stop.coordinates.longitude
//                            ] as [String: Any?],
                            "name": stop.name
                        ] as [String: Any?]
                    }
                ] as [String: Any?]
            }
        ]
        
        return [
            "point": point,
            "length": length,
            "value": value
        ]
    }
}

extension PublicTransportInfo {
    var toMessage: PublicTransportInfoMessage {
        return PublicTransportInfoMessage(
            type: self.type.toMessage,
            names: self.names,
            suggestedCarNumbers: self.suggestedCarNumbers.map { Int64.init(bitPattern: UInt64($0)) },
            boardingSuggest: self.boardingSuggest,
            routeLogo: self.routeLogo
        )
    }
}

extension PublicTransportTransfer {
    func toMessage() -> PublicTransportTransferMessage {
        return PublicTransportTransferMessage(
            startPointName: self.startPointName,
            finishPointName: self.finishPointName,
            routeParts: self.routeParts.map { routePart in
                PublicRoutePartMessage(
                    transports: routePart.transports.map { $0.toMessage },
                    intermediateStops: routePart.intermediateStops.map { stop in
                        PublicTransportStopMessage(
                            coordinates: stop.coordinates.toMessage(),
                            name: stop.name
                        )
                    }
                )
            }
        )
    }
}

extension PublicTransportStop {
    func toMessage() -> PublicTransportStopMessage {
        return PublicTransportStopMessage(
            coordinates: self.coordinates.toMessage(),
            name: self.name
        )
    }
}
