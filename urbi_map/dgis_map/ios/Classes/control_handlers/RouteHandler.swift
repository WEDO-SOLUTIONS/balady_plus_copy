import DGis
import Foundation

class RouteHandler {
    private class Events {
        static let onRouteChanged = "onRouteChanged"
    }
    
    private let positioningService: PlatformPositioningServicesFactory
    private let routeEditor: RouteEditor
    private let routeEditorSource: RouteEditorSource
    private var publicTransportHandler: PublicTransportHandler?
    
    private let map: Map
    private let eventChannel: DgisStreamHandler
    
    private var cancelable: Array<Cancellable> = []
    private var moveCameraCancellable: DGis.Cancellable?
    
    private(set) var options: RouteSearchOptions?
    private(set) var finishPoint: RouteSearchPoint?
    
    var selectedRoute: TrafficRoute? {
        get {
            guard let routeIndex = self.routeEditor.activeRouteIndex?.value else {
                return nil
            }
            
            return self.routeEditor.routesInfo.routes[Int(routeIndex)]
        }
    }
    
    init(
        map: Map,
        sdk: Container,
        eventChannel: DgisStreamHandler,
        positioningService: PlatformPositioningServicesFactory
    ) {
        let context = try! sdk.context
        
        self.map = map
        self.eventChannel = eventChannel
        self.routeEditor = RouteEditor(context: context)
        self.routeEditorSource = RouteEditorSource(
            context: context, routeEditor: self.routeEditor
        )
        self.positioningService = positioningService
        
        self.publicTransportHandler = PublicTransportHandler(eventChannel: eventChannel, routeHandler: self)
        
        cancelable.append(self.routeEditor.routesInfoChannel.sink { [weak self] info in
            if case .publicTransport = self?.options {
                self?.publicTransportHandler?.onRoutesChanged()
            }
            self?.onRoutesInfoChanged(info)
        })
        cancelable.append(self.routeEditor.activeRouteIndexChannel.sink { [weak self] index in
            if case .publicTransport = self?.options {
                self?.publicTransportHandler?.onActiveRouteChanged()
            }
            self?.onActiveRouteChanged(index)
        })

        self.map.addSource(source: routeEditorSource)
        
    }
    
    func cancel() {
        cancelable.forEach { $0.cancel() }
        moveCameraCancellable?.cancel()
        cancelable.removeAll()
    }
    
    func setActiveRouteIndex(_ index: UInt64) {
        self.routeEditor.setActiveRouteIndex(index: RouteIndex(value: index))
    }
    
    func onRouteTap(_ route: RouteMapObject) {
        self.routeEditor.setActiveRouteIndex(index: route.routeIndex)
    }
    
    func setRoutesVisible(_ visible: Bool) {
        self.routeEditorSource.setRoutesVisible(visible: visible)
    }
    
    func setRouteParams(_ params: RouteEditorRouteParamsMessage) {
        let startPoint: RouteSearchPoint? = {
            if let pStartPoint = params.startPoint {
                return RouteSearchPoint(coordinates: GeoPoint(
                    latitude: pStartPoint.latitude.doubleValue,
                    longitude: pStartPoint.longitude.doubleValue
                ))
            } else if let lastLocation = positioningService.locationProvider?.lastLocation?.coordinate {
                return RouteSearchPoint(coordinates: GeoPoint(
                    latitude: lastLocation.latitude,
                    longitude: lastLocation.longitude
                ))
            }
            
            return nil
        }()
        
        let finishPoint: RouteSearchPoint? = {
            if let pFinishPoint = params.finishPoint {
                return RouteSearchPoint(coordinates: GeoPoint(
                    latitude: pFinishPoint.latitude.doubleValue,
                    longitude: pFinishPoint.longitude.doubleValue
                ))
            } else if let lastLocation = positioningService.locationProvider?.lastLocation?.coordinate {
                return RouteSearchPoint(coordinates: GeoPoint(
                    latitude: lastLocation.latitude,
                    longitude: lastLocation.longitude
                ))
            }
            
            return nil
        }()
        
        guard let startPoint = startPoint, let finishPoint = finishPoint else {
            return
        }
        
        let routeSearchOptions = getRouteSearchOptions(opts: params.options)
        self.options = routeSearchOptions
        
        self.finishPoint = finishPoint
        
        let routeEditorParams = RouteEditorRouteParams(
            startPoint: startPoint,
            finishPoint: finishPoint,
            routeSearchOptions: routeSearchOptions,
            intermediatePoints: []
        )
        routeEditor.setRouteParams(routeParams: routeEditorParams)
        routeEditorSource.setRoutesVisible(visible: true)
        routeEditorSource.setShowOnlyActiveRoute(showOnlyActiveRoute: params.options == .publicTransport)
    }
    
