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

    // Active tilt-by-zoom controller added via applyCameraSettings(_:); tracked so it can be
    // replaced/removed cleanly.
    private var tiltFollowController: TiltFollowController?
    // Same, but for the CarPlay map (separate Map instance → separate controller).
    private var carPlayTiltFollowController: TiltFollowController?

    // Last navigation-camera settings tuned on the phone. Stored so the CarPlay map can
    // pick them up when its scene connects after the phone has already applied them.
    static var lastNavigationCameraSettings: NavigationCameraSettings?

    private var cancelable: Array<Cancellable> = []
    private var moveCameraCancellable: DGis.Cancellable?
    
    // Models to observe channels and send events to Flutter
    private let speedControlModel: SpeedControlModel
    private let dashboardControlModel: DashboardControlModel
    private let messageControlModel: MessageControlModel
    private let maneuverControlModel: ManeuverControlModel
    
    private let oldSource: DGis.Source?
    
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
        case State.finished:
            self.eventChannel.success([
                "event": Events.navigationEvent,
                "state": Events.stateFinished
            ])
            self.isNavigating = false
            stopNavigation()
        case State.navigation:
            self.eventChannel.success([
                "event": Events.navigationEvent,
                "state": Events.stateNavigation
            ])
            self.isNavigating = true
        case State.routeSearch:
            self.eventChannel.success([
                "event": Events.navigationEvent,
                "state": Events.stateRouteSearch
            ])
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
            // Mirror the phone-tuned navigation camera onto the CarPlay map (its scene may have
            // connected after the phone applied the settings, so pull the stored copy here).
            if let settings = NavigationHandler.lastNavigationCameraSettings {
                applyPerMapSettings(settings, to: carPlayMap, tiltController: &self.carPlayTiltFollowController)
            }
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

    /// Applies any subset of navigation-camera controls. Every field of `settings` is optional:
    /// a nil field leaves the corresponding SDK behavior untouched, so this can be used both to
    /// configure the full camera at navigation start and to tweak a single parameter live.
    /// Phone only — does not touch the CarPlay map.
    func applyCameraSettings(_ settings: NavigationCameraSettings) {
        // Remember the latest phone-tuned settings so the CarPlay map can adopt them when its
        // scene connects after the phone has already applied them (see setupCamera).
        NavigationHandler.lastNavigationCameraSettings = settings

        let zoomFollowSettings = self.navigationManager.zoomFollowSettings

        if let rules = settings.speedZoomRules {
            zoomFollowSettings.speedRangeToStyleZoomSequence = rules.map(Self.toSpeedRangeToStyleZoom)
        }
        if let rules = settings.freeRoamSpeedZoomRules {
            zoomFollowSettings.speedRangeToStyleZoomFreeRoamSequence = rules.map(Self.toSpeedRangeToStyleZoom)
        }

        if let tuning = settings.zoomTuning {
            // SDK durations are TimeInterval (seconds); the API carries milliseconds.
            if let ms = tuning.styleZoomSpeedRangesAnimationMs {
                zoomFollowSettings.styleZoomSpeedRangesAnimationDuration = TimeInterval(ms) / 1000.0
            }
            if let ms = tuning.zoomInBeforeManeuverAnimationMs {
                zoomFollowSettings.zoomInBeforeManeuverAnimationDuration = TimeInterval(ms) / 1000.0
            }
            if let ms = tuning.zoomOutAfterManeuverAnimationMs {
                zoomFollowSettings.zoomOutAfterManeuverAnimationDuration = TimeInterval(ms) / 1000.0
            }
            if let mm = tuning.distanceGapToManeuverMm {
                zoomFollowSettings.distanceGapToManeuver = RouteDistance(millimeters: Int64(mm))
            }
            if let value = tuning.minSpeedToConsiderInZoomInBeforeManeuver {
                zoomFollowSettings.minSpeedToConsiderInZoomInBeforeManeuverAnimation = value
            }
            if let value = tuning.zoomInBeforeManeuverAnimationAcceleration {
                zoomFollowSettings.zoomInBeforeManeuverAnimationAcceleration = value
            }
            if let ms = tuning.minAnimationMs {
                zoomFollowSettings.minAnimationDuration = TimeInterval(ms) / 1000.0
            }
        }

        if let behaviour = settings.followBehaviour {
            let cameraBehaviour = CameraBehaviour(
                position: FollowPosition(
                    bearing: behaviour.followBearing ? .on : .off,
                    styleZoom: behaviour.followStyleZoom ? .on : .off
                ),
                tilt: behaviour.followTilt ? .on : .off
            )
            self.navigationManager.mapFollowController.cameraBehaviour = cameraBehaviour
        }

        // Per-map controls (follow behaviour, tilt-by-zoom curve, max-tilt, zoom restriction).
        // Applied to the phone map and — if its scene is connected — the CarPlay map, so the
        // camera tuned on the phone is mirrored in CarPlay. (Speed→zoom lives on the shared
        // navigationManager above, so it already propagates to CarPlay.)
        applyPerMapSettings(settings, to: self.map, tiltController: &self.tiltFollowController)
        if let carPlayMap = FlutterCarPlaySceneDelegate.map {
            applyPerMapSettings(settings, to: carPlayMap, tiltController: &self.carPlayTiltFollowController)
        }

        if let seconds = settings.followReturnDelaySeconds {
            self.navigationManager.mapFollowController.followReturnDelay = TimeInterval(seconds)
        }
    }

    /// Applies the per-map subset of [NavigationCameraSettings] (follow behaviour, tilt-by-zoom
    /// curve, max-tilt restriction, zoom restriction) to a specific map. Used for both the phone
    /// map and the CarPlay map so the phone-tuned camera is mirrored in CarPlay.
    private func applyPerMapSettings(
        _ settings: NavigationCameraSettings,
        to map: Map,
        tiltController: inout TiltFollowController?
    ) {
        if let behaviour = settings.followBehaviour {
            map.camera.setBehaviour(behaviour: CameraBehaviour(
                position: FollowPosition(
                    bearing: behaviour.followBearing ? .on : .off,
                    styleZoom: behaviour.followStyleZoom ? .on : .off
                ),
                tilt: behaviour.followTilt ? .on : .off
            ))
        }
        if let points = settings.tiltRelation {
            if let existing = tiltController {
                map.camera.removeFollowController(followController: existing)
            }
            let controller = TiltFollowController(styleZoomToTilt: ZoomTiltRelation(points: points))
            map.camera.addFollowController(followController: controller)
            tiltController = controller
        }
        if let points = settings.maxTiltRelation {
            map.camera.maxTiltRestriction = ZoomTiltRelation(points: points)
        }
        if settings.minZoom != nil || settings.maxZoom != nil {
            let current = map.camera.zoomRestrictions
            let restrictions = CameraZoomRestrictions(
                minZoom: settings.minZoom.map { Zoom(value: Float($0)) } ?? current.minZoom,
                maxZoom: settings.maxZoom.map { Zoom(value: Float($0)) } ?? current.maxZoom
            )
            try? map.camera.setZoomRestrictions(zoomRestrictions: restrictions)
        }
    }

    // BE-193 is on SDK 12 → keep the 4-arg SpeedRangeToStyleZoom (no styleTilt / roadClasses,
    // which only exist on SDK 13). Per-speed-band tilt is therefore not applied here; the tilt
    // curve is driven via the TiltFollowController in applyPerMapSettings above.
    private static func toSpeedRangeToStyleZoom(_ rule: SpeedZoomRule) -> SpeedRangeToStyleZoom {
        SpeedRangeToStyleZoom(
            range: SpeedRange(minSpeed: rule.minSpeed, maxSpeed: rule.maxSpeed),
            minDistanceToManeuver: RouteDistance(millimeters: Int64(rule.minDistanceToManeuverMm)),
            maxDistanceToManeuver: RouteDistance(millimeters: Int64(rule.maxDistanceToManeuverMm)),
            styleZoom: StyleZoom(value: Float(rule.styleZoom))
        )
    }

    func resetCamera() {
        // Drop the navigation tilt-by-zoom controller so the chase pitch does not leak into
        // normal map mode after navigation ends.
        if let existing = self.tiltFollowController {
            self.map.camera.removeFollowController(followController: existing)
            self.tiltFollowController = nil
        }

        resetCamera(map: self.map)
        
        // Restore the original graphics preset if it was stored
        // This preserves traffic layer colors when freeroam ends
        if let prevGraphicsPreset = self.prevGraphicsPreset {
            map.graphicsPreset = prevGraphicsPreset
            self.prevGraphicsPreset = nil
        }

        if let carPlayMap = FlutterCarPlaySceneDelegate.map {
            if let existing = self.carPlayTiltFollowController {
                carPlayMap.camera.removeFollowController(followController: existing)
                self.carPlayTiltFollowController = nil
            }
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
        self.navigationManager.stop()
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

/// Drives camera tilt from the current style zoom via a list of zoom→tilt control points,
/// linearly interpolating between them and clamping at the endpoints.
private final class ZoomTiltRelation: StyleZoomToTiltRelation {
    private let points: [StyleZoomTiltPoint]

    init(points: [StyleZoomTiltPoint]) {
        self.points = points.sorted { $0.styleZoom < $1.styleZoom }
    }

    func styleZoomToTilt(styleZoom: StyleZoom) -> Tilt {
        guard let first = points.first, let last = points.last else { return Tilt(value: 0) }
        let zoom = Double(styleZoom.value)
        if zoom <= first.styleZoom { return Tilt(value: Float(first.tiltDegrees)) }
        if zoom >= last.styleZoom { return Tilt(value: Float(last.tiltDegrees)) }
        for index in 0..<(points.count - 1) {
            let lower = points[index]
            let upper = points[index + 1]
            if zoom >= lower.styleZoom && zoom <= upper.styleZoom {
                let span = upper.styleZoom - lower.styleZoom
                let t = span == 0 ? 0 : (zoom - lower.styleZoom) / span
                return Tilt(value: Float(lower.tiltDegrees + t * (upper.tiltDegrees - lower.tiltDegrees)))
            }
        }
        return Tilt(value: Float(last.tiltDegrees))
    }
}
