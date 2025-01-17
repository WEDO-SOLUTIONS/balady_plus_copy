import Foundation
import CarPlay
import DGis
import AVFoundation

final class FlutterCarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate, DgisCarPlayMapViewDelegate, SwiftDgisMapPluginDelegate {
    static var mapView: DgisCarPlayMapView?
    
    private var carWindow: CPWindow?
    private var interfaceController: CPInterfaceController?
    
    static private var mapTemplate: CPMapTemplate?
    static private var navigationSession: CPNavigationSession?
    static private var trip: CPTrip?
    
    static private(set) var map: Map?
    
    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController,
        to window: CPWindow
    ) {        
        self.carWindow = window
        self.interfaceController = interfaceController
        
        if SwiftDgisMapPlugin.initialized {
            initMapView()
        } else {
            SwiftDgisMapPlugin.delegate = self
        }
    }
    
    func pluginInitialized() {
        initMapView()
    }
    
    func initMapView() {
        let mapTemplate = CPMapTemplate()
        mapTemplate.hidesButtonsWithNavigationBar = false
        FlutterCarPlaySceneDelegate.mapTemplate = mapTemplate
        
        let mapView = DgisCarPlayMapView()
        mapView.delegate = self
        FlutterCarPlaySceneDelegate.mapView = mapView
        
        mapTemplate.mapDelegate = mapView
        self.carWindow?.rootViewController = mapView
        
        self.carWindow?.isUserInteractionEnabled = true
        self.carWindow?.isMultipleTouchEnabled = true
        
        mapTemplate.mapButtons = [
            makeZoomInButton(),
            makeZoomOutButton(),
            makeMyLocationButton()
        ]
        
        mapTemplate.trailingNavigationBarButtons = [
            makePanHeaderButton(),
            makeTrafficButton(),
        ]

        self.interfaceController?.setRootTemplate(mapTemplate, animated: true, completion: nil)
    }
    
    func viewDidLoad(with map: DGis.Map) {
        FlutterCarPlaySceneDelegate.map = map
    }
    
    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didDisconnect interfaceController: CPInterfaceController,
        from window: CPWindow
    ) {
        self.interfaceController = nil
        self.carWindow = nil
        FlutterCarPlaySceneDelegate.map = nil
    }
}

extension FlutterCarPlaySceneDelegate {
    func makeTrafficButton() -> CPBarButton {
        let image = UIImage(named: "TrafficOffNavBar")!.withRenderingMode(.alwaysOriginal)
        let button = CPBarButton(image: image) { _ in
            FlutterCarPlaySceneDelegate.mapView?.trafficClicked()
        }
        FlutterCarPlaySceneDelegate.mapView?.trafficButton = button
        button.isEnabled = true
        
        return button
    }
    
    func makeZoomInButton() -> CPMapButton {
        let button = CPMapButton { _ in
            FlutterCarPlaySceneDelegate.mapView?.zoomIn()
        }
        button.isHidden = false
        button.isEnabled = true
        button.image = UIImage(named: "ZoomIn")!.withRenderingMode(.alwaysOriginal)
        button.focusedImage = UIImage(named: "ZoomIn")!.withRenderingMode(.alwaysOriginal)
        
        return button
    }
    
    func makeZoomOutButton() -> CPMapButton {
        let button = CPMapButton { _ in
            FlutterCarPlaySceneDelegate.mapView?.zoomOut()
        }
        button.isHidden = false
        button.isEnabled = true
        button.image = UIImage(named: "ZoomOut")!.withRenderingMode(.alwaysOriginal)
        button.focusedImage = UIImage(named: "ZoomOut")!.withRenderingMode(.alwaysOriginal)
        
        return button
    }
    
    func makeMyLocationButton() -> CPMapButton {
        let button = CPMapButton { _ in
            FlutterCarPlaySceneDelegate.mapView?.myLocation()
        }
        button.isHidden = false
        button.isEnabled = true
        button.image = UIImage(named: "FollowOn")!.withRenderingMode(.alwaysOriginal)
        button.focusedImage = UIImage(named: "FollowOn")!.withRenderingMode(.alwaysOriginal)
        
        return button
    }
    
    func makeAcceptHeaderButton() -> CPBarButton {
        let button = CPBarButton(title: "Accept") { _ in
            FlutterCarPlaySceneDelegate.mapTemplate?.dismissPanningInterface(animated: true)
            FlutterCarPlaySceneDelegate.mapTemplate?.trailingNavigationBarButtons = [
                self.makePanHeaderButton(),
                self.makeTrafficButton()
            ]
            FlutterCarPlaySceneDelegate.mapTemplate?.leadingNavigationBarButtons = []
        }
        button.isEnabled = true
        
        return button
    }
    
    func makePanHeaderButton() -> CPBarButton {
        let image = UIImage(named: "Pan")!.withRenderingMode(.alwaysOriginal)
        let button = CPBarButton(image: image) { _ in
            FlutterCarPlaySceneDelegate.mapTemplate?.showPanningInterface(animated: true)
            FlutterCarPlaySceneDelegate.mapTemplate?.trailingNavigationBarButtons = [
                self.makeMyLocationHeaderButton()
            ]
            FlutterCarPlaySceneDelegate.mapTemplate?.leadingNavigationBarButtons = [
                self.makeAcceptHeaderButton()
            ]
        }
        button.isEnabled = true
        
        return button
    }
    
