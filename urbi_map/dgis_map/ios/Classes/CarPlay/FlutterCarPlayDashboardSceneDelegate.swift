import Foundation
import CarPlay
import DGis
import AVFoundation

final class FlutterCarPlayDashboardSceneDelegate: UIResponder, CPTemplateApplicationDashboardSceneDelegate, DgisCarPlayMapViewDelegate {

    static private(set) var map: Map?
    
    func viewDidLoad(with map: DGis.Map) {
        FlutterCarPlayDashboardSceneDelegate.map = map
    }
    
    func templateApplicationDashboardScene(_ templateApplicationDashboardScene: CPTemplateApplicationDashboardScene, didConnect dashboardController: CPDashboardController, to window: UIWindow) {
        DgisMapInitializer.shared.initialize(configMessage: .momrahProd, contentMessage: nil)
        
        let mapView = DgisCarPlayDashboardMapView()
        mapView.delegate = self
        
        let button = CPDashboardButton(titleVariants: [], subtitleVariants: [], image: UIImage(named: "MockImage")!.withRenderingMode(.alwaysOriginal))
        
        dashboardController.shortcutButtons = [button]
        window.rootViewController = mapView
    }
    
    func templateApplicationDashboardScene(
        _ templateApplicationDashboardScene: CPTemplateApplicationDashboardScene,
        didDisconnect dashboardController: CPDashboardController,
        from window: UIWindow) {
        FlutterCarPlayDashboardSceneDelegate.map = nil
    }
}
