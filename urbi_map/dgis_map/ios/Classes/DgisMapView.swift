import Foundation
import Flutter
import DGis

class DgisMapView: NSObject, FlutterPlatformView, MapApi {
    private class Events {
        static let zoomOutEvent = "zoomOutState"
        static let zoomInEvent = "zoomInState"
        static let myLocationEnabledState = "myLocationEnabledState"
        static let myLocationFollowState = "myLocationFollowState"
        static let activeLevelIndex = "activeLevelIndex"
        static let levelNames = "levelNames"
    }
    
    private var _view: UIView
    private let sdk: Container
    private let registrar: FlutterPluginRegistrar
    
    private var wasInitialized = false
    private var errorDescription = ""
    
    private var eventChannel: DgisStreamHandler?
    
    private var cancelable: Array<Cancellable> = []
    
    private var map: Map?
    private var mapView: (UIView & IMapView)?
    
    private var zoomControlHandler: ZoomControlHandler?
    private var locationControlHandler: LocationControlHandler?
    private var indoorControlHandler: IndoorControlHandler?
    private var routeHandler: RouteHandler?
    private var navigationHandler: NavigationHandler?
    private var searchHandler: SearchHandler?

    private var objectTapHandler: ObjectTapHandler?
    private var visibleRectHandler: VisibleRectHandler?

    private let everGisLayerHandler: EverGisLayerHandler
    private var compassControlHandler: CompassControlHandler?
    private var trafficAndParkingControlHandler: TrafficAndParkingControlHandler?

    private lazy var positioningService = PlatformPositioningServicesFactory()
    
    private var moveCameraCancellable: DGis.Cancellable?
    
    init(
        dgisSdk sdk: Container,
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        registrar: FlutterPluginRegistrar
    ) {
        self._view = UIView(frame: frame)
        self.sdk = sdk
        self.registrar = registrar
        self.everGisLayerHandler = EverGisLayerHandler(sdkContext: sdk.context)
        super.init()
        
        self.eventChannel = DgisStreamHandler(
            viewId: viewId,
            messenger: registrar.messenger(),
            completion: onEventChannelReady
        )
        
        MapApiSetup(registrar.messenger(), self)
        createMapView(sdk)
    }
    
    deinit {
        self.zoomControlHandler?.cancel()
        self.locationControlHandler?.cancel()
        self.indoorControlHandler?.cancel()
        self.visibleRectHandler?.cancel()
        self.routeHandler?.cancel()
        self.navigationHandler?.cancel()
        self.compassControlHandler?.cancel()
        self.trafficAndParkingControlHandler?.cancel()
    }
    
    // MARK: - Controls initialize
    private func onEventChannelReady() {
        guard let map = self.map, let mapView = self.mapView, let eventChannel = self.eventChannel else { return }
        
        self.zoomControlHandler = ZoomControlHandler(
            map: map,
            eventChannel: eventChannel
        )
        
        self.locationControlHandler = LocationControlHandler(
            map: map,
            eventChannel: eventChannel
        )
        
        self.indoorControlHandler = IndoorControlHandler(
            manager: map.indoorManager,
            eventChannel: eventChannel
        )
        
        self.visibleRectHandler = VisibleRectHandler(
            map: map,
            eventChannel: eventChannel
        )
        
        self.routeHandler = RouteHandler(
            map: map,
            sdk: self.sdk,
            eventChannel: eventChannel,
            positioningService: self.positioningService
        )
        
        self.navigationHandler = NavigationHandler(
            map: map,
            mapView: mapView,
            sdk: self.sdk,
            eventChannel: eventChannel,
            view: self._view
        )
        
        self.searchHandler = SearchHandler(
            searchManager: SearchManager.createOnlineManager(context: sdk.context),
            map: map,
            sdkContext: self.sdk,
            imageFactory: self.sdk.imageFactory
        )
        
        self.compassControlHandler = CompassControlHandler(
            map: map,
            eventChannel: eventChannel
        )

        self.trafficAndParkingControlHandler = TrafficAndParkingControlHandler(
            map: map,
            eventChannel: eventChannel
        )

        setupTapHandler()
    }
    
    func view() -> UIView {
        return self._view
    }
    
