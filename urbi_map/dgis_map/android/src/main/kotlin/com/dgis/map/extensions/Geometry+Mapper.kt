package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.*
import ru.dgis.sdk.geometry.*

fun Geometry.toMessage(): GeometryMessage {
    return GeometryMessage.Builder()
        .setKind(this.kind.toMessage())
        .setBounds(this.bounds.toMessage())
        .setMaxPoint(this.maxPoint.toMessage())
        .setMinPoint(this.minPoint.toMessage())
        .build()
}

fun GeometryKind.toMessage(): GeometryKindMessage = when(this) {
    GeometryKind.POINT -> GeometryKindMessage.POINT
    GeometryKind.POLYLINE -> GeometryKindMessage.POLYLINE
    GeometryKind.POLYGON -> GeometryKindMessage.POLYGON
    GeometryKind.COMPLEX -> GeometryKindMessage.COMPLEX
}
