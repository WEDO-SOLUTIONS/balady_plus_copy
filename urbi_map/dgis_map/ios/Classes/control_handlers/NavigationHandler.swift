import DGis
import Foundation

class NavigationHandler {
    private class Events {
        // event name
        static let navigationEvent = "navigationEvent"
        static let routeOptionsEvent = "routeOptionsEvent"

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

    init(map: Map, mapView: UIView & IMapView, sdk: Container, eventChannel: DgisStreamHandler, view: UIView) {
        let context = try! sdk.context
        
        self.map = map
        self.eventChannel = eventChannel
        
        self.navigationManager = try! NavigationManager(platformContext: context)
        navigationManager.alternativeRoutesProviderSettings.alternativeRoutesEnabled = false
        navigationManager.alternativeRoutesProviderSettings.betterRouteEnabled = false
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
    }
    
    private func stateChannelListener(_ state: State) {
        switch (state) {
        case State.disabled:
            self.eventChannel.success([
                "event": Events.navigationEvent,
                "state": Events.stateDisabled
            ])
        case State.finished:
            self.eventChannel.success([
                "event": Events.navigationEvent,
                "state": Events.stateFinished
            ])
        default:
            return
        }
    }
    
    private func routeInfoListener(_ routeInfo: RouteInfo) {
        self.eventChannel.success([
            "event": Events.routeOptionsEvent,
            "hasOptions": routeInfo.routeBuildOptions != nil
        ])
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
    
    func setupCamera() {
        self.prevMyLocationMapObjectSource = self.map.sources.first { $0 is MyLocationMapObjectSource } as? MyLocationMapObjectSource
        if let prevLocationSource = self.prevMyLocationMapObjectSource {
            self.map.removeSource(source: prevLocationSource)
        }
        self.map.addSource(source: self.locationSource)
                
        var position = self.map.camera.position
        position.zoom = styleZToProjectionZ(styleZ: 17.5, latitude: position.point.latitude)
        try? self.map.camera.setPosition(position: position)
        
        self.prevCameraBehaviour = self.map.camera.behaviour.newBehaviour
        self.map.camera.setBehaviour(
            behaviour: CameraBehaviour(
                position: .init(bearing: .on, styleZoom: .on)
            )
        )
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
            setupCamera()
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
            setupCamera()
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
        print("navigationManager started")
        navigationManager.stop()
        resetCamera()
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

    func toggleSounds() {
        self.dashboardControlModel.toggleSounds()
    }
}
