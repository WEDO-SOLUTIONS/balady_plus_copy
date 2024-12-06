import Foundation
import DGis

extension Geometry {
    func toMessage() -> GeometryMessage {
        GeometryMessage(
            kind: self.kind.toMessage(),
            bounds: self.bounds.toMessage(),
            minPoint: self.minPoint.toMessage(),
            maxPoint: self.maxPoint.toMessage()
        )
    }
}

extension GeometryKind {
    func toMessage() -> GeometryKindMessage {
        switch self {
        case .point:
            return .point
        case .polyline:
            return .polyline
        case .polygon:
            return .polygon
        case .complex:
            return .complex
        }
    }
}
