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
    private var packagesHandler: PackagesHandler?
    private var weatherHandler: WeatherHandler?

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
        
        let messenger = ProxyBinaryMessenger(with: registrar.messenger(), channelSuffix: "map_\(viewId)")

        MapApiSetup(messenger, self)
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
        self.packagesHandler?.cancel()
        self.objectTapHandler?.cancel()
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
        
        
        self.navigationHandler = NavigationHandler(
            map: map,
            mapView: mapView,
            sdk: self.sdk,
            eventChannel: eventChannel,
            view: self._view
        )
        
        self.routeHandler = RouteHandler(
            map: map,
            sdk: self.sdk,
            eventChannel: eventChannel,
            navigationHandler: navigationHandler!,
            positioningService: self.positioningService
        )
        
        self.searchHandler = SearchHandler(
            searchManager: try! SearchManager.createOnlineManager(context: try! sdk.context),
            map: map,
            sdkContext: self.sdk,
            vendorConfig: SwiftDgisMapPlugin.vendorConfig
        )
        
        self.compassControlHandler = CompassControlHandler(
            map: map,
            eventChannel: eventChannel
        )
        
        self.trafficAndParkingControlHandler = TrafficAndParkingControlHandler(
            sdk: try! sdk.context,
            map: map,
            eventChannel: eventChannel
        )
        
        self.packagesHandler = PackagesHandler(
            sdk: try! sdk.context,
            eventChannel: eventChannel
        )
        
        self.weatherHandler = WeatherHandler(
            sdkContext: self.sdk,
            map: map
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
    
    func toggleFollowState(completion: @escaping (FlutterError?) -> Void) {
        self.locationControlHandler?.toggleFollowState()
        completion(nil)
    }
    
    func followNavigation(completion: @escaping (FlutterError?) -> Void) {
        self.navigationHandler?.followNavigation()
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
        manager.overrideLocales(locales: locales.map {
            let parts = $0.components(separatedBy: "-")
            return Locale(language: parts[0], region: parts[1])
        })
        
        completion(nil)
    }
    
    func setCameraPaddingCameraPadding(_ cameraPadding: CameraSetPaddingMessage, completion: @escaping (FlutterError?) -> Void) {
        guard let map = self.map else {
            completion(FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }
        map.camera.padding = Padding(
            left: cameraPadding.leftPadding.uint32Value,
            top: cameraPadding.topPadding.uint32Value,
            right: cameraPadding.rightPadding.uint32Value,
            bottom: cameraPadding.bottomPadding.uint32Value
        )
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
        desiredPosition.point = cameraPosition.point.geoPoint
        desiredPosition.zoom = Zoom(value: cameraPosition.zoom.floatValue)
        desiredPosition.tilt = Tilt(value: cameraPosition.tilt.floatValue)
        desiredPosition.bearing = Bearing(value: cameraPosition.bearing.doubleValue)
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

    func setCameraPositionPointCameraPosition(
        _ cameraPosition: CameraPositionPointMessage,
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
        
        do {
            try map.camera.setPositionPoint(positionPoint: CameraPositionPoint(x: cameraPosition.x.floatValue, y: cameraPosition.y.floatValue))
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
    
    func moveCameraCameraPosition(_ cameraPosition: CameraPositionMessage, duration: NSNumber, animationType: CameraAnimationTypeMessage, completion: @escaping (FlutterError?) -> Void) {
        guard let map = self.map else {
            completion(FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }
        var desiredPosition = map.camera.position
        desiredPosition.point = cameraPosition.point.geoPoint
        desiredPosition.zoom = Zoom(value: cameraPosition.zoom.floatValue)
        desiredPosition.tilt = Tilt(value: cameraPosition.tilt.floatValue)
        desiredPosition.bearing = Bearing(value: cameraPosition.bearing.doubleValue)
        
        let duration = TimeInterval(duration.doubleValue)
        let animationType = animationType.animationType
        
        let moveCancelable = map.camera.move(position: desiredPosition, time: duration, animationType: animationType).sink(receiveValue: { _ in
            completion(nil)
            return
        }, failure: { error in
            completion(FlutterError(
                code: "FutureError",
                message: error.localizedDescription,
                details: nil
            ))
            return
        })
        cancelable.append(moveCancelable)
    }
    
    func calcPosition(forRouteOptions options: CalcPositionOptionsMessage, completion: @escaping (CameraPositionMessage?, FlutterError?) -> Void) {
        self.navigationHandler?.calcPositionForRoute(options: options, completion: completion)
    }
    
    func calcPosition(forMarkersMarkers markers: [String], options: CalcPositionOptionsMessage, completion: @escaping (CameraPositionMessage?, FlutterError?) -> Void) {
        self.objectTapHandler?.calcPosition(markers: markers, options: options, completion: completion)
    }
    
    func calcPosition(forPolygonsPolygons polygons: [String], options: CalcPositionOptionsMessage, completion: @escaping (CameraPositionMessage?, FlutterError?) -> Void) {
        self.objectTapHandler?.calcPosition(polygons: polygons, options: options, completion: completion)
    }
    
    func calcPosition(forPolylinesPolylines polylines: [String], options: CalcPositionOptionsMessage, completion: @escaping (CameraPositionMessage?, FlutterError?) -> Void) {
        self.objectTapHandler?.calcPosition(polylines: polylines, options: options, completion: completion)
    }
    
    func getNearestObjects(completion: @escaping ([RenderedObjectMessage]?, FlutterError?) -> Void) {
        guard let map = self.map else {
            completion(nil, FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }
        
        self.objectTapHandler?.getNearestObjects(completion: completion)
    }
    
    func getCameraPosition(completion: @escaping (CameraPositionMessage?, FlutterError?) -> Void) {
        guard let map = self.map else {
            completion(nil, FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }
        
        completion(
            CameraPositionMessage.make(
                withPoint: map.camera.position.point.toMessage(),
                zoom: NSNumber(value: map.camera.position.zoom.value),
                tilt: NSNumber(value: map.camera.position.tilt.value),
                bearing: NSNumber(value: map.camera.position.bearing.value)
            ),
            nil
        )
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
        byCategoryCategory category: SearchCategoryMessage,
        spatialRestriction: [GeoPointMessage]?,
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

        // TODO. Remove, when backend data will fixed.
        if category == .parks {
            searchHandler.searchByParkCategory(
                spatialRestriction: spatialRestriction,
                searchGeoRect: searchRect?.geoRect,
                weekTimeMessage: weekTime,
                sortingType: sortingType,
                pageSize: pageSize.int32Value,
                completion: completion
            )
            return
        }

        // TODO. Remove, when backend data will fixed.
        if category == .beaches {
            searchHandler.searchByBeachCategory(
                spatialRestriction: spatialRestriction,
                searchGeoRect: searchRect?.geoRect,
                weekTimeMessage: weekTime,
                sortingType: sortingType,
                pageSize: pageSize.int32Value,
                completion: completion
            )
            return
        }

        searchHandler.searchByCategories(
            category.toRubrics(),
            spatialRestriction: spatialRestriction,
            searchGeoRect: searchRect?.geoRect,
            weekTimeMessage: weekTime,
            sortingType: sortingType,
            pageSize: pageSize.int32Value,
            completion: completion
        )
    }

    func search(byRubricsRubrics rubrics: [NSNumber], spatialRestriction: [GeoPointMessage]?, weekTime: WeekTimeSearchMessage?, searchRect: GeoRectMessage?, sortingType: SortingTypeMessage, pageSize: NSNumber, completion: @escaping (SearchResultMessage?, FlutterError?) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(nil, FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            ))
            return
        }

        searchHandler.searchByCategories(
            rubrics.map { RubricId(value: $0.uint64Value) },
            spatialRestriction: spatialRestriction,
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
        categories: SearchCategoriesMessage?,
        spatialRestriction: [GeoPointMessage]?,
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
            categories: categories?.categories.flatMap {
                $0.category.toRubrics()
            },
            spatialRestriction: spatialRestriction,
            searchGeoRect: searchRect?.geoRect,
            weekTimeMessage: weekTime,
            sortingType: sortingType,
            pageSize: pageSize.int32Value,
            completion: completion
        )
    }
    
    func search(
        byQueryQuery query: SearchQueryMessage,
        spatialRestriction: [GeoPointMessage]?,
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
            spatialRestriction: spatialRestriction,
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
        allowedResultTypes: [SuggestedTypeMessage_]?,
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
            allowedResultTypes: allowedResultTypes,
            searchGeoRect: searchRect?.geoRect,
            completion: completion
        )
    }
    // MARK: Marker
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
    
    func addMarkerMarker(_ marker: MarkerMessage, manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addMarker(marker, to: manager?.id, completion: completion)
    }

    func addMarkersMarkers(_ markers: [MarkerMessage], manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addMarkers(markers, to: manager?.id, completion: completion)
    }
    
    func removeMarkerId(_ id: String, manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removeMarker(id, from: manager?.id, completion: completion)
    }
    
    func removeAllMarkersManager(_ manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removeAllMarkers(from: manager?.id, completion: completion)
    }
    
    // MARK: Map Object Manager
    
    func createMapObjectManager(withClusteringMessage message: ClusteringMapObjectManagerOptionsMessage, layerId: String?, completion: @escaping (MapObjectManagerMessage?, FlutterError?) -> Void) {
        self.objectTapHandler?.createClusteringMapObjectManager(message, layerId, completion: completion)
    }
    
    func createMapObjectManagerLayerId(_ layerId: String?, completion: @escaping (MapObjectManagerMessage?, FlutterError?) -> Void) {
        self.objectTapHandler?.createMapObjectManager(layerId, completion: completion)
    }
    
    func removeMapObjectManagerManager(_ manager: MapObjectManagerMessage, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removeMapObjectManager(manager, completion: completion)
    }
    
    func setMapObjectManagerIsVisibleIsVisible(_ isVisible: NSNumber, manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.setMapObjectManagerIsVisible(isVisible.boolValue, for: manager?.id, completion: completion)
    }
    
    // MARK: Cluster
    
    func setClusterIconId(_ id: String, icon: String, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.setClusterIcon(icon, for: id, completion: completion)
    }
    
    func releaseClusterId(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.releaseCluster(id)
        completion(nil)
    }
    
    // MARK: Polygon
    
    func addPolygonPolygon(_ polygon: PolygonMessage, manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addPolygon(polygon, to: manager?.id, completion: completion)
    }
    
    func addPolygonsPolygons(_ polygons: [PolygonMessage], manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addPolygons(polygons, to: manager?.id, completion: completion)
    }
    
    func removePolygonId(_ id: String, manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removePolygon(id, from: manager?.id, completion: completion)
    }
    
    func removeAllPolygonsManager(_ manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removeAllPolygons(from: manager?.id, completion: completion)
    }
    
    // MARK: Polyline
    
    func addPolylinePolyline(_ polyline: PolylineMessage, manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addPolyline(polyline, to: manager?.id, completion: completion)
    }
    
    func addPolylinesPolylines(_ polylines: [PolylineMessage], manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.addPolylines(polylines, to: manager?.id, completion: completion)
    }
    
    func removePolylineId(_ id: String, manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removePolyline(id, from: manager?.id, completion: completion)
    }
    
    func removeAllPolylinesManager(_ manager: MapObjectManagerMessage?, completion: @escaping (FlutterError?) -> Void) {
        self.objectTapHandler?.removeAllPolylines(from: manager?.id, completion: completion)
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
        self.objectTapHandler?.removeAllMarkers(from: nil, completion: completion)
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
    
    func containsRect(_ rect: GeoRectMessage, point: GeoPointMessage, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        completion(NSNumber(value: rect.geoRect.contains(point: point.geoPoint)), nil)
    }
    
    func containsRectOuter(_ outer: GeoRectMessage, inner: GeoRectMessage, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        completion(NSNumber(value: outer.geoRect.contains(rect2: inner.geoRect)), nil)
    }
    
    func pointBearing(from: GeoPointMessage, to: GeoPointMessage, completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        completion(NSNumber(value: from.geoPoint.bearing(point: to.geoPoint).value), nil)
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
            controller: MyLocationController(bearingSource: .auto)
        ))
        self.map = map
        
        let mapView = mapFactory.mapView
        
        // This gesture is temporarily disabled as it conflicts with MapObjectTappedCallback
        mapView.gestureView?.doubleTapAndPanGestureRecognizer?.isEnabled = false
        
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
            map: map,
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
        completion(nil);
    }

    func showRoutes(completion: @escaping (FlutterError?) -> Void) {
        self.routeHandler?.setRoutesVisible(true)
        completion(nil);
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

    func toggleSoundEnabled(_ enabled: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        self.navigationHandler?.toggleSounds(enabled: enabled.boolValue)
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
    
    func setAppearanceAppearance(_ appearance: MapAppearanceMessage, completion: @escaping (FlutterError?) -> Void) {
        guard let mapView = self.mapView else {
            completion(
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
            return
        }
        
        switch appearance {
        case .day:
            mapView.appearance = .universal("day")
        case .night:
            mapView.appearance = .universal("night")
        case .system:
            mapView.appearance = .automatic(light: "day", dark: "night")
        }
        
        completion(nil)
    }
    
    func setZoomRestrictionsMin(_ min: NSNumber?, max: NSNumber?, completion: @escaping (FlutterError?) -> Void) {
        guard let map = self.map else {
            completion(
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
            return
        }
        
        try? map.camera.setZoomRestrictions(
            zoomRestrictions: CameraZoomRestrictions(
                minZoom: min.map {
                    Zoom(value: $0.floatValue)
                } ?? Zoom(floatLiteral: 0),
                maxZoom: max.map {
                    Zoom(value: $0.floatValue)
                } ?? Zoom(floatLiteral: 20)
            )
        )
        
        completion(nil)
    }

    func findBriefRouteInfosRouteSearchOptions(_ routeSearchOptions: RouteSearchOptionsMessage, startPoint: RouteSearchPointMessage?, finishPoint: RouteSearchPointMessage?, completion: @escaping ([BriefRouteInfoMessage]?, FlutterError?) -> Void) {

        let routeSearchOptionsConverted = routeSearchOptions.toRouteSearchOptions()

        let startSearchPoint = startPoint?.toRouteSearchPoint()
        let finishSearchPoint  = finishPoint?.toRouteSearchPoint()

        routeHandler?.findBriefRouteInfosRouteSearchOptions(
            routeSearchOptionsConverted,
            startPoint: startSearchPoint,
            finishPoint: finishSearchPoint,
            completion: completion
        )
    }

    func listPackages(completion: @escaping ([PackageMessage]?, FlutterError?) -> Void) {
        packagesHandler?.listPackages(completion: completion)
    }

    func installPackageId(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        packagesHandler?.installPackage(id, completion: completion)
    }

    func listVoices(completion: @escaping ([PackageMessage]?, FlutterError?) -> Void) {
        packagesHandler?.listVoices(completion: completion)
    }

    func installVoiceId(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        packagesHandler?.installVoice(id, completion: completion)
    }

    func setNavigatorVoiceId(_ id: String, completion: @escaping (FlutterError?) -> Void) {
        navigationHandler?.setNavigatorVoice(id, completion: completion)
    }

    func toggleHeatmapMessage(
        _ message: WeatherMapMessage,
        completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        weatherHandler?.toggleHeatmap(message,completion: completion)
    }
    
    func betterRouteResponseResponse(_ response: BetterRouteResponseMessage, completion: @escaping (FlutterError?) -> Void) {
        navigationHandler?.betterRouteResponse(response: response)
        completion(nil)
    }
    
    func getBetterRouteSettings(completion: @escaping (BetterRouteSettingsMessage?, FlutterError?) -> Void) {
        navigationHandler?.getBetterRouteSettings(completion: completion)
    }
    
    func setBetterRouteSettingsMessage(_ message: BetterRouteSettingsMessage, completion: @escaping (FlutterError?) -> Void) {
        navigationHandler?.setBetterRouteSettings(settings: message)
        completion(nil)
    }
}
