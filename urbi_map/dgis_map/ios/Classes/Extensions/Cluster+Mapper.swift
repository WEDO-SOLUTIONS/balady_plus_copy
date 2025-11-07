import Foundation
import DGis

extension SimpleClusterObject {
    /// Convert a SimpleClusterObject into a [String: Any?] dictionary
    /// Includes position, all objects inside the cluster, and visual/metadata properties
    func toMap(id: String) -> [String: Any?] {
        return [
            "id": id, // Unique cluster ID

            // Cluster position (latitude, longitude, elevation)
            "position": geoPointWithElevationToMap(self.position),

            // Number of objects inside the cluster
            "objectCount": self.objectCount,

            // Full serialization of each object in the cluster
            "objects": self.objects.map { $0.toMap() },

            // Anchor point for icon placement
            "anchor": anchorToMap(self.anchor),

            // Visual properties
            "iconOpacity": self.iconOpacity.value,

            // Cluster label and style
            "text": self.text,
            "textStyle": self.textStyle.toMap(),

            // Size and direction
            "iconWidth": self.iconWidth.value,
            "iconMapDirection": self.iconMapDirection?.value
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
