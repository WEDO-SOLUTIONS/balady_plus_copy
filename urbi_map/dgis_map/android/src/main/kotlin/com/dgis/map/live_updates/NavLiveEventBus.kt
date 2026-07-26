package com.dgis.map.live_updates

import kotlinx.coroutines.flow.MutableStateFlow

/** ETA snapshot produced by DashboardControlModel (phone navigation session). */
data class NavEta(
    val durationSec: Int,
    val distanceMeters: Double,
    val arrivalTime: String,
)

/** Next maneuver snapshot produced by ManeuverControlModel (phone navigation session). */
data class NavManeuver(
    val distanceMm: Long,
    val roadName: String,
    val instructionName: String,
)

/**
 * Lightweight in-process bus between the existing navigation control models and
 * [NavigationForegroundService]. The control models push the same payloads they already
 * send to Flutter; the service observes and renders them into the ongoing notification.
 */
object NavLiveEventBus {
    val eta = MutableStateFlow<NavEta?>(null)
    val maneuver = MutableStateFlow<NavManeuver?>(null)

    /** Mirrors NavigationHandler state names: disabled / finished / navigation / routeSearch. */
    val navState = MutableStateFlow<String?>(null)

    fun reset() {
        eta.value = null
        maneuver.value = null
        navState.value = null
    }
}
