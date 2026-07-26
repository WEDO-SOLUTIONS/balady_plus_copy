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

@available(iOS 16.2, *)
struct NavigationLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NavigationActivityAttributes.self) { context in
            NavigationLockScreenView(context: context)
                .activityBackgroundTint(Color(red: 0.06, green: 0.09, blue: 0.13).opacity(0.85))
                .activitySystemActionForegroundColor(Color.white)
                .widgetURL(baladyAppURL)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        Image(systemName: context.state.maneuverSymbol)
                            .font(.title2)
                            .foregroundColor(.white)
                        Text(context.state.distanceToManeuverText)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .environment(\.layoutDirection, context.attributes.layoutDirection)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.etaText)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.white)
                        .environment(\.layoutDirection, context.attributes.layoutDirection)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    NavigationIslandBottomView(context: context)
                        .environment(\.layoutDirection, context.attributes.layoutDirection)
                }
            } compactLeading: {
                Image(systemName: context.state.maneuverSymbol)
                    .foregroundColor(.white)
            } compactTrailing: {
                Text(context.state.isArrived ? context.state.etaText : context.state.distanceToManeuverText)
                    .foregroundColor(.white)
            } minimal: {
                Image(systemName: context.state.maneuverSymbol)
                    .foregroundColor(.white)
            }
            .widgetURL(baladyAppURL)
            .keylineTint(Color.green)
        }
    }
}

@available(iOS 16.2, *)
private extension NavigationActivityAttributes {
    var layoutDirection: LayoutDirection {
        language == "ar" ? .rightToLeft : .leftToRight
    }

    var routeTypeSymbol: String {
        routeType == "pedestrian" ? "figure.walk" : "car.fill"
    }
}

@available(iOS 16.2, *)
private struct NavigationLockScreenView: View {
    let context: ActivityViewContext<NavigationActivityAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if context.state.isArrived {
                arrivedHeader
            } else {
                maneuverHeader
            }
            bottomRow
        }
        .padding(16)
        .environment(\.layoutDirection, context.attributes.layoutDirection)
    }

    private var arrivedHeader: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 34))
                .foregroundColor(.green)
            VStack(alignment: .leading, spacing: 2) {
                Text(context.attributes.arrivedMessage)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                if !context.attributes.destinationName.isEmpty {
                    Text(context.attributes.destinationName)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                }
            }
            Spacer()
        }
    }

    private var maneuverHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: context.state.maneuverSymbol)
                .font(.system(size: 34, weight: .semibold))
                .foregroundColor(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text(context.state.distanceToManeuverText)
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)
                if !context.state.roadName.isEmpty {
                    Text(context.state.roadName)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                }
            }
            Spacer()
        }
    }

    private var bottomRow: some View {
        HStack(alignment: .center, spacing: 8) {
            if !context.state.isArrived {
                HStack(spacing: 6) {
                    Image(systemName: context.attributes.routeTypeSymbol)
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                    VStack(alignment: .leading, spacing: 1) {
                        if !context.attributes.destinationName.isEmpty {
                            Text(context.attributes.destinationName)
                                .font(.footnote.weight(.semibold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        Text(subtitleText)
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(1)
                    }
                }
            }

            Spacer()

            if #available(iOS 17.0, *) {
                Button(intent: EndTripIntent()) {
                    Text(context.attributes.endTripTitle)
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.85), in: Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var subtitleText: String {
        [context.state.etaText, context.state.remainingTimeText, context.state.remainingDistanceText]
            .filter { !$0.isEmpty }
            .joined(separator: " · ")
    }
}

@available(iOS 16.2, *)
private struct NavigationIslandBottomView: View {
    let context: ActivityViewContext<NavigationActivityAttributes>

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 1) {
                if context.state.isArrived {
                    Text(context.attributes.arrivedMessage)
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                } else if !context.attributes.destinationName.isEmpty {
                    Text(context.attributes.destinationName)
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                if !context.state.isArrived {
                    Text(
                        [context.state.remainingTimeText, context.state.remainingDistanceText]
                            .filter { !$0.isEmpty }
                            .joined(separator: " · ")
                    )
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
                }
            }

            Spacer()

            if #available(iOS 17.0, *) {
                if !context.state.isArrived {
                    Button(intent: EndTripIntent()) {
                        Text(context.attributes.endTripTitle)
                            .font(.footnote.weight(.semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red.opacity(0.85), in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
