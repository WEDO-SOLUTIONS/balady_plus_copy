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
    
    private var prevCameraBehaviour: CameraPosition?
    
    private var cancelable: Array<Cancellable> = []
    private var moveCameraCancellable: DGis.Cancellable?
    
    // Models to observe channels and send events to Flutter
    private let speedControlModel: SpeedControlModel
    private let dashboardControlModel: DashboardControlModel
    private let messageControlModel: MessageControlModel
    private let maneuverControlModel: ManeuverControlModel

    init(map: Map, mapView: UIView & IMapView, sdk: Container, eventChannel: DgisStreamHandler, view: UIView) {
        self.map = map
        self.eventChannel = eventChannel
        
        self.navigationManager = NavigationManager(platformContext: sdk.context)
        navigationManager.alternativeRoutesProviderSettings.alternativeRoutesEnabled = false
        navigationManager.alternativeRoutesProviderSettings.betterRouteEnabled = false
        self.navigationManager.mapManager.addMap(map: self.map)
        
        let navigationViewFactory = sdk.makeNavigationViewFactory()
        
        let locationSource = MyLocationMapObjectSource(
            context: sdk.context,
            directionBehaviour: .followSatelliteHeading,
            controller: createSmoothMyLocationController()
        )
        self.map.addSource(source: locationSource)

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
        
        self.prevCameraBehaviour = self.map.camera.position
        self.navigationManager.start(
            routeBuildOptions: RouteBuildOptions(
                finishPoint: finishPoint,
                routeSearchOptions: options
            ),
            trafficRoute: route
        )
        
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
        
        self.prevCameraBehaviour = self.map.camera.position
        self.navigationManager.startSimulation(
            routeBuildOptions: RouteBuildOptions(
                finishPoint: finishPoint,
                routeSearchOptions: options
            ),
            trafficRoute: route
        )
        
        completion(nil)
    }
    
    func stopNavigation() {
        print("navigationManager started")
        navigationManager.stop()
        
        guard let prevCameraBehaviour = self.prevCameraBehaviour else {
            print("prevCameraBehaviour failed")
            return
        }
        print("prevCameraBehaviour init \(prevCameraBehaviour)")
        self.moveCameraCancellable?.cancel()
        self.moveCameraCancellable = self.map.camera.move(
            position: prevCameraBehaviour,
            time: 0.25,
            animationType: .default
        ).sink {_ in
            print("prevCameraBehaviour after camera moved \(prevCameraBehaviour)")
            /// TODO: вот здесь мы якобы двигаем камеру, но по сути ничего не происходит и она все равно улетает в universe
            print("camera moved")
        } failure: {_ in
            print("moving failed")
        }
    }

    func startFreeRoam() {
        self.navigationManager.start()
    }

    func stopFreeRoam() {
        self.navigationManager.stop()
    }

    func toggleSounds() {
        self.dashboardControlModel.toggleSounds()
    }
}
