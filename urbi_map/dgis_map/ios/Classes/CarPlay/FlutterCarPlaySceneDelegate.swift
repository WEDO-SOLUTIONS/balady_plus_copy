import Foundation
import CarPlay
import DGis
import AVFoundation

public class FlutterCarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    static private(set) var map: Map?
    static var delegate: CarPlayConnectionSceneDelegate?
    static var eventChannel: DgisStreamHandler?
    static private var mainScreen: MainScreen?
    
    public static var flutterEngine: FlutterEngine? {
        didSet {
            guard let flutterEngine = flutterEngine else { return }
            api = UrbiAnalyticsFlutterApi(binaryMessenger: flutterEngine.binaryMessenger)
        }
    }
    private static var api: UrbiAnalyticsFlutterApi?
    
    public static func runApp() {
        guard let api = api else { return }
        api.runMain { result in print("========= runApp() \(String(describing: result))") }
    }
    
    public func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController,
        to window: CPWindow
    ) {
        guard let flutterEngine = Self.flutterEngine else { return }
        Bundle.swizzleLocalization()
        Bundle.syncLanguage()

        print("===================== FlutterCarPlaySceneDelegate isRunning")

        let api = UrbiAnalyticsFlutterApi(binaryMessenger: flutterEngine.binaryMessenger)
        
        // TODO(Sergei): load config from Firebase remote config
        DgisMapInitializer.shared.initialize(configMessage: .momrahProd, contentMessage: nil)
        
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        
        guard let mapFactory = try? sdk.makeMapFactory(options: MapOptions.default), let context = try? sdk.context else {
            fatalError("Plugin has not been initialized")
        }
        
        let map = mapFactory.map
        let dgisCarPlayMapView = DgisCarPlayMapView(map: map, mapView: mapFactory.mapView)
        let mainScreen = MainScreen(
            urbiAnalyticsFlutterApi: api,
            map: map,
            interfaceController: interfaceController,
            dgisCarPlayMapView: dgisCarPlayMapView,
            window: window,
            eventProcessor: mapFactory.mapEventProcessor,
            navigationManager: DgisMapInitializer.shared.getNavigationManager(),
            userDefaultsPublished: UserDefaultsPublished(),
            eventChannel: FlutterCarPlaySceneDelegate.eventChannel
        )
        let mapTemplate = mainScreen.createTemplate()
        
        dgisCarPlayMapView.carWindowScreenNativeBounds = templateApplicationScene.carWindow.screen.nativeBounds
        
        interfaceController.setRootTemplate(mapTemplate, animated: true, completion: nil)
        
        Self.delegate?.onConnectionStateChanged(connected: true)
        FlutterCarPlaySceneDelegate.mainScreen = mainScreen
        FlutterCarPlaySceneDelegate.map = map
    }
    
    func viewDidLoad(with map: DGis.Map) {
        FlutterCarPlaySceneDelegate.map = map
    }
    
    public func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didDisconnect interfaceController: CPInterfaceController,
        from window: CPWindow
    ) {
        FlutterCarPlaySceneDelegate.mainScreen = nil
        FlutterCarPlaySceneDelegate.map = nil
        Self.delegate?.onConnectionStateChanged(connected: false)
    }
    
    static func toggleSounds(toggleType: SoundToggleType) {
        self.mainScreen?.toggleSounds(toggleType: toggleType)
    }
}

public protocol CarPlayConnectionSceneDelegate {
    func onConnectionStateChanged(connected: Bool)
}
