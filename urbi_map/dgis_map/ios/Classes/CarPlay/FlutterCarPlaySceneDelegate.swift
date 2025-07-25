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
            hostFlutterApi = HostFlutterApi(binaryMessenger: flutterEngine.binaryMessenger)
        }
    }
    private static var hostFlutterApi: HostFlutterApi?
    
    public static func runApp() {
        guard let api = hostFlutterApi else { return }
        api.runMain { _ in  }
    }
    
    private static var sentCarPlayStart = false
    
    public func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController,
        to window: CPWindow
    ) {
        guard let hostFlutterApi = Self.hostFlutterApi else { return }
        
        if (!Self.sentCarPlayStart) {
            hostFlutterApi.analyticsTrack(event: "car_play_start") { _ in }
            Self.sentCarPlayStart = true
        }

        // TODO(Sergei): load config from Firebase remote config
        DgisMapInitializer.shared.initialize(configMessage: .momrahProd, contentMessage: nil)
        
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        
        guard let mapFactory = try? sdk.makeMapFactory(options: MapOptions.default), let context = try? sdk.context else {
            fatalError("Plugin has not been initialized")
        }
        
        let map = mapFactory.map
        let dgisCarPlayMapView = DgisCarPlayMapView(map: map, mapView: mapFactory.mapView)
        let mainScreen = MainScreen(
            map: map,
            container: sdk,
            interfaceController: interfaceController,
            dgisCarPlayMapView: dgisCarPlayMapView,
            window: window,
            eventProcessor: mapFactory.mapEventProcessor,
            navigationManager: DgisMapInitializer.shared.getNavigationManager(),
            userDefaultsPublished: UserDefaultsPublished(),
            eventChannel: FlutterCarPlaySceneDelegate.eventChannel,
            hostFlutterApi: hostFlutterApi
        )
        let mapTemplate = mainScreen.createTemplate()
        
        let carPlayFixOn = templateApplicationScene.carWindow.screen.nativeBounds.width == 800
        map.attributes.setAttributeValue(name: "carPlayFixOn", value: .boolean(carPlayFixOn))
        
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
        Self.mainScreen?.dispose()
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