    func initialize(completion: @escaping (InitializeMessage?, FlutterError?) -> Void) {
        completion(
            InitializeMessage.make(
                withWasInitialized: NSNumber(value: self.wasInitialized),
                errorDescription: self.errorDescription
            ),
            nil
        )
    }
    
    // MARK: - MapApi
    func zoomDownType(_ type: ZoomControlMessage, completion: @escaping (FlutterError?) -> Void) {
        self.zoomControlHandler?.onZoomDown(type)
        completion(nil)
    }
    
    func zoomUpType(_ type: ZoomControlMessage, completion: @escaping (FlutterError?) -> Void) {
        self.zoomControlHandler?.onZoomUp(type)
        completion(nil)
    }
    
    func changeFollowState(completion: @escaping (FlutterError?) -> Void) {
        self.locationControlHandler?.changeFollowState()
        completion(nil)
    }
    
    func selectIndoorLevelIndex(_ index: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        self.indoorControlHandler?.selectIndoorLevel(index: index.uint64Value)
        completion(nil)
    }
    
    func loadStylesAsset(_ asset: String, completion: @escaping (FlutterError?) -> Void) {
        let assetKey = self.registrar.lookupKey(forAsset: asset)
        
        guard let assetPath = Bundle.main.path(forResource: assetKey, ofType: nil) else { return }
        
        let styleFuture = self.sdk.makeStyleFactory().loadFile(path: assetPath)
        cancelable.append(
            styleFuture.sink (
                receiveValue: { [map = self.map] style in
                    map?.style = style
                    completion(nil)
                },
                failure: { error in
                    completion(FlutterError(
                        code: "FileNotFoundException",
                        message: "Failed to load style from <\(assetPath)>. Error: \(error)",
                        details: nil
                    ))
                })
        )
    }
    
    func overrideLocalesLocales(_ locales: [String], completion: @escaping (FlutterError?) -> Void) {
        let manager = getLocaleManager(context: sdk.context)
        manager.overrideLocales(locales: locales)
        
        completion(nil)
    }
    
