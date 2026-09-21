package com.dgis.map.live_updates

import kotlinx.coroutines.flow.MutableStateFlow

/** One traffic-coloured stretch of the route timeline. */
data class NavTrafficSegment(
    /** Share of the whole route, 0..1. */
    val share: Double,
    /** DGis TrafficSpeedColor ordinal: 0 undefined, 1 green, 2 yellow, 3 red, 4 deep red. */
    val level: Int,
)

/** ETA snapshot produced by DashboardControlModel (phone navigation session). */
data class NavEta(
    val durationSec: Int,
    val distanceMeters: Double,
    val arrivalTime: String,
    /** Travelled share of the route, 0..1. */
    val progress: Double = 0.0,
    val trafficSegments: List<NavTrafficSegment> = emptyList(),
)

/** Next maneuver snapshot produced by ManeuverControlModel (phone navigation session). */
data class NavManeuver(
    val distanceMm: Long,
    val roadName: String,
    val instructionName: String,
)

/** Speed snapshot produced by SpeedControlModel. Meaningful for car routes only. */
data class NavSpeed(
    val speed: Int,
    val speedLimit: Int?,
    val isSpeeding: Boolean,
)

/**
 * Lightweight in-process bus between the existing navigation control models and
 * [NavigationForegroundService]. The control models push the same payloads they already
 * send to Flutter; the service observes and renders them into the ongoing notification.
 */
object NavLiveEventBus {
    val eta = MutableStateFlow<NavEta?>(null)
    val maneuver = MutableStateFlow<NavManeuver?>(null)
    val speed = MutableStateFlow<NavSpeed?>(null)

    /** Mirrors MessageControlModel values: none / gpsLost / routeResearch. */
    val message = MutableStateFlow("none")

    /** Mirrors NavigationHandler state names: disabled / finished / navigation / routeSearch. */
    val navState = MutableStateFlow<String?>(null)

    fun reset() {
        eta.value = null
        maneuver.value = null
        speed.value = null
        message.value = "none"
        navState.value = null
    }
}
