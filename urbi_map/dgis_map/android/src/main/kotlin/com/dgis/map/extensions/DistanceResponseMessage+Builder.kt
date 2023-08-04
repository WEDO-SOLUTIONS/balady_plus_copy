package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.DistanceRequestMessage
import com.dgis.map.map_api.Messages.DistanceResponseMessage
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.distance

fun DistanceRequestMessage.toResponse(geoPoint: GeoPoint): DistanceResponseMessage {
    return DistanceResponseMessage.Builder()
        .setDistance(geoPoint.distance(this.geoPoint.toGeoPoint()).value.toDouble())
        .setDgisObjectId(dgisObjectId)
        .build()
}