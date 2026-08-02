//
//  NavigationLiveActivity.swift
//  MovingViolationsExtension
//
//  Lock screen / Dynamic Island UI for turn-by-turn navigation.
//  All strings arrive pre-localized in NavigationActivityAttributes;
//  layout direction follows the session language.
//

import ActivityKit
import WidgetKit
import SwiftUI

private let baladyAppURL = URL(string: "https://plus.balady.sa/#/")

/// Design tokens, mirrored from balady_uikit so the widget matches the app.
private enum NavPalette {
    /// accent/default
    static let accent = Color(red: 0.165, green: 0.702, blue: 0.663)
    /// BaseColors.error
    static let error = Color(red: 0.878, green: 0.216, blue: 0.239)
    /// BaseColors.success
    static let success = Color(red: 0.208, green: 0.592, blue: 0.282)
    /// background/surface4 — the travelled part of the timeline.
    static let surface4 = Color(red: 0.945, green: 0.945, blue: 0.945)
    /// screen-overlay/dimming-80
    static let dimming = Color.black.opacity(0.8)
    /// Surface behind the maneuver glyph.
    static let iconSurface = Color.white.opacity(0.12)
    static let softButton = Color.white.opacity(0.16)

    /// DGis `TrafficSpeedColor` raw values, coloured as on the map.
    /// free — accent/default, jam — extra-02/default, congestion — #F63319.
    static func traffic(level: Int) -> Color {
        switch level {
        case 1: return accent
        case 2: return Color(red: 1.0, green: 0.937, blue: 0.012)
        case 3: return Color(red: 0.965, green: 0.200, blue: 0.098)
        case 4: return Color(red: 0.659, green: 0.122, blue: 0.059)
        default: return Color.white.opacity(0.35)
        }
    }
}

@available(iOS 16.2, *)
struct NavigationLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NavigationActivityAttributes.self) { context in
            NavigationLockScreenView(context: context)
                .activityBackgroundTint(NavPalette.dimming)
                .activitySystemActionForegroundColor(Color.white)
                .widgetURL(baladyAppURL)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    NavigationHeaderView(context: context, compact: true)
                        .environment(\.layoutDirection, context.attributes.layoutDirection)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack(spacing: 8) {
                        if let speed = context.state.speed {
                            SpeedClusterView(
                                speed: speed,
                                limit: context.state.speedLimit,
                                isSpeeding: context.state.isSpeeding
                            )
                        }
                    }
                    .environment(\.layoutDirection, context.attributes.layoutDirection)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 10) {
                        if context.state.status == .arrived {
                            ArrivalActionsView(context: context)
                        } else {
                            RouteTimelineView(
                                segments: context.state.trafficSegments,
                                progress: context.state.progress,
                                isPedestrian: context.attributes.isPedestrian
                            )
                            RouteSummaryView(context: context)
                        }
                    }
                    .environment(\.layoutDirection, context.attributes.layoutDirection)
                }
            } compactLeading: {
                ManeuverGlyphView(context: context, size: 18)
            } compactTrailing: {
                Text(context.state.distanceToManeuverText)
                    .foregroundColor(.white)
            } minimal: {
                ManeuverGlyphView(context: context, size: 18)
            }
            .widgetURL(baladyAppURL)
            .keylineTint(NavPalette.accent)
        }
    }
}

@available(iOS 16.2, *)
private extension NavigationActivityAttributes {
    var layoutDirection: LayoutDirection {
        language == "ar" ? .rightToLeft : .leftToRight
    }

    var isPedestrian: Bool {
        routeType == "pedestrian"
    }

    /// Free roam has no route: no maneuver, no timeline, no ETA.
    var isFreeRoam: Bool {
        mode == "freeRoam"
    }
}

// MARK: - Lock screen

