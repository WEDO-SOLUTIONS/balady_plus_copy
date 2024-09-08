import DGis
import Foundation

class NavigationHandler {
    private class Events {
        // event name
        static let navigationEvent = "navigationEvent"
        static let routeOptionsEvent = "routeOptionsEvent"
        static let betterRouteEvent = "betterRouteEvent"

        // event values
        static let stateFinished = "finished"
        static let stateDisabled = "disabled"
    }
    
    private let map: Map
    private let context: Context
    private let eventChannel: DgisStreamHandler
    
    public static var navigationManager: NavigationManager?
    
    private let voiceManager: VoiceManager
    
    private var prevCameraBehaviour: CameraBehaviour?
    
    private var cancelable: Array<Cancellable> = []
    private var moveCameraCancellable: DGis.Cancellable?
    
    // Models to observe channels and send events to Flutter
    private let speedControlModel: SpeedControlModel
    private let dashboardControlModel: DashboardControlModel
    private let messageControlModel: MessageControlModel
    private let maneuverControlModel: ManeuverControlModel
    
    private(set) var isNavigating: Bool = false

    init(map: Map, mapView: UIView & IMapView, sdk: Container, eventChannel: DgisStreamHandler, view: UIView) {
        let context = try! sdk.context
        self.map = map

        self.eventChannel = eventChannel
        NavigationHandler.navigationManager = try! NavigationManager(platformContext: context)
        NavigationHandler.navigationManager.alternativeRoutesProviderSettings.alternativeRoutesEnabled = false
        NavigationHandler.navigationManager.routeSourceSettings.calloutVisualizationMode = .multipleRoutes
        NavigationHandler.navigationManager.routeMapSettings.onRouteDisplayFlags.insert(.immersiveRouteParts)
        
        self.voiceManager = getVoiceManager(context: context)

        self.speedControlModel = SpeedControlModel(
            model: NavigationHandler.navigationManager!.uiModel,
            eventChannel: eventChannel
        )

        self.dashboardControlModel = DashboardControlModel(
            model: NavigationHandler.navigationManager!.uiModel,
            eventChannel: self.eventChannel,
            navigationManager: NavigationHandler.navigationManager!
        )

        self.messageControlModel = MessageControlModel(
            model: NavigationHandler.navigationManager!.uiModel,
            eventChannel: eventChannel
        )

        self.maneuverControlModel = ManeuverControlModel(
            model: NavigationHandler.navigationManager!.uiModel,
            eventChannel: self.eventChannel
        )

        self.cancelable.append(
            NavigationHandler.navigationManager!.uiModel.stateChannel.sink(receiveValue: stateChannelListener)
        )

        self.cancelable.append(
            NavigationHandler.navigationManager!.uiModel.routeChannel.sink(receiveValue: routeInfoListener)
        )
        
        self.cancelable.append(
            NavigationHandler.navigationManager!.uiModel.betterRouteChannel.sink(receiveValue: betterRouteListener)
        )
        
        if let carMapView = FlutterCarPlaySceneDelegate.mapView {
            carMapView.addSpeedControl()
        }
    }
    
    private func stateChannelListener(_ state: State) {
        switch (state) {
        case State.disabled:
            self.eventChannel.success([
                "event": Events.navigationEvent,
                "state": Events.stateDisabled
            ])
            self.isNavigating = false
        case State.finished:
            self.eventChannel.success([
                "event": Events.navigationEvent,
                "state": Events.stateFinished
            ])
            self.isNavigating = false
            stopNavigation()
        case State.navigation:
            self.isNavigating = true
        case State.routeSearch:
            self.isNavigating = true
        }
    }
    
    func onRouteTap(_ route: RouteMapObject) {
        let trafficRoute = route.route
        if !route.isActive {
            NavigationHandler.navigationManager!.alternativeRouteSelector.selectAlternativeRoute(trafficRoute: trafficRoute)
            betterRouteResponse(response: .accept)
        }
    }
    
    private func routeInfoListener(_ routeInfo: RouteInfo) {
        self.eventChannel.success([
            "event": Events.routeOptionsEvent,
            "hasOptions": routeInfo.routeBuildOptions != nil
        ])
    }
    