    func setCameraPositionCameraPosition(
        _ cameraPosition: CameraPositionMessage,
        completion: @escaping (FlutterError?) -> Void
    ) {
        guard let map = self.map else {
            completion(FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }
        var desiredPosition = map.camera.position
        desiredPosition.point = GeoPoint(
            latitude: Latitude(value: cameraPosition.geoPoint.latitude.doubleValue),
            longitude: Longitude(value: cameraPosition.geoPoint.longitude.doubleValue)
        )
        desiredPosition.zoom = Zoom(value: cameraPosition.zoomValue.floatValue)
        map.camera.position = desiredPosition
        completion(nil)
        
    }
    
    func search(
        byObjectIdObjectId objectId: DgisObjectIdMessage,
        completion: @escaping (ObjectInfoMessage?, FlutterError?) -> Void
    ) {
        guard let searchHandler = self.searchHandler else {
            completion(nil, FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }
        searchHandler.searchByDirectoryObjectId(
            objectId: DgisObjectId(
                objectId: objectId.objectId.uint64Value,
                entranceId: objectId.entranceId.uint64Value
            ),
            completion: completion
        )
    }
    
    func getDistanceToPoints(
        _ points: [DistanceRequestMessage],
        completion: @escaping ([DistanceResponseMessage]?, FlutterError?) -> Void
    ) {
        guard let searchHandler = self.searchHandler else {
            completion(nil, FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }
        searchHandler.getDistanceTo(
            points: points,
            location: positioningService.locationProvider?.lastLocation?.coordinate,
            completion: completion
        )
    }
    
    func searchQueryText(
        _ queryText: String,
        weekTime: WeekTimeSearchMessage?,
        sortingType: SortingTypeMessage,
        pageSize: NSNumber,
        completion: @escaping ([ObjectInfoMessage]?, FlutterError?) -> Void
    ) {
        guard let map = self.map, let searchHandler = self.searchHandler else {
            completion(
                nil,
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
            return
        }
        
        searchHandler.search(
            queryText,
            searchGeoRect: map.camera.visibleRect,
            weekTimeMessage: weekTime,
            sortingType: sortingType,
            pageSize: pageSize.int32Value,
            completion: completion
        )
    }
    
    func getNextPage(completion: @escaping ([ObjectInfoMessage]?, FlutterError?) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(nil, FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }
        searchHandler.getNextPage(completion: completion)
    }
    
    func setMarkerOptionsOptions(
        _ markerOptions: MarkerOptionsMessage,
        completion: @escaping (FlutterError?) -> Void
    ) {
        let assetKey = registrar.lookupKey(forAsset: markerOptions.svgAsset)
        
        self.objectTapHandler?.setMarkerOptions(
            assetKey: assetKey,
            svgSize: CGSize(
                width: markerOptions.width.doubleValue,
                height: markerOptions.height.doubleValue
            ),
            iconWidth: markerOptions.iconWidth.floatValue,
            imageFactory: self.sdk.imageFactory,
            completion: completion
        )
    }
    
    func addMarkerGeoPoint(_ geoPoint: GeoPointMessage, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addMarker(geoPoint, completion: completion)
    }
    
    func setHighlightedObjectIds(_ objectIds: [DgisObjectIdMessage], completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.setHighlighted(
            objectIds.map({
                DgisObjectId(
                    objectId: $0.objectId.uint64Value,
                    entranceId: $0.entranceId.uint64Value
                )
            }),
            completion
        )
    }
    
    func getLayersWithCompletion(_ completion: @escaping ([EverGisLayerMessage]?, FlutterError?) -> Void) {
        guard let map = self.map else {
            completion(
                nil,
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
            return
        }
        self.everGisLayerHandler.getLayers(map, completion)
    }
    
    func setLayerVisibleAlias(_ alias: String, visible: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        self.everGisLayerHandler.setLayerVisible(
            alias: alias,
            isVisible: visible.boolValue,
            completion: completion
        )
    }
    
    func removeAllMarkers(completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removeAllMarkers()
        completion(nil)
    }
    
    func removeSearchMarkers(completion: @escaping (FlutterError?) -> Void) {
        self.searchHandler?.removeSearchMarkers()
        completion(nil)
    }
    
    func fetchSuggestsQueryText(
        _ queryText: String,
        completion: @escaping ([SuggestMessage]?, FlutterError?) -> Void
    ) {
        guard let map = self.map, let searchHandler = self.searchHandler else {
            completion(
                nil,
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
            return
        }
    
        searchHandler.fetchSuggests(
            queryText: queryText,
            searchGeoRect: map.camera.visibleRect,
            completion: completion
        )
    }
    
    func addPanoramasMarkersMessage(_ message: AddMarkersWithPhotoMessage, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addPanoramasMarkers(message)
        completion(nil)
    }
    
    func hidePanoramasMarkers(completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.hidePanoramasMarkers()
        completion(nil)    }
    
    func showPanoramasMarkers(completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.showPanoramasMarkers()
        completion(nil)
    }
    
    func removePanoramasMarkers(completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removePanoramasMarkers()
        completion(nil)
        
    }
    
    func setPanoramasPaddingsMessage(_ message: CameraSetPaddingMessage, completion: @escaping (FlutterError?) -> Void) {
        guard let map = self.map else { return }
        self.objectTapHandler?.setPanoramasPadding(map: map, message: message)
        completion(nil)
    }
    
    func moveCameraToSelectedPanorama(completion: @escaping (FlutterError?) -> Void) {
        guard let map = self.map else { return }
        self.objectTapHandler?.moveCameraToSelectedPanorama(map: map)
        completion(nil)
    }
    
    
    func unselectPanorama(completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.unselectPanorama()
        completion(nil)
    }
    
    func setPanoramaMarkerAzimuthMessage(_ message: MarkerAzimuthMessage, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.setPanoramasAzimuth(degrees: message.degree.doubleValue)
        completion(nil)
    }
    
    func overlapped(byOuterRect outerRect: VisibleRectMessage, innerRect: VisibleRectMessage, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        let outer = GeoRect(
            southWestPoint:
                GeoPoint(
                    latitude: Latitude(value: outerRect.southWest.latitude.doubleValue),
                    longitude: Longitude(value: outerRect.southWest.longitude.doubleValue)),
            northEastPoint:
                GeoPoint(
                    latitude: Latitude(value: outerRect.northEast.latitude.doubleValue),
                    longitude: Longitude(value: outerRect.northEast.longitude.doubleValue)))
        
        let inner = GeoRect(
            southWestPoint:
                GeoPoint(
                    latitude: Latitude(value: innerRect.southWest.latitude.doubleValue),
                    longitude: Longitude(value: innerRect.southWest.longitude.doubleValue)),
            northEastPoint:
                GeoPoint(
                    latitude: Latitude(value: innerRect.northEast.latitude.doubleValue),
                    longitude: Longitude(value: innerRect.northEast.longitude.doubleValue)))
        
        completion(outer.contains(rect2: inner) ? 1 : 0, nil)
    }
    
    func getSuggestObjectIndex(
        _ index: NSNumber,
        completion: @escaping (ObjectInfoMessage?, FlutterError?) -> Void
    ) {
        guard let searchHandler = self.searchHandler else {
            completion(nil, FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }
        searchHandler.getSuggestObject(index.intValue, completion: completion)
    }
    
    func search(
        bySuggestIndex index: NSNumber,
        weekTime: WeekTimeSearchMessage?,
        sortingType: SortingTypeMessage,
        pageSize: NSNumber,
        completion: @escaping ([ObjectInfoMessage]?, FlutterError?) -> Void
    ) {
        guard let map = self.map, let searchHandler = self.searchHandler else {
            completion(
                nil,
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
            return
        }
        
        searchHandler.search(
            bySuggestIndex: index.intValue,
            weekTime: weekTime,
            sortingType: sortingType,
            pageSize: pageSize.int32Value,
            searchGeoRect: map.camera.visibleRect,
            completion: completion
        )
    }
    
    func onLocationPremissionGrantedDesiredAccuracy(
        _ desiredAccuracy: DesiredAccuracyMessage,
        completion: @escaping (FlutterError?) -> Void
    ) {
        guard let locationProvider = self.positioningService.locationProvider else {
            completion(FlutterError(
                code: "LocationError",
                message: "PlatformPositioningServicesFactory cannot be created",
                details: nil
            ))
            return
        }
        locationProvider.setDesiredAccuracy(desiredAccuracy.toSdkAccuracy())
        completion(nil)
    }
    
    func showLastSearchMarker(completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.showLastSearchMarker()
        completion(nil)
    }
    
    // MARK: - Directory filters
    func getDirectoryDynamicFilters(completion: @escaping ([FlagFilterMessage]?, FlutterError?) -> Void) {
        self.searchHandler?.getDirectoryDynamicFilters(completion)
    }

    func applyDirectoryFiltersFilters(_ filters: [FlagFilterMessage], isOpenFilter: WorkingFilterMessage, sortingType: SortingTypeMessage, completion: @escaping ([ObjectInfoMessage]?, FlutterError?) -> Void) {
        self.searchHandler?.applyDirectoryFiltersFilters(
            filters: filters,
            isOpenFilter: isOpenFilter,
            sortingType: sortingType,
            completion: completion
        )
    }

    // MARK: - EverGis layer filters
    func applyEverGisFiltersLayerAlias(
        _ layerAlias: String,
        stringFilters: [EGStringFilterMessage],
        doubleFilters: [EGDoubleFilterMessage],
        intFilters: [EGIntFilterMessage],
        dateRangeFilters: [EGDateRangeFilterMessage],
        complexDateFilters: [EGComplexDateFilterMessage],
        completion: @escaping (FlutterError?) -> Void
    ) {
        self.everGisLayerHandler.applyEverGisFiltersLayerAlias(
            layerAlias: layerAlias,
            stringFilters: stringFilters,
            doubleFilters: doubleFilters,
            intFilters: intFilters,
            dateRangeFilters: dateRangeFilters,
            complexDateFilters: complexDateFilters,
            completion: completion
        )
    }

    // MARK: - Private methods
    private func createMapView(_ sdk:  DGis.Container) {
        guard let mapFactory = try? sdk.makeMapFactory(options: MapOptions.default) else {
            self.wasInitialized = false
            self.errorDescription = "Error creating MapFactory"
            return
        }
        
        let map = mapFactory.map
        map.addSource(source: MyLocationMapObjectSource(
            context: sdk.context,
            directionBehaviour: .followMagneticHeading
        ))
        self.map = map
        
        let mapView = mapFactory.mapView
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self._view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: self._view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: self._view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: self._view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self._view.bottomAnchor),
        ])
        self.mapView = mapView
        
        self.wasInitialized = true
    }
    
    private func setupTapHandler() {
        guard let mapView = self.mapView,
              let eventChannel = self.eventChannel,
              let map = self.map else {
            self.wasInitialized = false
            self.errorDescription = "MapView was not initialized properly"
            return
        }
        
        let objectTapHandler = ObjectTapHandler(
            objectManager: MapObjectManager(map: map),
            panoramasMapObjectManager:
                MapObjectManager.withGeneralization(
                    map: map,
                    logicalPixel: LogicalPixel(value: 20),
                    maxZoom: Zoom(value: 18)),
            imageFactory: self.sdk.imageFactory,
            routeHandler: self.routeHandler,
            eventChannel: eventChannel
        )
        
        mapView.addObjectTappedCallback(callback: MapObjectTappedCallback(
            callback: objectTapHandler.objectTapListener(_:)))
        
        self.objectTapHandler = objectTapHandler
    }
    
    func setRouteParamsParams(_ params: RouteEditorRouteParamsMessage, completion: @escaping (FlutterError?) -> Void) {
        self.routeHandler?.setRouteParams(params)
        completion(nil);
    }
    
    func hideRoutes(completion: @escaping (FlutterError?) -> Void) {
        self.routeHandler?.setRoutesVisible(false)
    }
    
    func startNavigation(completion: @escaping (FlutterError?) -> Void) {
        guard let routeHandler = self.routeHandler else {
            completion(FlutterError(
                code: "NavigationError",
                message: "RouteHandler not initialized",
                details: nil
            ))
            return
        }
        
        self.routeHandler?.setRoutesVisible(false)
        self.navigationHandler?.startNavigation(
            finishPoint: routeHandler.finishPoint,
            options: routeHandler.options,
            route: routeHandler.selectedRoute,
            completion: completion
        )
    }
    
    func startNavigationSimulation(completion: @escaping (FlutterError?) -> Void) {
        guard let routeHandler = self.routeHandler else {
            completion(FlutterError(
                code: "NavigationError",
                message: "RouteHandler not initialized",
                details: nil
            ))
            return
        }
        
        self.routeHandler?.setRoutesVisible(false)
        self.navigationHandler?.startSimulation(
            finishPoint: routeHandler.finishPoint,
            options: routeHandler.options,
            route: routeHandler.selectedRoute,
            completion: completion
        )
    }
    
    func stopNavigation(completion: @escaping (FlutterError?) -> Void) {
        self.navigationHandler?.stopNavigation()
        completion(nil)
    }
    
    func onCompassClicked(completion: @escaping (FlutterError?) -> Void) {
        self.compassControlHandler?.onClicked()
        completion(nil)
    }

    func startFreeRoam(completion: @escaping (FlutterError?) -> Void) {
        self.navigationHandler?.startFreeRoam()
        completion(nil)
    }

    func stopFreeRoam(completion: @escaping (FlutterError?) -> Void) {
        self.navigationHandler?.stopFreeRoam()
        completion(nil)
    }

    func toggleSound(completion: @escaping (FlutterError?) -> Void) {
        self.navigationHandler?.toggleSounds()
        completion(nil)
    }

    func setPublicTransportActiveRouteRouteIndex(_ routeIndex: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        routeHandler?.setActiveRouteIndex(routeIndex.uint64Value)
        completion(nil)
    }

    func onTrafficAndParkingAttached(completion: @escaping (FlutterError?) -> Void) {
        self.trafficAndParkingControlHandler?.onAttachToMap()
        completion(nil)
    }

    func onTrafficAndParkingDetached(completion: @escaping (FlutterError?) -> Void) {
        self.trafficAndParkingControlHandler?.onDetachFromMap()
        completion(nil)
    }

    func onParkingClicked(completion: @escaping (FlutterError?) -> Void) {
        self.trafficAndParkingControlHandler?.onParkingClicked()
        completion(nil)
    }

    func onTrafficClicked(completion: @escaping (FlutterError?) -> Void) {
        self.trafficAndParkingControlHandler?.onTrafficClicked()
        completion(nil)
    }
}
