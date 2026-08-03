import DGis
import Foundation

/// Watches the active navigation route and reports whether the vehicle's current
/// position is inside a tunnel (`RoadSubtype.tunnel`).
///
/// Shared by the phone map (`DgisMapView`) and the two CarPlay maps — each darkens its
/// own map surface while the reported state is `true`.
///
/// Hysteresis is geometric, not time-based: when a route arrives, its tunnel segments are
/// folded into dark zones, merging any two that are less than `gapMergeMeters` apart. That
/// swallows the short daylight gaps that make the theme flicker (route-graph segmentation,
/// ventilation openings, tunnel-to-tunnel interchanges) without deferring the real thing.
/// Everything after that is a plain range check against the current route position, so both
/// entering and leaving a tunnel are reported on the next position tick — no exit delay.
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

    private let model: Model
    private let onTunnelStateChanged: (Bool) -> Void

    private var routeChannelCancellable: DGis.Cancellable?
    private var routePositionCancellable: DGis.Cancellable?

    private var darkZones: [DarkZone] = []

    private(set) var isInTunnel: Bool = false

    init(model: Model, onTunnelStateChanged: @escaping (Bool) -> Void) {
        self.model = model
        self.onTunnelStateChanged = onTunnelStateChanged

        // Pick up whatever route is already active by the time the detector is created.
        self.darkZones = Self.darkZones(in: model.route.route.roadSubtypes)

        self.routeChannelCancellable = model.routeChannel.sinkOnMainThread { [weak self] routeInfo in
            guard let self else { return }

            self.darkZones = Self.darkZones(in: routeInfo.route.roadSubtypes)
            // A reroute can move us in or out of a tunnel without the position moving at all.
            self.evaluate(routePosition: self.model.routePosition)
        }

        self.routePositionCancellable = model.routePositionChannel.sinkOnMainThread { [weak self] routePosition in
            self?.evaluate(routePosition: routePosition)
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

    private func evaluate(routePosition: RoutePoint?) {
        // No position at all means guidance is over (or never started) — whatever the last
        // route said, we are not in a tunnel any more. Reporting that matters: the caller
        // darkens the app on the way in and would otherwise stay dark after a trip that
        // was finished or cancelled underground.
        let inTunnelNow = routePosition.map { position in
            let distance = position.distance.millimeters
            return darkZones.contains { distance >= $0.start && distance < $0.end }
        } ?? false

        guard isInTunnel != inTunnelNow else { return }

        isInTunnel = inTunnelNow
        onTunnelStateChanged(inTunnelNow)
    }

    func cancel() {
        routeChannelCancellable?.cancel()
        routePositionCancellable?.cancel()
    }

    deinit {
        cancel()
    }
}
