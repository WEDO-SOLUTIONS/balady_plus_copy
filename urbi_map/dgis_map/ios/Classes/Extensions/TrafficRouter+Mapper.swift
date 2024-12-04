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

extension BriefExtraRouteInfo {
    func toBriefExtraRouteInfoMessage() -> BriefExtraRouteInfoMessage {
        switch self {
        case let .car(carBriefRouteInfo):
            let distance = NSNumber(value: carBriefRouteInfo.length.millimeters)
            return BriefExtraRouteInfoMessage.make(withType: BriefExtraRouteInfoTypeMessage.car, distance: Int(truncating: distance))
        case let .bicycle(bicycleBriefRouteInfo):
            let distance = NSNumber(value: bicycleBriefRouteInfo.length.millimeters)
            return BriefExtraRouteInfoMessage.make(withType: BriefExtraRouteInfoTypeMessage.bicycle, distance: Int(truncating: distance))
        case let .pedestrian(pedestrianBriefRouteInfo):
            let distance = NSNumber(value: pedestrianBriefRouteInfo.length.millimeters)
            return BriefExtraRouteInfoMessage.make(withType: BriefExtraRouteInfoTypeMessage.pedestrian, distance: Int(truncating:distance))
        case .publicTransport:
            return BriefExtraRouteInfoMessage.make(withType: BriefExtraRouteInfoTypeMessage.publicTransport, distance: Int(0.0))
        case let .scooter(scooterBriefRouteInfo):
            let distance = NSNumber(value: scooterBriefRouteInfo.length.millimeters)
            return BriefExtraRouteInfoMessage.make(withType: BriefExtraRouteInfoTypeMessage.scooter, distance: Int(truncating:distance))
        @unknown default:
            let carBriefRouteInfo = self as? CarBriefRouteInfo
            let distance = NSNumber(value: carBriefRouteInfo?.length.millimeters ?? 0)
            return BriefExtraRouteInfoMessage.make(withType: BriefExtraRouteInfoTypeMessage.car, distance: Int(truncating:distance))
        }
    }
}


extension BriefRouteInfo {
    func toBriefRouteInfoMessage() -> BriefRouteInfoMessage {
        return BriefRouteInfoMessage.make(
            withDuration: self.duration,
            extraInfo: extraInfo.toBriefExtraRouteInfoMessage())
    }
}

extension TimeInterval{
    func toDuration()->NSNumber{
        return self as NSNumber
    }
}
