package com.dgis.map.extensions

import com.dgis.map.control_handlers.ObjectTapHandler
import ru.dgis.sdk.LevelId
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.GeoRect
import ru.dgis.sdk.geometry.GeoPointWithElevation
import ru.dgis.sdk.map.Anchor
import ru.dgis.sdk.map.SimpleClusterObject
import ru.dgis.sdk.map.SimpleMapObject

/* ===================== Cluster ===================== */

/**
 * Convert a SimpleClusterObject to a Map<String, Any?> representation.
 * Keep cluster tap payload minimal to avoid touching unstable native-backed fields.
 */
fun SimpleClusterObject.toMap(clusterId: String): Map<String, Any?> {
    return mapOf(
        "id" to clusterId, // Unique cluster ID
        "objectCount" to this.objectCount,
        "objects" to this.objects.map { it.toClusterTapMap() },
    )
}

/**
 * Serialize a LevelId to a Map representation.
 */
private fun LevelId.toMap(): Map<String, Any?> = mapOf(
    "value" to this.value
)

/* ===================== Map Object (cluster items) ===================== */

/**
 * Convert a SimpleMapObject to a Map<String, Any?> representation.
 * Includes visibility, zIndex, level information, and bounds.
 */
fun SimpleMapObject.toMap(): Map<String, Any?> {
    return mapOf(
        // If userData contains a MarkerId, include it as the "id"
        "id" to (userData as? ObjectTapHandler.MarkerId)?.id,

        // Visibility and drawing order
        "isVisible" to this.isVisible,
        "zIndex" to this.zIndex.value,

        // Floor level (if applicable) and the bounding rectangle
        "levelId" to this.levelId?.toMap(),
        "bounds" to this.bounds.toMap(),
    )
}

private fun SimpleMapObject.toClusterTapMap(): Map<String, Any?> {
    return mapOf(
        "id" to (userData as? ObjectTapHandler.MarkerId)?.id,
    )
}

/* ===================== Helpers ===================== */

/**
 * Convert a GeoPointWithElevation to a Map representation.
 */
private fun geoPointWithElevationToMap(p: GeoPointWithElevation): Map<String, Any?> = mapOf(
    "latitude" to p.latitude.value,
    "longitude" to p.longitude.value,
    "elevation" to p.elevation.value
)

/**
 * Convert an Anchor object to a Map representation.
 */
private fun anchorToMap(a: Anchor): Map<String, Any?> = mapOf(
    "x" to a.x,
    "y" to a.y
)

/**
 * Convert a GeoRect to a Map representation with south-west and north-east points.
 * Includes validation flags.
 */
private fun GeoRect.toMap(): Map<String, Any?> = mapOf(
    "southWest" to geoPointToMap(this.southWestPoint),
    "northEast" to geoPointToMap(this.northEastPoint),
    "isValid" to this.isValid,
    "isDegenerate" to this.isDegenerate
)

/**
 * Convert a GeoPoint to a Map representation.
 */
private fun geoPointToMap(p: GeoPoint): Map<String, Any?> = mapOf(
    "latitude" to p.latitude.value,
    "longitude" to p.longitude.value,
    "isValid" to p.isValid
)
