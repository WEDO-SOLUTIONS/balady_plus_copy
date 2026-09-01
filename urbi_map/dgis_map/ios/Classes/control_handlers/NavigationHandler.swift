import DGis
import Foundation

// Cross-module contract with the Runner Live Activity controller.
// Raw values are part of the fixed contract — do not rename.
extension Notification.Name {
    static let dgisNavigationDashboardTick = Notification.Name("dgis.navigation.dashboardTick")
    static let dgisNavigationManeuverTick = Notification.Name("dgis.navigation.maneuverTick")
    static let dgisNavigationSpeedTick = Notification.Name("dgis.navigation.speedTick")
    static let dgisNavigationMessageTick = Notification.Name("dgis.navigation.messageTick")
    static let dgisNavigationStateChanged = Notification.Name("dgis.navigation.stateChanged")
}

class NavigationHandler {
    private class Events {
        // event name
        static let navigationEvent = "navigationEvent"
        static let routeOptionsEvent = "routeOptionsEvent"
        static let betterRouteEvent = "betterRouteEvent"

        // event values
        static let stateFinished = "finished"
        static let stateDisabled = "disabled"
        static let stateNavigation = "navigation"
        static let stateRouteSearch = "routeSearch"
    }
    
    private let map: Map
    private let context: Context
    private let eventChannel: DgisStreamHandler
    
    public var navigationManager: NavigationManager
    
    private let voiceManager: VoiceManager
    
    private var prevCameraBehaviour: CameraBehaviour?
    private var prevGraphicsPreset: GraphicsPreset?
    
    private var cancelable: Array<Cancellable> = []
    private var moveCameraCancellable: DGis.Cancellable?

    // Models to observe channels and send events to Flutter
    private let speedControlModel: SpeedControlModel
    private let dashboardControlModel: DashboardControlModel
    private let messageControlModel: MessageControlModel
    private let maneuverControlModel: ManeuverControlModel
    
    private let oldSource: DGis.Source?
    /// BALADY-3772: the navigation-cursor 3D model is set on the my-location
    /// object via setModelData. The owner (DgisMapView) re-applies it whenever
    /// that object may have (re)materialised its model: after guidance swaps
    /// the source and when a session (guidance / free roam) starts — a model
    /// set while the cursor was still the idle dashboard marker is not shown.
    var onMyLocationSourceReplaced: (() -> Void)?
    /// BALADY-3772 (regression): the custom model is a turn-by-turn-only
    /// visual. Fired when a session ends so the owner resets the my-location
    /// marker back to the standard style default.
    var onNavigationSessionEnded: (() -> Void)?

    private(set) var isNavigating: Bool = false

    init(map: Map, mapView: UIView & IMapView, sdk: Container, eventChannel: DgisStreamHandler, view: UIView) {
        self.context = try! sdk.context
        self.map = map

        self.eventChannel = eventChannel
        self.navigationManager = DgisMapInitializer.shared.getNavigationManager()
        self.oldSource = nil
        
        self.voiceManager = getVoiceManager(context: context)

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
        
        navigationManager.mapManager.addMap(map: map)
    }

    private func stateChannelListener(_ state: State) {
        switch (state) {
        case State.disabled:
            self.eventChannel.success([
                "event": Events.navigationEvent,
                "state": Events.stateDisabled
            ])
            self.isNavigating = false
            postStateChanged(Events.stateDisabled)
        case State.finished:
            self.eventChannel.success([
                "event": Events.navigationEvent,
                "state": Events.stateFinished
            ])
            self.isNavigating = false
            postStateChanged(Events.stateFinished)
            stopNavigation()
        case State.navigation:
            self.eventChannel.success([
                "event": Events.navigationEvent,
                "state": Events.stateNavigation
            ])
            self.isNavigating = true
            postStateChanged(Events.stateNavigation)
        case State.routeSearch:
            self.eventChannel.success([
                "event": Events.navigationEvent,
                "state": Events.stateRouteSearch
            ])
            self.isNavigating = true
            postStateChanged(Events.stateRouteSearch)
        }
    }

