import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
GeneratedPluginRegistrant.register(with: self)
            GMSServices.provideAPIKey("AIzaSyBqCwmdyfOA84Tz3XwRbFPHUgiNs0O95pU")

    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
