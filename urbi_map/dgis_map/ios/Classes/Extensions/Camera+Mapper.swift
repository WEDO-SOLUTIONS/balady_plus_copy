import Foundation
import DGis

extension CameraAnimationTypeMessage {
    var animationType: CameraAnimationType {
        switch self {
        case .defaultType:
            return .default
        case .linear:
            return .linear
        case .showBothPositions:
            return .showBothPositions
        }
    }
}
