import Flutter
import UIKit
import DGis

class DgisPluginApi: NSObject, PluginApi {
    var registrar: FlutterPluginRegistrar
    
    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
    }

    func initialize(message: LogOptionsMessage?, configMessage: VendorConfigMessage?, contentMessage: VendorConfigContentMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        initializeDGis(logOptions: message?.logOptions, configMessage: configMessage, contentMessage: contentMessage)
        completion(Result.success(()))
    }
    
    private func initializeDGis(logOptions: LogOptions?, configMessage: VendorConfigMessage? ,contentMessage: VendorConfigContentMessage?) {
        DgisMapInitializer.shared.initialize(logOptions: logOptions, configMessage: configMessage, contentMessage: contentMessage)
    }
}

public class SwiftDgisMapPlugin: NSObject, FlutterPlugin {
    private static let flutterViewId = "com.dgis.map_view"
    public static var registrar: FlutterPluginRegistrar?

    /// Plugin-level method channel for CarPlay → Flutter events.
    /// Unlike the view-specific EventChannel, this channel is tied to the
    /// FlutterEngine's binary messenger and is always available regardless
    /// of whether a map view exists or the phone scene is backgrounded.
    private static var carPlayChannel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = DgisMapViewFactory(registrar: registrar)

        registrar.register(factory, withId: self.flutterViewId)
        PluginApiSetup.setUp(binaryMessenger: registrar.messenger(), api: DgisPluginApi.init(registrar: registrar))
        self.registrar = registrar

        // Set up a plugin-level method channel for CarPlay events.
        // This is NOT tied to any specific map view, so it works even
        // when the phone scene is backgrounded on a real CarPlay device.
        let channel = FlutterMethodChannel(
            name: "com.dgis.carplay_events",
            binaryMessenger: registrar.messenger()
        )
        self.carPlayChannel = channel
    }

    /// Called by CarPlay's SettingsScreen to notify Flutter about sound changes.
    /// Uses the plugin-level method channel which is always available.
    public static func notifyCarPlaySoundChanged(isSoundEnabled: Bool) {
        DispatchQueue.main.async {
            carPlayChannel?.invokeMethod("soundChanged", arguments: isSoundEnabled)
        }
    }
}
