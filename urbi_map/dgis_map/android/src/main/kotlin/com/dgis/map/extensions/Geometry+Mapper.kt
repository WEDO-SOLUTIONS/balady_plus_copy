package com.dgis.map.extensions

import com.dgis.map.map_api.*
import ru.dgis.sdk.geometry.*

fun Geometry.toMessage(): GeometryMessage {
    return GeometryMessage(
        kind = this.kind.toMessage(),
        bounds = this.bounds.toMessage(),
        maxPoint = this.maxPoint.toMessage(),
        minPoint = this.minPoint.toMessage()
    )
}


fun GeometryKind.toMessage(): GeometryKindMessage = when(this) {
    GeometryKind.POINT -> GeometryKindMessage.POINT
    GeometryKind.POLYLINE -> GeometryKindMessage.POLYLINE
    GeometryKind.POLYGON -> GeometryKindMessage.POLYGON
    GeometryKind.COMPLEX -> GeometryKindMessage.COMPLEX
}
