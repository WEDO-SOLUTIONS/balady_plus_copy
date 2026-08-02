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
        static let speedTick = Notification.Name("dgis.navigation.speedTick")
        static let messageTick = Notification.Name("dgis.navigation.messageTick")
        static let stateChanged = Notification.Name("dgis.navigation.stateChanged")
        static let endTripRequested = Notification.Name("balady.endTripRequested")
    }

    private struct SessionMetadata {
        let destinationName: String
        /// "navigation" | "freeRoam"
        let mode: String
        let routeType: String
        let language: String
        /// Copy handed over by Dart (Localazy-managed); missing keys fall back
        /// to the built-in table below.
        let strings: [String: String]
        let enabled: Bool
    }

    private struct DashboardData {
        let durationSeconds: Int
        let distanceKm: Double
        let arrivalTime: String
        let progress: Double
        let trafficSegments: [NavigationTrafficSegment]
    }

    private struct ManeuverData {
        let distanceMm: Double
        let roadName: String
        let instruction: String
    }

    private struct SpeedData {
        let speed: Int
        let speedLimit: Int?
        let isSpeeding: Bool
    }

    /// Best-effort bridge back to Dart, wired up by NavigationLiveUpdatesChannel.
    var onEndTripRequested: (() -> Void)?

    private var metadata: SessionMetadata?
    private var navigationState: String = "disabled"
    private var dashboard: DashboardData?
    private var maneuver: ManeuverData?
    private var speed: SpeedData?
    /// "none" | "gpsLost" | "routeResearch", as posted by MessageControlModel.
    private var message: String = "none"

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
            forName: NotificationNames.speedTick, object: nil, queue: .main
        ) { [weak self] notification in
            self?.handleSpeedTick(notification.userInfo)
        })
        observers.append(center.addObserver(
            forName: NotificationNames.messageTick, object: nil, queue: .main
        ) { [weak self] notification in
            self?.handleMessageTick(notification.userInfo)
        })
        observers.append(center.addObserver(
            forName: NotificationNames.endTripRequested, object: nil, queue: .main
        ) { [weak self] _ in
            self?.handleEndTripRequested()
        })

        endStaleActivities()
    }

    // MARK: - Channel API (called from NavigationLiveUpdatesChannel, main thread)

    func setSessionMetadata(
        destinationName: String,
        mode: String,
        routeType: String,
        language: String,
        strings: [String: String],
        enabled: Bool
    ) {
        metadata = SessionMetadata(
            destinationName: destinationName,
            mode: mode,
            routeType: routeType,
            language: language,
            strings: strings,
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
        speed = nil
        message = "none"
        endActivity(dismissalPolicy: .immediate)
    }

    // MARK: - Navigation event handling

    private func handleStateChanged(_ state: String) {
        navigationState = state
        switch state {
        case "navigation", "routeSearch":
            startActivityIfPossible()
        case "finished":
            finishWithArrival()
        case "disabled":
            dashboard = nil
            maneuver = nil
            speed = nil
            message = "none"
            endActivity(dismissalPolicy: .immediate)
        default:
            break
        }
    }

    private func handleDashboardTick(_ userInfo: [AnyHashable: Any]?) {
        guard
            let duration = userInfo?["duration"] as? Int,
            let distanceKm = userInfo?["distanceKm"] as? Double,
            let arrivalTime = userInfo?["arrivalTime"] as? String
        else { return }

        let shares = userInfo?["trafficShares"] as? [Double] ?? []
        let levels = userInfo?["trafficLevels"] as? [Int] ?? []
        let segments = zip(shares, levels).map { NavigationTrafficSegment(share: $0.0, level: $0.1) }

        dashboard = DashboardData(
            durationSeconds: duration,
            distanceKm: distanceKm,
            arrivalTime: arrivalTime,
            progress: userInfo?["progress"] as? Double ?? 0,
            trafficSegments: segments
        )
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

    private func handleSpeedTick(_ userInfo: [AnyHashable: Any]?) {
        guard let value = userInfo?["speed"] as? Int else { return }

        speed = SpeedData(
            speed: value,
            speedLimit: userInfo?["speedLimit"] as? Int,
            isSpeeding: userInfo?["exceeding"] as? Bool ?? false
        )
        // Free roam has no dashboard/maneuver ticks — speed is what starts it.
        startActivityIfPossible()
        updateActivityIfNeeded()
    }

    private func handleMessageTick(_ userInfo: [AnyHashable: Any]?) {
        guard let state = userInfo?["state"] as? String else { return }

        message = state
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
        guard activity == nil,
              let metadata = metadata,
              metadata.enabled,
              isLiveState(for: metadata),
              ActivityAuthorizationInfo().areActivitiesEnabled
        else { return }

        let language = metadata.language
        let attributes = NavigationActivityAttributes(
            mode: metadata.mode,
            routeType: metadata.routeType,
            destinationName: metadata.destinationName,
            language: language,
            endTripTitle: localized("end_trip"),
            openAppTitle: localized("open_app"),
            arrivedMessage: localized("arrived"),
            freeRoamTitle: localized("free_roam")
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
        } catch {
            NSLog("NavigationLiveActivityController: failed to start Live Activity: \(error)")
        }
    }

    /// Guidance only runs in "navigation"; free roam has no route, so the engine
    /// sits in "routeSearch" for the whole session.
    private func isLiveState(for metadata: SessionMetadata) -> Bool {
        if metadata.mode == "freeRoam" {
            return navigationState == "navigation" || navigationState == "routeSearch"
        }
        return navigationState == "navigation"
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
        speed = nil
        message = "none"

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
        let instruction = maneuver?.instruction ?? ""
        let distanceToManeuverText: String
        if let maneuver = maneuver {
            distanceToManeuverText = formatManeuverDistance(millimeters: maneuver.distanceMm)
        } else {
            distanceToManeuverText = ""
        }

        let remainingDistanceText: String
        let remainingTimeText: String
        if let dashboard = dashboard {
            remainingDistanceText = formatRemainingDistance(kilometers: dashboard.distanceKm)
            remainingTimeText = formatRemainingTime(seconds: dashboard.durationSeconds)
        } else {
            remainingDistanceText = ""
            remainingTimeText = ""
        }

        let status = isArrived ? NavigationActivityStatus.arrived : Self.status(forMessage: message)
        let statusText = statusText(for: status)
        // Speed only makes sense while driving; pedestrian routes and the arrival
        // card hide the cluster.
        let isCar = (metadata?.routeType ?? "car") == "car" && !isArrived

        return NavigationActivityAttributes.ContentState(
            status: status,
            statusText: statusText,
            instruction: instruction,
            roadName: maneuver?.roadName ?? "",
            distanceToManeuverText: distanceToManeuverText,
            maneuverIcon: Self.maneuverIcon(for: instruction),
            etaText: dashboard?.arrivalTime ?? "",
            remainingDistanceText: remainingDistanceText,
            remainingTimeText: remainingTimeText,
            progress: isArrived ? 1 : (dashboard?.progress ?? 0),
            trafficSegments: isCar ? (dashboard?.trafficSegments ?? []) : [],
            speed: isCar ? speed?.speed : nil,
            speedLimit: isCar ? speed?.speedLimit : nil,
            isSpeeding: isCar && (speed?.isSpeeding ?? false)
        )
    }

    private static func status(forMessage message: String) -> NavigationActivityStatus {
        switch message {
        case "gpsLost":
            return .gpsLost
        case "routeResearch":
            return .rerouting
        default:
            return .navigating
        }
    }

    private func statusText(for status: NavigationActivityStatus) -> String {
        switch status {
        case .gpsLost:
            return localized("gps_lost")
        case .rerouting:
            return localized("reroute")
        case .arrived:
            return localized("arrived")
        case .navigating:
            return ""
        }
    }

    // MARK: - Formatting

    // Buckets mirror the CarPlay formatter
    // (urbi_map/dgis_map/ios/Classes/CarPlay/NavigationSessionManeuvers.swift, formatDistance):
    // < 100 m — 10 m steps, < 1000 m — 50 m steps, >= 1000 m — km with one decimal.
    func formatManeuverDistance(millimeters: Double) -> String {
        let meters = max(0, millimeters / 1000.0)

        if meters >= 1000 {
            let km = (meters / 100).rounded(.down) / 10
            return "\(Self.trimTrailingZero(km)) \(localized("km"))"
        }

        let rounded: Int
        if meters < 100 {
            rounded = Int((meters / 10).rounded(.down)) * 10
        } else {
            rounded = Int((meters / 50).rounded(.down)) * 50
        }
        return "\(rounded) \(localized("m"))"
    }

    func formatRemainingDistance(kilometers: Double) -> String {
        if kilometers >= 1 {
            let km = (kilometers * 10).rounded(.down) / 10
            return "\(Self.trimTrailingZero(km)) \(localized("km"))"
        }
        let meters = Int((kilometers * 1000 / 10).rounded(.down)) * 10
        return "\(meters) \(localized("m"))"
    }

    func formatRemainingTime(seconds: Int) -> String {
        let totalMinutes = max(0, seconds) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 {
            if minutes > 0 {
                return "\(hours) \(localized("h")) \(minutes) \(localized("min"))"
            }
            return "\(hours) \(localized("h"))"
        }
        return "\(max(1, minutes)) \(localized("min"))"
    }

    private static func trimTrailingZero(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(format: "%.1f", value)
    }

    // MARK: - Localization (pre-localized in-process; the extension renders plain strings)

    private static let strings: [String: [String: String]] = [
        // Mirrors mapness/lib/l10n/app_{en,ar}.arb:
        // endTrip, youArrived, gpsLost, routeResearch.
        "en": [
            "end_trip": "End trip",
            "open_app": "Open Balady+",
            "arrived": "You've arrived",
            "free_roam": "Free roam",
            "gps_lost": "GPS signal lost",
            "reroute": "Re-route",
            "km": "km",
            "m": "m",
            "h": "h",
            "min": "min",
        ],
        "ar": [
            "end_trip": "إنهاء الرحلة",
            "open_app": "فتح بلدي+",
            "arrived": "لقد وصلت إلى وجهتك",
            "free_roam": "التجول الحر",
            "gps_lost": "انقطعت إشارة GPS",
            "reroute": "إعادة التوجيه",
            "km": "كم",
            "m": "م",
            "h": "س",
            "min": "د",
        ],
    ]

    private static func localized(_ key: String, _ language: String) -> String {
        strings[language]?[key] ?? strings["en"]?[key] ?? key
    }

    /// Prefers the copy Dart sent for this session over the built-in table.
    private func localized(_ key: String) -> String {
        if let value = metadata?.strings[key], !value.isEmpty {
            return value
        }
        return Self.localized(key, metadata?.language ?? "en")
    }

    // MARK: - Maneuver icon mapping

    // Instruction names come from
    // urbi_map/dgis_map/ios/Classes/Extensions/InstructionManeuver+ToString.swift;
    // asset names match the in-app glyphs used by CarPlay
    // (urbi_map/dgis_map/ios/Classes/CarPlay/NavigationSessionManeuvers.swift).
    static func maneuverIcon(for instruction: String) -> String {
        switch instruction {
        case "crossroad_left":
            return "Crossroad_left"
        case "crossroad_right":
            return "Crossroad_right"
        case "crossroad_sharply_left":
            return "Crossroad_sharply_left"
        case "crossroad_sharply_right":
            return "Crossroad_sharply_right"
        case "crossroad_slightly_left":
            return "Crossroad_slightly_left"
        case "crossroad_slightly_right":
            return "Crossroad_slightly_right"
        case "crossroad_keep_left":
            return "Crossroad_keep_left"
        case "crossroad_keep_right":
            return "Crossroad_keep_right"
        case "crossroad_straight", "start", "road_crossing":
            return "Crossroad_straight"
        case "crossroad_uturn", "uturn":
            return "Turn_over_right_hand"
        case "roundabout_forward":
            return "Ringroad_forward"
        case "roundabout_left_45":
            return "Ringroad_left_45"
        case "roundabout_left_90":
            return "Ringroad_left_90"
        case "roundabout_left_135":
            return "Ringroad_left_135"
        case "roundabout_right_45":
            return "Ringroad_right_45"
        case "roundabout_right_90":
            return "Ringroad_right_90"
        case "roundabout_right_135":
            return "Ringroad_right_135"
        case "roundabout_backward":
            return "Ringroad_backward"
        case "roundabout_exit":
            return "Ringroad_exit"
        case "finish":
            return "Road_finish"
        default:
            return "Crossroad_straight"
        }
    }
}

#endif
