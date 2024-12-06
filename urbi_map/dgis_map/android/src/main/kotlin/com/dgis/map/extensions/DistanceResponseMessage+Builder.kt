package com.dgis.map.extensions

import com.dgis.map.map_api.DistanceRequestMessage
import com.dgis.map.map_api.DistanceResponseMessage
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.distance

fun DistanceRequestMessage.toResponse(geoPoint: GeoPoint): DistanceResponseMessage {
    return DistanceResponseMessage(
        dgisObjectId = dgisObjectId,
        distance =  geoPoint.distance(this.geoPoint.toGeoPoint()).value.toDouble(),
    )
}