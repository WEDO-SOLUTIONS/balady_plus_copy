//
//  NavLiveActivityWidget.swift
//  MovingViolationsExtension
//
//  Lock screen / Dynamic Island UI for the live navigation demo:
//  a row with distance to maneuver, street and speed above a traffic-colored
//  route bar with an arrow marking the current car position.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct NavLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NavLiveActivityAttributes.self) { context in
            NavLiveLockScreenView(attributes: context.attributes, state: context.state)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .activityBackgroundTint(Color(red: 0.07, green: 0.09, blue: 0.15))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(NavLiveFormat.distance(context.state.distanceToManeuverMeters))
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.speedKmh) / \(context.state.maxSpeedKmh) km/h")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 6) {
                        Text(context.state.street)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.85))
                            .lineLimit(1)
                        NavLiveRouteBar(
                            segments: context.attributes.trafficSegments,
                            progress: context.state.routeProgress
                        )
                        .frame(height: 20)
                    }
                }
            } compactLeading: {
                Image(systemName: "location.north.fill")
                    .foregroundStyle(.blue)
            } compactTrailing: {
                Text(NavLiveFormat.distance(context.state.distanceToManeuverMeters))
                    .font(.caption2)
                    .monospacedDigit()
            } minimal: {
                Image(systemName: "location.north.fill")
                    .foregroundStyle(.blue)
            }
            .keylineTint(.blue)
        }
    }
}

// MARK: - Lock screen content

private struct NavLiveLockScreenView: View {
    let attributes: NavLiveActivityAttributes
    let state: NavLiveActivityAttributes.ContentState

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(NavLiveFormat.distance(state.distanceToManeuverMeters))
                    .font(.headline)
                    .monospacedDigit()
                    .foregroundStyle(.white)

                Spacer(minLength: 8)

                Text(state.street)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(1)

                Spacer(minLength: 8)

                Text("\(state.speedKmh) / \(state.maxSpeedKmh) km/h")
                    .font(.headline)
                    .monospacedDigit()
                    .foregroundStyle(.white)
            }

            NavLiveRouteBar(segments: attributes.trafficSegments, progress: state.routeProgress)
                .frame(height: 22)
        }
    }
}

// MARK: - Traffic route bar

struct NavLiveRouteBar: View {
    let segments: [NavLiveActivityAttributes.TrafficSegment]
    /// Car position, 0...1.
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let carX = min(max(progress * width, height / 2), width - height / 2)

            ZStack(alignment: .leading) {
                // Traffic-colored segments clipped to a pill.
                HStack(spacing: 0) {
                    ForEach(Array(segments.enumerated()), id: \.offset) { _, segment in
                        Rectangle()
                            .fill(Self.color(for: segment.severity))
                            .frame(width: segment.fraction * width)
                    }
                    // Fill any rounding remainder with the last color.
                    Rectangle()
                        .fill(Self.color(for: segments.last?.severity ?? 0))
                }
                .frame(height: height * 0.5)
                .overlay(alignment: .leading) {
                    // Dim the traveled part.
                    Rectangle()
                        .fill(Color.black.opacity(0.45))
                        .frame(width: progress * width)
                }
                .clipShape(Capsule())
                .frame(maxHeight: .infinity, alignment: .center)

                // Car puck: blue circle with a white arrow along the route.
                ZStack {
                    Circle()
                        .fill(Color(red: 0.08, green: 0.40, blue: 0.75))
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 1.5)
                    Image(systemName: "location.north.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .padding(height * 0.22)
                        .rotationEffect(.degrees(90)) // point along the route (to the right)
                }
                .frame(width: height, height: height)
                .position(x: carX, y: height / 2)
            }
        }
    }

    static func color(for severity: Int) -> Color {
        switch severity {
        case 2: return Color(red: 0.96, green: 0.26, blue: 0.21) // jam
        case 1: return Color(red: 1.00, green: 0.76, blue: 0.03) // slow
        default: return Color(red: 0.30, green: 0.69, blue: 0.31) // free flow
        }
    }
}

// MARK: - Formatting

enum NavLiveFormat {
    static func distance(_ meters: Double) -> String {
        meters >= 1000
            ? String(format: "%.1f km", meters / 1000)
            : "\(Int(meters)) m"
    }
}