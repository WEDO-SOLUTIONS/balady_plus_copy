//
//  NavigationLiveUpdatesChannel.swift
//  Runner
//
//  MethodChannel bridge between Dart and NavigationLiveActivityController.
//  Dart only supplies session metadata and teardown signals — all live data
//  flows natively from the dgis_map plugin via NotificationCenter. The bridge
//  is one-way: nothing is sent back from the widget to Dart.
//

import Flutter
import Foundation

final class NavigationLiveUpdatesChannel {
    static let channelName = "balady/navigation_live_updates"

    /// Retained so the channel outlives `register`.
    private static var methodChannel: FlutterMethodChannel?

    static func register(messenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        methodChannel = channel

        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "setSessionMetadata":
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(
                        code: "BadArguments",
                        message: "setSessionMetadata expects a map",
                        details: nil
                    ))
                    return
                }
                if #available(iOS 16.2, *) {
                    NavigationLiveActivityController.shared.setSessionMetadata(
                        destinationName: args["destinationName"] as? String ?? "",
                        mode: args["mode"] as? String ?? "navigation",
                        routeType: args["routeType"] as? String ?? "car",
                        language: args["language"] as? String ?? "en",
                        strings: args["strings"] as? [String: String] ?? [:],
                        enabled: args["enabled"] as? Bool ?? true
                    )
                }
                result(nil)

            case "endSession":
                if #available(iOS 16.2, *) {
                    NavigationLiveActivityController.shared.endSession()
                }
                result(nil)

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        if #available(iOS 16.2, *) {
            NavigationLiveActivityController.shared.activate()
        }
    }
}
