import Flutter
import UIKit
import DGis

class DgisPluginApi: NSObject, PluginApi {

    func initializeMessage(_ message: LogOptionsMessage?, configMessage: VendorConfigMessage, completion: @escaping (FlutterError?) -> Void) {
        initializeDGis(logOptions: message?.logOptions, configMessage: configMessage)
        completion(nil)
    }
    
    private func initializeDGis(logOptions: LogOptions?,configMessage: VendorConfigMessage) {
        let vendorConfigName: String
            switch configMessage {
            case .urbiPreProd:
                vendorConfigName = "urbi-pre-prod-vendor-config"
            case .momrahProd:
                vendorConfigName = "momrah-prod-vendor-config"
            case .momrahStg:
                vendorConfigName = "momrah-staging-vendor-config"
            @unknown default:
                vendorConfigName = "momrah-prod-vendor-config"
            }
        
        let vendorConfigPath = Bundle.main.path(forResource: vendorConfigName, ofType: "jsonx")
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
