import DGis
import Foundation

/// Watches the active navigation route and reports whether the vehicle's current
/// position is inside a tunnel (`RoadSubtype.tunnel`).
///
/// Shared by the phone map (`DgisMapView`) and the two CarPlay maps — each darkens its
/// own map surface while the reported state is `true`.
///
/// The route tells us exactly where the tunnels are, so the state is derived from the
/// route position rather than measured on arrival:
///
/// * **Where.** Tunnel segments become dark zones as a route arrives. Only touching or
///   overlapping segments are joined, so a zone is a tunnel the route actually describes and
///   nothing more.
/// * **Where, the gaps between them.** The short daylight gaps that flicker the theme
///   (route-graph segmentation, ventilation openings, tunnel-to-tunnel interchanges) are
///   swallowed one at a time, when the car reaches one, by `mergesGap` — a gap the car clears
///   in a blink is not worth a theme change. This is the exit-side hysteresis; being geometric
///   it costs a genuine exit nothing.
/// * **When, entering.** A zone is entered `enterLeadMeters` before the portal, so the map
///   is already dark by the time the driver is under it instead of one position report late.
/// * **When, reports stall.** A tunnel is precisely where satellite positioning gives up, so
///   the report that would have carried us across a portal is often the one that never
///   arrives. When the next boundary is within `maxCoastSeconds` at the speed the last two
///   reports showed, the crossing is scheduled instead of awaited. One step per report, no
///   chaining: a longer gap in reports falls back to waiting, which keeps the current state.
final class TunnelDetector {
    /// Stretch of the route, in route-distance millimetres, that must be rendered dark.
    /// Half-open: `start ..< end`.
    private struct DarkZone {
        let start: Int64
        let end: Int64
    }

    /// The standing answer to "is this particular daylight gap tunnel?", taken once on the way
    /// into the gap and held for its whole length.
    private struct GapVerdict {
        /// Route distance the preceding zone ended at — this is what identifies the gap.
        let afterZoneEnd: Int64
        /// `true` = the gap counts as tunnel and the theme stays dark across it.
        let merge: Bool
    }

    /// Travel time a daylight gap has to be worth before it earns a theme change. What makes a
    /// gap flicker is not how long it is but how briefly it lasts, so the threshold is a
    /// duration and the metres follow from the speed: ~42 m at 100 km/h, ~25 m at 60 km/h,
    /// ~13 m in city traffic at 30 km/h. 1.5 s is the least daylight a driver could read as
    /// being out of the tunnel rather than as a flicker; below that, the pair of theme swaps
    /// costs more attention than the light it shows conveys.
    private static let mergeGapSeconds: Double = 1.5

    /// Floor under the merge threshold — for a car that is barely moving, and for the reports
    /// before any speed has been measured at all. Without it the threshold collapses towards
    /// zero exactly where the estimate is least trustworthy, and the artefacts the merge exists
    /// to hide (one tunnel chopped into pieces by the road graph, a ventilation opening) start
    /// flickering again. 25 m is what the time threshold itself asks for at 60 km/h, so the
    /// floor only takes over below that, where it stands in for 3 s of travel at 30 km/h.
    private static let minMergeGapMeters: Double = 25

    /// Ceiling on the merge threshold: 100 m was the fixed window before this became a function
    /// of speed, so a gap that merges now would have merged then too — the change can only bring
    /// the light theme back sooner, never later. With the speed cap at
    /// `maxPlausibleSpeedMetersPerSecond` the product tops out at 90 m, so this bound guards
    /// that property rather than trimming anything today.
    private static let maxMergeGapMeters: Double = 100

    /// How far ahead of a portal the map goes dark. Route positions arrive about once a
    /// second, so a strict "am I already inside?" test can only ever fire once the car is a
    /// second of travel past the portal. 40 m is that second back at motorway speed (1.4 s at
    /// 100 km/h, 1.8 s at 80 km/h) plus room for the style swap; at crawling speed it fires a
    /// few seconds early, right at a portal that is already filling the windscreen.
    private static let enterLeadMeters: Int64 = 40

    /// Below this the extrapolation is not worth trusting — and a car this slow is not about
    /// to cross a portal unnoticed anyway.
    private static let minCoastSpeedMetersPerSecond: Double = 5

    /// How far ahead of the last route position a boundary crossing may be scheduled. Five
    /// seconds is short enough that a car cruising at the last reported speed cannot have
    /// come to a stop inside the window, which is the only way coasting could report the
    /// wrong side of a portal.
    private static let maxCoastSeconds: Double = 5

    /// Weight of the newest sample in the speed estimate. Half-and-half rides out the
    /// jitter of GPS-derived deltas without lagging a real acceleration.
    private static let speedSmoothing: Double = 0.5

    /// Shorter gaps between two reports divide by too little to mean anything.
    private static let minSpeedSampleSeconds: TimeInterval = 0.2

