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
 * Includes position, objects inside the cluster, and various visual and metadata parameters.
 */
fun SimpleClusterObject.toMap(clusterId: String): Map<String, Any?> {
    return mapOf(
        "id" to clusterId, // Unique cluster ID

        // Cluster position with latitude, longitude, and elevation
        "position" to geoPointWithElevationToMap(this.position),

        // Number of objects inside the cluster
        "objectCount" to this.objectCount,

        // Full serialization of each object inside the cluster
        "objects" to this.objects.map { it.toMap() },

        // Anchor point for icon placement and visual properties
        "anchor" to anchorToMap(this.anchor),
        "iconOpacity" to this.iconOpacity.value,

        // Cluster label text and its style
        "text" to this.text,
        "textStyle" to this.textStyle.toMap(),

        // Icon size, direction, and other parameters
        "iconWidth" to this.iconWidth.value,
        "iconMapDirection" to this.iconMapDirection?.value,

        // Additional visual/animation parameters
        "animatedAppearance" to this.animatedAppearance,
        "zIndex" to this.zIndex.value,
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
