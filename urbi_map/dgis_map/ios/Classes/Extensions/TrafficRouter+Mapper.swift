import Foundation
import DGis

extension RouteSearchOptionsMessage {
    func toRouteSearchOptions() -> RouteSearchOptions {
        switch self {
        case .bicycle:
            return RouteSearchOptions.bicycle(BicycleRouteSearchOptions.init())
        case .car:
            return RouteSearchOptions.car(CarRouteSearchOptions.init())
        case .publicTransport:
            return RouteSearchOptions.publicTransport(PublicTransportRouteSearchOptions.init())
        case .pedestrian:
            return RouteSearchOptions.pedestrian(PedestrianRouteSearchOptions.init())
        case .scooter:
            return RouteSearchOptions.scooter(ScooterRouteSearchOptions.init())
        case .truck:
            return RouteSearchOptions.truck(TruckRouteSearchOptions.init(car: CarRouteSearchOptions.init()))
        case .taxi:
            return RouteSearchOptions.taxi(TaxiRouteSearchOptions.init(car: CarRouteSearchOptions.init()))
        @unknown default:
            return RouteSearchOptions.car(CarRouteSearchOptions.init())
        }
    }
    
}

extension RouteSearchOptions {
    func toRouteSearchOptions() -> RouteSearchOptionsMessage {
        switch self {
        case .bicycle:
            return .bicycle
        case .car:
            return .car
        case .publicTransport:
            return .publicTransport
        case .pedestrian:
            return .pedestrian
        case .scooter:
            return .scooter
        case .truck:
            return .truck
        case .taxi:
            return .taxi
        @unknown default:
            return .car
        }
    }
    
}

extension BearingMessage {
    func toBearing() -> Bearing {
        return Bearing(value:  self.value)
    }
}

extension DgisObjectIdMessage {
    func toDgisObjectId() -> DgisObjectId {
        return DgisObjectId(objectId: UInt64( self.objectId),
                            entranceId: UInt64( self.entranceId))
    }
}

extension LevelIdMessage {
    func toLevelId() -> LevelId {
        return LevelId(value: UInt64(self.value))
    }
}

extension RouteSearchPointMessage {
    func toRouteSearchPoint() -> RouteSearchPoint {
        return RouteSearchPoint(
            coordinates: coordinates.geoPoint,
                course: course?.toBearing(),
                objectId: objectId.toDgisObjectId(),
                levelId: levelId?.toLevelId()
        )
    }
}

extension RouteSearchPoint {
    func toMessage() -> RouteSearchPointMessage {
        return RouteSearchPointMessage(
            coordinates: coordinates.toMessage(),
            course: course.map { BearingMessage(value: $0.value) },
            objectId: objectId.toMessage(),
            levelId: levelId.map { LevelIdMessage(value: Int64($0.value)) }
        )
    }
}

extension BriefExtraRouteInfo {
    func toBriefExtraRouteInfoMessage() -> BriefExtraRouteInfoMessage {
        switch self {
        case let .car(carBriefRouteInfo):
            let distance = NSNumber(value: carBriefRouteInfo.length.millimeters)
            return BriefExtraRouteInfoMessage(type: BriefExtraRouteInfoTypeMessage.car, distance: Int64(truncating: distance))
        case let .bicycle(bicycleBriefRouteInfo):
            let distance = NSNumber(value: bicycleBriefRouteInfo.length.millimeters)
            return BriefExtraRouteInfoMessage(type: BriefExtraRouteInfoTypeMessage.bicycle, distance: Int64(truncating: distance))
        case let .pedestrian(pedestrianBriefRouteInfo):
            let distance = NSNumber(value: pedestrianBriefRouteInfo.length.millimeters)
            return BriefExtraRouteInfoMessage(type: BriefExtraRouteInfoTypeMessage.pedestrian, distance: Int64(truncating:distance))
        case .publicTransport:
            return BriefExtraRouteInfoMessage(type: BriefExtraRouteInfoTypeMessage.publicTransport, distance: Int64(0.0))
        case let .scooter(scooterBriefRouteInfo):
            let distance = NSNumber(value: scooterBriefRouteInfo.length.millimeters)
            return BriefExtraRouteInfoMessage(type: BriefExtraRouteInfoTypeMessage.scooter, distance: Int64(truncating:distance))
        @unknown default:
            let carBriefRouteInfo = self as? CarBriefRouteInfo
            let distance = NSNumber(value: carBriefRouteInfo?.length.millimeters ?? 0)
            return BriefExtraRouteInfoMessage(type: BriefExtraRouteInfoTypeMessage.car, distance: Int64(truncating:distance))
        }
    }
}


extension BriefRouteInfo {
    func toBriefRouteInfoMessage() -> BriefRouteInfoMessage {
        return BriefRouteInfoMessage(
            duration: self.duration,
            extraInfo: extraInfo.toBriefExtraRouteInfoMessage())
    }
}

extension TimeInterval{
    func toDuration()->NSNumber{
        return self as NSNumber
    }
}
