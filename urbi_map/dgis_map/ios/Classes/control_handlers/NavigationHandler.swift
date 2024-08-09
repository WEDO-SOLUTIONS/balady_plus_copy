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
    private let eventChannel: DgisStreamHandler
    private let navigationManager: NavigationManager
    private let voiceManager: VoiceManager
    
    private var prevCameraBehaviour: CameraBehaviour?
    
    private var cancelable: Array<Cancellable> = []
    private var moveCameraCancellable: DGis.Cancellable?
    private let locationSource: MyLocationMapObjectSource
    private var prevMyLocationMapObjectSource: MyLocationMapObjectSource?
    
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
        
        self.navigationManager = try! NavigationManager(platformContext: context)
        self.navigationManager.alternativeRoutesProviderSettings.alternativeRoutesEnabled = false
        self.navigationManager.routeSourceSettings.calloutVisualizationMode = .multipleRoutes
        self.navigationManager.mapManager.addMap(map: self.map)
        
        self.voiceManager = getVoiceManager(context: context)
        
        self.locationSource = MyLocationMapObjectSource(
            context: context,
            controller: navigationManager.mapLocationController.myLocationIndicatorController
        )

        self.speedControlModel = SpeedControlModel(
            model: self.navigationManager.uiModel,
            eventChannel: eventChannel
        )

        self.dashboardControlModel = DashboardControlModel(
            model: self.navigationManager.uiModel,
            eventChannel: self.eventChannel,
            navigationManager: self.navigationManager
        )

        self.messageControlModel = MessageControlModel(
            model: self.navigationManager.uiModel,
            eventChannel: eventChannel
        )

        self.maneuverControlModel = ManeuverControlModel(
            model: self.navigationManager.uiModel,
            eventChannel: self.eventChannel
        )

        self.cancelable.append(
            self.navigationManager.uiModel.stateChannel.sink(receiveValue: stateChannelListener)
        )

        self.cancelable.append(
            self.navigationManager.uiModel.routeChannel.sink(receiveValue: routeInfoListener)
        )
        
        self.cancelable.append(
            self.navigationManager.uiModel.betterRouteChannel.sink(receiveValue: betterRouteListener)
        )
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
            self.navigationManager.alternativeRouteSelector.selectAlternativeRoute(trafficRoute: trafficRoute)
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
        let activeRouteDuration = navigationManager.uiModel.duration
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
            self.navigationManager.uiModel.betterRouteResponse(response: .accept)
        case .reject:
            self.navigationManager.uiModel.betterRouteResponse(response: .reject)
        case .timeout:
            self.navigationManager.uiModel.betterRouteResponse(response: .timeout)
        }
    }
    
    func getBetterRouteSettings(completion: @escaping (BetterRouteSettingsMessage?, FlutterError?) -> Void) {
        let settings = self.navigationManager.alternativeRoutesProviderSettings
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
        self.navigationManager.alternativeRoutesProviderSettings.routeSearchDelay = settings.routeSearchDelay.doubleValue
        self.navigationManager.alternativeRoutesProviderSettings.betterRouteTimeCostThreshold = settings.betterRouteTimeCostThreshold.doubleValue
        self.navigationManager.alternativeRoutesProviderSettings.betterRouteLengthThreshold = RouteDistance(millimeters: settings.betterRouteLengthThreshold.int64Value)
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
    
    func setupCamera(
        speedRangeZoom: SpeedRangeZoom
    ) {
        self.prevMyLocationMapObjectSource = self.map.sources.first { $0 is MyLocationMapObjectSource } as? MyLocationMapObjectSource
        if let prevLocationSource = self.prevMyLocationMapObjectSource {
            self.map.removeSource(source: prevLocationSource)
        }
        self.map.addSource(source: self.locationSource)
        
        self.prevCameraBehaviour = self.map.camera.behaviour.newBehaviour
        self.map.camera.setBehaviour(
            behaviour: self.navigationManager.mapFollowController.cameraBehaviour
        )
        
        self.navigationManager.mapFollowController.setFollow(follow: true)
        self.navigationManager.zoomFollowSettings.speedRangeToStyleZoomSequence = [
            SpeedRangeToStyleZoom(
                range: SpeedRange(minSpeed: Double(truncating: speedRangeZoom.minSpeedRange), maxSpeed: Double(truncating: speedRangeZoom.maxSpeedRange)),
                minDistanceToManeuver: RouteDistance(millimeters: Int64(truncating: speedRangeZoom.routeDistanceMillimeters)),
                maxDistanceToManeuver: RouteDistance(millimeters: Int64(truncating: speedRangeZoom.routeDistanceMillimeters)),
                styleZoom: StyleZoom(value: Float(truncating: speedRangeZoom.styleZoomValue))
            ),
        ]
    }
    
    func followNavigation() {
        self.map.camera.setBehaviour(
            behaviour: self.navigationManager.mapFollowController.cameraBehaviour
        )
        self.navigationManager.mapFollowController.setFollow(follow: true)
    }
    
    func resetCamera() {
        self.map.removeSource(source: self.locationSource)
        if let prevLocationSource = self.prevMyLocationMapObjectSource {
            self.map.addSource(source: prevLocationSource)
        }
        if let prevCameraBehaviour {
            self.map.camera.setBehaviour(behaviour: prevCameraBehaviour)
        }

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
            try self.navigationManager.start(
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
        navigationManager.voiceSelector.voice = voiceManager.voices.first { $0.id == id }?.navigationVoice
        completion(nil)
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
            try self.navigationManager.startSimulation(
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
        navigationManager.stop()
        resetCamera()
    }
    
    func saveNavigationState(completion: @escaping (FlutterStandardTypedData?, FlutterError?) -> Void) {
        let state = PackedNavigationState.fromModel(model: self.navigationManager.uiModel)
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

    func startFreeRoam(completion: @escaping (FlutterError?) -> Void) {
        do {
            try self.navigationManager.start()
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
        self.navigationManager.stop()
    }

    func toggleSounds(toggleType: SoundToggleType) {
        self.dashboardControlModel.toggleSounds(toggleType: toggleType)
    }
    
    func calcPositionForRoute(options: CalcPositionOptionsMessage, completion: @escaping (CameraPositionMessage?, FlutterError?) -> Void) {
        let geometries = navigationManager.uiModel.route.route.geometry.entries.map { entry in
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
