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
 *  * **Where.** Tunnel segments become dark zones as a route arrives. Only touching or overlapping
 *    segments are joined, so a zone is a tunnel the route actually describes and nothing more.
 *  * **Where, the gaps between them.** The short daylight gaps that flicker the theme (route-graph
 *    segmentation, ventilation openings, tunnel-to-tunnel interchanges) are swallowed one at a
 *    time, when the car reaches one, by [mergesGap] — a gap the car clears in a blink is not worth
 *    a theme change. This is the exit-side hysteresis; being geometric it costs a genuine exit
 *    nothing.
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

    /**
     * The standing answer to "is this particular daylight gap tunnel?", taken once on the way into
     * the gap and held for its whole length.
     *
     * @property afterZoneEnd route distance the preceding zone ended at — this is what identifies
     *   the gap.
     * @property merge `true` = the gap counts as tunnel and the theme stays dark across it.
     */
    private data class GapVerdict(val afterZoneEnd: Long, val merge: Boolean)

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

    /** Verdict on the daylight gap we are currently in, if we are in one. See [mergesGap]. */
    private var gapVerdict: GapVerdict? = null

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

    /**
     * Turns the route's tunnel segments into dark zones, joining only the ones that touch or
     * overlap.
     *
     * Nothing is joined across a gap here. Doing that was the regression: each segment was compared
     * against the zone built so far, which had already been stretched by the segment before it, so
     * merging was transitive. A chain of tunnels with every gap under the window — an interchange in
     * Riyadh — collapsed into one zone spanning the whole chain, and the theme stayed dark until the
     * last tunnel of the chain was behind us. Gaps are now judged individually, and only when the
     * car actually arrives at one; see [mergesGap].
     */
    private fun buildDarkZones(roadSubtypes: RoadSubtypeRouteLongAttribute): List<DarkZone> {
        val zones = mutableListOf<DarkZone>()

        for (entry in roadSubtypes.entries) {
            if (entry.value != RoadSubtype.TUNNEL) continue

            val start = entry.point.distance.millimeters
            val end = start + entry.length.millimeters

            // `entries` runs along the route, so a segment can only extend the zone built so far
            // or start a new one.
            val last = zones.lastOrNull()
            if (last != null && start <= last.end) {
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
        // A gap verdict is only as good as the speed it was taken at, and it is keyed by a route
        // distance — a new route renumbers those. Both callers (a reroute, guidance ending) mean the
        // verdict has nothing left to refer to.
        gapVerdict = null
    }

    private fun isInsideZone(distance: Long): Boolean {
        var previousZoneEnd: Long? = null

        // Zones run along the route, disjoint and in order.
        for (zone in darkZones) {
            if (distance < zone.start - ENTER_LEAD_MILLIMETERS) {
                // Daylight, short of this zone's dark region. If a zone has already gone by, this is
                // the gap between the two and the merge verdict decides the theme.
                val previous = previousZoneEnd ?: return false
                return mergesGap(afterZoneEnd = previous, beforeZoneStart = zone.start)
            }
            // The lead moves only the near edge: we go dark early and come back out at the portal
            // the route actually gives us.
            if (distance < zone.end) return true
            previousZoneEnd = zone.end
        }

        return false
    }

    /**
     * Decides whether the daylight between two tunnel segments is too brief to be worth surfacing,
     * and so should be driven through dark.
     *
     * The comparison is against the daylight the driver would actually get, not the distance between
     * the portals: the next zone already claims [ENTER_LEAD_METERS] of the gap for its own early
     * entry. A 60 m gap with a 40 m lead is a 20 m flash of light — worse than staying dark — so the
     * lead comes off the gap before the threshold is applied.
     *
     * The verdict is taken once, on the way into the gap, and latched by the gap's identity for its
     * whole length. The threshold moves with the speed estimate, and re-deciding on every report
     * would let a car hovering around the threshold flip the theme mid-gap; latching the answer —
     * including a "no" — means the theme changes at most where a zone edge is.
     */
    private fun mergesGap(afterZoneEnd: Long, beforeZoneStart: Long): Boolean {
        val latched = gapVerdict
        if (latched != null && latched.afterZoneEnd == afterZoneEnd) return latched.merge

        val daylightMeters =
            maxOf(0L, beforeZoneStart - ENTER_LEAD_MILLIMETERS - afterZoneEnd) / 1000.0
        val threshold =
            (speedMetersPerSecond * MERGE_GAP_SECONDS)
                .coerceIn(MIN_MERGE_GAP_METERS, MAX_MERGE_GAP_METERS)

        val merge = daylightMeters <= threshold
        gapVerdict = GapVerdict(afterZoneEnd, merge)

        return merge
    }

    /**
     * First zone edge strictly ahead of [distance], in route millimetres — the point at which the
     * reported state may change if the car kept going.
     *
     * Raw zone edges, gaps not taken into account: the far edge of a zone whose following gap turns
     * out to be merged is not a state change at all. Scheduling that crossing anyway costs one
     * [isInsideZone] call that [report] then discards as a no-op, and the alternative — resolving
     * verdicts for gaps the car has not reached — would be deciding them at the wrong speed.
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
         * Travel time a daylight gap has to be worth before it earns a theme change. What makes a
         * gap flicker is not how long it is but how briefly it lasts, so the threshold is a duration
         * and the metres follow from the speed: ~42 m at 100 km/h, ~25 m at 60 km/h, ~13 m in city
         * traffic at 30 km/h. 1.5 s is the least daylight a driver could read as being out of the
         * tunnel rather than as a flicker; below that, the pair of theme swaps costs more attention
         * than the light it shows conveys.
         */
        const val MERGE_GAP_SECONDS = 1.5

        /**
         * Floor under the merge threshold — for a car that is barely moving, and for the reports
         * before any speed has been measured at all. Without it the threshold collapses towards zero
         * exactly where the estimate is least trustworthy, and the artefacts the merge exists to
         * hide (one tunnel chopped into pieces by the road graph, a ventilation opening) start
         * flickering again. 25 m is what the time threshold itself asks for at 60 km/h, so the floor
         * only takes over below that, where it stands in for 3 s of travel at 30 km/h.
         */
        const val MIN_MERGE_GAP_METERS = 25.0

        /**
         * Ceiling on the merge threshold: 100 m was the fixed window before this became a function
         * of speed, so a gap that merges now would have merged then too — the change can only bring
         * the light theme back sooner, never later. With the speed cap at
         * [MAX_PLAUSIBLE_SPEED_METERS_PER_SECOND] the product tops out at 90 m, so this bound guards
         * that property rather than trimming anything today.
         */
        const val MAX_MERGE_GAP_METERS = 100.0

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
