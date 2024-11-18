import Foundation
import MapKit
import CarPlay
import DGis

protocol DgisCarPlayMapViewDelegate {
    func viewDidLoad(with map: Map)
}

class DgisCarPlayMapView: UIViewController, CPMapTemplateDelegate {
    var delegate: DgisCarPlayMapViewDelegate?
    
    private var map: Map?
    private var eventProcessor: IMapEventProcessor?
    private var mapView: (UIView & IMapView)?
    private var speedControl: UIView?
    
    private var myLocationControlModel: MyLocationControlModel?
    private var zoomControlModel: ZoomControlModel?
    
    private var trafficControlModel: TrafficControlModel?
    var trafficButton: CPMapButton?
    
    private var navigationViewFactory: INavigationViewControlsFactory?
    
    private var cancellables = Set<Cancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let sdk = SwiftDgisMapPlugin.sdkContext else {
            fatalError("Plugin has not been initialized")
        }
        
        guard let mapFactory = try? sdk.makeMapFactory(options: MapOptions.default), let context = try? sdk.context else {
            fatalError("Plugin has not been initialized")
        }
        
        let map = mapFactory.map
        let mapView = mapFactory.mapView
        self.eventProcessor = mapFactory.mapEventProcessor
        try? map.camera.setPositionPoint(positionPoint: CameraPositionPoint(x: 0.5, y: 0.8))
        
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
        
        try? map.camera.setPosition(
            point: GeoPoint(
                latitude: 24.712301, longitude: 46.674175
            ),
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
        
        self.navigationViewFactory = (try? sdk.makeNavigationViewFactory())?.makeNavigationViewControlsFactory()
        
        self.delegate?.viewDidLoad(with: map)
        
        loadStylesAsset("assets/maps/styles/styles.2gis")
    }
    
    func loadStylesAsset(_ asset: String) {
        let assetKey = SwiftDgisMapPlugin.registrar!.lookupKey(forAsset: asset)
        
        guard let assetPath = Bundle.main.path(forResource: assetKey, ofType: nil) else { return }
        
        let styleFuture = try! SwiftDgisMapPlugin.sdkContext!.styleFactory.loadFile(path: assetPath)
        cancellables.insert(
            styleFuture.sink (
                receiveValue: { [map = self.map] style in
                    map?.style = style
                },
                failure: { _ in }
            )
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cancellables.forEach { $0.cancel() }
    }
    
    func addSpeedControl() {
        guard self.speedControl == nil else { return }

        if let model = NavigationHandler.navigationManager?.uiModel, let speedControl = navigationViewFactory?.makeSpeedControl(uiModel: model) {
            self.speedControl = speedControl
            speedControl.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(speedControl)

            speedControl.applyTransform(withScale: 0.6, anchorPoint: CGPoint(x: 0, y: 1))
            
            NSLayoutConstraint.activate([
                speedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
                speedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            ])
        }
    }
    
    func mapTemplate(_ mapTemplate: CPMapTemplate, panWith direction: CPMapTemplate.PanDirection) {
        print("panWith \(direction)")
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
            trafficButton?.image = UIImage(named: "TrafficOn")!.withRenderingMode(.alwaysOriginal)
            trafficButton?.focusedImage = UIImage(named: "TrafficOn")!.withRenderingMode(.alwaysOriginal)
        default:
            trafficButton?.image = UIImage(named: "TrafficOff")!.withRenderingMode(.alwaysOriginal)
            trafficButton?.focusedImage = UIImage(named: "TrafficOff")!.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func myLocation() {
        guard let myLocationControlModel else { return }
        
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
