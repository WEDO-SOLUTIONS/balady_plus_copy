import Foundation
import DGis

extension SimpleClusterObject {
    /// Convert a SimpleClusterObject into a [String: Any?] dictionary
    /// Keep cluster tap payload minimal to avoid touching unstable native-backed fields
    func toMap(id: String) -> [String: Any?] {
        return [
            "id": id, // Unique cluster ID
            "objectCount": self.objectCount,
            "objects": self.objects.map { $0.toClusterTapMap() }
        ]
    }
}

extension SimpleMapObject {
    /// Convert a SimpleMapObject into a [String: Any?] dictionary
    /// Includes visibility, zIndex, level information, and bounds
    func toMap() -> [String: Any?] {
        return [
            // Include marker id if present in userData
            "id": (self.userData as? MarkerId)?.id,

            // Visibility and drawing order
            "isVisible": self.isVisible,
            "zIndex": self.zIndex.value,

            // Level (if set)
            "levelId": self.levelId?.toMap(),

            // Bounding rectangle of the object
            "bounds": self.bounds.toMap()
        ]
    }

    func toClusterTapMap() -> [String: Any?] {
        return [
            "id": (self.userData as? MarkerId)?.id
        ]
    }
}

/* ===================== Helpers ===================== */

private func geoPointWithElevationToMap(_ p: GeoPointWithElevation) -> [String: Any?] {
    return [
        "latitude": p.latitude.value,
        "longitude": p.longitude.value,
        "elevation": p.elevation.value
    ]
}

private func anchorToMap(_ a: Anchor) -> [String: Any?] {
    return [
        "x": a.x,
        "y": a.y
    ]
}

private extension LevelId {
    func toMap() -> [String: Any?] {
        return ["value": self.value]
    }
}

private extension GeoRect {
    func toMap() -> [String: Any?] {
        return [
            "southWest": geoPointToMap(self.southWestPoint),
            "northEast": geoPointToMap(self.northEastPoint),
            "isValid": self.isValid,
            "isDegenerate": self.isDegenerate
        ]
    }
}

private func geoPointToMap(_ p: GeoPoint) -> [String: Any?] {
    return [
        "latitude": p.latitude.value,
        "longitude": p.longitude.value,
        "isValid": p.isValid
    ]
}
