import Foundation
import DGis

extension GeoPoint {
    func toMessage() -> GeoPointMessage {
        GeoPointMessage(
            latitude: self.latitude.value,
            longitude: self.longitude.value
        )
    }
}

extension GeoPointWithElevation {
    func toMessage() -> GeoPointWithElevationMessage {
        GeoPointWithElevationMessage(
            latitude:  self.latitude.value,
            longitude:  self.longitude.value,
            elevation:  Double(self.elevation.value)
        )
    }
}

extension GeoPointMessage {
    var geoPoint: GeoPoint {
        return GeoPoint(
            latitude: Latitude(value: self.latitude),
            longitude: Longitude(value: self.longitude)
        )
    }
}

extension GeoPointWithElevationMessage {
    var geoPointWithElevation: GeoPointWithElevation {
        return GeoPointWithElevation(
            point: GeoPoint(
                latitude: Latitude(value: self.latitude),
                longitude: Longitude(value: self.longitude)
            ),
            elevation: Elevation(value: Float(self.elevation))
        )
    }
}
