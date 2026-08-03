import DGis
import Foundation

class RouteHandler {
    private class Events {
        static let onActiveRouteChanged = "onActiveRouteChanged"
        static let onRoutesInfoChanged = "onRoutesInfoChanged"
    }
    private let routeEditor: RouteEditor
    private let routeEditorSource: RouteEditorSource
    private var publicTransportHandler: PublicTransportHandler?
    private let trafficRouter: TrafficRouter
    private let navigationHandler: NavigationHandler
    private let indoorControlHandler: IndoorControlHandler?

    private let locationService: LocationService
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
        navigationHandler: NavigationHandler,
        indoorControlHandler: IndoorControlHandler? = nil
    ) {
        let context = try! sdk.context

        self.locationService = try! sdk.locationService
        self.map = map
        self.eventChannel = eventChannel
        self.navigationHandler = navigationHandler
        self.indoorControlHandler = indoorControlHandler
        self.routeEditor = RouteEditor(context: context)
        self.routeEditorSource = RouteEditorSource(
            context: context, routeEditor: self.routeEditor,
            calloutLabelDisplayMode: .relativeToActiveRouteValues
        )

        self.trafficRouter = TrafficRouter.init(context: context)

        self.publicTransportHandler = PublicTransportHandler(eventChannel: eventChannel, routeHandler: self)

        
        /// Since future versions of the SDK will not support `sink`, we have to use `sinkOnMainThread`. More: https://docs.2gis.com/en/ios/sdk/examples/base#data-channels
        /// TODO: It is necessary to consider error handling for this method. See BSA-3348 issue
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

    private func getCurrentLevelId() -> LevelId? {
        return indoorControlHandler?.currentLevelId
    }

    func cancel() {
        publicTransportHandler?.stopDurationUpdates()
        cancelable.forEach { $0.cancel() }
        moveCameraCancellable?.cancel()
        cancelable.removeAll()
    }
    
    func setActiveRouteIndex(_ index: UInt64) {
        self.routeEditor.setActiveRouteIndex(index: RouteIndex(value: index))
    }
    
    func onRouteTap(_ route: RouteMapObject) {
        if navigationHandler.isNavigating {
            navigationHandler.onRouteTap(route)
        } else {
            self.routeEditor.setActiveRouteIndex(index: route.routeIndex)
        }
    }
    
    func setRoutesVisible(_ visible: Bool) {
        self.routeEditorSource.setRoutesVisible(visible: visible)
    }
    
    func setShowOnlyActiveRoute(_ visible: Bool) {
        self.routeEditorSource.setShowOnlyActiveRoute(showOnlyActiveRoute: visible)
    }

    private func createRouteSearchPoint(_ point: RouteEditorRoutePointMessage) -> RouteSearchPoint {
        return RouteSearchPoint(
            coordinates: GeoPoint(
                latitude: point.point.latitude,
                longitude: point.point.longitude
            ),
            objectId: DgisObjectId(
                objectId: UInt64(point.objectId?.objectId ?? 0),
                entranceId: UInt64(point.objectId?.entranceId ?? 0)
            ),
            levelId: point.levelId.map {
                LevelId(value: UInt64($0))
            }
        )
    }
    
    func setRouteParams(_ params: RouteEditorRouteParamsMessage) {
        let startPoint: RouteSearchPoint? = {
            if let pStartPoint = params.startPoint {
                return createRouteSearchPoint(pStartPoint)
            } else if let lastLocation = self.locationService.lastLocation?.coordinates {
                return RouteSearchPoint(
                    coordinates: GeoPoint(
                        latitude: lastLocation.value.latitude,
                        longitude: lastLocation.value.longitude
                    ),
                    levelId: getCurrentLevelId()
                )
            }

            return nil
        }()

        let finishPoint: RouteSearchPoint? = {
            if let pFinishPoint = params.finishPoint {
                return createRouteSearchPoint(pFinishPoint)
            } else if let lastLocation = self.locationService.lastLocation?.coordinates {
                return RouteSearchPoint(
                    coordinates: GeoPoint(
                        latitude: lastLocation.value.latitude,
                        longitude: lastLocation.value.longitude
                    ),
                    levelId: getCurrentLevelId()
                )
            }

            return nil
        }()

        guard let startPoint = startPoint, let finishPoint = finishPoint else {
            return
        }
        
        let routeSearchOptions = getRouteSearchOptions(opts: params.options, searchParams: params.searchParams)
        self.options = routeSearchOptions
        
        self.finishPoint = finishPoint
        
        let intermediatePoints = params.intermediatePoints?.map { createRouteSearchPoint($0)}

        let routeEditorParams = RouteEditorRouteParams(
            startPoint: startPoint,
            finishPoint: finishPoint,
            routeSearchOptions: routeSearchOptions,
            intermediatePoints: intermediatePoints ?? []
        )
        routeEditor.setRouteParams(routeParams: routeEditorParams)
        
        let showOnlyActiveRoute = params.showOnlyActiveRoute ?? true
        
        routeEditorSource.setShowOnlyActiveRoute(showOnlyActiveRoute: showOnlyActiveRoute)
    }
    
    private func getRouteSearchOptions(opts: RouteSearchOptionsMessage, searchParams: CarRouteSearchOptionParamsMessage?) -> RouteSearchOptions {
        let avoidTollRoads = searchParams?.avoidTollRoads ?? false
        let avoidUnpavedRoads = searchParams?.avoidUnpavedRoads ?? false
        let carOptions = CarRouteSearchOptions(avoidTollRoads: avoidTollRoads, avoidUnpavedRoads: avoidUnpavedRoads)

        switch opts {
        case .car:
            return .car(carOptions)
        case .bicycle:
            return .bicycle(BicycleRouteSearchOptions())
        case .pedestrian:
            return .pedestrian(PedestrianRouteSearchOptions())
        case .truck:
            return .truck(TruckRouteSearchOptions(car: carOptions))
        case .scooter:
            return .scooter(ScooterRouteSearchOptions())
        case .publicTransport:
            return .publicTransport(PublicTransportRouteSearchOptions())
        case .taxi:
            return .taxi(TaxiRouteSearchOptions(car: carOptions))
        }
    }
    
    private func onActiveRouteChanged(_ index: RouteIndex?) {
        guard let index else {
            return
        }
        
        eventChannel.success([
            "event": Events.onActiveRouteChanged,
            "index": index.value
        ])
    }
    
    private static func getPedestrianRouteData(_ route: Route) -> (Int, Int, [Int]) {
        return (
            route.roadSubtypes.entries.filter({ $0.value == .stairwayUp || $0.value == .stairwayDown }).count,
            route.obstacles.entries.count,
            route.altitudes.entries.map({ Int($0.value) })
        );
    }
    
    static func mapRouteInfo(_ route: TrafficRoute) -> [String: Any] {
        let distance = Double(route.route.geometry.last?.point.distance.millimeters ?? 0) / 1000.0
        
        var duration = 0
        if let first = route.route.geometry.first {
            duration = Int(route.traffic.durations.calculateDuration(routePoint: first.point).rounded())
        }
        
        let (stairwayCount, gateCount, altitudes) = getPedestrianRouteData(route.route)
        
        return [
            "distance": distance,
            "duration": duration,
            "stairwayCount": stairwayCount,
            "gateCount": gateCount,
            "altitudes" : altitudes
        ]
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
        
        let geometry = ComplexGeometry(geometries: geometries)
        let position = calcPosition(camera: map.camera, geometry: geometry)
        
        self.moveCameraCancellable?.cancel()
        self.moveCameraCancellable = self.map.camera.move(
            position: position
        ).sink {_ in } failure: {_ in }
        
        let mappedRoutes = routesInfo.routes.map(RouteHandler.mapRouteInfo)
        
        eventChannel.success([
            "event": Events.onRoutesInfoChanged,
            "routes": mappedRoutes
        ])
    }
    
    
    
    func getLastLocation() -> (latitude: Double, longitude: Double)? {
        guard let coords = locationService.lastLocation?.coordinates else { return nil }
        return (latitude: coords.value.latitude.value, longitude: coords.value.longitude.value)
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
    
    func moveCameraToActiveRouteIndex(_ index: UInt64) {
        
        let route = routeEditor.routesInfo.routes[Int(index)]
        
        let geometries = route.route.geometry.entries.map { entry in
            PointGeometry(point: entry.value)
        }
        
        let geometry = ComplexGeometry(geometries: geometries)
        let position = calcPosition(camera: map.camera, geometry: geometry)
        
        // We need to update zoom to make route contain the screen
        let newZoom = position.zoom.value - 1.0
        
        var updatedPosition = map.camera.position
        
        updatedPosition.zoom = Zoom(value: newZoom)
        
        
        self.moveCameraCancellable?.cancel()
        self.moveCameraCancellable = self.map.camera.move(
            position: updatedPosition
        ).sink {_ in } failure: {_ in }
    }
    
    
    func findBriefRouteInfosRouteSearchOptions(
        _ routeSearchOptions: RouteSearchOptions,
        startPoint: RouteSearchPoint?,
        finishPoint: RouteSearchPoint?,
        completion: @escaping (Result<[BriefRouteInfoMessage], any Error>)->Void)
    {
        let startSearchPoint: RouteSearchPoint
        let finishSearchPoint: RouteSearchPoint
        
        if let startPoint {
            startSearchPoint = startPoint
        } else if let lastLocation = self.locationService.lastLocation?.coordinates {
            startSearchPoint = RouteSearchPoint(
                coordinates: GeoPoint(
                    latitude: lastLocation.value.latitude,
                    longitude: lastLocation.value.longitude
                ),
                levelId: getCurrentLevelId()
            )
        } else {
            completion(
                Result.failure(
                FlutterError(
                    code: "Failed to get route information",
                    message: nil,
                    details: nil
                ))
            )
            return // Возвращаем nil или промежуточное значение в случае ошибки получения стартовой точки
        }
        
        if let finishPoint {
            finishSearchPoint = finishPoint
        } else if let lastLocation = self.locationService.lastLocation?.coordinates {
            finishSearchPoint = RouteSearchPoint(
                coordinates: GeoPoint(
                    latitude: lastLocation.value.latitude,
                    longitude: lastLocation.value.longitude
                ),
                levelId: getCurrentLevelId()
            )
        } else {
            completion(
                Result.failure(
                FlutterError(
                    code: "Failed to get route information",
                    message: nil,
                    details: nil
                ))
            )
            return // Возвращаем nil или промежуточное значение в случае ошибки получения стартовой точки
        }
        
        let briefRouteInfoSearchPoints = BriefRouteInfoSearchPoints(startPoint: startSearchPoint, finishPoint: finishSearchPoint)
        
        self.cancelable.append(trafficRouter.findBriefRouteInfos(
            searchPoints: [briefRouteInfoSearchPoints],
            routeSearchOptions: routeSearchOptions
        )
            .sink(receiveValue: {
                [weak self] response in
                guard let self = self else {
                    completion(
                        Result.failure(
                        FlutterError(
                            code: "Failed to get route information",
                            message: nil,
                            details: nil)
                    ))
                    return
                }
                
                
                let briefRouteInfoMessages = response.compactMap{v in
                    let result =  v?.toBriefRouteInfoMessage()
                    return result
                }
                
                completion(Result.success(briefRouteInfoMessages))
                
                
            }, failure: { error in
                completion(
                    Result.failure(
                    FlutterError(
                        code: "FindBriefRouteInfo error",
                        message: error.description,
                        details: nil
                    ))
                )
            })
        )
    }
    
    
    func findRoute(
        startPoint: RouteSearchPoint,
        finishPoint: RouteSearchPoint,
        routeSearchOptions: RouteSearchOptions,
        intermediatePoints: [RouteSearchPoint]?,
        completion: @escaping (Result<FindRouteResultMessage, any Error>) -> Void
    ) {
        let routesFuture = trafficRouter.findRoute(
            startPoint: startPoint,
            finishPoint: finishPoint,
            routeSearchOptions: routeSearchOptions,
            intermediatePoints: intermediatePoints ?? []
        )
        
        self.cancelable.append(routesFuture.sink { (response: [TrafficRoute]) in
            let routeInfoMessages = response.map(self.routeInfoMessages)
            let result = FindRouteResultMessage(routes: routeInfoMessages)
            completion(Result.success(result))
        } failure: { error in
            completion(
                Result.failure(
                    FlutterError(
                        code: "FindRoute error",
                        message: error.description,
                        details: nil
                    )))
            }
        )
    }
    
    func routeInfoMessages(route: TrafficRoute) -> RouteInfoMessage {
        let distance = Double(route.route.geometry.last?.point.distance.millimeters ?? 0) / 1000.0
        
        var duration = 0.0
        if let first = route.route.geometry.first {
            duration = Double(route.traffic.durations.calculateDuration(routePoint: first.point))
        }
        
        let (stairwayCount, gateCount, altitudes) = RouteHandler.getPedestrianRouteData(route.route)
        
        let publicTransportTransfers = route.route.publicTransportTransfers.entries.map { transfer in
            transfer.toMessage.value
        }
        
        return RouteInfoMessage(
            distance: distance,
            duration: duration,
            stairwayCount: Int64(stairwayCount),
            gateCount: Int64(gateCount),
            altitudes:  altitudes.map { Int64($0)},
            publicTransportTransfers: publicTransportTransfers
        )
    }
}
