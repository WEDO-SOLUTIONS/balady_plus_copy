import Foundation
import DGis

/// Initializer for DGis initialization and sharing instances between main app and CarPlay
class DgisMapInitializer {
    static let shared = DgisMapInitializer()
    
    private init() {}
    
    private var sdkContainer: DGis.Container?
    
    private var navigationManager: NavigationManager?
    
    func initialize(logOptions: LogOptions? = nil, configMessage: VendorConfigMessage? ,contentMessage: VendorConfigContentMessage?) {
        if sdkContainer != nil {
            // SDK has already been initialized
            return
        }
        let sdkVendorConfig: DGis.VendorConfig
        if let contentMessage = contentMessage, !contentMessage.content.isEmpty {
            // vendorConfig from contentMessage
            sdkVendorConfig = DGis.VendorConfig.fromString(VendorConfigFromString(contents: contentMessage.content))
        } else {
            // vendorConfig from configMessage
            let vendorConfigName: String
            switch configMessage {
            case .urbiPreProd:
                vendorConfigName = "urbi-pre-prod-vendor-config.jsonx"
            case .momrahProd:
                vendorConfigName = "momrah-prod-vendor-config.jsonx"
            case .momrahStg:
                vendorConfigName = "momrah-staging-vendor-config.jsonx"
            case .none:
                vendorConfigName = "momrah-prod-vendor-config.jsonx"
            }
            let vendorConfigPath = Bundle.main.path(forResource: "Frameworks/App.framework/flutter_assets/assets/maps/configs/" + vendorConfigName, ofType: nil)
            
            let vendorConfigFile = vendorConfigPath.map { File(path: $0) }
            
            sdkVendorConfig = DGis.VendorConfig.fromFile(VendorConfigFromFile(path: vendorConfigPath ?? ""))
        }
        
        sdkContainer = Container(
            logOptions: logOptions ?? LogOptions(
                systemLevel: .warning,
                customLevel: .warning,
                customSink: nil
            ),
            httpOptions: HttpOptions(useCache: true),
            // Keeps guidance (and the lock screen Live Activity) alive with the
            // screen off — see BackgroundLocationProvider.
            locationProvider: BackgroundLocationProvider(),
            vendorConfig: sdkVendorConfig
        )
    }
    
    func getSdkContainer() -> DGis.Container {
        if sdkContainer == nil {
            fatalError("SDK has not been initialized")
        }
        return sdkContainer!
    }
    
    func getNavigationManager() -> NavigationManager {
        if navigationManager == nil {
            navigationManager = try! NavigationManager(platformContext: getSdkContainer().context)
            navigationManager!.alternativeRoutesProviderSettings.alternativeRoutesEnabled = false
            navigationManager!.routeSourceSettings.calloutVisualizationMode = .multipleRoutes
            navigationManager!.alternativeRoutesProviderSettings.routeSearchDelay = TimeInterval(20)
            navigationManager!.alternativeRoutesProviderSettings.betterRouteTimeCostThreshold = TimeInterval(2 * 60)
            navigationManager!.alternativeRoutesProviderSettings.betterRouteLengthThreshold = RouteDistance(millimeters: 500 * 1000)
            navigationManager!.routeMapSettings.onRouteDisplayFlags.insert(.immersiveRouteParts)

            // Apply persisted sound setting immediately when NavigationManager is created.
            // The SDK enables all sound categories by default. We read from Flutter's
            // SharedPreferences and default to OFF if the key is not set.
            let voiceKey = "flutter.voice_instruction_index"
            let hasKey = UserDefaults.standard.object(forKey: voiceKey) != nil
            let voiceIndex = hasKey ? UserDefaults.standard.integer(forKey: voiceKey) : 0
            if voiceIndex == 0 {
                navigationManager!.soundNotificationSettings.enabledSoundCategories = []
            }
        }
        return navigationManager!
    }
}
