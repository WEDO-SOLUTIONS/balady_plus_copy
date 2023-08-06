package com.dgis.map.extensions

import com.dgis.map.control_handlers.ObjectTapHandler
import ru.dgis.sdk.map.SimpleClusterObject

fun SimpleClusterObject.toMap(clusterId: String): Map<String, Any?> {
    return mapOf(
        "id" to clusterId,
        "position" to mapOf(
            "latitude" to this.position.latitude.value,
            "longitude" to this.position.longitude.value,
            "elevation" to this.position.elevation.value,
        ),
        "objectCount" to this.objectCount,
        "objects" to this.objects.mapNotNull {
            val userData = it.userData

            if (userData is ObjectTapHandler.MarkerId) {
                return@mapNotNull userData.id
            }

            return@mapNotNull null
        },
        "anchor" to mapOf(
            "x" to this.anchor.x,
            "y" to this.anchor.y,
        ),
        "iconOpacity" to this.iconOpacity.value,
        "text" to this.text,
        "textStyle" to this.textStyle.toMap(),
        "iconWidth" to this.iconWidth.value,
        "iconMapDirection" to this.iconMapDirection?.value,
    )
}