    private func betterRouteListener(_ routeInfo: BetterRouteInfo?) {
        let activeRouteDuration = NavigationHandler.navigationManager!.uiModel.duration
        var betterRouteDuration: TimeInterval? = nil
        let durationProfit: Int
        if let first = routeInfo?.trafficRoute.route.geometry.first {
            betterRouteDuration = routeInfo!.trafficRoute.traffic.durations.calculateDuration(routePoint: first.point).rounded()
        }
        if let activeRouteDuration = activeRouteDuration, let betterRouteDuration = betterRouteDuration {
            durationProfit = Int(activeRouteDuration - betterRouteDuration)
        } else {
            durationProfit = 0
        }
        self.eventChannel.success([
            "event": Events.betterRouteEvent,
            "route": routeInfo != nil ? RouteHandler.mapRouteInfo(routeInfo!.trafficRoute) : nil,
            "durationProfit": durationProfit
        ])
    }
    
    func betterRouteResponse(response: BetterRouteResponseMessage) {
        switch response {
        case .accept:
            NavigationHandler.navigationManager!.uiModel.betterRouteResponse(response: .accept)
        case .reject:
            NavigationHandler.navigationManager!.uiModel.betterRouteResponse(response: .reject)
        case .timeout:
            NavigationHandler.navigationManager!.uiModel.betterRouteResponse(response: .timeout)
        }
    }
    
    func getBetterRouteSettings(completion: @escaping (BetterRouteSettingsMessage?, FlutterError?) -> Void) {
        let settings = NavigationHandler.navigationManager!.alternativeRoutesProviderSettings
        completion(
            BetterRouteSettingsMessage.make(
                withBetterRouteTimeCostThreshold: NSNumber(value: Int(settings.betterRouteTimeCostThreshold)),
                betterRouteLengthThreshold: NSNumber(value: settings.betterRouteLengthThreshold.millimeters),
                routeSearchDelay: NSNumber(value: Int(settings.routeSearchDelay))
            ),
            nil
        )
    }
    
    func setBetterRouteSettings(settings: BetterRouteSettingsMessage) {
        NavigationHandler.navigationManager!.alternativeRoutesProviderSettings.routeSearchDelay = settings.routeSearchDelay.doubleValue
        NavigationHandler.navigationManager!.alternativeRoutesProviderSettings.betterRouteTimeCostThreshold = settings.betterRouteTimeCostThreshold.doubleValue
        NavigationHandler.navigationManager!.alternativeRoutesProviderSettings.betterRouteLengthThreshold = RouteDistance(millimeters: settings.betterRouteLengthThreshold.int64Value)
    }

    func cancel() {
        cancelable.forEach { $0.cancel() }
        moveCameraCancellable?.cancel()
        cancelable.removeAll()
        self.dashboardControlModel.cancel()
        self.speedControlModel.cancel()
        self.messageControlModel.cancel()
        self.maneuverControlModel.cancel()
    }
    
    func setupCamera(speedRangeZoom: SpeedRangeZoom) {
        setupCamera(map: self.map, speedRangeZoom: speedRangeZoom)

        if let carPlayMap = FlutterCarPlaySceneDelegate.map {
            setupCamera(map: carPlayMap, speedRangeZoom: speedRangeZoom)
        }
    }
    
    func setupCamera(
        map: Map,
        speedRangeZoom: SpeedRangeZoom
    ) {
        self.prevCameraBehaviour = map.camera.behaviour.newBehaviour
        map.camera.setBehaviour(
            behaviour: NavigationHandler.navigationManager!.mapFollowController.cameraBehaviour
        )
        
        NavigationHandler.navigationManager!.mapFollowController.setFollow(follow: true)
        NavigationHandler.navigationManager!.zoomFollowSettings.speedRangeToStyleZoomSequence = [
            SpeedRangeToStyleZoom(
                range: SpeedRange(minSpeed: Double(truncating: speedRangeZoom.minSpeedRange), maxSpeed: Double(truncating: speedRangeZoom.maxSpeedRange)),
                minDistanceToManeuver: RouteDistance(millimeters: Int64(truncating: speedRangeZoom.routeDistanceMillimeters)),
                maxDistanceToManeuver: RouteDistance(millimeters: Int64(truncating: speedRangeZoom.routeDistanceMillimeters)),
                styleZoom: StyleZoom(value: Float(truncating: speedRangeZoom.styleZoomValue))
            ),
        ]
    }
    
