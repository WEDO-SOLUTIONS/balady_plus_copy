import Foundation
import DGis

extension GeoRect {
    func toMessage() -> GeoRectMessage {
        GeoRectMessage(
            northEast: self.northEastPoint.toMessage(),
            southWest: self.southWestPoint.toMessage()
        )
    }
}

extension GeoRectMessage {
    var geoRect: GeoRect {
        return GeoRect(
            southWestPoint: self.southWest.geoPoint,
            northEastPoint: self.northEast.geoPoint
        )
    }
}
