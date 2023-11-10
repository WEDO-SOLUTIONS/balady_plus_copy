import DGis
import Foundation

enum RouteColorType {
    case normal
    case dimmed
    case withValue
}

struct RouteColor {
    let type: RouteColorType
    let value: UInt32?
    
    func toMap() -> [String: Any?] {
        return [
            "type": "\(type)",
            "value": value
        ]
    }
}

enum TransferIconType {
    case start
    case finish
    case empty
    case transport
}

struct TransferIcon {
    let type: TransferIconType
    let value: Any?
    
    func toMap() -> [String: Any?] {
        let mappedValue: Any? = {
            switch value {
            case let icon as BriefPublicTransportModel.TransportIcon:
                return icon.toMap()
            case let color as RouteColor:
                return color.toMap()
            default:
                return value
            }
        }()
        return [
            "type": "\(type)",
            "value": mappedValue
        ]
    }
}

enum TextColorType {
    case normal
    case highlighted
    case withValue
}

struct TextColor {
    let type: TextColorType
    let value: UInt32?
    
    func toMap() -> [String: Any?] {
        return [
            "type": "\(type)",
            "value": value
        ]
    }
}

struct Car {
    let highlighted: Bool
    
    func toMap() -> [String: Any?] {
        return [
            "highlighted": highlighted
        ]
    }
}

enum TransferDescriptionType {
    case onFoot
    case metro
    case ofType
    case finish
}

struct TransferDescription {
    let type: TransferDescriptionType
    let value: Any?
    var color: TextColor
    
    func toMap() -> [String: Any?] {
        return [
            "type": "\(type)",
            "value": value,
            "color": color.toMap()
        ]
    }
}

struct Transfer {
    let title: String?
    let duration: Int?
    let icon: TransferIcon
    let lineColor: RouteColor?
    let description: TransferDescription?
    let transports: [BriefPublicTransportModel.Transport]
    let stopCount: Int?
    let useStationsInsteadOfStops: Bool
    let getOffAfter: String?
    let stops: [String]
    let boardingDescription: String?
    let cars: [Car]
    
    func toMap() -> [String: Any?] {
        return [
            "title": title,
            "duration": duration,
            "icon": icon.toMap(),
            "lineColor": lineColor?.toMap(),
            "description": description?.toMap(),
            "transports": transports.map { $0.toMap() },
            "stopCount": stopCount,
            "useStationsInsteadOfStops": useStationsInsteadOfStops,
            "getOffAfter": getOffAfter,
            "stops": stops,
            "boardingDescription": boardingDescription,
            "cars": cars.map { $0.toMap() }
        ]
    }
}
