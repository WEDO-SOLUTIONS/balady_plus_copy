//
//  NavigationLiveUpdatesChannel.swift
//  Runner
//
//  MethodChannel bridge between Dart and NavigationLiveActivityController.
//  Dart only supplies session metadata and teardown signals — all live data
//  flows natively from the dgis_map plugin via NotificationCenter.
//

import Flutter
import Foundation

final class NavigationLiveUpdatesChannel {
    static let channelName = "balady/navigation_live_updates"

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
            NavigationLiveActivityController.shared.onEndTripRequested = {
                notifyEndTripRequested()
            }
            NavigationLiveActivityController.shared.activate()
        }
    }

    /// Best-effort notification to Dart that the user ended the trip from the widget.
    static func notifyEndTripRequested() {
        methodChannel?.invokeMethod("onEndTripRequested", arguments: nil)
    }
}
