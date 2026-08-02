package com.dgis.map

import ru.dgis.sdk.navigation.NavigationManager
import ru.dgis.sdk.navigation.RouteInfo
import ru.dgis.sdk.routing.RoadSubtype
import ru.dgis.sdk.routing.RoadSubtypeRouteLongAttribute
import ru.dgis.sdk.routing.RoutePoint

/**
 * Detects whether the current position along the active navigation route lies inside a tunnel
 * (RoadSubtype.TUNNEL), so the caller can force a dark map theme while driving through one.
 *
 * Shared by the phone map ([DgisMapView]) and the Android Auto session
 * ([com.dgis.map.android_auto.NavigationCarAppSession]) — both darken their own map surface.
 *
 * Hysteresis is geometric, not time-based: when a route arrives, its tunnel segments are folded
 * into dark zones, merging any two that are less than [GAP_MERGE_METERS] apart. That swallows the
 * short daylight gaps that make the theme flicker (route-graph segmentation, ventilation openings,
 * tunnel-to-tunnel interchanges) without deferring the real thing. Everything after that is a plain
 * range check against the current route position, so both entering and leaving a tunnel are
 * reported on the next position tick — no exit delay.
 */
class TunnelDetector(
    navigationManager: NavigationManager,
    private val onTunnelStateChanged: (Boolean) -> Unit,
) : AutoCloseable {

    /**
     * Stretch of the route, in route-distance millimetres, that must be rendered dark.
     * Half-open: `start until end`.
     */
    private data class DarkZone(val start: Long, val end: Long)

    private val model = navigationManager.uiModel

    private var darkZones: List<DarkZone> = buildDarkZones(model.route.route.roadSubtypes)
    private var isInTunnel = false

    private val closeables =
        mutableListOf<AutoCloseable>(
            model.routeChannel.connect(::onRouteChanged),
            model.routePositionChannel.connect(::onRoutePositionChanged),
        )

    init {
        // Evaluate the state immediately in case a route/position already exist (e.g. the
        // detector is (re)created while navigation is already in progress).
        evaluate(model.routePosition)
    }

    private fun onRouteChanged(routeInfo: RouteInfo) {
        darkZones = buildDarkZones(routeInfo.route.roadSubtypes)
        // A reroute can move us in or out of a tunnel without the position moving at all.
        evaluate(model.routePosition)
    }

    private fun onRoutePositionChanged(position: RoutePoint?) = evaluate(position)

    /** Folds the route's tunnel segments into the dark zones described on [GAP_MERGE_METERS]. */
    private fun buildDarkZones(roadSubtypes: RoadSubtypeRouteLongAttribute): List<DarkZone> {
        val zones = mutableListOf<DarkZone>()

        for (entry in roadSubtypes.entries) {
            if (entry.value != RoadSubtype.TUNNEL) continue

            val start = entry.point.distance.millimeters
            val end = start + entry.length.millimeters

            // `entries` runs along the route, so a segment can only extend the zone built so far
            // or start a new one.
            val last = zones.lastOrNull()
            if (last != null && start - last.end <= GAP_MERGE_MILLIMETERS) {
                zones[zones.lastIndex] = last.copy(end = maxOf(last.end, end))
            } else {
                zones.add(DarkZone(start, end))
            }
        }

        return zones
    }

    /**
     * A null [position] means guidance is over (or never started) — whatever the last route said,
     * we are not in a tunnel any more. Reporting that matters: the caller darkens the app on the
     * way in and would otherwise stay dark after a trip that was finished or cancelled underground.
     */
    private fun evaluate(position: RoutePoint?) {
        val distance = position?.distance?.millimeters
        val inTunnel = distance != null && darkZones.any { distance >= it.start && distance < it.end }

        if (isInTunnel == inTunnel) return

        isInTunnel = inTunnel
        onTunnelStateChanged(inTunnel)
    }

    override fun close() {
        closeables.forEach(AutoCloseable::close)
    }

    private companion object {
        /**
         * Daylight gap between two tunnel segments that still counts as tunnel. Long enough to
         * cover how the road graph chops a single tunnel up and the gaps at interchanges, short
         * enough that a genuine stretch of daylight brings the light theme straight back.
         */
        const val GAP_MERGE_METERS = 100L
        const val GAP_MERGE_MILLIMETERS = GAP_MERGE_METERS * 1000
    }
}
