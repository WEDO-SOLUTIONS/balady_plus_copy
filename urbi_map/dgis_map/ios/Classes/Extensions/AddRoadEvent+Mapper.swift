import Foundation
import DGis

extension AddEventError {
    func toMessage() -> AddRoadEventResultMessage {
        switch self {
        case .networkError:
            return .networkError
        case .territoryNotSupported:
            return .territoryNotSupported
        case .unknownUserLocation:
            return .unknownUserLocation
        case .userLocationTooFarFromEvent:
            return .userLocationTooFarFromEvent
        case .notAuthorized:
            return .notAuthorized
        case .noPersonalDataCollectionConsent:
            return .noPersonalDataCollectionConsent
        case .userBlocked:
            return .userBlocked
        case .tooManyRequests:
            return .tooManyRequests
        }
    }
}

extension RoadEventLaneMessage {
    var laneOption: LaneOptionSet {
        switch self {
        case .left:
            return .left
        case .center:
            return .center
        case .right:
            return .right
        }
    }
}

extension Array where Element == RoadEventLaneMessage {
    func toLaneOptionSet() -> LaneOptionSet {
        self.reduce(into: LaneOptionSet()) { set, lane in
            set.insert(lane.laneOption)
        }
    }
}
