import Foundation
import MapKit
import CarPlay
import DGis

protocol DgisCarPlayMapViewDelegate {
    func viewDidLoad(with map: Map)
}

class DgisCarPlayMapView: UIViewController {
    static let defaultCameraPositionPoint = CameraPositionPoint(x: 0.5, y: 0.8)
    static let defaultCameraPosition = GeoPoint(latitude: 24.712301, longitude: 46.674175)
    static let defaultCameraZoom = Zoom(value: 17)
    
    private let map: Map
    private let mapView: (UIView & IMapView)
    
    private var myLocationControlModel: MyLocationControlModel?
    private var myLocationSource: MyLocationMapObjectSource?
    
    private var cancellables = Set<Cancellable>()
    
    init(
        map: Map,
        mapView: (UIView & IMapView)
    ) {
        self.map = map
        self.mapView = mapView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        
        guard let context = try? sdk.context else {
            fatalError("Plugin has not been initialized")
        }

        try? map.camera.setPositionPoint(positionPoint: Self.defaultCameraPositionPoint)
        
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
                zoom: Self.defaultCameraZoom
            )
        } else {
            try? map.camera.setPosition(
                point: Self.defaultCameraPosition,
                zoom: Self.defaultCameraZoom
            )
        }
        
        map.attributes.setAttributeValue(name: "camerasOn", value: .boolean(true))

        myLocation()
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        addSpeedControl()
        DgisMapInitializer.shared.getNavigationManager().mapManager.addMap(map: map)
        
        if let styleFactory = try? sdk.styleFactory, let cancellable = map.loadStyle(styleFactory: styleFactory) {
            cancellables.insert(cancellable)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DgisMapInitializer.shared.getNavigationManager().mapManager.removeMap(map: map)
        mapView.subviews.forEach { $0.removeFromSuperview() }
        if let myLocationSource = self.myLocationSource {
            map.removeSource(source: myLocationSource)
            self.myLocationSource = nil
        }
        myLocationControlModel = nil
        cancellables.forEach { $0.cancel() }
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

    func myLocation() {
        let camera = map.camera
        guard let myLocationControlModel,
              let myLocation = try? DgisMapInitializer.shared.getSdkContainer().locationService.lastLocation?.coordinates else {
            return
        }
        
        let position = camera.position
        if position.zoom.value > Self.defaultCameraZoom.value - 1 {
            myLocationControlModel.onClicked()
            return
        }
        
        let navigationManager = DgisMapInitializer.shared.getNavigationManager()
        let navigationState = navigationManager.uiModel.state
        if navigationState == .navigation || navigationState == .routeSearch {
            cancellables.insert(
                camera.move(
                    point: myLocation.value,
                    zoom: Self.defaultCameraZoom,
                    tilt: position.tilt,
                    bearing: position.bearing
                ).sink(
                    receiveValue: { _ in
                        navigationManager.mapFollowController.setFollow(follow: true)
                    },
                    failure: { _ in }
                )
            )
            return
        }
        
        cancellables.insert(
            camera.move(
                point: myLocation.value,
                zoom: Self.defaultCameraZoom,
                tilt: position.tilt,
                bearing: position.bearing
            ).sink(
                receiveValue: { _ in },
                failure: { _ in }
            )
        )
        myLocationControlModel.onClicked()
    }
}

extension UIView {
    func applyTransform(withScale scale: CGFloat, anchorPoint: CGPoint) {
        layer.anchorPoint = anchorPoint
        let scale = scale != 0 ? scale : CGFloat.leastNonzeroMagnitude
        let xPadding = 1/scale * (anchorPoint.x - 0.5)*bounds.width
        let yPadding = 1/scale * (anchorPoint.y - 0.5)*bounds.height
        transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xPadding, y: yPadding)
    }
}

extension Map {
    func loadStyle(styleFactory: DGis.IStyleFactory) -> DGis.Cancellable? {
        let stylePath = FlutterDartProject.lookupKey(forAsset: "packages/map_styles/src/styles.2gis")
        guard let assetPath = Bundle.main.path(forResource: stylePath, ofType: nil) else { return nil }
        return styleFactory.loadFile(path: assetPath).sink(
            receiveValue: { style in
                self.style = style
            },
            failure: { _ in }
        )
    }
}
