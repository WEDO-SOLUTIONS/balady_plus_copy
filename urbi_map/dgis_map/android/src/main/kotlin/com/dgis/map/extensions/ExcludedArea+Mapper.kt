package com.dgis.map.extensions

import com.dgis.map.map_api.ExcludedAreaMessage
import com.dgis.map.map_api.ExcludedAreaSeverityMessage
import com.dgis.map.map_api.ExcludedAreaTypeMessage
import ru.dgis.sdk.routing.ExcludedArea
import ru.dgis.sdk.routing.ExcludedAreaSeverity
import ru.dgis.sdk.routing.ExcludedAreaType
import ru.dgis.sdk.routing.RouteDistance

fun ExcludedAreaTypeMessage.toExcludedAreaType(): ExcludedAreaType = when (this) {
    ExcludedAreaTypeMessage.POINT -> ExcludedAreaType.POINT
    ExcludedAreaTypeMessage.POLYLINE -> ExcludedAreaType.POLYLINE
    ExcludedAreaTypeMessage.POLYGON -> ExcludedAreaType.POLYGON
}

fun ExcludedAreaSeverityMessage.toExcludedAreaSeverity(): ExcludedAreaSeverity = when (this) {
    ExcludedAreaSeverityMessage.SOFT -> ExcludedAreaSeverity.SOFT
    ExcludedAreaSeverityMessage.HARD -> ExcludedAreaSeverity.HARD
}

fun ExcludedAreaMessage.toExcludedArea(): ExcludedArea = ExcludedArea(
    this.type.toExcludedAreaType(),
    this.severity.toExcludedAreaSeverity(),
    RouteDistance((this.extentMeters * 1000).toLong()),
    this.points.map { it.toGeoPoint() },
)
