//
//  NavLiveActivityController.swift
//  Runner
//
//  Demo of a "live" navigation notification on iOS — a Live Activity on the
//  lock screen / Dynamic Island driven by mocked turn-by-turn data. A 1-second
//  timer mutates the mock state (same simulation as the Android
//  NavLiveNotificationService) and pushes updates to the activity.
//
//  Note: local (non-push) Live Activity updates only tick while the app
//  process is running; in background the activity stays on the lock screen
//  frozen at the last pushed state.
//

import ActivityKit
import Flutter
import Foundation

@available(iOS 16.2, *)
final class NavLiveActivityController {

    // MARK: - Mock route model

    private struct Leg {
        let street: String
        let lengthMeters: Double
        let maxSpeedKmh: Int
    }

    private let legs: [Leg] = [
        Leg(street: "King Fahd Rd", lengthMeters: 1200, maxSpeedKmh: 90),
        Leg(street: "Olaya St", lengthMeters: 800, maxSpeedKmh: 60),
        Leg(street: "Tahlia St", lengthMeters: 1500, maxSpeedKmh: 80),
        Leg(street: "King Abdullah Rd", lengthMeters: 2100, maxSpeedKmh: 100),
        Leg(street: "Northern Ring Rd", lengthMeters: 1700, maxSpeedKmh: 110),
    ]

    private let trafficSegments: [NavLiveActivityAttributes.TrafficSegment] = [
        .init(fraction: 0.18, severity: 0),
        .init(fraction: 0.10, severity: 1),
        .init(fraction: 0.08, severity: 2),
        .init(fraction: 0.22, severity: 0),
        .init(fraction: 0.12, severity: 1),
        .init(fraction: 0.07, severity: 2),
        .init(fraction: 0.23, severity: 0),
    ]

    private var totalRouteMeters: Double { legs.reduce(0) { $0 + $1.lengthMeters } }

    // MARK: - Mutable mock state

    private var legIndex = 0
    private var traveledInLegMeters = 0.0
    private var traveledTotalMeters = 0.0
    private var currentSpeedKmh = 48.0
    private var tick = 0

    private var timer: Timer?
    private var activity: Activity<NavLiveActivityAttributes>?

    private static let updateInterval: TimeInterval = 1.0

    // MARK: - Flutter bridge

    init(messenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(
            name: "com.balady.nav_live_notification",
            binaryMessenger: messenger
        )
        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "start":
                self?.start()
                result(nil)
            case "stop":
                self?.stop()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - Activity lifecycle

    func start() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        stop()
        legIndex = 0
        traveledInLegMeters = 0
        traveledTotalMeters = 0
        tick = 0

        let attributes = NavLiveActivityAttributes(trafficSegments: trafficSegments)
        activity = try? Activity.request(
            attributes: attributes,
            content: ActivityContent(state: makeContentState(), staleDate: nil)
        )
        guard activity != nil else { return }

        timer = Timer.scheduledTimer(withTimeInterval: Self.updateInterval, repeats: true) { [weak self] _ in
            self?.advanceMockState()
            self?.pushUpdate()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        if let activity {
            Task { await activity.end(nil, dismissalPolicy: .immediate) }
        }
        activity = nil
    }

    private func pushUpdate() {
        guard let activity else { return }
        let content = ActivityContent(state: makeContentState(), staleDate: nil)
        Task { await activity.update(content) }
    }

    // MARK: - Mock simulation

    private func advanceMockState() {
        tick += 1
        let leg = legs[legIndex]

        // Speed drifts around ~70% of the leg's limit with a gentle sine wobble.
        let target = Double(leg.maxSpeedKmh) * 0.7
        currentSpeedKmh = min(max(target + sin(Double(tick) / 5.0) * 12.0, 20.0), Double(leg.maxSpeedKmh))

        let deltaMeters = currentSpeedKmh / 3.6 * Self.updateInterval
        traveledInLegMeters += deltaMeters
        traveledTotalMeters += deltaMeters

        if traveledInLegMeters >= leg.lengthMeters {
            traveledInLegMeters = 0
            legIndex = (legIndex + 1) % legs.count
        }
        if traveledTotalMeters >= totalRouteMeters {
            // Loop the demo route.
            traveledTotalMeters = 0
            traveledInLegMeters = 0
            legIndex = 0
        }
    }

    private func makeContentState() -> NavLiveActivityAttributes.ContentState {
        let leg = legs[legIndex]
        return NavLiveActivityAttributes.ContentState(
            distanceToManeuverMeters: max(0, leg.lengthMeters - traveledInLegMeters),
            street: leg.street,
            speedKmh: Int(currentSpeedKmh),
            maxSpeedKmh: leg.maxSpeedKmh,
            routeProgress: min(max(traveledTotalMeters / totalRouteMeters, 0), 1)
        )
    }
}