    func resetCamera() {
        resetCamera(map: self.map)
        map.graphicsPreset = .normal

        if let carPlayMap = FlutterCarPlaySceneDelegate.map {
            resetCamera(map: carPlayMap)
        }
    }
    
    func resetCamera(map: Map) {
        if let prevCameraBehaviour {
            map.camera.setBehaviour(behaviour: prevCameraBehaviour)
        }
    }
    
    func followNavigation() {
        self.map.camera.setBehaviour(
            behaviour: NavigationHandler.navigationManager!.mapFollowController.cameraBehaviour
        )
        NavigationHandler.navigationManager!.mapFollowController.setFollow(follow: true)
    }
    
    func startNavigation(
        finishPoint: RouteSearchPoint?,
        options: RouteSearchOptions?,
        route: TrafficRoute?,
        speedRangeZoom: SpeedRangeZoom,
        completion: @escaping (FlutterError?) -> Void
    ) {
        guard let finishPoint = finishPoint, let options = options, let route = route else {
            completion(FlutterError(
                code: "NavigationError",
                message: "Not enough data to start navigation. Check RouteHandler documentation",
                details: nil
            ))
            return
        }
        
        do {
            setupCamera(speedRangeZoom: speedRangeZoom)
            
            NavigationHandler.navigationManager!.mapManager.addMap(map: self.map)
            if let carPlayMap = FlutterCarPlaySceneDelegate.map {
                NavigationHandler.navigationManager!.mapManager.addMap(map: carPlayMap)
                FlutterCarPlaySceneDelegate.startNavigation()
            }
            
            // TODO: return back
            try NavigationHandler.navigationManager!.startSimulation(
                routeBuildOptions: RouteBuildOptions(
                    finishPoint: finishPoint,
                    routeSearchOptions: options
                ),
                trafficRoute: route
            )
        } catch {
            completion(FlutterError(
                code: "NavigationError",
                message: error.localizedDescription,
                details: nil
            ))
            return
        }
        
        completion(nil)
    }
    
    func setNavigatorVoice(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        NavigationHandler.navigationManager!.voiceSelector.voice = voiceManager.voices.first { $0.id == id }?.navigationVoice
        completion(nil)
    }
    
    func simulationSpeed(speed: Double) {
        self.navigationManager.simulationSettings.speedMode = SimulationSpeedMode.speed(SimulationConstantSpeed(speed: speed))
    }
    
    func startSimulation(
        finishPoint: RouteSearchPoint?,
        options: RouteSearchOptions?,
        route: TrafficRoute?,
        speedRangeZoom: SpeedRangeZoom,
        completion: @escaping (FlutterError?) -> Void
    ) {
        guard let finishPoint = finishPoint, let options = options, let route = route else {
            completion(FlutterError(
                code: "NavigationError",
                message: "Not enough data to start navigation. Check RouteHandler documentation",
                details: nil
            ))
            return
        }
        
        do {
            setupCamera(speedRangeZoom: speedRangeZoom)
            
            NavigationHandler.navigationManager!.mapManager.addMap(map: self.map)
            if let carPlayMap = FlutterCarPlaySceneDelegate.map {
                NavigationHandler.navigationManager!.mapManager.addMap(map: carPlayMap)
                FlutterCarPlaySceneDelegate.startNavigation()
            }

            try NavigationHandler.navigationManager!.startSimulation(
                routeBuildOptions: RouteBuildOptions(
                    finishPoint: finishPoint,
                    routeSearchOptions: options
                ),
                trafficRoute: route
            )
        } catch {
            completion(FlutterError(
                code: "NavigationError",
                message: error.localizedDescription,
                details: nil
            ))
            return
        }
        
        completion(nil)
    }
    
    func stopNavigation() {
        NavigationHandler.navigationManager!.stop()
        
        NavigationHandler.navigationManager!.mapManager.removeMap(map: self.map)
        if let carPlayMap = FlutterCarPlaySceneDelegate.map {
            NavigationHandler.navigationManager!.mapManager.removeMap(map: carPlayMap)
        }
        
        if FlutterCarPlaySceneDelegate.map != nil {
            FlutterCarPlaySceneDelegate.stopNaviagtion()
        }
        
        resetCamera()
    }
    
