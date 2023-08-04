package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.*
import ru.dgis.sdk.coordinates.GeoRect

fun GeoRectMessage.toGeoRect() = GeoRect(
    northEastPoint = northEast.toGeoPoint(),
    southWestPoint = southWest.toGeoPoint(),
)

fun GeoRect.toMessage(): GeoRectMessage {
    return GeoRectMessage.Builder()
        .setNorthEast(this.northEastPoint.toMessage())
        .setSouthWest(this.southWestPoint.toMessage())
        .build()
}
