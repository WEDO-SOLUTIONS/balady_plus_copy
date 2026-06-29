import DGis
import Foundation

class PublicTransportHandler {
    private class Events {
        static let onPublicTransportRoutesChanged = "onPublicTransportRoutesChanged"
        static let onPublicTransportActiveRouteChanged = "onPublicTransportActiveRouteChanged"
    }

    private let eventChannel: DgisStreamHandler
    private let routeHandler: RouteHandler

    private var updateTimer: Timer?
    private static let updateInterval: TimeInterval = 10.0

    init(eventChannel: DgisStreamHandler, routeHandler: RouteHandler) {
        self.eventChannel = eventChannel
        self.routeHandler = routeHandler
    }

    func onRoutesChanged() {
        let trafficRoutes = routeHandler.getPublicTransportRoutes()
        let briefs = trafficRoutes.map { BriefPublicTransportModel(route: $0) }
        eventChannel.success([
            "event": Events.onPublicTransportRoutesChanged,
            "routes": briefs.map { $0.toMap() },
        ])
    }

    func onActiveRouteChanged() {
        guard let activeRoute = routeHandler.getActivePublicTransportRoute() else { return }
        eventChannel.success([
            "event": Events.onPublicTransportActiveRouteChanged,
            "route": PublicTransportModel(route: activeRoute).toMap(),
        ])
        startDurationUpdates()
    }

    func startDurationUpdates() {
        stopDurationUpdates()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.updateTimer = Timer.scheduledTimer(
                withTimeInterval: Self.updateInterval,
                repeats: true
            ) { [weak self] _ in
                self?.sendUpdatedRoute()
            }
        }
    }

    func stopDurationUpdates() {
        DispatchQueue.main.async { [weak self] in
            self?.updateTimer?.invalidate()
            self?.updateTimer = nil
        }
    }

    private func sendUpdatedRoute() {
        guard let route = routeHandler.getActivePublicTransportRoute() else { return }
        guard let location = routeHandler.getLastLocation() else { return }

        let entries = route.route.geometry.entries
        guard !entries.isEmpty else { return }

        guard let nearest = entries.min(by: { a, b in
            haversineDistanceMeters(
                location.latitude, location.longitude,
                a.value.latitude.value, a.value.longitude.value
            ) < haversineDistanceMeters(
                location.latitude, location.longitude,
                b.value.latitude.value, b.value.longitude.value
            )
        }) else { return }

        eventChannel.success([
            "event": Events.onPublicTransportActiveRouteChanged,
            "route": PublicTransportModel(route: route, currentPosition: nearest.point).toMap(),
        ])
    }

    private func haversineDistanceMeters(
        _ lat1: Double, _ lon1: Double,
        _ lat2: Double, _ lon2: Double
    ) -> Double {
        let r = 6_371_000.0
        let dLat = (lat2 - lat1) * .pi / 180
        let dLon = (lon2 - lon1) * .pi / 180
        let a = sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180) *
            sin(dLon / 2) * sin(dLon / 2)
        return r * 2 * atan2(sqrt(a), sqrt(1 - a))
    }
}
