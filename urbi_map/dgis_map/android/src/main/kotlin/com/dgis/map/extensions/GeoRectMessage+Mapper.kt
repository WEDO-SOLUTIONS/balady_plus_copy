package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.GeoRectMessage
import ru.dgis.sdk.coordinates.GeoRect

fun GeoRectMessage.toGeoRect() = GeoRect(
    northEastPoint = northEast.toGeoPoint(),
    southWestPoint = southWest.toGeoPoint(),
)
