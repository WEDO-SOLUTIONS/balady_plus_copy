//
//  EndTripIntent.swift
//  Runner / MovingViolationsExtension (dual target membership)
//
//  "End Trip" button on the navigation Live Activity (iOS 17+).
//  LiveActivityIntent performs in the app process, so posting on
//  NotificationCenter reaches NavigationHandler and the Live Activity
//  controller directly.
//

import Foundation

#if canImport(AppIntents)
import AppIntents

@available(iOS 17.0, *)
struct EndTripIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "End Trip"
    static var isDiscoverable: Bool = false

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            NotificationCenter.default.post(
                name: Notification.Name("balady.endTripRequested"),
                object: nil
            )
        }
        return .result()
    }
}

#endif
