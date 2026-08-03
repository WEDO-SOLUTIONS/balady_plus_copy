import Foundation
import DGis

extension ExcludedAreaTypeMessage {
    func toExcludedAreaType() -> ExcludedAreaType {
        switch self {
        case .point:
            return .point
        case .polyline:
            return .polyline
        case .polygon:
            return .polygon
        }
    }
}

extension ExcludedAreaSeverityMessage {
    func toExcludedAreaSeverity() -> ExcludedAreaSeverity {
        switch self {
        case .soft:
            return .soft
        case .hard:
            return .hard
        }
    }
}

extension ExcludedAreaMessage {
    func toExcludedArea() -> ExcludedArea {
        ExcludedArea(
            type: self.type.toExcludedAreaType(),
            severity: self.severity.toExcludedAreaSeverity(),
            extent: RouteDistance(millimeters: Int64(self.extentMeters * 1000)),
            points: self.points.map { $0.geoPoint }
        )
    }
}
