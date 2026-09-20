import Flutter
import UIKit

/// Keeps the Home Screen icon in sync with the state chosen by Dart
/// (`SaudiNationalDayAppIcon`), and owns every retry.
///
/// Why native, and why on every activation:
///
///  * `UIApplication.setAlternateIconName` only succeeds while the app is
///    foreground-active *and* LaunchServices (`lsd`) is willing to mint an
///    "icon alert token" for the "You have changed the icon" alert.
///  * If a request is made while the app is not yet active, the alert's
///    presentation is cancelled (`NSCocoaErrorDomain 3072`) — and `lsd` then
///    keeps the token it minted. From that moment every request from every
///    process gets `NSPOSIXErrorDomain 35` ("Resource temporarily
///    unavailable") until the device reboots. That single sequence is what
///    made the icon appear "impossible to change" during testing.
///  * Dart cannot observe those conditions precisely; the platform can.
///    So the desired icon is persisted here and only requested once the app
///    has been continuously active for [settleDelay], on *every* activation,
///    until it sticks. A launch that is refused self-heals on the next
///    foreground, with no relaunch required.
///
/// Dart decides *which* icon (remote-config date window) once per cold start
/// and hands it over via `setDesiredIconName`; this class decides *when*.
///
/// Simulator note: the simulator cannot render the system alert
/// (`couldn't load upcall bundle principal class`) and reports
/// `NSPOSIXErrorDomain 5` even though the icon does change. Real devices
/// present the alert and complete without error.
final class LauncherIconChannel: NSObject {
    static let channelName = "momra.balady/app_icon"

    /// UserDefaults key. Absent → Dart has never decided; "" → primary icon.
    private static let desiredKey = "momra.balady.launcher_icon.desired"
    private static let primaryMarker = ""

    /// How long the app must have been continuously active before a change
    /// is requested. On a first launch the location / notification prompts
    /// land within the first second or two and take the app inactive; a
    /// request that collides with one of them gets its alert cancelled and
    /// wedges `lsd` (see above). Any `willResignActive` cancels the pending
    /// request, so it only ever fires after a quiet window.
    private static let settleDelay: TimeInterval = 2.0

    /// Delays between retries within one activation. After the last one the
    /// applier stays idle until the next `didBecomeActive`.
    private static let retryDelays: [TimeInterval] = [1, 3, 8, 20]

    private let channel: FlutterMethodChannel
    private var attempt = 0
    private var inFlight = false
    private var pendingWork: DispatchWorkItem?

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: messenger)
        super.init()

        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call, result: result)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Method channel

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "supportsAlternateIcons":
            result(UIApplication.shared.supportsAlternateIcons)

        case "getCurrentIconName":
            result(UIApplication.shared.alternateIconName)

        case "setDesiredIconName":
            let args = call.arguments as? [String: Any]
            let name = args?["name"] as? String // nil → primary icon
            store(desired: name)
            NSLog(
                "[LauncherIcon] desired=%@ current=%@ appState=%ld",
                name ?? "<primary>",
                UIApplication.shared.alternateIconName ?? "<primary>",
                UIApplication.shared.applicationState.rawValue
            )
            attempt = 0
            scheduleApply(after: Self.settleDelay, reason: "setDesiredIconName")
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Persistence

    private func store(desired: String?) {
        UserDefaults.standard.set(desired ?? Self.primaryMarker, forKey: Self.desiredKey)
    }

    /// `.none` → Dart never decided; `.some(nil)` → primary; `.some(name)` → alternate.
    private func storedDesired() -> String?? {
        guard let raw = UserDefaults.standard.string(forKey: Self.desiredKey) else {
            return .none
        }
        return .some(raw == Self.primaryMarker ? nil : raw)
    }

    // MARK: - Lifecycle

    @objc private func onDidBecomeActive() {
        attempt = 0
        scheduleApply(after: Self.settleDelay, reason: "didBecomeActive")
    }

    @objc private func onWillResignActive() {
        // Anything fired while inactive would be cancelled by iOS and could
        // wedge `lsd` — wait for the next activation instead.
        pendingWork?.cancel()
        pendingWork = nil
    }

    // MARK: - Apply

    private func scheduleApply(after delay: TimeInterval, reason: String) {
        pendingWork?.cancel()
        let work = DispatchWorkItem { [weak self] in
            self?.applyIfNeeded(reason: reason)
        }
        pendingWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    }

    private func applyIfNeeded(reason: String) {
        guard UIApplication.shared.supportsAlternateIcons else { return }
        guard case .some(let desired) = storedDesired() else { return }

        let current = UIApplication.shared.alternateIconName
        guard current != desired else {
            if reason != "didBecomeActive" {
                NSLog("[LauncherIcon] %@: icon already %@, nothing to do", reason, desired ?? "<primary>")
            }
            return
        }

        guard UIApplication.shared.applicationState == .active else {
            NSLog("[LauncherIcon] %@: app not active, deferring to next activation", reason)
            return
        }
        guard !inFlight else { return }

        inFlight = true
        UIApplication.shared.setAlternateIconName(desired) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.inFlight = false

                if let error = error as NSError? {
                    NSLog(
                        "[LauncherIcon] %@: attempt %ld failed: %@ (%@ %ld)",
                        reason,
                        self.attempt + 1,
                        error.localizedDescription,
                        error.domain,
                        error.code
                    )
                    self.scheduleRetry()
                } else {
                    NSLog("[LauncherIcon] %@: icon -> %@", reason, desired ?? "<primary>")
                    self.attempt = 0
                }
            }
        }
    }

    private func scheduleRetry() {
        guard attempt < Self.retryDelays.count else {
            NSLog("[LauncherIcon] giving up until next activation")
            return
        }

        let delay = Self.retryDelays[attempt]
        attempt += 1
        scheduleApply(after: delay, reason: "retry")
    }
}
