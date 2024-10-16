import Flutter
import UIKit
import DGis

class DgisPluginApi: NSObject, PluginApi {
    var registrar: FlutterPluginRegistrar
    
    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
    }

    func initializeMessage(_ message: LogOptionsMessage?, configMessage: VendorConfigMessage, completion: @escaping (FlutterError?) -> Void) {
        initializeDGis(logOptions: message?.logOptions, configMessage: configMessage)
        completion(nil)
    }
    
    private func initializeDGis(logOptions: LogOptions?, configMessage: VendorConfigMessage) {
        let vendorConfigName: String
            switch configMessage {
            case .urbiPreProd:
                vendorConfigName = "assets/maps/configs/urbi-pre-prod-vendor-config.jsonx"
            case .momrahProd:
                vendorConfigName = "assets/maps/configs/momrah-prod-vendor-config.jsonx"
            case .momrahStg:
                vendorConfigName = "assets/maps/configs/momrah-staging-vendor-config.jsonx"
            @unknown default:
                vendorConfigName = "assets/maps/configs/momrah-prod-vendor-config.jsonx"
            }
        let vendorResource = registrar.lookupKey(forAsset: vendorConfigName)
        let vendorConfigPath = Bundle.main.path(forResource: vendorResource, ofType: nil)
        
        let vendorConfigFile = vendorConfigPath.map { File(path: $0) }
        let vendorConfig = vendorConfigPath.flatMap(VendorConfig.from)
        
        
        SwiftDgisMapPlugin.sdkContext = Container(
            logOptions: logOptions ?? LogOptions(
                systemLevel: .warning,
                customLevel: .warning,
                customSink: nil
            ),
            httpOptions: HttpOptions(useCache: true),
            vendorConfig: DGis.VendorConfig.fromFile(VendorConfigFromFile(path: vendorConfigPath ?? ""))
        )
        SwiftDgisMapPlugin.vendorConfig = vendorConfig
        SwiftDgisMapPlugin.initialized = true
        SwiftDgisMapPlugin.delegate?.pluginInitialized()
    }
}

public class SwiftDgisMapPlugin: NSObject, FlutterPlugin {
    private static let flutterViewId = "com.dgis.map_view"
    public static var sdkContext: DGis.Container? = nil
    public static var vendorConfig: VendorConfig? = nil

    public static var initialized: Bool = false
    public static var delegate: SwiftDgisMapPluginDelegate?
    public static var registrar: FlutterPluginRegistrar?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = DgisMapViewFactory(registrar: registrar)

        registrar.register(factory, withId: self.flutterViewId)
        PluginApiSetup(registrar.messenger(), DgisPluginApi.init(registrar: registrar))
        self.registrar = registrar
    }
}

public protocol SwiftDgisMapPluginDelegate {
    func pluginInitialized()
}
