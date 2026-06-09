import Flutter
import UIKit

/// Captures home-screen shortcut keys for pre-warmed Flutter engines.
final class AppIconQuickActionChannel {
    static let channelName = "momra.balady/app_icon_quick_action"

    private static var pendingShortcutKey: String?
    private static var methodChannel: FlutterMethodChannel?

    static func register(messenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        methodChannel?.setMethodCallHandler { call, result in
            switch call.method {
            case "consumePendingShortcut":
                result(consumePending())
            case "peekPendingShortcut":
                result(peekPending())
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    static func store(_ key: String) {
        pendingShortcutKey = key
    }

    private static func peekPending() -> String? {
        pendingShortcutKey
    }

    private static func consumePending() -> String? {
        defer { pendingShortcutKey = nil }
        return pendingShortcutKey
    }
}
