import UIKit
import Flutter
import dgis_map
//import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var overlayView: UIView?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
       // GMSServices.provideAPIKey("AIzaSyBqCwmdyfOA84Tz3XwRbFPHUgiNs0O95pU")
        let sharedSingleFlutterEngine = FlutterEngine(name: "SharedSingle")
        sharedSingleFlutterEngine.run()
        GeneratedPluginRegistrant.register(with: sharedSingleFlutterEngine)
        FlutterCarPlaySceneDelegate.flutterEngine = sharedSingleFlutterEngine
        SceneDelegate.flutterEngine = sharedSingleFlutterEngine

        // Setup native overlay method channel
        setupNativeOverlayChannel(with: sharedSingleFlutterEngine)

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        return true
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