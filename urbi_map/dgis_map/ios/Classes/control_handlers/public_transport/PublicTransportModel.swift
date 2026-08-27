import DGis
import Foundation

class PublicTransportModel {
    let route: TrafficRoute
    
    let currentPosition: RoutePoint?

    init(route: TrafficRoute, currentPosition: RoutePoint? = nil) {
        self.route = route
        self.currentPosition = currentPosition
    }

    var briefModel: BriefPublicTransportModel {
        BriefPublicTransportModel(route: route, currentPosition: currentPosition)
    }
    
    var transfers: [Transfer] {
        let durations = route.traffic.durations
        var prevEndPoint: String? = nil
        var prevLineColor: RouteColor? = nil
        let entries = route.route.publicTransportTransfers.entries
        
        var result = entries.map { entry -> Transfer in
            let transfer: PublicTransportTransfer = entry.value
            let isFirst = prevEndPoint == nil
            let transferStartPoint = transfer.startPointName.isEmpty ? nil : transfer.startPointName
            let title = transferStartPoint ?? prevEndPoint
            prevEndPoint = transfer.finishPointName
            let transportTypes = transfer.transportTypes
            let transports = transfer.transports
            let isMetro = transportTypes.count == 1 && transportTypes.first!.isMetro
            let onFoot = transports.isEmpty
            let stops = transfer.stops
            
            var lineColor: RouteColor? = nil
            if onFoot {
                lineColor = RouteColor(
                    type: .dimmed,
                    value: nil
                )
            } else if transportTypes.count > 1 {
                lineColor = RouteColor(
                    type: .normal,
                    value: nil
                )
            } else {
                lineColor = transfer.color?.toRouteColor() ?? RouteColor(
                    type: .normal,
                    value: nil
                )
            }
            
            var descriptionColor: TextColor = TextColor(type: .normal, value: nil)
            if isMetro && lineColor?.type == .withValue {
                descriptionColor = TextColor(type: .withValue, value: lineColor?.value!)
            }
            
            var description: TransferDescription?
            if onFoot {
                description = TransferDescription(
                    type: .onFoot,
                    value: Double(entry.length.millimeters) / 1000.0,
                    color: descriptionColor
                )
            } else if transports.count > 1 {
                // do nothing
            } else {
                let type = transportTypes.first!
                let names = transports.first?.names ?? []
                switch names.count {
                case 0:
                    description = TransferDescription(
                        type: .ofType,
                        value: type.kotlinName,
                        color: descriptionColor
                    )
                case 1:
                    if type.isMetro {
                        description = TransferDescription(
                            type: .metro,
                            value: names.first!,
                            color: descriptionColor
                        )
                    }
                default:
                    break
                }
            }
            
            let transportIcon = transfer.transportIcon?.recolor(
                color: lineColor?.type == .withValue ? lineColor?.value! : nil
            )
            
            let transferObj = Transfer(
                title: title,
                duration: durations.calculateDuration(entry: entry),
                icon: isFirst ? TransferIcon(
                    type: .start,
                    value: nil
                ) : transportIcon != nil ? TransferIcon(
                    type: .transport,
                    value: transportIcon!
                ) : TransferIcon(
                    type: .empty,
                    value: prevLineColor ?? RouteColor(type: .normal, value: nil)
                ),
                lineColor: lineColor,
                description: description,
                transports: description == nil ? transports : [],
                stopCount: onFoot ? nil : (stops.isEmpty ? 0 : stops.count),
                useStationsInsteadOfStops: transportTypes.useStationsInsteadOfStops,
                getOffAfter: stops.last,
                stops: stops,
                boardingDescription: transfer.boardingDescription,
                cars: transfer.cars
            )
            prevLineColor = lineColor
            return transferObj
        }
        
        let lastTransfer = Transfer(
            title: prevEndPoint?.isEmpty == false ? prevEndPoint : nil,
            duration: nil,
            icon: TransferIcon(
                type: .finish,
                value: nil
            ),
            lineColor: nil,
            description: TransferDescription(
                type: .finish,
                value: nil,
                color: TextColor(
                    type: .highlighted,
                    value: nil
                )
            ),
            transports: [],
            stopCount: nil,
            useStationsInsteadOfStops: false,
            getOffAfter: nil,
            stops: [],
            boardingDescription: nil,
            cars: []
        )
        result.append(lastTransfer)
        
        
        return result
    }
    
    func toMap() -> [String: Any]  {
        return [
            "brief": briefModel.toMap(),
            "transfers": transfers.map { $0.toMap() },
        ]
    }
}

extension MillisecondsRouteAttribute {
    func calculateDuration(entry: PublicTransportTransferRouteLongEntry) -> Int {
        return Int(
            calculateDuration(routePoint: entry.point).rounded() -
            calculateDuration(
                routePoint: RoutePoint(
                    distance: RouteDistance(
                        millimeters: entry.point.distance.millimeters + entry.length.millimeters
                    )
                )
            ).rounded()
        )
    }
}

extension PublicTransportTransfer {
    var transports: [BriefPublicTransportModel.Transport] {
        if routeParts.isEmpty {
            return []
        }
        return routeParts.first!.transports.map {
            BriefPublicTransportModel.Transport(
                icon: BriefPublicTransportModel.TransportIcon(
                    type: BriefPublicTransportModel.TransportIconType.ofType,
                    value: "\($0.type)",
                    color: $0.type.isMetro ? color : nil
                ),
                names: $0.names
            )
        }
    }
    
    var stops: [String] {
        if routeParts.isEmpty {
            return []
        }
        return routeParts.first!.intermediateStops.map { $0.name }
    }
    
    var boardingDescription: String? {
        guard firstTransport?.boardingSuggest.isEmpty == false else {
            return nil
        }
        
        return firstTransport?.boardingSuggest.capitalized
    }
    
    var cars: [Car] {
        guard let transport = firstTransport, !transport.boardingSuggest.isEmpty else {
            return []
        }
        let numbers = transport.suggestedCarNumbers
        return (0..<5).map {
            Car(highlighted: numbers.contains($0 + 1))
        }
    }
}


extension Set<PublicTransportType> {
    var useStationsInsteadOfStops: Bool {
        guard count == 1 else {
            return false
        }
        
        switch first {
        case .metro, .suburbanTrain, .premetro, .lightMetro, .moscowCentralRing, .moscowCentralDiameters:
            return true
        default:
            return false
        }
    }
}

extension UInt32 {
    func toRouteColor() -> RouteColor {
        return RouteColor(
            type: RouteColorType.withValue,
            value: self
        )
    }
}

extension BriefPublicTransportModel.TransportIcon {
    func recolor(color: UInt32?) -> BriefPublicTransportModel.TransportIcon {
        switch self.type {
        case .combined:
            return self
        case .ofType, .special:
            return BriefPublicTransportModel.TransportIcon(
                type: self.type,
                value: self.value,
                color: color
            )
        }
    }
}
