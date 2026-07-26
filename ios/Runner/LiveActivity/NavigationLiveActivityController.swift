//
//  NavigationLiveActivityController.swift
//  Runner
//
//  Drives the turn-by-turn navigation Live Activity from the native
//  navigation events posted by the dgis_map plugin (NotificationCenter),
//  independent of the Dart isolate. Session metadata (destination, route
//  type, language, toggle) arrives via NavigationLiveUpdatesChannel.
//

import Foundation

#if canImport(ActivityKit)
import ActivityKit

@available(iOS 16.2, *)
final class NavigationLiveActivityController {
    static let shared = NavigationLiveActivityController()

    // Contract with the dgis_map plugin and EndTripIntent (raw strings are fixed).
    private enum NotificationNames {
        static let dashboardTick = Notification.Name("dgis.navigation.dashboardTick")
        static let maneuverTick = Notification.Name("dgis.navigation.maneuverTick")
        static let stateChanged = Notification.Name("dgis.navigation.stateChanged")
        static let endTripRequested = Notification.Name("balady.endTripRequested")
    }

    private struct SessionMetadata {
        let destinationName: String
        let routeType: String
        let language: String
        let enabled: Bool
    }

    private struct DashboardData {
        let durationSeconds: Int
        let distanceKm: Double
        let arrivalTime: String
    }

    private struct ManeuverData {
        let distanceMm: Double
        let roadName: String
        let instruction: String
    }

    /// Best-effort bridge back to Dart, wired up by NavigationLiveUpdatesChannel.
    var onEndTripRequested: (() -> Void)?

    private var metadata: SessionMetadata?
    private var navigationState: String = "disabled"
    private var dashboard: DashboardData?
    private var maneuver: ManeuverData?

    private var activity: Activity<NavigationActivityAttributes>?
    private var lastContentState: NavigationActivityAttributes.ContentState?
    private var lastUpdateTime: Date = .distantPast
    private var observers: [NSObjectProtocol] = []

    private static let minUpdateInterval: TimeInterval = 1.0
    private static let staleInterval: TimeInterval = 600
    private static let arrivalDismissalInterval: TimeInterval = 180

    private init() {}

    /// Call once from AppDelegate: installs observers and removes Live Activities
    /// orphaned by a force-kill of a previous session.
    func activate() {
        guard observers.isEmpty else { return }

        let center = NotificationCenter.default
        observers.append(center.addObserver(
            forName: NotificationNames.stateChanged, object: nil, queue: .main
        ) { [weak self] notification in
            guard let state = notification.userInfo?["state"] as? String else { return }
            self?.handleStateChanged(state)
        })
        observers.append(center.addObserver(
            forName: NotificationNames.dashboardTick, object: nil, queue: .main
        ) { [weak self] notification in
            self?.handleDashboardTick(notification.userInfo)
        })
        observers.append(center.addObserver(
            forName: NotificationNames.maneuverTick, object: nil, queue: .main
        ) { [weak self] notification in
            self?.handleManeuverTick(notification.userInfo)
        })
        observers.append(center.addObserver(
            forName: NotificationNames.endTripRequested, object: nil, queue: .main
        ) { [weak self] _ in
            self?.handleEndTripRequested()
        })

        endStaleActivities()

        // TEMP-DEBUG-BE90-LADEMO — remove before merge.
        // Launch with `-BaladyLADemo` to drive the Live Activity through the real
        // NotificationCenter contract without a navigation session (network-free check).
        if ProcessInfo.processInfo.arguments.contains("-BaladyLADemo") {
            startDemoDriver()
        }
    }

