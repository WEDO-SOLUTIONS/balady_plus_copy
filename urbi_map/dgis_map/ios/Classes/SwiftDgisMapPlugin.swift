import Flutter
import UIKit
import DGis

class DgisPluginApi: NSObject, PluginApi {
    public func initializeMessage(_ message: LogOptionsMessage?, completion: @escaping (FlutterError?) -> Void) {
        SwiftDgisMapPlugin.sdkContext = initializeDGis(logOptions: message?.logOptions)
        completion(nil)
    }
    
    private func initializeDGis(logOptions: LogOptions?) -> DGis.Container {
        let vendorConfigFile = Bundle.main.path(forResource: "vendor-config", ofType: "jsonx").map { File(path: $0) }
        
        return Container(
            logOptions: logOptions ?? LogOptions(
                osLogLevel: .warning,
                customLogLevel: .warning,
                customSink: nil
            ),
            vendorConfigFile: vendorConfigFile
        )
    }
}

public class SwiftDgisMapPlugin: NSObject, FlutterPlugin {
    private static let flutterViewId = "com.dgis.map_view"
    public static var sdkContext: DGis.Container? = nil

    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = DgisMapViewFactory(registrar: registrar)

        registrar.register(factory, withId: self.flutterViewId)
        PluginApiSetup(registrar.messenger(), DgisPluginApi.init())
    }
}
