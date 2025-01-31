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

    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = DgisMapViewFactory(registrar: registrar)

        registrar.register(factory, withId: self.flutterViewId)
        PluginApiSetup.setUp(binaryMessenger: registrar.messenger(), api: DgisPluginApi.init(registrar: registrar))
        self.registrar = registrar
    }
}