    /// 216 km/h. Anything above this is a position jump, not a speed.
    private static let maxPlausibleSpeedMetersPerSecond: Double = 60

    private let model: Model
    private let onTunnelStateChanged: (Bool) -> Void

    private var routeChannelCancellable: DGis.Cancellable?
    private var routePositionCancellable: DGis.Cancellable?

    private var darkZones: [DarkZone] = []

    /// Last position the SDK actually reported, and the speed derived from consecutive
    /// reports. Together they let the next boundary crossing be scheduled rather than awaited.
    private var lastDistanceMillimeters: Int64?
    private var lastReportUptime: TimeInterval = 0
    private var speedMetersPerSecond: Double = 0
    private var coastWorkItem: DispatchWorkItem?

    /// Verdict on the daylight gap we are currently in, if we are in one. See `mergesGap`.
    private var gapVerdict: GapVerdict?

    private(set) var isInTunnel: Bool = false

    init(model: Model, onTunnelStateChanged: @escaping (Bool) -> Void) {
        self.model = model
        self.onTunnelStateChanged = onTunnelStateChanged

        // Pick up whatever route is already active by the time the detector is created.
        self.darkZones = Self.darkZones(in: model.route.route.roadSubtypes)

        self.routeChannelCancellable = model.routeChannel.sinkOnMainThread { [weak self] routeInfo in
            guard let self else { return }

            self.darkZones = Self.darkZones(in: routeInfo.route.roadSubtypes)
            // Route distances are measured from the route's own start, so the speed baseline
            // does not survive a reroute. Drop it and let the next report rebuild it.
            self.forgetMotion()
            // A reroute can move us in or out of a tunnel without the position moving at all.
            self.handle(routePosition: self.model.routePosition)
        }

        self.routePositionCancellable = model.routePositionChannel.sinkOnMainThread { [weak self] routePosition in
            self?.handle(routePosition: routePosition)
        }
    }

    /// Turns the route's tunnel segments into dark zones, joining only the ones that touch or
    /// overlap.
    ///
    /// Nothing is joined across a gap here. Doing that was the regression: each segment was
    /// compared against the zone built so far, which had already been stretched by the segment
    /// before it, so merging was transitive. A chain of tunnels with every gap under the window
    /// — an interchange in Riyadh — collapsed into one zone spanning the whole chain, and the
    /// theme stayed dark until the last tunnel of the chain was behind us. Gaps are now judged
    /// individually, and only when the car actually arrives at one; see `mergesGap`.
    private static func darkZones(in roadSubtypes: RoadSubtypeRouteLongAttribute) -> [DarkZone] {
        var zones: [DarkZone] = []

        for entry in roadSubtypes.entries where entry.value == .tunnel {
            let start = entry.point.distance.millimeters
            let end = start + entry.length.millimeters

            // `entries` runs along the route, so a segment can only extend the zone built so
            // far or start a new one.
            if let last = zones.last, start <= last.end {
                zones[zones.count - 1] = DarkZone(start: last.start, end: max(last.end, end))
            } else {
                zones.append(DarkZone(start: start, end: end))
            }
        }

        return zones
    }

    /// A route position of `nil` means guidance is over (or never started) — whatever the last
    /// route said, we are not in a tunnel any more. Reporting that matters: the caller darkens
    /// the app on the way in and would otherwise stay dark after a trip that was finished or
    /// cancelled underground.
    private func handle(routePosition: RoutePoint?) {
        cancelCoast()

        guard let routePosition else {
            forgetMotion()
            apply(inTunnel: false)
            return
        }

        let distance = routePosition.distance.millimeters
        let now = ProcessInfo.processInfo.systemUptime

        updateSpeed(distanceMillimeters: distance, at: now)

        lastDistanceMillimeters = distance
        lastReportUptime = now

        apply(inTunnel: isInsideZone(atDistance: distance))
        scheduleCoast(from: distance)
    }

    private func updateSpeed(distanceMillimeters distance: Int64, at now: TimeInterval) {
        guard let previous = lastDistanceMillimeters else { return }

        let elapsed = now - lastReportUptime
        guard elapsed >= Self.minSpeedSampleSeconds else { return }

        let travelledMeters = Double(distance - previous) / 1000
        guard travelledMeters >= 0 else {
            // Snapped backwards (map matching correcting itself, or a route swap we have not
            // been told about yet). Nothing to extrapolate from.
            speedMetersPerSecond = 0
            return
        }

        let sample = travelledMeters / elapsed
        // A road vehicle cannot do this. A sample that says otherwise is a position jump (a
        // reacquired fix, a map-match correction) or a clock that stood still while the device
        // slept — either way not something to extrapolate from.
        guard sample <= Self.maxPlausibleSpeedMetersPerSecond else { return }

        speedMetersPerSecond = Self.speedSmoothing * sample + (1 - Self.speedSmoothing) * speedMetersPerSecond
    }

