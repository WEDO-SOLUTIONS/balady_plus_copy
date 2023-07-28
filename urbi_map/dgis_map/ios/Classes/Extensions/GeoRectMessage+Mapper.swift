import Foundation
import DGis

extension GeoRectMessage {
    var geoRect: GeoRect {
        return GeoRect(
            southWestPoint: GeoPoint(
                latitude: Latitude(value: southWest.latitude.doubleValue),
                longitude: Longitude(value: southWest.longitude.doubleValue)
            ),
            northEastPoint: GeoPoint(
                latitude: Latitude(value: northEast.latitude.doubleValue),
                longitude: Longitude(value: northEast.longitude.doubleValue)
            )
        )
    }
}
