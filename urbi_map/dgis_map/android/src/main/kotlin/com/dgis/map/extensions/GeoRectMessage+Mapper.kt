package com.dgis.map.extensions

import com.dgis.map.map_api.GeoRectMessage
import ru.dgis.sdk.coordinates.GeoRect

fun GeoRectMessage.toGeoRect() = GeoRect(
    northEastPoint = northEast.toGeoPoint(),
    southWestPoint = southWest.toGeoPoint(),
)

fun GeoRect.toMessage(): GeoRectMessage {
    return  GeoRectMessage(
        northEast = this.northEastPoint.toMessage(),
        southWest = this.southWestPoint.toMessage()
    )
}
