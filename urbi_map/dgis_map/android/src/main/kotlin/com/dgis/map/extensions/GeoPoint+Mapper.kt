package com.dgis.map.extensions

import com.dgis.map.map_api.GeoPointMessage
import com.dgis.map.map_api.GeoPointWithElevationMessage
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.geometry.Elevation
import ru.dgis.sdk.geometry.GeoPointWithElevation

fun GeoPointWithElevation.toMessage(): GeoPointWithElevationMessage {
    return GeoPointWithElevationMessage(
        latitude = this.latitude.value,
        longitude = this.longitude.value,
        elevation = this.elevation.value.toDouble()
    )
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
    return GeoPointMessage(
        latitude = this.latitude.value,
        longitude = this.longitude.value
    )
}