    private func forgetMotion() {
        lastDistanceMillimeters = nil
        lastReportUptime = 0
        speedMetersPerSecond = 0
        // A gap verdict is only as good as the speed it was taken at, and it is keyed by a route
        // distance — a new route renumbers those. Both callers (a reroute, guidance ending) mean
        // the verdict has nothing left to refer to.
        gapVerdict = nil
    }

    private func isInsideZone(atDistance distance: Int64) -> Bool {
        let leadMillimeters = Self.enterLeadMeters * 1000
        var previousZoneEnd: Int64?

        // Zones run along the route, disjoint and in order.
        for zone in darkZones {
            if distance < zone.start - leadMillimeters {
                // Daylight, short of this zone's dark region. If a zone has already gone by,
                // this is the gap between the two and the merge verdict decides the theme.
                guard let previousZoneEnd else { return false }
                return mergesGap(after: previousZoneEnd, before: zone.start)
            }
            // The lead moves only the near edge: we go dark early and come back out at the
            // portal the route actually gives us.
            if distance < zone.end { return true }
            previousZoneEnd = zone.end
        }

        return false
    }

    /// Decides whether the daylight between two tunnel segments is too brief to be worth
    /// surfacing, and so should be driven through dark.
    ///
    /// The comparison is against the daylight the driver would actually get, not the distance
    /// between the portals: the next zone already claims `enterLeadMeters` of the gap for its
    /// own early entry. A 60 m gap with a 40 m lead is a 20 m flash of light — worse than
    /// staying dark — so the lead comes off the gap before the threshold is applied.
    ///
    /// The verdict is taken once, on the way into the gap, and latched by the gap's identity for
    /// its whole length. The threshold moves with the speed estimate, and re-deciding on every
    /// report would let a car hovering around the threshold flip the theme mid-gap; latching
    /// the answer — including a "no" — means the theme changes at most where a zone edge is.
    private func mergesGap(after previousZoneEnd: Int64, before nextZoneStart: Int64) -> Bool {
        if let gapVerdict, gapVerdict.afterZoneEnd == previousZoneEnd {
            return gapVerdict.merge
        }

        let leadMillimeters = Self.enterLeadMeters * 1000
        let daylightMeters = Double(max(0, nextZoneStart - leadMillimeters - previousZoneEnd)) / 1000

        let threshold = min(
            max(speedMetersPerSecond * Self.mergeGapSeconds, Self.minMergeGapMeters),
            Self.maxMergeGapMeters
        )

        let merge = daylightMeters <= threshold
        gapVerdict = GapVerdict(afterZoneEnd: previousZoneEnd, merge: merge)

        return merge
    }

    /// First zone edge strictly ahead of `distance`, in route millimetres — the point at which
    /// the reported state may change if the car kept going.
    ///
    /// Raw zone edges, gaps not taken into account: the far edge of a zone whose following gap
    /// turns out to be merged is not a state change at all. Scheduling that crossing anyway
    /// costs one `isInsideZone` call that `apply(inTunnel:)` then discards as a no-op, and the
    /// alternative — resolving verdicts for gaps the car has not reached — would be deciding
    /// them at the wrong speed.
    private func nextBoundary(after distance: Int64) -> Int64? {
        let leadMillimeters = Self.enterLeadMeters * 1000

        for zone in darkZones {
            let entryEdge = zone.start - leadMillimeters
            if entryEdge > distance {
                return entryEdge
            }
            if zone.end > distance {
                return zone.end
            }
        }

        return nil
    }

    /// Schedules the next boundary crossing when it is close enough to predict, so a gap in
    /// route positions — which is what a tunnel does to satellite positioning — does not hold
    /// the theme on the wrong side of a portal. Exactly one step is scheduled per report: if
    /// no report arrives to re-arm it, the state simply stops moving.
    private func scheduleCoast(from distance: Int64) {
        guard speedMetersPerSecond >= Self.minCoastSpeedMetersPerSecond else { return }
        guard let boundary = nextBoundary(after: distance) else { return }

        let metersToBoundary = Double(boundary - distance) / 1000
        let seconds = metersToBoundary / speedMetersPerSecond
        guard seconds > 0, seconds <= Self.maxCoastSeconds else { return }

        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }

            self.coastWorkItem = nil
            self.apply(inTunnel: self.isInsideZone(atDistance: boundary))
        }

        coastWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: workItem)
    }

    private func cancelCoast() {
        coastWorkItem?.cancel()
        coastWorkItem = nil
    }

    private func apply(inTunnel: Bool) {
        guard isInTunnel != inTunnel else { return }

        isInTunnel = inTunnel
        onTunnelStateChanged(inTunnel)
    }

    func cancel() {
        cancelCoast()
        routeChannelCancellable?.cancel()
        routePositionCancellable?.cancel()
    }

    deinit {
        cancel()
    }
}
