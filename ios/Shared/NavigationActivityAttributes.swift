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

@available(iOS 16.2, *)
struct NavigationActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        /// Maneuver enum name from the navigation engine, e.g. "crossroad_left".
        var instruction: String
        /// Name of the road the next maneuver leads to. May be empty.
        var roadName: String
        /// Display-ready distance to the next maneuver, e.g. "300 m".
        var distanceToManeuverText: String
        /// SF Symbol name for the next maneuver.
        var maneuverSymbol: String
        /// Estimated arrival time, "HH:mm".
        var etaText: String
        /// Display-ready remaining route distance, e.g. "4.2 km".
        var remainingDistanceText: String
        /// Display-ready remaining travel time, e.g. "1 h 20 min".
        var remainingTimeText: String
        /// True once the destination is reached — switches the layout to the arrival state.
        var isArrived: Bool
    }

    /// "car", "pedestrian", ...
    var routeType: String
    var destinationName: String
    /// "en" or "ar" — drives layout direction in the extension.
    var language: String
    /// Pre-localized in the app process so the extension needs no string tables.
    var endTripTitle: String
    var arrivedMessage: String
}

#endif
