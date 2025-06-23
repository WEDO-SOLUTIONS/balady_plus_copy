import Foundation
import CarPlay
import DGis
import AVFoundation

final class FlutterCarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    static private(set) var map: Map?
    static var delegate: CarPlayConnectionSceneDelegate?
    private var mainScreen: MainScreen?
    
    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController,
        to window: CPWindow
    ) {
        Bundle.swizzleLocalization()
        Bundle.syncLanguage()
        
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
            interfaceController: interfaceController,
            dgisCarPlayMapView: dgisCarPlayMapView,
            window: window,
            eventProcessor: mapFactory.mapEventProcessor,
            navigationManager: DgisMapInitializer.shared.getNavigationManager(),
            userDefaultsPublished: UserDefaultsPublished()
        )
        let mapTemplate = mainScreen.createTemplate()
        
        dgisCarPlayMapView.carWindowScreenNativeBounds = templateApplicationScene.carWindow.screen.nativeBounds
        
        interfaceController.setRootTemplate(mapTemplate, animated: true, completion: nil)
        
        Self.delegate?.onConnectionStateChanged(connected: true)
        self.mainScreen = mainScreen
        FlutterCarPlaySceneDelegate.map = map
    }
    
    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didDisconnect interfaceController: CPInterfaceController,
        from window: CPWindow
    ) {
        self.mainScreen = nil
        FlutterCarPlaySceneDelegate.map = nil
        Self.delegate?.onConnectionStateChanged(connected: false)
    }
}

public protocol CarPlayConnectionSceneDelegate {
    func onConnectionStateChanged(connected: Bool)
}
