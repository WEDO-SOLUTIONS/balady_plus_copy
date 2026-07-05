//
//  NavLiveActivityAttributes.swift
//  Shared between Runner and MovingViolationsExtension — ActivityKit matches
//  the activity by this type, so both targets compile this file.
//

import ActivityKit
import Foundation

struct NavLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        /// Distance to the next maneuver, meters.
        var distanceToManeuverMeters: Double
        /// Current street name.
        var street: String
        /// Current speed, km/h.
        var speedKmh: Int
        /// Speed limit on the current street, km/h.
        var maxSpeedKmh: Int
        /// Car position along the whole route, 0...1.
        var routeProgress: Double
    }

    /// Traffic segment along the route: fraction of total length + jam severity.
    struct TrafficSegment: Codable, Hashable {
        /// Fraction of the total route length, 0...1.
        var fraction: Double
        /// 0 — free flow (green), 1 — slow (yellow), 2 — jam (red).
        var severity: Int
    }

    /// Static per-route traffic layout (does not change during the demo).
    var trafficSegments: [TrafficSegment]
}