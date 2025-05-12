import Foundation
import MapKit
import CarPlay
import DGis

protocol DgisCarPlayMapViewDelegate {
    func viewDidLoad(with map: Map)
}

class DgisCarPlayMapView: UIViewController, CPMapTemplateDelegate {
    static let defaultCameraPositionPoint = CameraPositionPoint(x: 0.5, y: 0.8)
    static let defaultCameraPosition = GeoPoint(latitude: 24.712301, longitude: 46.674175)
    static let defaultCameraZoom = Zoom(value: 17)
    
    var delegate: DgisCarPlayMapViewDelegate?
    
    private var map: Map?
    private var eventProcessor: IMapEventProcessor?
    private var mapView: (UIView & IMapView)?
    
    private var myLocationControlModel: MyLocationControlModel?
    private var zoomControlModel: ZoomControlModel?
    
    private var trafficControlModel: TrafficControlModel?
    var trafficButton: CPBarButton?
    
    private var cancellables = Set<Cancellable>()
    
    var carWindowScreenNativeBounds: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        
        guard let mapFactory = try? sdk.makeMapFactory(options: MapOptions.default), let context = try? sdk.context else {
            fatalError("Plugin has not been initialized")
        }
        
        let map = mapFactory.map
        let mapView = mapFactory.mapView
        self.eventProcessor = mapFactory.mapEventProcessor
        try? map.camera.setPositionPoint(positionPoint: Self.defaultCameraPositionPoint)
        
        myLocationControlModel = MyLocationControlModel(map: map)
        zoomControlModel = ZoomControlModel(map: map)
        trafficControlModel = TrafficControlModel(map: map)
        
        cancellables.insert(
            trafficControlModel!.stateChannel.sink(receiveValue: trafficStateChanged)
        )
        
        map.addSource(source: MyLocationMapObjectSource(
            context: context,
            controllerSettings: MyLocationControllerSettings(
                bearingSource: .auto
            ),
            markerType: .model
        ))
        self.map = map
        
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

        let carPlayFixOn = carWindowScreenNativeBounds?.width == 800
        map.attributes.setAttributeValue(name: "carPlayFixOn", value: .boolean(carPlayFixOn))

        myLocation()
        
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
    
    func mapTemplate(_ mapTemplate: CPMapTemplate, panWith direction: CPMapTemplate.PanDirection) {
        let shiftedPoint = ScreenPoint(x: 0.5, y: 0.5)
        
        var screenShift = ScreenShift(dx: 0, dy: 0)
        if direction == .left {
            screenShift = ScreenShift(dx: -5, dy: 0)
        }
        else if direction == .right {
            screenShift = ScreenShift(dx: 5, dy: 0 )
        }
        else if direction == .up {
            screenShift = ScreenShift(dx: 0, dy: -5)
        }
        else if direction == .down {
            screenShift = ScreenShift(dx: 0, dy: 5)
        }
        
        self.eventProcessor!.process(
            event: DirectMapShiftEvent(
                screenShift: screenShift,
                shiftedPoint: shiftedPoint,
                timestamp: TimeInterval(CACurrentMediaTime())
            )
        )
    }
    
    func mapTemplate(_ mapTemplate: CPMapTemplate, didUpdatePanGestureWithTranslation translation: CGPoint, velocity: CGPoint) {
        self.eventProcessor?.process(
            event: DirectMapShiftEvent(
                screenShift: ScreenShift(
                    dx: Float(translation.x),
                    dy: Float(translation.y)
                ),
                shiftedPoint: ScreenPoint.init(translation),
                timestamp: TimeInterval(CACurrentMediaTime())
            )
        )
    }
    
    func zoomIn() {
        zoomControlModel?.setPressed(button: .zoomIn, value: true)
        zoomControlModel?.setPressed(button: .zoomIn, value: false)
    }
    
    func zoomOut() {
        zoomControlModel?.setPressed(button: .zoomOut, value: true)
        zoomControlModel?.setPressed(button: .zoomOut, value: false)
    }
    
    func trafficClicked() {
        trafficControlModel?.onClicked()
    }
    
    func trafficStateChanged(_ state: TrafficControlState) {
        switch state.status {
        case .enabled, .loading:
            trafficButton?.image = UIImage(named: "TrafficOnNavBar")!.withRenderingMode(.alwaysOriginal)
        default:
            trafficButton?.image = UIImage(named: "TrafficOffNavBar")!.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func myLocation() {
        guard let camera = map?.camera, let myLocationControlModel,
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
