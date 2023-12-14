import Flutter
import UIKit
import DGis

class DgisPluginApi: NSObject, PluginApi {
    public func initializeMessage(_ message: LogOptionsMessage?, completion: @escaping (FlutterError?) -> Void) {
        initializeDGis(logOptions: message?.logOptions)
        completion(nil)
    }
    
    private func initializeDGis(logOptions: LogOptions?) {
        let vendorConfigPath = Bundle.main.path(forResource: "vendor-config", ofType: "jsonx")
        let vendorConfigFile = vendorConfigPath.map { File(path: $0) }
        let vendorConfig = vendorConfigPath.flatMap(VendorConfig.from)
        
        SwiftDgisMapPlugin.sdkContext = Container(
            logOptions: logOptions ?? LogOptions(
                osLogLevel: .warning,
                customLogLevel: .warning,
                customSink: nil
            ),
            vendorConfigFile: vendorConfigFile
        )
        SwiftDgisMapPlugin.vendorConfig = vendorConfig
    }
}

public class SwiftDgisMapPlugin: NSObject, FlutterPlugin {
    private static let flutterViewId = "com.dgis.map_view"
    public static var sdkContext: DGis.Container? = nil
    public static var vendorConfig: VendorConfig? = nil

    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = DgisMapViewFactory(registrar: registrar)

        registrar.register(factory, withId: self.flutterViewId)
        PluginApiSetup(registrar.messenger(), DgisPluginApi.init())
    }
}