    func makeMyLocationHeaderButton() -> CPBarButton {
        let image = UIImage(named: "MyLocation")!.withRenderingMode(.alwaysOriginal)
        let button = CPBarButton(image: image) { _ in
            FlutterCarPlaySceneDelegate.mapView?.myLocation()
        }
        button.isEnabled = true
        
        return button
    }
}

extension FlutterCarPlaySceneDelegate {
    static func startNavigation() {
        if let navigationSession = self.navigationSession {
            navigationSession.cancelTrip()
            self.navigationSession = nil
        }
        
        self.trip = CPTrip(
            origin: MKMapItem(
                placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
            ),
            destination: MKMapItem(
                placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1))
            ),
            routeChoices: []
        )
        self.navigationSession = self.mapTemplate?.startNavigationSession(
            for: self.trip!
        )
    }
    
    static func updateEstimates(distanceRemaining distance: Measurement<UnitLength>, timeRemaining time: TimeInterval) {
        if let trip = self.trip {
            self.mapTemplate?.updateEstimates(
                CPTravelEstimates(
                    distanceRemaining: distance.humanReadable,
                    timeRemaining: time
                ),
                for: trip
            )
        }
    }
    
    static func updateManeuver(
        roadName: String,
        instruction: DGis.InstructionRouteEntry,
        distanceRemaining distance: Measurement<UnitLength>,
        timeRemaining time: TimeInterval
    ) {
        guard let navigationSession else {
            return
        }
        
        let instructionType = getInstructionManeuver(extraInstructionInfo: instruction.value.extraInstructionInfo)
        
        let maneuver = CPManeuver()
        maneuver.instructionVariants = [roadName]
        maneuver.userInfo = instruction
        
        let iconName: String? = switch (instructionType) {
        case .none:
            nil
        case .finish:
            "Road_finish"
        case .start, .crossroadStraight:
            "Crossroad_straight"
        case .crossroadSlightlyLeft:
            "Crossroad_slightly_left"
        case .crossroadLeft:
            "Crossroad_left"
        case .crossroadSharplyLeft:
            "Crossroad_sharply_left"
        case .crossroadSlightlyRight:
            "Crossroad_slightly_right"
        case .crossroadRight:
            "Crossroad_right"
        case .crossroadSharplyRight:
            "Crossroad_sharply_right"
        case .crossroadKeepLeft:
            "Crossroad_keep_left"
        case .crossroadKeepRight:
            "Crossroad_keep_right"
        case .roundaboutForward:
            "Ringroad_forward"
        case .roundaboutLeft45:
            "Ringroad_left_45"
        case .roundaboutLeft90:
            "Ringroad_left_90"
        case .roundaboutLeft135:
            "Ringroad_left_135"
        case .roundaboutRight45:
            "Ringroad_right_45"
        case .roundaboutRight90:
            "Ringroad_right_90"
        case .roundaboutRight135:
            "Ringroad_right_135"
        case .roundaboutBackward:
            "Ringroad_backward"
        case .roundaboutExit:
            "Ringroad_exit"
        case .uTurn, .crossroadUTurn:
            "Turn_over_right_hand"
        case .roadCrossing:
            nil
        @unknown default:
            nil
        }
        
        if let iconName {
            maneuver.symbolImage = UIImage(named: iconName)!
            maneuver.dashboardSymbolImage = UIImage(named: iconName)!
            maneuver.initialTravelEstimates = CPTravelEstimates(
                distanceRemaining: distance.roundedMeters.humanReadable,
                timeRemaining: time
            )
        }
        
        if navigationSession.upcomingManeuvers.first?.userInfo as? InstructionRouteEntry != instruction {
            navigationSession.upcomingManeuvers = [maneuver]
        }
        
        navigationSession.updateEstimates(
            CPTravelEstimates(distanceRemaining: distance.roundedMeters.humanReadable, timeRemaining: time),
            for: navigationSession.upcomingManeuvers.first!
        )
        navigationSession.maneuverState = switch(distance.value) {
        case ...0:
                .continue
        case ...1:
                .execute
        default:
                .initial
        }
    }
    
    static func stopNaviagtion() {
        self.navigationSession?.finishTrip()
        self.navigationSession = nil
    }
}

extension Measurement<UnitLength> {
    var humanReadable: Measurement<UnitLength> {
        var convertedDistance = self.converted(to: .kilometers)
        if convertedDistance.value < 1 {
            convertedDistance = self.converted(to: .meters)
        }
        if convertedDistance.value < 0 {
            convertedDistance.value = 0
        }
        
        return convertedDistance
    }
    
    var roundedMeters: Measurement<UnitLength> {
        let meters = self.converted(to: .meters).value
        
        let roundedMeters = if meters > 200 {
            (meters / 50).rounded(.down) * 50
        } else {
            (meters / 10).rounded(.down) * 10
        }
        
        return Measurement(value: roundedMeters, unit: .meters)
    }
}
