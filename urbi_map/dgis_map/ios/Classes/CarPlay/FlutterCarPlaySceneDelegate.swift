import Foundation
import CarPlay
import DGis
import AVFoundation

final class FlutterCarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate, DgisCarPlayMapViewDelegate {
    static var mapView: DgisCarPlayMapView?
    
    static private var mapTemplate: CPMapTemplate?
    static private var navigationSession: CPNavigationSession?
    static private let trip = CPTrip(
        origin: MKMapItem(
            placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        ),
        destination: MKMapItem(
            placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1))
        ),
        routeChoices: []
    )
    private static var currentManeuver: CarPlayManeuver?
    private static var currentEstimates: CarPlayEstimates?
    
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
            userDefaultsPublished: UserDefaultsPublished()
        )
        let mapTemplate = mainScreen.createTemplate()
        
        FlutterCarPlaySceneDelegate.mapTemplate = mapTemplate
        
        dgisCarPlayMapView.carWindowScreenNativeBounds = templateApplicationScene.carWindow.screen.nativeBounds
        dgisCarPlayMapView.delegate = self
        FlutterCarPlaySceneDelegate.mapView = dgisCarPlayMapView
        
        interfaceController.setRootTemplate(mapTemplate, animated: true, completion: nil)
        
        Self.delegate?.onConnectionStateChanged(connected: true)
        self.mainScreen = mainScreen
    }
    
    func viewDidLoad(with map: DGis.Map) {
        FlutterCarPlaySceneDelegate.map = map
        
        let uiModel = DgisMapInitializer.shared.getNavigationManager().uiModel
        let isNavigationState = uiModel.state == .navigation || uiModel.state == .routeSearch
        let routeBuildOptions = uiModel.route.routeBuildOptions
        let isRouteNavigation = isNavigationState && routeBuildOptions != nil
        let isFreeRoam = isNavigationState && routeBuildOptions == nil
        
        if isRouteNavigation {
            Self.startNavigation()
            if let maneuver = Self.currentManeuver {
                Self.updateManeuver(maneuver)
            }
            if let estimates = Self.currentEstimates {
                Self.updateEstimates(estimates)
            }
        } else if !isFreeRoam {
            try? DgisMapInitializer.shared.getNavigationManager().start()
            map.attributes.setAttributeValue(name: "navigatorOn", value: .boolean(true))
        }
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

extension FlutterCarPlaySceneDelegate {
    static func startNavigation() {
        guard let map else {
            return
        }
        
        if let navigationSession = self.navigationSession {
            navigationSession.cancelTrip()
            self.navigationSession = nil
        }
        
        self.navigationSession = self.mapTemplate?.startNavigationSession(
            for: self.trip
        )
    }
    
    static func updateEstimates(_ estimates: CarPlayEstimates) {
        currentEstimates = estimates
        guard let map else {
            return
        }
        
        self.mapTemplate?.updateEstimates(
            CPTravelEstimates(
                distanceRemaining: estimates.distanceRemaining.humanReadable,
                timeRemaining: estimates.timeRemaining
            ),
            for: self.trip
        )
    }
    
    static func updateManeuver(_ maneuver: CarPlayManeuver) {
        currentManeuver = maneuver
        guard let map else {
            return
        }
        
        guard let navigationSession else {
            return
        }
        
        let roadName = maneuver.roadName
        let instruction = maneuver.instruction
        let distance = maneuver.distanceRemaining
        let time = maneuver.timeRemaining
        
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
        if #available(iOS 17.4, *) {
            navigationSession.maneuverState = switch(distance.value) {
            case ...0:
                    .continue
            case ...1:
                    .execute
            default:
                    .initial
            }
        }
    }
    
    static func stopNavigation() {
        Self.currentManeuver = nil
        Self.currentEstimates = nil
        self.navigationSession?.finishTrip()
        self.navigationSession = nil
        
        if mapView != nil || FlutterCarPlayDashboardSceneDelegate.mapView != nil {
            // await for following to be disabled in SDK when navigation is stopped
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                mapView?.myLocation()
                FlutterCarPlayDashboardSceneDelegate.mapView?.myLocation()
            }
        }
    }
}

public protocol CarPlayConnectionSceneDelegate {
    func onConnectionStateChanged(connected: Bool)
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