    private func getRouteSearchOptions(opts: RouteSearchOptionsMessage) -> RouteSearchOptions {
        switch opts {
        case .car:
            return RouteSearchOptions.car(CarRouteSearchOptions())
        case .bicycle:
            return RouteSearchOptions.bicycle(BicycleRouteSearchOptions())
        case .pedestrian:
            return RouteSearchOptions.pedestrian(PedestrianRouteSearchOptions())
        case .truck:
            return RouteSearchOptions.truck(TruckRouteSearchOptions(car: CarRouteSearchOptions()))
        case .scooter:
            return RouteSearchOptions.scooter(ScooterRouteSearchOptions())
        case .publicTransport:
            return RouteSearchOptions.publicTransport(PublicTransportRouteSearchOptions(
                transportTypes: .init()
            ))
        case .taxi:
            return RouteSearchOptions.taxi(TaxiRouteSearchOptions(car: CarRouteSearchOptions()))
        }
    }
    
    private func onActiveRouteChanged(_ index: RouteIndex?) {
        guard let index else {
            return
        }
        let route = routeEditor.routesInfo.routes[Int(index.value)]
        
        let distance = Double(route.route.geometry.last?.point.distance.millimeters ?? 0) / 1000.0
        
        var duration = 0
        if let first = route.route.geometry.first {
            duration = Int(route.traffic.durations.calculateDuration(routePoint: first.point).rounded())
        }
        
        let (stairwayCount, gateCount, altitudes) = getPedestrianRouteData(route.route)
        
        eventChannel.success([
            "event": Events.onRouteChanged,
            "distance": distance,
            "duration": duration,
            "stairwayCount": stairwayCount,
            "gateCount": gateCount,
            "altitudes" : altitudes
        ])
    }
    
    private func getPedestrianRouteData(_ route: Route) -> (Int, Int, [Int]) {
        return (
            route.roadSubtypes.entries.filter({ $0.value == .stairway }).count,
            route.obstacles.entries.count,
            route.altitudes.entries.map({ Int($0.value) })
        );
    }
    
    private func onRoutesInfoChanged(_ routesInfo: RouteEditorRoutesInfo) {
        guard !routesInfo.routes.isEmpty else {
            return
        }
        
        let geometries = routesInfo.routes.map { route in
            route.route.geometry.entries.map { entry in
                PointGeometry(point: entry.value)
            }
        }.flatMap { $0 }
        
        let density = UIScreen.main.scale
        let dpQuantity = UInt32(50 * density)
        let padding = Padding(left: dpQuantity, top: dpQuantity, right: dpQuantity, bottom: dpQuantity)
        
        let geometry = ComplexGeometry(geometries: geometries)
        self.map.camera.padding = padding
        let position = calcPosition(camera: map.camera, geometry: geometry)
        
        self.moveCameraCancellable?.cancel()
        self.moveCameraCancellable = self.map.camera.move(
            position: position
        ).sink {_ in } failure: {_ in }
    }
    
    func getActivePublicTransportRoute() -> TrafficRoute? {
        guard let routeIndex = routeEditor.activeRouteIndex else {
            return nil
        }
        
        return routeEditor.routesInfo.routes[Int(routeIndex.value)]
    }
    
    func getPublicTransportRoutes() -> [TrafficRoute] {
        return routeEditor.routesInfo.routes.filter {
            !$0.route.publicTransportTransfers.isEmpty
        }
    }
}
