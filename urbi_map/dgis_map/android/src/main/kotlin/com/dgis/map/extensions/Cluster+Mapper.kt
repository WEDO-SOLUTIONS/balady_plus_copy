package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.MarkerAnchorMessage
import com.dgis.map.map_api.Messages.MarkerAzimuthMessage
import com.dgis.map.map_api.Messages.SimpleClusterObjectMessage
import ru.dgis.sdk.coordinates.Latitude
import ru.dgis.sdk.coordinates.Longitude
import ru.dgis.sdk.geometry.Elevation
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.map.SimpleClusterObject

fun SimpleClusterObject.toMessage(): SimpleClusterObjectMessage {
    return SimpleClusterObjectMessage.Builder()
        .setPosition(GeoPointWithElevation(
            latitude = Latitude(0.0),
            longitude = Longitude(0.0),
            elevation = Elevation(0.0f),
        ).toMessage()) // this.position.toMessage())
        .setObjectCount(this.objectCount.toLong())
        .setAnchor(
            MarkerAnchorMessage.Builder()
                .setX(0.0)// this.anchor.x.toDouble())
                .setY(0.0) //this.anchor.y.toDouble())
                .build()
        )
        .setIconOpacity(0.0)// this.iconOpacity.value.toDouble())
        .setText("") //this.text)
        .setTextStyle(null) // this.textStyle.toMessage())
        .setIconWidth(0.0) // this.iconWidth.value.toDouble())
        .setIconMapDirection(
            null
//            this.iconMapDirection?.let {
//                MarkerAzimuthMessage.Builder()
//                    .setDegree(it.value)
//                    .build()
//            }
        )
        .build()
}
