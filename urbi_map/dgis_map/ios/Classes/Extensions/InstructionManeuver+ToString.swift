import Foundation
import DGis

extension InstructionManeuver {
    func name() -> String {
        switch self {
        case .none:
            return "none"
        case .start:
            return "start"
        case .finish:
            return "finish"
        case .crossroadStraight:
            return "crossroad_straight"
        case .crossroadSlightlyLeft:
            return "crossroad_slightly_left"
        case .crossroadLeft:
            return "crossroad_left"
        case .crossroadSharplyLeft:
            return "crossroad_sharply_left"
        case .crossroadSlightlyRight:
            return "crossroad_slightly_right"
        case .crossroadRight:
            return "crossroad_right"
        case .crossroadSharplyRight:
            return "crossroad_sharply_right"
        case .crossroadKeepLeft:
            return "crossroad_keep_left"
        case .crossroadKeepRight:
            return "crossroad_keep_right"
        case .crossroadUTurn:
            return "crossroad_uturn"
        case .roundaboutForward:
            return "roundabout_forward"
        case .roundaboutLeft45:
            return "roundabout_left_45"
        case .roundaboutLeft90:
            return "roundabout_left_90"
        case .roundaboutLeft135:
            return "roundabout_left_135"
        case .roundaboutRight45:
            return "roundabout_right_45"
        case .roundaboutRight90:
            return "roundabout_right_90"
        case .roundaboutRight135:
            return "roundabout_right_135"
        case .roundaboutBackward:
            return "roundabout_backward"
        case .roundaboutExit:
            return "roundabout_exit"
        case .uTurn:
            return "uturn"
        case .roadCrossing:
            return "road_crossing"
        }
    }
}
