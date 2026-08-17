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
/// * **Where.** Tunnel segments are folded into dark zones when a route arrives, merging
///   any two less than `gapMergeMeters` apart. That swallows the short daylight gaps that
///   flicker the theme (route-graph segmentation, ventilation openings, tunnel-to-tunnel
///   interchanges) without deferring a genuine exit — this is the exit-side hysteresis,
///   and being geometric it costs a real exit nothing.
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

    /// Daylight gap between two tunnel segments that still counts as tunnel. Long enough to
    /// cover how the road graph chops a single tunnel up and the gaps at interchanges, short
    /// enough that a genuine stretch of daylight brings the light theme straight back.
    private static let gapMergeMeters: Int64 = 100

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

    /// Folds the route's tunnel segments into the dark zones described on `gapMergeMeters`.
    private static func darkZones(in roadSubtypes: RoadSubtypeRouteLongAttribute) -> [DarkZone] {
        let gapMergeMillimeters = gapMergeMeters * 1000
        var zones: [DarkZone] = []

        for entry in roadSubtypes.entries where entry.value == .tunnel {
            let start = entry.point.distance.millimeters
            let end = start + entry.length.millimeters

            // `entries` runs along the route, so a segment can only extend the zone built so
            // far or start a new one.
            if let last = zones.last, start - last.end <= gapMergeMillimeters {
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
    }

    private func isInsideZone(atDistance distance: Int64) -> Bool {
        let leadMillimeters = Self.enterLeadMeters * 1000

        // The lead moves only the near edge: we go dark early and come back out at the
        // portal the route actually gives us.
        return darkZones.contains { distance >= $0.start - leadMillimeters && distance < $0.end }
    }

    /// First zone edge strictly ahead of `distance`, in route millimetres — the point at which
    /// the reported state would change if the car kept going.
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