    func saveNavigationState(completion: @escaping (FlutterStandardTypedData?, FlutterError?) -> Void) {
        let state = PackedNavigationState.fromModel(model: NavigationHandler.navigationManager!.uiModel)
        completion(
            .init(bytes: state.toBytes()),
            nil
        )
    }
    
    func restoreNavigationState(
        state bytes: FlutterStandardTypedData,
        speedRangeZoom: SpeedRangeZoom,
        completion: @escaping (FlutterError?) -> Void
    ) {
        do {
            let state = try PackedNavigationState.fromBytes(data: bytes.data)
            self.startNavigation(
                finishPoint: state.finishPoint,
                options: state.routeSearchOptions,
                route: state.trafficRoute,
                speedRangeZoom: speedRangeZoom,
                completion: completion
            )
        } catch {
            completion(FlutterError(
                code: "NavigationError",
                message: error.localizedDescription,
                details: nil
            ))
            return
        }
    }
    
    func getCurrentNavigationState(completion: @escaping (NavigationStateMessage?, FlutterError?) -> Void) {
        let state = switch navigationManager.uiModel.state {
        case .navigation, .routeSearch:  NavigationState.navigation
        case   .finished: NavigationState.finish
        case  .disabled: NavigationState.disabled
        default: NavigationState.disabled
        }
        let options = navigationManager.uiModel.route.routeBuildOptions?.routeSearchOptions.toRouteSearchOptions() ?? RouteSearchOptionsMessage.car
        completion(
            NavigationStateMessage.make(with: state, routeSearchOptions: options),
            nil
        )
    }

    func startFreeRoam(speedRangeZoom: SpeedRangeZoom, completion: @escaping (FlutterError?) -> Void) {
        do {
            setupCamera(speedRangeZoom: speedRangeZoom)
            try NavigationHandler.navigationManager!.start()
        } catch {
            completion(FlutterError(
                code: "NavigationError",
                message: error.localizedDescription,
                details: nil
            ))
            return
        }

        completion(nil)
    }

    func stopFreeRoam() {
        NavigationHandler.navigationManager!.stop()
        resetCamera()
    }

    func toggleSounds(toggleType: SoundToggleType) {
        self.dashboardControlModel.toggleSounds(toggleType: toggleType)
    }

    func toggleRoadCameras(roadCameras: Bool) {
        self.dashboardControlModel.toggleRoadCameras(roadCameras: roadCameras)
    }

    func toggleOverSpeeding(overSpeeding: Bool) {
        self.dashboardControlModel.toggleOverSpeeding(overSpeeding: overSpeeding)
    }
    
    func calcPositionForRoute(options: CalcPositionOptionsMessage, completion: @escaping (CameraPositionMessage?, FlutterError?) -> Void) {
        let geometries = NavigationHandler.navigationManager!.uiModel.route.route.geometry.entries.map { entry in
            PointGeometry(point: entry.value)
        }
        let geometry = ComplexGeometry(geometries: geometries)
        
        let cameraPosition = DGis.calcPosition(
            camera: map.camera,
            geometry: geometry,
            screenArea: options.screenArea.map {
                Padding(
                    left: $0.leftPadding.uint32Value,
                    top: $0.topPadding.uint32Value,
                    right: $0.rightPadding.uint32Value,
                    bottom: $0.bottomPadding.uint32Value
                )
            },
            tilt: options.tilt.map {
                Tilt(value: $0.floatValue)
            },
            bearing: options.bearing.map {
                Bearing(value: $0.doubleValue)
            },
            size: options.size.map {
                ScreenSize(
                    width: $0.width.uint32Value,
                    height: $0.height.uint32Value
                )
            }
        )
        
        completion(
            CameraPositionMessage.make(
                withPoint: cameraPosition.point.toMessage(),
                zoom: NSNumber(value: cameraPosition.zoom.value),
                tilt: NSNumber(value: cameraPosition.tilt.value),
                bearing: NSNumber(value: cameraPosition.bearing.value)
            ),
            nil
        )
    }
}
