import Flutter
import UIKit
import DGis

class DgisPluginApi: NSObject, PluginApi {
    func initializeMessage(_ message: LogOptionsMessage?, configMessage configMessageBoxed: VendorConfigMessageBox?) async -> FlutterError? {
        return nil;
    }
    
    
    var registrar: FlutterPluginRegistrar
    
    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
    }

    func initializeMessage(_ message: LogOptionsMessage?, configMessage: VendorConfigMessage,
                           contentMessage: VendorConfigContentMessage?,
                           completion: @escaping (FlutterError?) -> Void) {
        initializeDGis(logOptions: message?.logOptions, configMessage: configMessage,contentMessage: contentMessage)
        completion(nil)
    }
    
    private func initializeDGis(logOptions: LogOptions?, configMessage: VendorConfigMessage,contentMessage: VendorConfigContentMessage?) {
        
        let sdkVendorConfig: DGis.VendorConfig
        let vendorConfig: VendorConfig?
         if let contentMessage = contentMessage, !contentMessage.content.isEmpty {
             // Инициализация vendorConfig из contentMessage
             sdkVendorConfig = DGis.VendorConfig.fromString(VendorConfigFromString(contents: contentMessage.content))
             vendorConfig = nil
         } else {
             // Инициализация vendorConfig из configMessage
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
             vendorConfig = vendorConfigPath.flatMap(VendorConfig.fromFile)
             
            let vendorConfigFile = vendorConfigPath.map { File(path: $0) }
            
            sdkVendorConfig = DGis.VendorConfig.fromFile(VendorConfigFromFile(path: vendorConfigPath ?? ""))

         }

        SwiftDgisMapPlugin.sdkContext = Container(
            logOptions: logOptions ?? LogOptions(
                systemLevel: .warning,
                customLevel: .warning,
                customSink: nil
            ),
            httpOptions: HttpOptions(useCache: true),
            vendorConfig: sdkVendorConfig
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
        SetUpPluginApi(registrar.messenger(), DgisPluginApi.init(registrar: registrar))
        self.registrar = registrar
    }
}

public protocol SwiftDgisMapPluginDelegate {
    func pluginInitialized()
}
