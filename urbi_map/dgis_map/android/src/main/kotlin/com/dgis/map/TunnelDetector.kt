package com.dgis.map

import android.os.Handler
import android.os.Looper
import android.os.SystemClock
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
 * The route tells us exactly where the tunnels are, so the state is derived from the route
 * position rather than measured on arrival:
 *
 *  * **Where.** Tunnel segments are folded into dark zones when a route arrives, merging any two
 *    less than [GAP_MERGE_METERS] apart. That swallows the short daylight gaps that flicker the
 *    theme (route-graph segmentation, ventilation openings, tunnel-to-tunnel interchanges) without
 *    deferring a genuine exit — this is the exit-side hysteresis, and being geometric it costs a
 *    real exit nothing.
 *  * **When, entering.** A zone is entered [ENTER_LEAD_METERS] before the portal, so the map is
 *    already dark by the time the driver is under it instead of one position report late.
 *  * **When, reports stall.** A tunnel is precisely where satellite positioning gives up, so the
 *    report that would have carried us across a portal is often the one that never arrives. When
 *    the next boundary is within [MAX_COAST_SECONDS] at the speed the last two reports showed, the
 *    crossing is scheduled instead of awaited. One step per report, no chaining: a longer gap in
 *    reports falls back to waiting, which keeps the current state.
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

    /**
     * Last position the SDK actually reported, and the speed derived from consecutive reports.
     * Together they let the next boundary crossing be scheduled rather than awaited.
     */
    private var lastDistanceMillimeters: Long? = null
    private var lastReportElapsedRealtime = 0L
    private var speedMetersPerSecond = 0.0

    private val mainHandler = Handler(Looper.getMainLooper())
    private var coastRunnable: Runnable? = null

    private val closeables =
        mutableListOf<AutoCloseable>(
            model.routeChannel.connect(::onRouteChanged),
            model.routePositionChannel.connect(::onRoutePositionChanged),
        )

    init {
        // Evaluate the state immediately in case a route/position already exist (e.g. the
        // detector is (re)created while navigation is already in progress).
        handle(model.routePosition)
    }

    private fun onRouteChanged(routeInfo: RouteInfo) {
        darkZones = buildDarkZones(routeInfo.route.roadSubtypes)
        // Route distances are measured from the route's own start, so the speed baseline does not
        // survive a reroute. Drop it and let the next report rebuild it.
        forgetMotion()
        // A reroute can move us in or out of a tunnel without the position moving at all.
        handle(model.routePosition)
    }

    private fun onRoutePositionChanged(position: RoutePoint?) = handle(position)

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
    private fun handle(position: RoutePoint?) {
        cancelCoast()

        val distance = position?.distance?.millimeters
        if (distance == null) {
            forgetMotion()
            report(inTunnel = false)
            return
        }

        val now = SystemClock.elapsedRealtime()
        updateSpeed(distance, now)

        lastDistanceMillimeters = distance
        lastReportElapsedRealtime = now

        report(isInsideZone(distance))
        scheduleCoast(distance)
    }

    private fun updateSpeed(distanceMillimeters: Long, now: Long) {
        val previous = lastDistanceMillimeters ?: return

        val elapsedSeconds = (now - lastReportElapsedRealtime) / 1000.0
        if (elapsedSeconds < MIN_SPEED_SAMPLE_SECONDS) return

        val travelledMeters = (distanceMillimeters - previous) / 1000.0
        if (travelledMeters < 0) {
            // Snapped backwards (map matching correcting itself, or a route swap we have not been
            // told about yet). Nothing to extrapolate from.
            speedMetersPerSecond = 0.0
            return
        }

        val sample = travelledMeters / elapsedSeconds
        // A road vehicle cannot do this. A sample that says otherwise is a position jump — a
        // reacquired fix, a map-match correction — not something to extrapolate from.
        if (sample > MAX_PLAUSIBLE_SPEED_METERS_PER_SECOND) return

        speedMetersPerSecond = SPEED_SMOOTHING * sample + (1 - SPEED_SMOOTHING) * speedMetersPerSecond
    }

    private fun forgetMotion() {
        lastDistanceMillimeters = null
        lastReportElapsedRealtime = 0L
        speedMetersPerSecond = 0.0
    }

    /**
     * The lead moves only the near edge: we go dark early and come back out at the portal the
     * route actually gives us.
     */
    private fun isInsideZone(distance: Long): Boolean =
        darkZones.any { distance >= it.start - ENTER_LEAD_MILLIMETERS && distance < it.end }

    /**
     * First zone edge strictly ahead of [distance], in route millimetres — the point at which the
     * reported state would change if the car kept going.
     */
    private fun nextBoundary(distance: Long): Long? {
        for (zone in darkZones) {
            val entryEdge = zone.start - ENTER_LEAD_MILLIMETERS
            if (entryEdge > distance) return entryEdge
            if (zone.end > distance) return zone.end
        }

        return null
    }

    /**
     * Schedules the next boundary crossing when it is close enough to predict, so a gap in route
     * positions — which is what a tunnel does to satellite positioning — does not hold the theme on
     * the wrong side of a portal. Exactly one step is scheduled per report: if no report arrives to
     * re-arm it, the state simply stops moving.
     */
    private fun scheduleCoast(distance: Long) {
        if (speedMetersPerSecond < MIN_COAST_SPEED_METERS_PER_SECOND) return
        val boundary = nextBoundary(distance) ?: return

        val metersToBoundary = (boundary - distance) / 1000.0
        val seconds = metersToBoundary / speedMetersPerSecond
        if (seconds <= 0 || seconds > MAX_COAST_SECONDS) return

        val runnable = Runnable {
            coastRunnable = null
            report(isInsideZone(boundary))
        }

        coastRunnable = runnable
        mainHandler.postDelayed(runnable, (seconds * 1000).toLong())
    }

    private fun cancelCoast() {
        coastRunnable?.let(mainHandler::removeCallbacks)
        coastRunnable = null
    }

    private fun report(inTunnel: Boolean) {
        if (isInTunnel == inTunnel) return

        isInTunnel = inTunnel
        onTunnelStateChanged(inTunnel)
    }

    override fun close() {
        cancelCoast()
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

        /**
         * How far ahead of a portal the map goes dark. Route positions arrive about once a second,
         * so a strict "am I already inside?" test can only ever fire once the car is a second of
         * travel past the portal. 40 m is that second back at motorway speed (1.4 s at 100 km/h,
         * 1.8 s at 80 km/h) plus room for the theme swap; at crawling speed it fires a few seconds
         * early, right at a portal that is already filling the windscreen.
         */
        const val ENTER_LEAD_METERS = 40L
        const val ENTER_LEAD_MILLIMETERS = ENTER_LEAD_METERS * 1000

        /**
         * Below this the extrapolation is not worth trusting — and a car this slow is not about to
         * cross a portal unnoticed anyway.
         */
        const val MIN_COAST_SPEED_METERS_PER_SECOND = 5.0

        /**
         * How far ahead of the last route position a boundary crossing may be scheduled. Five
         * seconds is short enough that a car cruising at the last reported speed cannot have come
         * to a stop inside the window, which is the only way coasting could report the wrong side
         * of a portal.
         */
        const val MAX_COAST_SECONDS = 5.0

        /**
         * Weight of the newest sample in the speed estimate. Half-and-half rides out the jitter of
         * GPS-derived deltas without lagging a real acceleration.
         */
        const val SPEED_SMOOTHING = 0.5

        /** Shorter gaps between two reports divide by too little to mean anything. */
        const val MIN_SPEED_SAMPLE_SECONDS = 0.2

        /** 216 km/h. Anything above this is a position jump, not a speed. */
        const val MAX_PLAUSIBLE_SPEED_METERS_PER_SECOND = 60.0
    }
}