@available(iOS 16.2, *)
private struct NavigationLockScreenView: View {
    let context: ActivityViewContext<NavigationActivityAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                if context.attributes.isFreeRoam {
                    FreeRoamHeaderView(context: context)
                } else {
                    NavigationHeaderView(context: context, compact: false)
                }
                Spacer(minLength: 8)
                if let speed = context.state.speed {
                    SpeedClusterView(
                        speed: speed,
                        limit: context.state.speedLimit,
                        isSpeeding: context.state.isSpeeding
                    )
                }
                Image("BaladyAppIcon")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }

            if context.attributes.isFreeRoam {
                EmptyView()
            } else if context.state.status == .arrived {
                ArrivalActionsView(context: context)
            } else {
                RouteTimelineView(
                    segments: context.state.trafficSegments,
                    progress: context.state.progress,
                    isPedestrian: context.attributes.isPedestrian
                )
                RouteSummaryView(context: context)
            }
        }
        .padding(16)
        .environment(\.layoutDirection, context.attributes.layoutDirection)
    }
}

/// Free roam: the road the driver is on, plus the status pill when the fix is lost.
@available(iOS 16.2, *)
private struct FreeRoamHeaderView: View {
    let context: ActivityViewContext<NavigationActivityAttributes>

    var body: some View {
        if context.state.status == .gpsLost {
            StatusPillView(text: context.state.statusText, color: NavPalette.error)
        } else {
            VStack(alignment: .leading, spacing: 2) {
                Text(context.attributes.freeRoamTitle)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                if !context.state.roadName.isEmpty {
                    Text(context.state.roadName)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
    }
}

/// First row: either the next maneuver, or the status pill that replaces it.
@available(iOS 16.2, *)
private struct NavigationHeaderView: View {
    let context: ActivityViewContext<NavigationActivityAttributes>
    let compact: Bool

    var body: some View {
        switch context.state.status {
        case .navigating:
            maneuver
        case .arrived:
            arrived
        case .gpsLost, .rerouting:
            StatusPillView(
                text: context.state.statusText,
                color: context.state.status == .rerouting ? NavPalette.success : NavPalette.error
            )
        }
    }

    private var maneuver: some View {
        HStack(spacing: 12) {
            ManeuverGlyphView(context: context, size: compact ? 22 : 26)
                .frame(width: compact ? 36 : 48, height: compact ? 36 : 48)
                .background(NavPalette.iconSurface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 1) {
                Text(context.state.distanceToManeuverText)
                    .font(.system(size: compact ? 18 : 22, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                if !context.state.roadName.isEmpty {
                    Text(context.state.roadName)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
    }

    private var arrived: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(context.attributes.arrivedMessage)
                .font(.system(size: compact ? 18 : 22, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
            if !context.attributes.destinationName.isEmpty {
                Text(context.attributes.destinationName)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
            }
        }
    }
}

@available(iOS 16.2, *)
private struct ManeuverGlyphView: View {
    let context: ActivityViewContext<NavigationActivityAttributes>
    let size: CGFloat

    var body: some View {
        Image(context.state.maneuverIcon)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(.white)
    }
}

@available(iOS 16.2, *)
private struct StatusPillView: View {
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(color, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

/// Speedometer with the speed-limit badge, mirroring balady_uikit's LimitAlert.
@available(iOS 16.2, *)
private struct SpeedClusterView: View {
    let speed: Int
    let limit: Int?
    let isSpeeding: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text("\(speed)")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 40, height: 40)
                .background(Color.white, in: Circle())
                .padding(.top, 8)
                .padding(.trailing, 10)

            if let limit = limit {
                Text("\(limit)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isSpeeding ? .white : .black)
                    .frame(width: 24, height: 24)
                    .background(isSpeeding ? NavPalette.error : Color.white, in: Circle())
                    .overlay(Circle().stroke(NavPalette.error, lineWidth: 3))
            }
        }
        .frame(width: 50, height: 48)
    }
}

// MARK: - Timeline

@available(iOS 16.2, *)
private struct RouteTimelineView: View {
    let segments: [NavigationTrafficSegment]
    let progress: Double
    let isPedestrian: Bool

    @Environment(\.layoutDirection) private var layoutDirection

    private static let barHeight: CGFloat = 8
    private static let dashWidth: CGFloat = 3
    private static let dashHeight: CGFloat = 12
    private static let dashGap: CGFloat = 2
    /// The marker overhangs the bar, so the row is as tall as the marker.
    private static let rowHeight: CGFloat = 24

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let passed = width * min(1, max(0, progress))

            ZStack(alignment: .leading) {
                if isPedestrian {
                    dashes(width: width, passed: passed)
                } else {
                    trafficBar(width: width, passed: passed)
                }
                marker(passed: passed)
            }
            .frame(width: width, height: Self.rowHeight, alignment: .center)
        }
        .frame(height: Self.rowHeight)
    }

    private func trafficBar(width: CGFloat, passed: CGFloat) -> some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 0) {
                ForEach(Array(resolvedSegments.enumerated()), id: \.offset) { index, segment in
                    NavPalette.traffic(level: segment.level)
                        .frame(width: width * segment.share)
                }
            }
            HStack(spacing: 0) {
                NavPalette.surface4.frame(width: passed)
                Spacer(minLength: 0)
            }
        }
        .frame(height: Self.barHeight)
        .clipShape(Capsule())
    }

    private func dashes(width: CGFloat, passed: CGFloat) -> some View {
        let pitch = Self.dashWidth + Self.dashGap
        let count = max(1, Int((width + Self.dashGap) / pitch))

        return HStack(spacing: Self.dashGap) {
            ForEach(0..<count, id: \.self) { index in
                UnevenRoundedCornersShape(radius: 2)
                    .fill(Color.white.opacity(CGFloat(index) * pitch < passed ? 0.4 : 1))
                    .frame(width: Self.dashWidth, height: Self.dashHeight)
            }
        }
        .frame(width: width, alignment: .leading)
    }

    private func marker(passed: CGFloat) -> some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
                .frame(width: max(0, passed - markerSize / 2))
            if isPedestrian {
                Image(systemName: "figure.walk")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: markerSize, height: markerSize)
                    .background(NavPalette.accent, in: Circle())
            } else {
                // assets/icons/makkah/directions.svg, already turned 90° clockwise
                // and recoloured (accent-950 fill, accent/on-container border).
                Image("RouteProgressMarker")
                    .resizable()
                    .scaledToFit()
                    .frame(width: markerSize, height: markerSize)
                    .rotationEffect(.degrees(layoutDirection == .rightToLeft ? 180 : 0))
            }
            Spacer(minLength: 0)
        }
    }

