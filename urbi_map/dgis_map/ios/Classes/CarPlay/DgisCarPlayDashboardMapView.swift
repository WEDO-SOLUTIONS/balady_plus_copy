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
        observeNavigationState()
        DgisMapInitializer.shared.getNavigationManager().mapManager.addMap(map: map)
        self.delegate?.viewDidLoad(with: map)
        
        if let styleFactory = try? sdk.styleFactory, let cancellable = map.loadStyle(styleFactory: styleFactory) {
            cancellables.insert(cancellable)
        }
    }
    
    func myLocation() {
        guard let myLocationControlModel else { return }
        myLocationControlModel.onClicked()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        updateCameraPositionPoint()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCameraPositionPoint()
    }

    private func observeNavigationState() {
        let model = DgisMapInitializer.shared.getNavigationManager().uiModel
        cancellables.insert(
            model.stateChannel.sinkOnMainThread { [weak self] _ in
                self?.updateCameraPositionPoint()
            }
        )
    }

    /// Keeps the car at the default follow point of the safe area, so the system ETA bar does not cover it.
    /// Without a bottom inset the bar is not reported, so a fixed point is used while navigating.
    private func updateCameraPositionPoint() {
        guard let map else { return }
        let bounds = view.bounds
        guard bounds.width > 0, bounds.height > 0 else { return }

        let insets = view.safeAreaInsets
        let safeArea = bounds.inset(by: insets)
        let defaultY = CGFloat(DgisCarPlayMapView.defaultCameraPositionPoint.y)
        var y = Float((safeArea.minY + defaultY * safeArea.height) / bounds.height)

        let state = DgisMapInitializer.shared.getNavigationManager().uiModel.state
        if insets.bottom == 0 && (state == .navigation || state == .routeSearch) {
            y = min(y, DgisCarPlayMapView.dashboardNavigationFallbackPositionY)
        }

        let point = CameraPositionPoint(x: Float(safeArea.midX / bounds.width), y: y)
        guard point != map.camera.positionPoint else { return }
        try? map.camera.setPositionPoint(positionPoint: point)
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
    }
}
