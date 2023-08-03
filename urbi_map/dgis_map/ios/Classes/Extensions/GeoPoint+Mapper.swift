import Foundation
import DGis

extension GeoPoint {
    func toMessage() -> GeoPointMessage {
        GeoPointMessage.make(
            withLatitude: NSNumber(value: self.latitude.value),
            longitude: NSNumber(value: self.longitude.value)
        )
    }
}

extension GeoPointWithElevation {
    func toMessage() -> GeoPointWithElevationMessage {
        GeoPointWithElevationMessage.make(
            withLatitude: NSNumber(value: self.latitude.value),
            longitude: NSNumber(value: self.longitude.value),
            elevation: NSNumber(value: self.elevation.value)
        )
    }
}

extension GeoPointMessage {
    var geoPoint: GeoPoint {
        return GeoPoint(
            latitude: Latitude(value: self.latitude.doubleValue),
            longitude: Longitude(value: self.longitude.doubleValue)
        )
    }
}

extension GeoPointWithElevationMessage {
    var geoPointWithElevation: GeoPointWithElevation {
        return GeoPointWithElevation(
            point: GeoPoint(
                latitude: Latitude(value: self.latitude.doubleValue),
                longitude: Longitude(value: self.longitude.doubleValue)
            ),
            elevation: Elevation(value: self.elevation.floatValue)
        )
    }
}
