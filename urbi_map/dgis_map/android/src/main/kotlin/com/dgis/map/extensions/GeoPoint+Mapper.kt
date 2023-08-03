package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.GeoPointMessage
import com.dgis.map.map_api.Messages.GeoPointWithElevationMessage
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.geometry.Elevation
import ru.dgis.sdk.geometry.GeoPointWithElevation

fun GeoPointWithElevation.toMessage(): GeoPointWithElevationMessage {
    return GeoPointWithElevationMessage.Builder()
        .setLatitude(this.latitude.value)
        .setLongitude(this.longitude.value)
        .setElevation(this.elevation.value.toDouble())
        .build()
}

fun GeoPointWithElevationMessage.toGeoPointWithElevation() = GeoPointWithElevation(
    latitude = this.latitude,
    longitude = this.longitude,
    elevation = Elevation(this.elevation.toFloat()),
)

fun GeoPointMessage.toGeoPoint(): GeoPoint = GeoPoint(
    latitude = this.latitude,
    longitude = this.longitude,
)

fun GeoPoint.toMessage(): GeoPointMessage {
    return GeoPointMessage.Builder()
        .setLatitude(this.latitude.value)
        .setLongitude(this.longitude.value)
        .build()
}
