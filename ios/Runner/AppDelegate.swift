import UIKit
import Flutter
import dgis_map
import AVFoundation
import ObjectiveC
//import GoogleMaps

extension Notification.Name {
    static let navigationVoiceStarted = Notification.Name("com.balady.navigationVoiceStarted")
    static let navigationVoiceEnded   = Notification.Name("com.balady.navigationVoiceEnded")
}

private enum AudioSessionMixer {
    static var unduckTimer: Timer?

    static func install() {
        let cls = AVAudioSession.self

        if let orig = class_getInstanceMethod(cls, #selector(AVAudioSession.setCategory(_:mode:options:))),
           let repl = class_getInstanceMethod(cls, #selector(AVAudioSession._bs_setCategory(_:mode:options:))) {
            method_exchangeImplementations(orig, repl)
        }

        if let orig = class_getInstanceMethod(cls, #selector(AVAudioSession.setActive(_:options:))),
           let repl = class_getInstanceMethod(cls, #selector(AVAudioSession._bs_setActiveWithOptions(_:withOptions:))) {
            method_exchangeImplementations(orig, repl)
        }
    }
}

extension AVAudioSession {
    @objc func _bs_setCategory(
        _ category: AVAudioSession.Category,
        mode: AVAudioSession.Mode,
        options: AVAudioSession.CategoryOptions
    ) throws {
        if mode == .voicePrompt || mode == .spokenAudio {
            return
        }
        // CRITICAL: do NOT inject `.mixWithOthers` for `.playback`.
        //
        // iOS deliberately hides MPNowPlayingInfoCenter and ignores
        // MPRemoteCommandCenter targets whenever the active audio session is
        // mixable — the app is treated as ambient/secondary audio. MBC radio
        // (NativeRadioPlayer) requires the standard "media player" UI on the
        // lock screen / Control Center / CarPlay, so its `.playback` session
        // MUST stay exclusive. The mixing override is only needed to make
        // 2GIS navigation voice (`.voicePrompt` / `.spokenAudio`, already
        // exempted above) coexist with other ambient audio.
        if category == .playback {
            try _bs_setCategory(category, mode: mode, options: options)
            return
        }
        let safeOptions = options.union(.mixWithOthers).subtracting(.duckOthers)
        try _bs_setCategory(category, mode: mode, options: safeOptions)
    }

    @objc func _bs_setActiveWithOptions(_ active: Bool, withOptions options: AVAudioSession.SetActiveOptions) throws {
        if !active {
            DispatchQueue.main.async {
                AudioSessionMixer.unduckTimer?.invalidate()
                AudioSessionMixer.unduckTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                    AudioSessionMixer.unduckTimer = nil
                    NotificationCenter.default.post(name: .navigationVoiceEnded, object: nil)
                }
            }
            return
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .navigationVoiceStarted, object: nil)
        }
        try _bs_setActiveWithOptions(active, withOptions: options)
    }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var overlayView: UIView?
    private var audioCoordinationManager: AudioCoordinationManager?
    private var nativeRadioPlayer: NativeRadioPlayer?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
       // GMSServices.provideAPIKey("AIzaSyBqCwmdyfOA84Tz3XwRbFPHUgiNs0O95pU")
        AudioSessionMixer.install()

        let sharedSingleFlutterEngine = FlutterEngine(name: "SharedSingle")
        sharedSingleFlutterEngine.run()
        GeneratedPluginRegistrant.register(with: sharedSingleFlutterEngine)
        FlutterCarPlaySceneDelegate.flutterEngine = sharedSingleFlutterEngine
        SceneDelegate.flutterEngine = sharedSingleFlutterEngine

        // Setup native overlay method channel
        setupNativeOverlayChannel(with: sharedSingleFlutterEngine)

        // Setup iOS audio coordination → Flutter events (duck/restore).
        audioCoordinationManager = AudioCoordinationManager(messenger: sharedSingleFlutterEngine.binaryMessenger)

        AppIconQuickActionChannel.register(messenger: sharedSingleFlutterEngine.binaryMessenger)

        // Lock-screen navigation Live Activity (metadata channel + native event observers).
        NavigationLiveUpdatesChannel.register(messenger: sharedSingleFlutterEngine.binaryMessenger)

        // Native radio player — bypasses just_audio_background interruption handling.
        nativeRadioPlayer = NativeRadioPlayer(messenger: sharedSingleFlutterEngine.binaryMessenger)

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        return true
    }

    override func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        AppIconQuickActionChannel.store(shortcutItem.type)
        completionHandler(true)
    }

    private func setupNativeOverlayChannel(with flutterEngine: FlutterEngine) {
        let overlayChannel = FlutterMethodChannel(name: "native_overlay_channel",
                                                  binaryMessenger: flutterEngine.binaryMessenger)

        overlayChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

            switch call.method {
            case "showOverlay":
                DispatchQueue.main.async {
                    self?.showNativeOverlay()
                }
                result(nil)
            case "hideOverlay":
                DispatchQueue.main.async {
                    self?.hideNativeOverlay()
                }
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }

    private func showNativeOverlay() {
        guard let window = UIApplication.shared.windows.first,
              let rootViewController = window.rootViewController else { return }

        if overlayView == nil {
            overlayView = UIView()
            overlayView?.backgroundColor = UIColor.clear // Completely transparent
            overlayView?.frame = rootViewController.view.bounds
            overlayView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            // Create a custom touch handling view that only blocks WebView interactions
            let webViewOverlay = WebViewOverlayView(frame: rootViewController.view.bounds)
            webViewOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlayView?.addSubview(webViewOverlay)

            // Add to the view controller's view instead of window to respect navigation
            rootViewController.view.addSubview(overlayView!)

            // Bring to front to ensure it's above WebView
            rootViewController.view.bringSubviewToFront(overlayView!)
        }
        overlayView?.isHidden = false

        // Ensure it's always on top
        if let overlay = overlayView {
            overlay.superview?.bringSubviewToFront(overlay)
        }
    }



    private func hideNativeOverlay() {
        overlayView?.isHidden = true
    }

    // Custom view that only blocks WebView interactions, not dialogs
    private class WebViewOverlayView: UIView {
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            // Check if there's a dialog or alert view present
            if let window = UIApplication.shared.windows.first {
                for subview in window.subviews {
                    // Check if the point is within a dialog/alert view
                    if let alertView = findAlertView(in: subview) {
                        let convertedPoint = convert(point, to: alertView)
                        if alertView.point(inside: convertedPoint, with: event) {
                            return false // Don't block touches on dialogs
                        }
                    }
                }
            }
            
            // Block touches for WebView area
            return true
        }
        
        private func findAlertView(in view: UIView) -> UIView? {
            // Look for common dialog/alert view classes
            if NSStringFromClass(type(of: view)).contains("UIAlertController") ||
               NSStringFromClass(type(of: view)).contains("_UIAlertControllerView") ||
               NSStringFromClass(type(of: view)).contains("UIAlertView") {
                return view
            }
            
            // Recursively search subviews
            for subview in view.subviews {
                if let alertView = findAlertView(in: subview) {
                    return alertView
                }
            }
            
            return nil
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // Only handle touches if they're not on a dialog
            if let touch = touches.first {
                let point = touch.location(in: self)
                if self.point(inside: point, with: event) {
                    super.touchesBegan(touches, with: event)
                }
            }
        }
    }
}