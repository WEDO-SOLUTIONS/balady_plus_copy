import Foundation
import MapKit
import DGis

class DgisCarPlayDashboardMapView: UIViewController {
    var delegate: DgisCarPlayMapViewDelegate?
    
    private var map: Map?
    private var mapView: (UIView & IMapView)?
    private var myLocationControlModel: MyLocationControlModel?
    private var myLocationSource: MyLocationMapObjectSource?
    
    private var cancellables = Set<Cancellable>()
    
    private var mapAppearance: CarPlayMapAppearance?
    private var prefersDarkMapContent = false

    private var tunnelDetector: TunnelDetector?
    private var isInTunnel = false

    /// Dashboard window — kept for its screen scale, see `MapOptions.carScreen`.
    private let cpWindow: UIWindow

    init(cpWindow: UIWindow) {
        self.cpWindow = cpWindow
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        
        // HB-57: the dashboard is a car screen too — same density fix as the
        // main CarPlay map.
        guard let mapFactory = try? sdk.makeMapFactory(options: .carScreen(for: cpWindow)),
              let context = try? sdk.context else {
            fatalError("Plugin has not been initialized")
        }
        
        let map = mapFactory.map
        let mapView = mapFactory.mapView
        try? map.camera.setPositionPoint(positionPoint: DgisCarPlayMapView.defaultCameraPositionPoint)
        
        myLocationControlModel = MyLocationControlModel(map: map)
        
        let myLocationSource = MyLocationMapObjectSource(
            context: context,
            controllerSettings: MyLocationControllerSettings(
                bearingSource: .auto
            ),
            markerType: .model
        )
        self.myLocationSource = myLocationSource
        map.addSource(source: myLocationSource)
        
        if let location = try? sdk.locationService.lastLocation?.coordinates {
            try? map.camera.setPosition(
                point: location.value,
                zoom: Zoom(value: 17)
            )
        } else {
            try? map.camera.setPosition(
                point: DgisCarPlayMapView.defaultCameraPosition,
                zoom: Zoom(value: 17)
            )
        }
        myLocation()
        
        let pos = map.camera.position
        cancellables.insert(
            map.camera.move(
                point: pos.point,
                zoom: pos.zoom,
                tilt: Tilt(value: 45),
                bearing: pos.bearing
            ).sink(
                receiveValue: { _ in },
                failure: { _ in }
            )
        )
        
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
        DgisMapInitializer.shared.getNavigationManager().mapManager.addMap(map: map)
        self.delegate?.viewDidLoad(with: map)
        
        if let styleFactory = try? sdk.styleFactory, let cancellable = map.loadStyle(styleFactory: styleFactory) {
            cancellables.insert(cancellable)
        }

        observeMapAppearance()
    }
    
    func myLocation() {
        guard let myLocationControlModel else { return }
        myLocationControlModel.onClicked()
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
        if let map = self.map {
            if let myLocationSource = self.myLocationSource {
                map.removeSource(source: myLocationSource)
                self.myLocationSource = nil
            }
            
            DgisMapInitializer.shared.getNavigationManager().mapManager.removeMap(map: map)
            self.map = nil
        }
        mapView?.subviews.forEach { $0.removeFromSuperview() }
        mapView = nil
        myLocationControlModel = nil
        cancellables.forEach { $0.cancel() }
        mapAppearance = nil
        tunnelDetector?.cancel()
        tunnelDetector = nil
    }

    // MARK: - Day/night appearance

    /// The dashboard map follows the same CarPlay content style as the main car map, and
    /// darkens inside tunnels for the same reason.
    private func observeMapAppearance() {
        mapAppearance = CarPlayMapAppearance { [weak self] prefersDark in
            guard let self else { return }

            self.prefersDarkMapContent = prefersDark
            self.applyMapAppearance()
        }

        let navigationModel = DgisMapInitializer.shared.getNavigationManager().uiModel
        tunnelDetector = TunnelDetector(model: navigationModel) { [weak self] isInTunnel in
            guard let self else { return }

            self.isInTunnel = isInTunnel
            self.applyMapAppearance()
        }
    }

    private func applyMapAppearance() {
        let isNight = prefersDarkMapContent || isInTunnel
        mapView?.appearance = isNight ? .universal("night") : .universal("day")
    }
}
