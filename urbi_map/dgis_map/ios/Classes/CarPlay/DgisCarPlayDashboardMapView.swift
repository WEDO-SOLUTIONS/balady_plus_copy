import Foundation
import MapKit
import DGis

class DgisCarPlayDashboardMapView: UIViewController {
    var delegate: DgisCarPlayMapViewDelegate?
    
    private var map: Map?
    private var mapView: (UIView & IMapView)?
    private var myLocationControlModel: MyLocationControlModel?
    
    private var cancellables = Set<Cancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        
        guard let mapFactory = try? sdk.makeMapFactory(options: MapOptions.default), let context = try? sdk.context else {
            fatalError("Plugin has not been initialized")
        }
        
        let map = mapFactory.map
        let mapView = mapFactory.mapView
        try? map.camera.setPositionPoint(positionPoint: DgisCarPlayMapView.defaultCameraPositionPoint)
        
        myLocationControlModel = MyLocationControlModel(map: map)
        
        map.addSource(source: MyLocationMapObjectSource(
            context: context,
            controllerSettings: MyLocationControllerSettings(
                bearingSource: .auto
            ),
            markerType: .model
        ))
        
        try? map.camera.setPosition(
            point: DgisCarPlayMapView.defaultCameraPosition,
            zoom: Zoom(value: 17)
        )
        myLocationControlModel?.onClicked()
        
        self.map = map
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        self.mapView = mapView
        addSpeedControl()
        self.delegate?.viewDidLoad(with: map)
        
        if let styleFactory = try? sdk.styleFactory, let cancellable = map.loadStyle(styleFactory: styleFactory) {
            cancellables.insert(cancellable)
        }
    }
    
    func addSpeedControl() {
        let model = DgisMapInitializer.shared.getNavigationManager().uiModel
        let navigationViewFactory = (try? DgisMapInitializer.shared.getSdkContainer().makeNavigationViewFactory())?.makeNavigationViewControlsFactory()
        if let speedControl = navigationViewFactory?.makeSpeedControl(uiModel: model) {
            speedControl.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(speedControl)

            speedControl.applyTransform(withScale: 0.6, anchorPoint: CGPoint(x: 0, y: 1))
            NSLayoutConstraint.activate([
                speedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
                speedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            ])
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cancellables.forEach { $0.cancel() }
    }
}
