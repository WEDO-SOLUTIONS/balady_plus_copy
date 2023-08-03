import Foundation
import DGis

extension CameraAnimationTypeMessage {
    var animationType: CameraAnimationType {
        switch self {
        case .default_:
            return .default
        case .linear:
            return .linear
        case .showBothPositions:
            return .showBothPositions
        }
    }
}