    /// Twice the dash height, per the design.
    private var markerSize: CGFloat { 24 }

    /// Falls back to a single neutral bar until the first traffic tick arrives.
    private var resolvedSegments: [NavigationTrafficSegment] {
        let total = segments.reduce(0) { $0 + $1.share }
        guard total > 0 else { return [NavigationTrafficSegment(share: 1, level: 0)] }
        return segments.map { NavigationTrafficSegment(share: $0.share / total, level: $0.level) }
    }
}

/// Pedestrian dash: rounded on top only, per the design.
private struct UnevenRoundedCornersShape: Shape {
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + radius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + radius),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Bottom rows

/// Three equal columns: time left, arrival time, distance left.
@available(iOS 16.2, *)
private struct RouteSummaryView: View {
    let context: ActivityViewContext<NavigationActivityAttributes>

    var body: some View {
        HStack(spacing: 4) {
            column(context.state.remainingTimeText, alignment: .leading)
            column(context.state.etaText, alignment: .center)
            column(context.state.remainingDistanceText, alignment: .trailing)
        }
    }

    private func column(_ text: String, alignment: Alignment) -> some View {
        Text(text)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(.white)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

/// Arrival state: open the app, or end the trip from the lock screen.
@available(iOS 16.2, *)
private struct ArrivalActionsView: View {
    let context: ActivityViewContext<NavigationActivityAttributes>

    var body: some View {
        HStack(spacing: 8) {
            Link(destination: baladyAppURL ?? URL(string: "https://plus.balady.sa")!) {
                actionLabel(context.attributes.openAppTitle, background: NavPalette.softButton)
            }
            if #available(iOS 17.0, *) {
                Button(intent: EndTripIntent()) {
                    actionLabel(context.attributes.endTripTitle, background: NavPalette.error)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func actionLabel(_ title: String, background: Color) -> some View {
        Text(title)
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.white)
            .lineLimit(1)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(background, in: Capsule())
    }
}
