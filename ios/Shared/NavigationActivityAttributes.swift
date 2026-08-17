//
//  NavigationActivityAttributes.swift
//  Runner / MovingViolationsExtension (dual target membership)
//
//  Shared contract between the app (starts/updates the Live Activity)
//  and the widget extension (renders it). Keep both targets in sync.
//

import Foundation

#if canImport(ActivityKit)
import ActivityKit

/// One traffic-coloured stretch of the route timeline.
struct NavigationTrafficSegment: Codable, Hashable {
    /// Share of the whole route, 0...1. Shares of all segments sum to ~1.
    var share: Double
    /// DGis `TrafficSpeedColor` raw value:
    /// 0 — undefined, 1 — green, 2 — yellow, 3 — red, 4 — deep red.
    var level: Int
}

/// What the first row of the widget shows.
enum NavigationActivityStatus: String, Codable, Hashable {
    case navigating
    case gpsLost
    case rerouting
    case arrived
}

@available(iOS 16.2, *)
struct NavigationActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var status: NavigationActivityStatus
        /// Pre-localized pill text for `gpsLost` / `rerouting`; empty while navigating.
        var statusText: String
        /// Maneuver enum name from the navigation engine, e.g. "crossroad_left".
        var instruction: String
        /// Name of the road the next maneuver leads to. May be empty.
        var roadName: String
        /// Display-ready distance to the next maneuver, e.g. "300 m".
        var distanceToManeuverText: String
        /// Asset name of the maneuver glyph bundled with the widget, e.g. "Crossroad_left".
        var maneuverIcon: String
        /// Estimated arrival time, "HH:mm".
        var etaText: String
        /// Display-ready remaining route distance, e.g. "4.2 km".
        var remainingDistanceText: String
        /// Display-ready remaining travel time, e.g. "1 h 20 min".
        var remainingTimeText: String
        /// Traveled share of the route, 0...1 — drives the timeline arrow.
        var progress: Double
        /// Route traffic colouring; empty for pedestrian routes, which draw plain dashes.
        var trafficSegments: [NavigationTrafficSegment]
        /// Current speed in km/h. Car routes only.
        var speed: Int?
        /// Speed limit in km/h where the engine knows one. Car routes only.
        var speedLimit: Int?
        var isSpeeding: Bool
    }

    /// "navigation" — guidance along a route, "freeRoam" — the free roam session.
    var mode: String
    /// "car", "pedestrian", ...
    var routeType: String
    var destinationName: String
    /// "en" or "ar" — drives layout direction in the extension.
    var language: String
    /// Pre-localized in the app process so the extension needs no string tables.
    var openAppTitle: String
    var arrivedMessage: String
    /// Headline for the free roam session, e.g. "Free roam".
    var freeRoamTitle: String
}

#endif
