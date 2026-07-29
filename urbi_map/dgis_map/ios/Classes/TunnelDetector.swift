import DGis
import Foundation

/// Watches the active navigation route and reports whether the vehicle's current
/// position is inside a tunnel (`RoadSubtype.tunnel`).
///
/// Shared by the phone map (`DgisMapView`) and the two CarPlay maps — each darkens its
/// own map surface while the reported state is `true`.
///
/// POC-quality hysteresis: entering a tunnel is reported immediately, but exiting is
/// only reported after `exitDelay` seconds spent continuously outside a tunnel. This
/// avoids flicker when `roadSubtypes` reports short gaps between adjoining tunnel
/// segments (e.g. at interchanges) or when GPS position briefly jitters near the portal.
final class TunnelDetector {
    private let model: Model

    private let exitDelay: TimeInterval
    private let onTunnelStateChanged: (Bool) -> Void

    private var routeChannelCancellable: DGis.Cancellable?
    private var routePositionCancellable: DGis.Cancellable?

    private var roadSubtypes: RoadSubtypeRouteLongAttribute?
    private var exitWorkItem: DispatchWorkItem?

    private(set) var isInTunnel: Bool = false

    init(model: Model, exitDelay: TimeInterval = 2.0, onTunnelStateChanged: @escaping (Bool) -> Void) {
        self.model = model
        self.exitDelay = exitDelay
        self.onTunnelStateChanged = onTunnelStateChanged

        // Pick up whatever route is already active by the time the detector is created.
        self.roadSubtypes = model.route.route.roadSubtypes

        self.routeChannelCancellable = model.routeChannel.sinkOnMainThread { [weak self] routeInfo in
            self?.roadSubtypes = routeInfo.route.roadSubtypes
        }

        self.routePositionCancellable = model.routePositionChannel.sinkOnMainThread { [weak self] routePosition in
            self?.handle(routePosition: routePosition)
        }
    }

    private func handle(routePosition: RoutePoint?) {
        guard let routePosition else { return }

        // `entry(point:)` returns the piecewise segment covering this route point, same
        // pattern as `speedLimits?.entry(point:)` in SpeedControlModel.
        let inTunnelNow = roadSubtypes?.entry(point: routePosition)?.value == .tunnel

        if inTunnelNow {
            exitWorkItem?.cancel()
            exitWorkItem = nil
            guard !isInTunnel else { return }
            isInTunnel = true
            onTunnelStateChanged(true)
            return
        }

        // Outside a tunnel: if we're already confirmed-out (or a confirmation is already
        // pending), there's nothing new to schedule.
        guard isInTunnel, exitWorkItem == nil else { return }

        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.exitWorkItem = nil
            self.isInTunnel = false
            self.onTunnelStateChanged(false)
        }
        exitWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + exitDelay, execute: workItem)
    }

    func cancel() {
        routeChannelCancellable?.cancel()
        routePositionCancellable?.cancel()
        exitWorkItem?.cancel()
        exitWorkItem = nil
    }

    deinit {
        cancel()
    }
}
