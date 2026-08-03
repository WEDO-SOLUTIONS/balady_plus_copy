import Foundation
import DGis

extension RoadEventActionTypeMessage {
    func toRoadEventActionType() -> RoadEventActionType {
        switch self {
        case .like:
            return .like
        case .dislike:
            return .dislike
        case .confirmation:
            return .confirmation
        case .disproof:
            return .disproof
        }
    }
}

extension ActionResult {
    func toMessage() -> RoadEventActionResultMessage {
        switch self {
        case .ok:
            return .ok
        case .networkError:
            return .networkError
        }
    }
}
