package com.dgis.map.extensions

import ru.dgis.sdk.map.SimpleClusterObject

fun SimpleClusterObject.toMap(): Map<String, Any?> {
    return mapOf(
        "position" to mapOf(
            "latitude" to this.position.latitude.value,
            "longitude" to this.position.longitude.value,
            "elevation" to this.position.elevation.value,
        ),
        "objectCount" to this.objectCount,
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
