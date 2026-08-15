import Foundation
import CarPlay
import DGis
import AVFoundation

final class FlutterCarPlayDashboardSceneDelegate: UIResponder, CPTemplateApplicationDashboardSceneDelegate, DgisCarPlayMapViewDelegate {

    static private(set) var map: Map?
    static private(set) var mapView: DgisCarPlayDashboardMapView?
    
    func viewDidLoad(with map: DGis.Map) {
        FlutterCarPlayDashboardSceneDelegate.map = map
    }
    
    func templateApplicationDashboardScene(_ templateApplicationDashboardScene: CPTemplateApplicationDashboardScene, didConnect dashboardController: CPDashboardController, to window: UIWindow) {
        // TODO(Sergei): load config from Firebase remote config
        DgisMapInitializer.shared.initialize(configMessage: .momrahProd, contentMessage: nil)
        
        let mapView = DgisCarPlayDashboardMapView(cpWindow: window)
        mapView.delegate = self
        FlutterCarPlayDashboardSceneDelegate.mapView = mapView
        
        let button = CPDashboardButton(titleVariants: [], subtitleVariants: [], image: UIImage(named: "MockImage")!.withRenderingMode(.alwaysOriginal))
        
        dashboardController.shortcutButtons = [button]
        window.rootViewController = mapView
    }
    
    func templateApplicationDashboardScene(
        _ templateApplicationDashboardScene: CPTemplateApplicationDashboardScene,
        didDisconnect dashboardController: CPDashboardController,
        from window: UIWindow) {
        FlutterCarPlayDashboardSceneDelegate.map = nil
        FlutterCarPlayDashboardSceneDelegate.mapView = nil
    }
}
