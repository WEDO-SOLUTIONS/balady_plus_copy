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
        let context = try! sdk.context
        self.registrar = registrar
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
            searchManager: try! SearchManager.createOnlineManager(context: try! sdk.context),
            map: map,
            sdkContext: self.sdk
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
        
        let styleFuture = try! self.sdk.makeStyleFactory().loadFile(path: assetPath)
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
        let manager = getLocaleManager(context: try! sdk.context)
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
        do {
            try map.camera.setPosition(position: desiredPosition)
        } catch {
            completion(FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }
        completion(nil)
        
    }
    
    func search(
        byObjectIdObjectId objectId: DgisObjectIdMessage,
        completion: @escaping (DirectoryObjectMessage?, FlutterError?) -> Void
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
    
    func search(
        byCategoryCategory category:
        SearchCategoryMessage,
        weekTime: WeekTimeSearchMessage?,
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: NSNumber,
        completion: @escaping (SearchResultMessage?, FlutterError?) -> Void
    ) {
        guard let searchHandler = self.searchHandler else {
            completion(nil, FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }
        searchHandler.searchByCategories(
            category.toRubrics(),
            searchGeoRect: searchRect?.geoRect,
            weekTimeMessage: weekTime,
            sortingType: sortingType,
            pageSize: pageSize.int32Value,
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
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: NSNumber,
        completion: @escaping (SearchResultMessage?, FlutterError?) -> Void
    ) {
        guard let searchHandler = self.searchHandler else {
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
            searchGeoRect: searchRect?.geoRect,
            weekTimeMessage: weekTime,
            sortingType: sortingType,
            pageSize: pageSize.int32Value,
            completion: completion
        )
    }
    
    func search(
        byQueryQuery query: SearchQueryMessage,
        weekTime: WeekTimeSearchMessage?,
        searchRect: GeoRectMessage?,
        sortingType: SortingTypeMessage,
        pageSize: NSNumber,
        completion: @escaping (SearchResultMessage?, FlutterError?) -> Void
    ) {
        guard let searchHandler = self.searchHandler else {
            completion(
                nil,
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
            return
        }
        
        searchHandler.searchByQuery(
            query,
            searchGeoRect: searchRect?.geoRect,
            weekTimeMessage: weekTime,
            sortingType: sortingType,
            pageSize: pageSize.int32Value,
            completion: completion
        )
    }
    
    func fetchNextPagePageId(_ pageId: PageIdMessage, completion: @escaping (PageMessage?, FlutterError?) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                nil,
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
            return
        }
        
        searchHandler.fetchNextPage(pageId, completion: completion)
    }
    
    func fetchPrevPagePageId(_ pageId: PageIdMessage, completion: @escaping (PageMessage?, FlutterError?) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                nil,
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
            return
        }
        
        searchHandler.fetchPrevPage(pageId, completion: completion)
    }
    
    func releasePagePageId(_ pageId: PageIdMessage, completion: @escaping (FlutterError?) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
            return
        }
        
        searchHandler.releasePage(pageId, completion: completion)
    }
    
    func fetchSuggestsQueryText(
        _ queryText: String,
        searchRect: GeoRectMessage?,
        completion: @escaping (SuggestResultMessage?, FlutterError?) -> Void
    ) {
        guard let searchHandler = self.searchHandler else {
            completion(
                nil,
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                )
            )
            return
        }

        searchHandler.fetchSuggests(
            queryText: queryText,
            searchGeoRect: searchRect?.geoRect,
            completion: completion
        )
    }
    
    func setMarkerOptionsOptions(
        _ markerOptions: MarkerOptionsMessageOld,
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
            completion: completion
        )
    }
    
    func addMarkerMarker(_ marker: MarkerMessage, completion: @escaping (FlutterError?) -> Void) {
         self.objectTapHandler?.addMarker(marker, completion: completion)
    }
    
    func addMarkersMarkers(_ markers: [MarkerMessage], completion: @escaping (FlutterError?) -> Void) {
         self.objectTapHandler?.addMarkers(markers, completion: completion)
    }
    
    func removeMarkerId(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removeMarker(id, completion: completion)
    }
    
    func addPolygonPolygon(_ polygon: PolygonMessage, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addPolygon(polygon, completion: completion)
    }
    
    func addPolygonsPolygons(_ polygons: [PolygonMessage], completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addPolygons(polygons, completion: completion)
    }
    
    func removePolygonId(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removePolygon(id, completion: completion)
    }
    
    func addPolylinePolyline(_ polyline: PolylineMessage, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addPolyline(polyline, completion: completion)
    }
    
    func addPolylinesPolylines(_ polylines: [PolylineMessage], completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addPolylines(polylines, completion: completion)
    }
    
    func removePolylineId(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removePolyline(id, completion: completion)
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
    
    func removeAllMarkers(completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removeAllMarkers()
        completion(nil)
    }
    
    func removeAllPolygons(completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removeAllPolygons()
        completion(nil)
    }
    
    func removeAllPolylines(completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removeAllPolylines()
        completion(nil)
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
    
    func showEsriIOLayerMessage(_ message: AddLayerPointObjectsMessage, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addIoMarkers(message, completion)
    }
    
    func removeEsriIOLayer(completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removeAllMarkers()
        completion(nil)
    }
    
    func setPanoramaMarkerAzimuthMessage(_ message: MarkerAzimuthMessage, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.setPanoramasAzimuth(degrees: message.degree.doubleValue)
        completion(nil)
    }
    
    func overlapped(byOuterRect outerRect: GeoRectMessage, innerRect: GeoRectMessage, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        let outer = outerRect.geoRect
        
        let inner = innerRect.geoRect
        
        completion(outer.contains(rect2: inner) ? 1 : 0, nil)
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
    
    // MARK: - Private methods
    private func createMapView(_ sdk:  DGis.Container) {
        guard let mapFactory = try? sdk.makeMapFactory(options: MapOptions.default), let context = try? sdk.context else {
            self.wasInitialized = false
            self.errorDescription = "Error creating MapFactory"
            return
        }
        
        let map = mapFactory.map
        map.addSource(source: MyLocationMapObjectSource(
            context: context,
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
            objectManager:
                MapObjectManager.withGeneralization(
                    map: map,
                    logicalPixel: LogicalPixel(value: 40),
                    maxZoom: Zoom(value: 18)
                ),
            panoramasMapObjectManager:
                MapObjectManager.withGeneralization(
                    map: map,
                    logicalPixel: LogicalPixel(value: 20),
                    maxZoom: Zoom(value: 18)
                ),
            ioObjectManager:
                MapObjectManager.withGeneralization(
                    map: map,
                    logicalPixel: LogicalPixel(value: 50),
                    maxZoom: Zoom(value: 18)
                ),
            imageFactory: try! self.sdk.makeImageFactory(),
            routeHandler: self.routeHandler,
            eventChannel: eventChannel,
            registrar: self.registrar
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
        self.navigationHandler?.startFreeRoam(completion: completion)
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