    // TEMP-DEBUG-BE90-LADEMO — remove before merge.
    private var demoTimer: Timer?
    private func startDemoDriver() {
        setSessionMetadata(
            destinationName: "King Fahd Road",
            routeType: "car",
            language: "en",
            enabled: true
        )
        var distanceMm: Double = 1_200_000
        var durationSec = 540
        let center = NotificationCenter.default
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak self] in
            center.post(name: NotificationNames.stateChanged, object: nil, userInfo: ["state": "navigation"])
            self?.demoTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
                distanceMm -= 60_000
                durationSec -= 4
                if distanceMm <= 0 {
                    timer.invalidate()
                    center.post(name: NotificationNames.stateChanged, object: nil, userInfo: ["state": "finished"])
                    return
                }
                center.post(
                    name: NotificationNames.maneuverTick,
                    object: nil,
                    userInfo: [
                        "distanceMm": distanceMm,
                        "roadName": "Olaya Street",
                        "instruction": distanceMm > 600_000 ? "crossroad_right" : "crossroad_left",
                    ]
                )
                center.post(
                    name: NotificationNames.dashboardTick,
                    object: nil,
                    userInfo: [
                        "duration": durationSec,
                        "distanceKm": distanceMm / 1_000_000.0 + 2.4,
                        "arrivalTime": "21:30",
                    ]
                )
            }
        }
    }

    // MARK: - Channel API (called from NavigationLiveUpdatesChannel, main thread)

    func setSessionMetadata(destinationName: String, routeType: String, language: String, enabled: Bool) {
        metadata = SessionMetadata(
            destinationName: destinationName,
            routeType: routeType,
            language: language,
            enabled: enabled
        )
        if !enabled {
            endActivity(dismissalPolicy: .immediate)
            return
        }
        startActivityIfPossible()
    }

    func endSession() {
        metadata = nil
        dashboard = nil
        maneuver = nil
        endActivity(dismissalPolicy: .immediate)
    }

    // MARK: - Navigation event handling

    private func handleStateChanged(_ state: String) {
        navigationState = state
        switch state {
        case "navigation":
            startActivityIfPossible()
        case "finished":
            finishWithArrival()
        case "disabled":
            dashboard = nil
            maneuver = nil
            endActivity(dismissalPolicy: .immediate)
        default:
            // "routeSearch" (e.g. rebuilding after going off route) keeps the activity as is.
            break
        }
    }

    private func handleDashboardTick(_ userInfo: [AnyHashable: Any]?) {
        guard
            let duration = userInfo?["duration"] as? Int,
            let distanceKm = userInfo?["distanceKm"] as? Double,
            let arrivalTime = userInfo?["arrivalTime"] as? String
        else { return }

        dashboard = DashboardData(durationSeconds: duration, distanceKm: distanceKm, arrivalTime: arrivalTime)
        startActivityIfPossible()
        updateActivityIfNeeded()
    }

    private func handleManeuverTick(_ userInfo: [AnyHashable: Any]?) {
        guard
            let distanceMm = userInfo?["distanceMm"] as? Double,
            let roadName = userInfo?["roadName"] as? String,
            let instruction = userInfo?["instruction"] as? String
        else { return }

        maneuver = ManeuverData(distanceMm: distanceMm, roadName: roadName, instruction: instruction)
        startActivityIfPossible()
        updateActivityIfNeeded()
    }

    private func handleEndTripRequested() {
        // NavigationHandler stops the engine itself; here we tear the widget
        // down immediately and let Dart clean up its side best-effort.
        endActivity(dismissalPolicy: .immediate)
        onEndTripRequested?()
    }

    // MARK: - Activity lifecycle

    private func startActivityIfPossible() {
        // TEMP-DEBUG-BE90-LADEMO diagnostics — remove before merge.
        NSLog(
            "BaladyLA: startActivityIfPossible activity=%@ metadata=%@ state=%@ enabled=%d",
            activity == nil ? "nil" : "exists",
            metadata == nil ? "nil" : "set",
            navigationState ?? "nil",
            ActivityAuthorizationInfo().areActivitiesEnabled ? 1 : 0
        )
        guard activity == nil,
              let metadata = metadata,
              metadata.enabled,
              navigationState == "navigation",
              ActivityAuthorizationInfo().areActivitiesEnabled
        else { return }

        let language = metadata.language
        let attributes = NavigationActivityAttributes(
            routeType: metadata.routeType,
            destinationName: metadata.destinationName,
            language: language,
            endTripTitle: Self.localized("end_trip", language),
            arrivedMessage: Self.localized("arrived", language)
        )
        let contentState = buildContentState(isArrived: false)

        do {
            activity = try Activity<NavigationActivityAttributes>.request(
                attributes: attributes,
                content: ActivityContent(
                    state: contentState,
                    staleDate: Date().addingTimeInterval(Self.staleInterval)
                )
            )
            lastContentState = contentState
            lastUpdateTime = Date()
            NSLog("BaladyLA: Live Activity started id=%@", activity?.id ?? "nil")
        } catch {
            NSLog("NavigationLiveActivityController: failed to start Live Activity: \(error)")
        }
    }

    private func updateActivityIfNeeded() {
        guard let activity = activity else { return }

        let contentState = buildContentState(isArrived: false)
        guard contentState != lastContentState else { return }
        guard Date().timeIntervalSince(lastUpdateTime) >= Self.minUpdateInterval else { return }

        lastContentState = contentState
        lastUpdateTime = Date()

        Task {
            await activity.update(ActivityContent(
                state: contentState,
                staleDate: Date().addingTimeInterval(Self.staleInterval)
            ))
        }
    }

    private func finishWithArrival() {
        guard let activity = activity else { return }
        self.activity = nil
        lastContentState = nil

        let arrivedState = buildContentState(isArrived: true)
        dashboard = nil
        maneuver = nil

        Task {
            let content = ActivityContent(state: arrivedState, staleDate: nil as Date?)
            await activity.update(content)
            await activity.end(
                content,
                dismissalPolicy: .after(Date().addingTimeInterval(Self.arrivalDismissalInterval))
            )
        }
    }

    private func endActivity(dismissalPolicy: ActivityUIDismissalPolicy) {
        guard let activity = activity else { return }
        self.activity = nil
        lastContentState = nil

        Task {
            await activity.end(nil, dismissalPolicy: dismissalPolicy)
        }
    }

    private func endStaleActivities() {
        guard activity == nil else { return }
        Task {
            for stale in Activity<NavigationActivityAttributes>.activities {
                await stale.end(nil, dismissalPolicy: .immediate)
            }
        }
    }

    // MARK: - Content state building

    private func buildContentState(isArrived: Bool) -> NavigationActivityAttributes.ContentState {
        let language = metadata?.language ?? "en"

        let instruction = maneuver?.instruction ?? ""
        let distanceToManeuverText: String
        if let maneuver = maneuver {
            distanceToManeuverText = Self.formatManeuverDistance(millimeters: maneuver.distanceMm, language: language)
        } else {
            distanceToManeuverText = ""
        }

        let remainingDistanceText: String
        let remainingTimeText: String
        if let dashboard = dashboard {
            remainingDistanceText = Self.formatRemainingDistance(kilometers: dashboard.distanceKm, language: language)
            remainingTimeText = Self.formatRemainingTime(seconds: dashboard.durationSeconds, language: language)
        } else {
            remainingDistanceText = ""
            remainingTimeText = ""
        }

        return NavigationActivityAttributes.ContentState(
            instruction: instruction,
            roadName: maneuver?.roadName ?? "",
            distanceToManeuverText: distanceToManeuverText,
            maneuverSymbol: isArrived ? "checkmark.circle.fill" : Self.maneuverSymbol(for: instruction),
            etaText: dashboard?.arrivalTime ?? "",
            remainingDistanceText: remainingDistanceText,
            remainingTimeText: remainingTimeText,
            isArrived: isArrived
        )
    }

    // MARK: - Formatting

    // Buckets mirror the CarPlay formatter
    // (urbi_map/dgis_map/ios/Classes/CarPlay/NavigationSessionManeuvers.swift, formatDistance):
    // < 100 m — 10 m steps, < 1000 m — 50 m steps, >= 1000 m — km with one decimal.
    static func formatManeuverDistance(millimeters: Double, language: String) -> String {
        let meters = max(0, millimeters / 1000.0)

        if meters >= 1000 {
            let km = (meters / 100).rounded(.down) / 10
            return "\(Self.trimTrailingZero(km)) \(Self.localized("km", language))"
        }

        let rounded: Int
        if meters < 100 {
            rounded = Int((meters / 10).rounded(.down)) * 10
        } else {
            rounded = Int((meters / 50).rounded(.down)) * 50
        }
        return "\(rounded) \(Self.localized("m", language))"
    }

    static func formatRemainingDistance(kilometers: Double, language: String) -> String {
        if kilometers >= 1 {
            let km = (kilometers * 10).rounded(.down) / 10
            return "\(Self.trimTrailingZero(km)) \(Self.localized("km", language))"
        }
        let meters = Int((kilometers * 1000 / 10).rounded(.down)) * 10
        return "\(meters) \(Self.localized("m", language))"
    }

    static func formatRemainingTime(seconds: Int, language: String) -> String {
        let totalMinutes = max(0, seconds) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 {
            if minutes > 0 {
                return "\(hours) \(Self.localized("h", language)) \(minutes) \(Self.localized("min", language))"
            }
            return "\(hours) \(Self.localized("h", language))"
        }
        return "\(max(1, minutes)) \(Self.localized("min", language))"
    }

    private static func trimTrailingZero(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(format: "%.1f", value)
    }

    // MARK: - Localization (pre-localized in-process; the extension renders plain strings)

    private static let strings: [String: [String: String]] = [
        "en": [
            "end_trip": "End Trip",
            "arrived": "You have arrived",
            "km": "km",
            "m": "m",
            "h": "h",
            "min": "min",
        ],
        "ar": [
            "end_trip": "إنهاء الرحلة",
            "arrived": "لقد وصلت",
            "km": "كم",
            "m": "م",
            "h": "س",
            "min": "د",
        ],
    ]

    private static func localized(_ key: String, _ language: String) -> String {
        strings[language]?[key] ?? strings["en"]?[key] ?? key
    }

    // MARK: - Maneuver symbol mapping

    // Instruction names come from
    // urbi_map/dgis_map/ios/Classes/Extensions/InstructionManeuver+ToString.swift.
    static func maneuverSymbol(for instruction: String) -> String {
        switch instruction {
        case "crossroad_left", "crossroad_sharply_left":
            return "arrow.turn.up.left"
        case "crossroad_right", "crossroad_sharply_right":
            return "arrow.turn.up.right"
        case "crossroad_slightly_left", "crossroad_keep_left":
            return "arrow.up.left"
        case "crossroad_slightly_right", "crossroad_keep_right":
            return "arrow.up.right"
        case "crossroad_straight", "start":
            return "arrow.up"
        case "crossroad_uturn", "uturn":
            return "arrow.uturn.left"
        case "roundabout_forward", "roundabout_left_45", "roundabout_left_90", "roundabout_left_135",
             "roundabout_right_45", "roundabout_right_90", "roundabout_right_135",
             "roundabout_backward", "roundabout_exit":
            return "arrow.triangle.2.circlepath"
        case "finish":
            return "flag.checkered"
        case "road_crossing":
            return "figure.walk"
        default:
            return "location.north.line.fill"
        }
    }
}

#endif