    private func postStateChanged(_ state: String) {
        // SDK callback thread: a synchronous post waits for main-queue observers and can
        // deadlock against main-thread calls into the SDK — post async on main instead.
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: .dgisNavigationStateChanged,
                object: nil,
                userInfo: ["state": state]
            )
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
        let durationProfit: Int
        if let routeInfo = routeInfo {
            durationProfit = calculateDurationProfit(navigationManager.uiModel, routeInfo)
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
    
    func getBetterRouteSettings(completion: @escaping (Result<BetterRouteSettingsMessage, any Error>) -> Void) {
        let settings = self.navigationManager.alternativeRoutesProviderSettings
        completion(
            Result.success(
            BetterRouteSettingsMessage(
                betterRouteTimeCostThreshold: Int64(settings.betterRouteTimeCostThreshold),
                betterRouteLengthThreshold: Int64(settings.betterRouteLengthThreshold.millimeters),
                routeSearchDelay: Int64(settings.routeSearchDelay)
            )
            )
        )
    }
    
    func setBetterRouteSettings(settings: BetterRouteSettingsMessage) {
        self.navigationManager.alternativeRoutesProviderSettings.routeSearchDelay = TimeInterval(settings.routeSearchDelay)
        self.navigationManager.alternativeRoutesProviderSettings.betterRouteTimeCostThreshold = TimeInterval(settings.betterRouteTimeCostThreshold)
        self.navigationManager.alternativeRoutesProviderSettings.betterRouteLengthThreshold = RouteDistance(millimeters: Int64(settings.betterRouteLengthThreshold))
    }
    
    func setBetterRouteEnabled(enabled: Bool) {
        self.navigationManager.alternativeRoutesProviderSettings.betterRouteEnabled = enabled
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
    
    func setupCamera(speedRangeZoom: [SpeedRangeZoom]) {
        setupCamera(map: self.map, speedRangeZoom: speedRangeZoom)

        if let carPlayMap = FlutterCarPlaySceneDelegate.map {
            setupCamera(map: carPlayMap, speedRangeZoom: speedRangeZoom)
        }
    }
    
    func setupCamera(
        map: Map,
        speedRangeZoom: [SpeedRangeZoom]
    ) {
        // Store the original graphics preset before changing it
        // This allows us to restore it later to preserve traffic layer colors
        self.prevGraphicsPreset = map.graphicsPreset
        
        // NEVER change graphics preset if it's not already immersive
        // This preserves traffic layer colors when freeroam starts
        // The preset will only be changed if it's already immersive (no-op)
        // This ensures traffic colors remain consistent regardless of traffic state
        // Only change to immersive if current preset is already immersive (no change needed)
        // Otherwise, preserve the current preset to maintain traffic colors
        if map.graphicsPreset == .immersive {
            // Already immersive, no change needed
        } else {
            // Preserve current preset - don't change to immersive
            // This keeps traffic colors consistent
        }
        
        self.prevCameraBehaviour = map.camera.behaviour.newBehaviour
        map.camera.setBehaviour(
            behaviour: self.navigationManager.mapFollowController.cameraBehaviour
        )
        
        startFollowNavigation()
        self.navigationManager.zoomFollowSettings.speedRangeToStyleZoomSequence = speedRangeZoom.map({ SpeedRangeToStyleZoom(
            range: SpeedRange(minSpeed: Double(truncating: $0.minSpeedRange as NSNumber), maxSpeed: $0.maxSpeedRange),
            minDistanceToManeuver: RouteDistance(millimeters: Int64($0.routeDistanceMillimeters)),
            maxDistanceToManeuver: RouteDistance(millimeters: Int64($0.routeDistanceMillimeters)),
            styleZoom: StyleZoom(value: Float($0.styleZoomValue))
        )})
    }
    
    func resetCamera() {
        resetCamera(map: self.map)
        
        // Restore the original graphics preset if it was stored
        // This preserves traffic layer colors when freeroam ends
        if let prevGraphicsPreset = self.prevGraphicsPreset {
            map.graphicsPreset = prevGraphicsPreset
            self.prevGraphicsPreset = nil
        }

        if let carPlayMap = FlutterCarPlaySceneDelegate.map {
            resetCamera(map: carPlayMap)
        }
        
        if oldSource == nil { return }
        let toDelete = map.sources.first(where: { $0 is MyLocationMapObjectSource})
        
        if toDelete == nil { return }
        
        map.removeSource(source: toDelete!)
        map.addSource(source: oldSource!)
    }
    
    func resetCamera(map: Map) {
        if let prevCameraBehaviour {
            map.camera.setBehaviour(behaviour: prevCameraBehaviour)
        }
    }
    
    func followNavigation() {
        self.map.camera.setBehaviour(
            behaviour: self.navigationManager.mapFollowController.cameraBehaviour
        )
        startFollowNavigation()
    }

    func startFollowNavigation() {
        self.navigationManager.mapFollowController.setFollow(follow: true)
        // Default delay is 15 seconds
        self.navigationManager.mapFollowController.followReturnDelay = 15.0
    }

    func stopFollowNavigation() {
        self.navigationManager.mapFollowController.setFollow(follow: false)
        // Disable auto return to follow mode
        self.navigationManager.mapFollowController.followReturnDelay = 0.0
    }
    
    func startNavigation(
        finishPoint: RouteSearchPoint?,
        options: RouteSearchOptions?,
        route: TrafficRoute?,
        speedRangeZoom: [SpeedRangeZoom],
        completion: @escaping (Result<Void, any Error>) -> Void
    ) {
        guard let finishPoint = finishPoint, let options = options, let route = route else {
            completion(
                Result.failure(
                FlutterError(
                code: "NavigationError",
                message: "Not enough data to start navigation. Check RouteHandler documentation",
                details: nil
            )))
            return
        }
        
        do {
            let isPublicTransport = options == .publicTransport(PublicTransportRouteSearchOptions())
            if !isPublicTransport {
            setupCamera(speedRangeZoom: speedRangeZoom)
            // TODO: return back
            try self.navigationManager.start(
                routeBuildOptions: RouteBuildOptions(
                    finishPoint: finishPoint,
                    routeSearchOptions: options
                ),
                trafficRoute: route
            )
            }
        } catch {
            completion(
                Result.failure(
                FlutterError(
                code: "NavigationError",
                message: error.localizedDescription,
                details: nil
            )))
            return
        }
        
        let oldSource = map.sources.first(where: { $0 is MyLocationMapObjectSource })!
        
        map.removeSource(source: oldSource)
        
        map.addSource(source: MyLocationMapObjectSource(
            context: context,
            controllerSettings:  MyLocationControllerSettings(
                coordinatesThreshold: Meter(value: 10),
                bearingThreshold: Bearing(value: 90)
            )
        ))
        onMyLocationSourceReplaced?()
        
        completion(Result.success(()))
    }
    
    func setNavigatorVoice(_ id: String, completion: @escaping (Result<Void, any Error>) -> Void) {

        
        guard let selectedVoice = voiceManager.voices.first(where: { $0.id == id && $0.progress == 100}) else {
                completion(.failure(FlutterError(
                    code: "NavigationError",
                    message: "Voice not found or not downloaded yet",
                    details: nil)))
                return
            }
            
            
        navigationManager.voiceSelector.voice = selectedVoice.navigationVoice
        completion(.success(()))
    }
    
    func simulationSpeed(speed: Double) {
        self.navigationManager.simulationSettings.speedMode = SimulationSpeedMode.speed(SimulationConstantSpeed(speed: speed))
    }
    
    func startSimulation(
        finishPoint: RouteSearchPoint?,
        options: RouteSearchOptions?,
        route: TrafficRoute?,
        speedRangeZoom: [SpeedRangeZoom],
        completion: @escaping (Result<Void, any Error>) -> Void
    ) {
        guard let finishPoint = finishPoint, let options = options, let route = route else {
            completion(
                Result.failure(
                FlutterError(
                code: "NavigationError",
                message: "Not enough data to start navigation. Check RouteHandler documentation",
                details: nil
            )))
            return
        }
        
        do {
            

            let isPublicTransport = options == .publicTransport(PublicTransportRouteSearchOptions())
            if !isPublicTransport {
            setupCamera(speedRangeZoom: speedRangeZoom)
            try self.navigationManager.startSimulation(
                routeBuildOptions: RouteBuildOptions(
                    finishPoint: finishPoint,
                    routeSearchOptions: options
                ),
                trafficRoute: route
            )
            }
        } catch {
            completion(
                Result.failure(FlutterError(
                code: "NavigationError",
                message: error.localizedDescription,
                details: nil
            )))
            return
        }
        
        completion(Result.success(()))
    }
    
    func stopNavigation() {
        self.navigationManager.stop()
        resetCamera()
        // BALADY-3772 (regression): the session is over — drop the custom
        // cursor model so the marker returns to the standard one.
        onNavigationSessionEnded?()
    }

    func saveNavigationState(completion: @escaping (Result<FlutterStandardTypedData, any Error>) -> Void) {
        let state = PackedNavigationState.fromModel(model: self.navigationManager.uiModel)
        completion(
            Result.success(
            .init(bytes: state.toBytes())
            )
        )
    }
    
    func restoreNavigationState(
        state bytes: FlutterStandardTypedData,
        speedRangeZoom: [SpeedRangeZoom],
        completion: @escaping (Result<Void, any Error>) -> Void
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
            completion(
                Result.failure(
                FlutterError(
                code: "NavigationError",
                message: error.localizedDescription,
                details: nil
            )))
            return
        }
    }
    
    func getCurrentNavigationState(
        completion: @escaping (Result<NavigationStateMessage, any Error>) -> Void
    ) {
        let state = switch self.navigationManager.uiModel.state {
        case .navigation, .routeSearch:  NavigationState.navigation
        case   .finished: NavigationState.finish
        case  .disabled: NavigationState.disabled
        default: NavigationState.disabled
        }
        let options = self.navigationManager.uiModel.route.routeBuildOptions?.routeSearchOptions.toRouteSearchOptions()
        completion(
            Result.success(NavigationStateMessage(state: state, routeSearchOptions: options))
        
        )
    }

    func startFreeRoam(speedRangeZoom: [SpeedRangeZoom], completion: (Result<Void, any Error>) -> Void) {
        do {
            setupCamera(speedRangeZoom: speedRangeZoom)
            try self.navigationManager.start()
            onMyLocationSourceReplaced?()
        } catch {
            completion(
                Result.failure(
                FlutterError(
                code: "NavigationError",
                message: error.localizedDescription,
                details: nil
            )))
            return
        }

        completion(Result.success(()))
    }

    func stopFreeRoam() {
        // Free roam has to leave the camera at the last roaming position instead of
        // snapping back to the user location, the same way Android behaves (TFS #34904).
        // The behaviour stored by `setupCamera` may be a following one (the map usually
        // follows the location before free roam starts), so restoring it would pull the
        // camera back to the current location right after the trip is ended.
        let wasActive = self.navigationManager.uiModel.state != .disabled
        self.navigationManager.stop()
        stopFollowNavigation()
        resetCamera()
        // BALADY-3772 (regression): see stopNavigation.
        onNavigationSessionEnded?()

        guard wasActive else { return }

        self.map.camera.setBehaviour(behaviour: CameraBehaviour(position: nil))
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
    
    func calcPositionForRoute(options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {
        let geometries = self.navigationManager.uiModel.route.route.geometry.entries.map { entry in
            PointGeometry(point: entry.value)
        }
        let geometry = ComplexGeometry(geometries: geometries)
        
        let cameraPosition = DGis.calcPosition(
            camera: map.camera,
            geometry: geometry,
            screenArea: options.screenArea.map {
                Padding(
                    left: UInt32($0.leftPadding),
                    top: UInt32($0.topPadding),
                    right: UInt32($0.rightPadding),
                    bottom: UInt32($0.bottomPadding)
                )
            },
            tilt: options.tilt.map {
                Tilt(value: Float($0))
            },
            bearing: options.bearing.map {
                Bearing(value: $0)
            },
            size: options.size.map {
                ScreenSize(
                    width: UInt32($0.width),
                    height: UInt32($0.height)
                )
            }
        )
        
        completion(
            Result.success(
            CameraPositionMessage(
                point: cameraPosition.point.toMessage(),
                zoom:  Double(cameraPosition.zoom.value),
                tilt:  Double(cameraPosition.tilt.value),
                bearing:  cameraPosition.bearing.value
            ))
        )
    }
}

func calculateDurationProfit(_ uiModel: Model,_ routeInfo: BetterRouteInfo) -> Int {
    let activeRouteDuration = uiModel.duration
    var betterRouteDuration: TimeInterval? = nil
    let durationProfit: Int
    if let first = routeInfo.trafficRoute.route.geometry.first {
        betterRouteDuration = routeInfo.trafficRoute.traffic.durations.calculateDuration(routePoint: first.point).rounded()
    }
    if let activeRouteDuration = activeRouteDuration, let betterRouteDuration = betterRouteDuration {
        durationProfit = Int(activeRouteDuration - betterRouteDuration)
    } else {
        durationProfit = 0
    }
    return durationProfit
}
