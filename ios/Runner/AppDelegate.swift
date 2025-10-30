import UIKit
import Flutter
import dgis_map
//import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
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
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
        return true
    }
}
