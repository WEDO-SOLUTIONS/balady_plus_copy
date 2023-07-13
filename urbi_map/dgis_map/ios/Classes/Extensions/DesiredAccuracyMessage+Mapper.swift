import Foundation
import DGis

extension DesiredAccuracyMessage {
    func toSdkAccuracy() -> DesiredAccuracy {
        switch self {
            case .low:
                return .low
            case .medium:
                return .medium
            case .high:
                return .high
            }
    }
}
