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

extension BriefRouteInfoSearchPointsMessage {
    func toSearchPoint() -> BriefRouteInfoSearchPoints {
        return BriefRouteInfoSearchPoints(
                startPoint: startPoint.toRouteSearchPoint(),
                finishPoint: finishPoint.toRouteSearchPoint()
        )
    }
}

extension BearingMessage {
    func toBearing() -> Bearing {
        return Bearing(value: Double(truncating: self.value))
    }
}

extension DgisObjectIdMessage {
    func toDgisObjectId() -> DgisObjectId {
        return DgisObjectId(objectId: UInt64(truncating: self.objectId),
                            entranceId: UInt64(truncating: self.entranceId))
    }
}

extension LevelIdMessage {
    func toLevelId() -> LevelId {
        return LevelId(value: UInt64(self.value.doubleValue))
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
        case .car(_):
            return BriefExtraRouteInfoMessage.car
        case .bicycle(_):
            return BriefExtraRouteInfoMessage.bicycle
        case .pedestrian(_):
            return BriefExtraRouteInfoMessage.pedestrian
        case .publicTransport(_):
            return BriefExtraRouteInfoMessage.publicTransport
        case .scooter(_):
            return BriefExtraRouteInfoMessage.scooter
        @unknown default:
            return BriefExtraRouteInfoMessage.car
        }
    }
}

extension BriefRouteInfo {
    func toBriefRouteInfoMessage() -> BriefRouteInfoMessage {
        return BriefRouteInfoMessage.make(
            withDuration: self.duration.toDuration(),
            extraInfo: extraInfo.toBriefExtraRouteInfoMessage())
    }
}

extension TimeInterval{
    func toDuration()->NSNumber{
        return self as NSNumber
    }
}
