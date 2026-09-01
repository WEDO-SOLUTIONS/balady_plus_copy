import DGis
import Flutter
import Foundation

extension FlutterError: Error {}

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
    private var carPlayHandler: CarPlayHandler?
    private var searchHandler: SearchHandler?
    private var packagesHandler: PackagesHandler?
    private var weatherHandler: WeatherHandler?
    private var satelliteHandler: SatelliteHandler?

    private var objectTapHandler: ObjectTapHandler?
    private var visibleRectHandler: VisibleRectHandler?
    
    private var compassControlHandler: CompassControlHandler?
    private var trafficAndParkingControlHandler: TrafficAndParkingControlHandler?
        
    private var moveCameraCancellable: DGis.Cancellable?

    private var mapFactory: IMapFactory?


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

        MapApiSetup.setUp(binaryMessenger: messenger, api: self)
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
        self.navigationHandler?.onMyLocationSourceReplaced = { [weak self] in
            self?.reapplyNavigationCursorModel()
        }
        self.navigationHandler?.onNavigationSessionEnded = { [weak self] in
            self?.resetNavigationCursorModelOnMap()
        }
        
        self.carPlayHandler = CarPlayHandler(eventChannel: eventChannel)
        
        self.routeHandler = RouteHandler(
            map: map,
            sdk: self.sdk,
            eventChannel: eventChannel,
            navigationHandler: navigationHandler!,
            indoorControlHandler: indoorControlHandler
        )
        
        self.searchHandler = SearchHandler(
            searchManager: try! SearchManager.createOnlineManager(context: try! sdk.context),
            searchHistory: SearchHistory(context: try! sdk.context),
            map: map,
            sdkContext: self.sdk
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

        self.satelliteHandler = SatelliteHandler(
            sdkContext: self.sdk,
            map: map
        )

        setupTapHandler()
    }
    
    func view() -> UIView {
        return self._view
    }
    
    func initialize(completion: @escaping (Result<InitializeMessage, any Error>) -> Void) {
        completion(
            Result.success(
            InitializeMessage(
                wasInitialized: self.wasInitialized,
                errorDescription: self.errorDescription
            ))
        )
    }
    
    // MARK: - MapApi
    func zoomDown(type: ZoomControlMessage, completion: @escaping (Result<Void, any Error>) -> Void) {        self.zoomControlHandler?.onZoomDown(type)
        completion(Result.success(()))
    }
    
    func zoomUp(type: ZoomControlMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.zoomControlHandler?.onZoomUp(type)
         completion(Result.success(()))
    }
    
    func toggleFollowState(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.locationControlHandler?.toggleFollowState()
         completion(Result.success(()))
    }
    
    func followNavigation(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.navigationHandler?.followNavigation()
         completion(Result.success(()))
    }

    func startFollowNavigation(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.navigationHandler?.startFollowNavigation()
         completion(Result.success(()))
    }

    func stopFollowNavigation(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.navigationHandler?.stopFollowNavigation()
         completion(Result.success(()))
    }
    
    func selectIndoorLevel(index: Int64, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.indoorControlHandler?.selectIndoorLevel(index: UInt64(index))
         completion(Result.success(()))
    }

    func setIndoorFloorPlansEnabled(enabled: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        if let indoorControlHandler = self.indoorControlHandler {
            indoorControlHandler.setIndoorFloorPlansEnabled(enabled: enabled)
        } else {
            self.map?.indoorManager.setIndoorState(newState: enabled ? .enabled : .disabled)
        }
         completion(Result.success(()))
    }

    func moveCameraToActiveRoute(index: Int64, completion: @escaping (Result<Void, any Error>) -> Void) {
      self.routeHandler?.moveCameraToActiveRouteIndex(UInt64(index))
         completion(Result.success(()))
    }
    
    func setActiveRouteIndex(index: Int64, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.routeHandler?.setActiveRouteIndex(UInt64(index))
        completion(Result.success(()))
    }
    
    func setfontScale(multiplier: Float) {
        do{
            try self.map?.setFontIconSizeMultiplier(multiplier: multiplier)
        }catch{}
       
    }
    
    func loadStyles(asset: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let assetKey = self.registrar.lookupKey(forAsset: asset)

        guard let assetPath = Bundle.main.path(forResource: assetKey, ofType: nil) else {
            completion(
                Result.failure(FlutterError(
                    code: "FileNotFoundException",
                    message: "Failed to resolve asset <\(asset)>",
                    details: nil
                ))
            )
            return
        }

        loadStyleFile(at: assetPath, completion: completion)
    }

    func loadStylesFromPath(absolutePath: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard FileManager.default.fileExists(atPath: absolutePath) else {
            completion(
                Result.failure(FlutterError(
                    code: "FileNotFoundException",
                    message: "Style file does not exist at <\(absolutePath)>",
                    details: nil
                ))
            )
            return
        }

        loadStyleFile(at: absolutePath, completion: completion)
    }

    private func loadStyleFile(at path: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let styleFuture = try! self.sdk.styleFactory.loadFile(path: path)
        cancelable.append(
            styleFuture.sink(
                receiveValue: { [map = self.map] style in
                    map?.style = style
                    completion(Result.success(()))
                },
                failure: { error in
                    completion(
                        Result.failure(FlutterError(
                            code: "FileNotFoundException",
                            message: "Failed to load style from <\(path)>. Error: \(error)",
                            details: nil
                        ))
                    )
                }
            )
        )
    }


    func overrideLocales(locales: [String], completion: @escaping (Result<Void, any Error>) -> Void) {
        let manager = getLocaleManager(context: try! sdk.context)
        manager.overrideLocales(locales: locales.map {
            let parts = $0.components(separatedBy: "-")
            return Locale(language: parts[0], region: parts[1])
        })
        
         completion(Result.success(()))
    }
    
    func setCameraPadding(cameraPadding: CameraSetPaddingMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let map = self.map else {
            completion(
                Result.failure(FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
               )
            return
        }
        map.camera.padding = Padding(
            left:  UInt32(cameraPadding.leftPadding),
            top: UInt32(cameraPadding.topPadding),
            right: UInt32(cameraPadding.rightPadding),
            bottom: UInt32(cameraPadding.bottomPadding)
        )
         completion(Result.success(()))
    }
    
    func setMapAttributeString(name: String, value: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        if name == "fontScaleMultiplier" {
               if let scale = Double(value) {
                 self.setfontScale(multiplier: Float(scale))
               }
           } else {
               map?.attributes.setAttributeValue(name: name, value: .string(value))
           }
           completion(Result.success(()))
    }

    func setMapAttributeBool(name: String, value: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        map?.attributes.setAttributeValue(name: name, value: .boolean(value))
         completion(Result.success(()))
    }

    func setCameraPosition(cameraPosition: CameraPositionMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let map = self.map else {
            completion(
                Result.failure(FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            )))
            return
        }
        var desiredPosition = map.camera.position
        desiredPosition.point = cameraPosition.point.geoPoint
        desiredPosition.zoom = Zoom(value: Float(cameraPosition.zoom))
        desiredPosition.tilt = Tilt(value: Float(cameraPosition.tilt))
        desiredPosition.bearing = Bearing(value: cameraPosition.bearing)
        do {
            try map.camera.setPosition(position: desiredPosition)
        } catch {
            completion(
                Result.failure(FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            )))
            return
        }
         completion(Result.success(()))   
    }

    func setCameraPositionPoint(cameraPosition: CameraPositionPointMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let map = self.map else {
            completion(
                Result.failure(FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            )))
            return
        }
        
        do {
            try map.camera.setPositionPoint(positionPoint: CameraPositionPoint(x: Float(cameraPosition.x), y: Float(cameraPosition.y)))
        } catch {
            completion(
                Result.failure(FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            )))
            return
        }
         completion(Result.success(()))
    
    }
    
    func moveCamera(cameraPosition: CameraPositionMessage, duration: Double, animationType: CameraAnimationTypeMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let map = self.map else {
                    completion(
                        Result.failure(FlutterError(
                        code: "IllegalArgumentException",
                        message: "Map was not initialized properly",
                        details: nil
                    )))
                    return
                }
        var desiredPosition = map.camera.position
        desiredPosition.point = cameraPosition.point.geoPoint
        desiredPosition.zoom = Zoom(value: Float(cameraPosition.zoom))
        desiredPosition.tilt = Tilt(value: Float(cameraPosition.tilt))
        desiredPosition.bearing = Bearing(value: cameraPosition.bearing)
        
        let duration = TimeInterval(duration)
        let animationType = animationType.animationType
        
        moveCamera(cameraPosition: desiredPosition, duration: duration, animationType: animationType, completion: completion)
    }
    
    private func moveCamera(cameraPosition: CameraPosition, duration: TimeInterval, animationType: CameraAnimationType, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let map = self.map else {
            completion(
                Result.failure(FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            )))
            return
        }
        
        let moveCancelable = map.camera.move(position: cameraPosition, time: duration, animationType: animationType).sink(receiveValue: { _ in
             completion(Result.success(()))
            return
        }, failure: { error in
            completion(
                Result.failure(FlutterError(
                code: "FutureError",
                message: error.localizedDescription,
                details: nil
            )))
            return
        })
        cancelable.append(moveCancelable)
    }
    
    func calcPositionForRoute(options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {        self.navigationHandler?.calcPositionForRoute(options: options, completion: completion)
    }
    
    func calcPositionForMarkers(markers: [String], options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {
        self.objectTapHandler?.calcPosition(markers: markers, options: options, completion: completion)
    }
    
    func calcPositionForPolygons(polygons: [String], options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {
        self.objectTapHandler?.calcPosition(polygons: polygons, options: options, completion: completion)
    }
    
    func calcPositionForPolylines(polylines: [String], options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {
        self.objectTapHandler?.calcPosition(polylines: polylines, options: options, completion: completion)
    }

    func calcPositionForGeoPoints(points: [GeoPointMessage], options: CalcPositionOptionsMessage, completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {
        self.objectTapHandler?.calcPosition(points: points, options: options, completion: completion)
    }

    func animateToRepresentativeArea(area: GeometryMessage, options: CalcPositionOptionsMessage, duration: Double, animationType: CameraAnimationTypeMessage,  completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.calcPosition(area: area, options: options) { positionResult in
               switch positionResult {
                case .success(let cameraPosition):
                   // Once we have the camera position, we can move the camera.
                   let duration = TimeInterval(duration)
                   let animationType = animationType.animationType
                   
                   self.moveCamera(
                       cameraPosition: cameraPosition,
                       duration: duration,
                       animationType: animationType,
                       completion: completion
                   )
                   
                case .failure(let error):
                   // If calcPosition failed, we immediately fail with the same error.
                   completion(.failure(error))
               }
           }
    }
    
    func getNearestObjects(completion: @escaping (Result<[RenderedObjectMessage], any Error>) -> Void) {
        guard let map = self.map else {
            completion(
                Result.failure(
                FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            )))
            return
        }
        
        self.objectTapHandler?.getNearestObjects(completion: completion)
    }
    
    func getCameraPosition(completion: @escaping (Result<CameraPositionMessage, any Error>) -> Void) {
        guard let map = self.map else {
            completion(Result.failure( FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            )))
            return
        }
        
        completion(
            Result.success(
            CameraPositionMessage(
                point: map.camera.position.point.toMessage(),
                zoom: Double( map.camera.position.zoom.value),
                tilt: Double( map.camera.position.tilt.value),
                bearing: Double( map.camera.position.bearing.value)
            ))
        )
    }
    
    /// BALADY-3772: swap the 3D model of the my-location object (navigation
    /// cursor) on the live map via `MyLocationMapObject.setModelData`. No style
    /// reload, no MapView recreate — route, maneuvers and camera stay untouched.
    ///
    /// Regression follow-up: the custom model is only visible during
    /// turn-by-turn navigation. Outside a session the bytes are just cached —
    /// NavigationHandler pushes them when guidance starts and resets the marker
    /// when it ends, so Explore keeps the standard my-location marker.
    func setNavigationCursorModel(glb: FlutterStandardTypedData, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let map = self.map else {
            completion(.failure(PigeonError(code: "map_not_ready", message: "setNavigationCursorModel: map is not ready", details: nil)))
            return
        }
        let modelData: ModelData
        do {
            modelData = try self.sdk.modelFactory.make(modelData: glb.data)
        } catch {
            completion(.failure(PigeonError(code: "model_factory_unavailable", message: "setNavigationCursorModel: \(error)", details: nil)))
            return
        }
        self.navigationCursorModel = modelData
        guard self.navigationHandler?.isNavigating == true else {
            completion(.success(()))
            return
        }
        guard let source = map.sources.first(where: { $0 is MyLocationMapObjectSource }) as? MyLocationMapObjectSource else {
            completion(.failure(PigeonError(code: "no_source", message: "setNavigationCursorModel: no MyLocationMapObjectSource on map", details: nil)))
            return
        }
        source.item.setModelData(data: modelData)
        completion(.success(()))
    }

    /// BALADY-3772: the navigation-cursor 3D model last set via
    /// `setNavigationCursorModel`. The custom model is a turn-by-turn-only
    /// visual: NavigationHandler applies it when a session starts (after the
    /// guidance source swap) and resets the marker back to the style default
    /// when the session ends. Outside a session the model is only cached here.
    private var navigationCursorModel: ModelData?

    private func reapplyNavigationCursorModel() {
        guard let model = self.navigationCursorModel,
              let source = self.map?.sources.first(where: { $0 is MyLocationMapObjectSource }) as? MyLocationMapObjectSource
        else { return }
        source.item.setModelData(data: model)
    }

    /// BALADY-3772 (regression): once the navigation session ends the
    /// my-location marker must return to the standard style default — the
    /// custom car model must not stick around on Explore. The chosen model
    /// stays cached in `navigationCursorModel` for the next session.
    private func resetNavigationCursorModelOnMap() {
        guard let source = self.map?.sources.first(where: { $0 is MyLocationMapObjectSource }) as? MyLocationMapObjectSource
        else { return }
        source.item.setModelData(data: nil)
    }

    func getCameraVisibleArea(completion: @escaping (Result<PolygonGeometryMessage, any Error>) -> Void) {
        guard let map = self.map else {
            completion(Result.failure( FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            )))
            return
        }
        
        let area = map.camera.visibleArea
        if let polygon = area as? PolygonGeometry {
            let contours = polygon.contours.map { $0.map { $0.toMessage() } }
            completion(
                Result.success(
                PolygonGeometryMessage(
                    contours: contours
                ))
            )
        } else {
            completion(
                Result.failure(
                FlutterError(
                code: "ParcingError",
                message: "Map was not initialized properly",
                details: nil
            )))
        }
    }

    func searchByObjectId(objectId: DgisObjectIdMessage, completion: @escaping (Result<DirectoryObjectMessage, any Error>) -> Void) {

        guard let searchHandler = self.searchHandler else {
            completion(
                Result.failure(
                FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            )))
            return
        }
        searchHandler.searchByDirectoryObjectId(
            objectId: DgisObjectId(
                objectId: UInt64(objectId.objectId),
                entranceId: UInt64(objectId.entranceId)
            ),
            completion: completion
        )
    }

    func searchByRubrics(rubrics: [Int64], spatialRestriction: [GeoPointMessage]?, weekTime: WeekTimeSearchMessage?, searchRect: GeoRectMessage?, sortingType: SortingTypeMessage, pageSize: Int64,  locale: String?, completion: @escaping (Result<SearchResultMessage, any Error>) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(  Result.failure( FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            )))
            return
        }

        searchHandler.searchByRubricIds(
            rubrics.map { RubricId(value: UInt64($0)) },
            spatialRestriction: spatialRestriction,
            searchGeoRect: searchRect?.geoRect,
            weekTimeMessage: weekTime,
            sortingType: sortingType,
            pageSize: Int32(pageSize),
            locale: locale,
            completion: completion
        )
    }

    func getDistanceTo(points: [DistanceRequestMessage], completion: @escaping (Result<[DistanceResponseMessage], any Error>) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                Result.failure(
                FlutterError(
                code: "IllegalArgumentException",
                message: "Map was not initialized properly",
                details: nil
            )))
            return
        }
        let location = try! self.sdk.locationService.lastLocation?.coordinates.value

        searchHandler.getDistanceTo(
            points: points,
            location: location,
            completion: completion
        )
    }
    
    func search(queryText: String, rubrics: [Int64]?, spatialRestriction: [GeoPointMessage]?, weekTime: WeekTimeSearchMessage?, searchRect: GeoRectMessage?, sortingType: SortingTypeMessage, pageSize: Int64,  locale: String?, completion: @escaping (Result<SearchResultMessage, any Error>) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                Result.failure(
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                )))
            return
        }
        
        searchHandler.search(
            queryText,
            rubricIds: rubrics?.map { RubricId(value: UInt64($0)) },
            spatialRestriction: spatialRestriction,
            searchGeoRect: searchRect?.geoRect,
            weekTimeMessage: weekTime,
            sortingType: sortingType,
            pageSize: Int32(pageSize),
            locale: locale,
            completion: completion
        )
    }
    
    func searchByQuery(query: SearchQueryMessage, spatialRestriction: [GeoPointMessage]?, weekTime: WeekTimeSearchMessage?, searchRect: GeoRectMessage?, sortingType: SortingTypeMessage, pageSize: Int64,  locale: String?, completion: @escaping (Result<SearchResultMessage, any Error>) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                Result.failure(
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                )))
            return
        }
        
        searchHandler.searchByQuery(
            query,
            spatialRestriction: spatialRestriction,
            searchGeoRect: searchRect?.geoRect,
            weekTimeMessage: weekTime,
            sortingType: sortingType,
            pageSize: Int32(pageSize),
            locale: locale,
            completion: completion
        )
    }
    
    func fetchNextPage(pageId: PageIdMessage, completion:@escaping (Result<PageMessage, any Error>) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                Result.failure(
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                )))
            return
        }
        
        searchHandler.fetchNextPage(pageId, completion: completion)
    }
    
    func fetchPrevPage(pageId: PageIdMessage, completion:@escaping (Result<PageMessage, any Error>) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                Result.failure(
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                )))
            return
        }
        
        searchHandler.fetchPrevPage(pageId, completion: completion)
    }
    
    func releasePage(pageId: PageIdMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                Result.failure(
                    FlutterError(
                        code: "IllegalArgumentException",
                        message: "Map was not initialized properly",
                        details: nil
                    ))
                )
               
            return
        }
        
        searchHandler.releasePage(pageId, completion: completion)
    }
    
    func fetchSuggests(queryText: String, allowedResultTypes: [SuggestedTypeMessage_]?, searchRect: GeoRectMessage?, locale: String?, suggestorType: SuggestorTypeEnum?, limit: Int64?, completion: @escaping (Result<SuggestResultMessage, any Error>) -> Void)  {

        guard let searchHandler = self.searchHandler else {
            completion(
                Result.failure(
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                ))
            )
            return
        }

        searchHandler.fetchSuggests(
            queryText: queryText,
            allowedResultTypes: allowedResultTypes,
            searchGeoRect: searchRect?.geoRect,
            locale: locale,
            suggestorType: suggestorType,
            limit: limit,
            completion: completion
        )
    }
    // MARK: Marker
    
    func addMarker(marker: MarkerMessage, manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.addMarker(marker, to: manager?.id, completion: completion)
    }
    
    func setMarkerOptions(id: String, options: ChangeMarkerOptionsMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.setMarkerOptions(id, options: options, completion: completion)
    }

    func addMarkers( markers: [MarkerMessage], manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.addMarkers(markers, to: manager?.id, completion: completion)
    }
    
    func removeMarker( id: String, manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.removeMarker(id, from: manager?.id, completion: completion)
    }
    
    func removeAllMarkers( manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.removeAllMarkers(from: manager?.id, completion: completion)
    }
    
    // MARK: Map Object Manager
    
    func createMapObjectManagerWithClustering(message: ClusteringMapObjectManagerOptionsMessage, layerId: String?, completion: @escaping (Result<MapObjectManagerMessage, any Error>) -> Void) {
        self.objectTapHandler?.createClusteringMapObjectManager(message, layerId, completion: completion)
    }
    
    func createMapObjectManager(layerId: String?, completion: @escaping (Result<MapObjectManagerMessage, any Error>) -> Void) {
        self.objectTapHandler?.createMapObjectManager(layerId, completion: completion)
    }
    
    func removeMapObjectManager( manager: MapObjectManagerMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.removeMapObjectManager(manager, completion: completion)
    }
    
    func setMapObjectManagerIsVisible(isVisible: Bool, manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.setMapObjectManagerIsVisible(isVisible, for: manager?.id, completion: completion)
    }
    
    // MARK: Cluster
    
    func setClusterIcon( id: String, icon: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.setClusterIcon(icon, for: id, completion: completion)
    }
    
    func releaseCluster( id: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.releaseCluster(id)
         completion(Result.success(()))
    }
    
    // MARK: Polygon
    
    func addPolygon(polygon: PolygonMessage, manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.addPolygon(polygon, to: manager?.id, completion: completion)
    }
    
    func addPolygons(polygons: [PolygonMessage], manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.addPolygons(polygons, to: manager?.id, completion: completion)
    }
    
    func removePolygon(id: String, manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.removePolygon(id, from: manager?.id, completion: completion)
    }
    
    func removeAllPolygons( manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.removeAllPolygons(from: manager?.id, completion: completion)
    }
    
    // MARK: Circle
    
    func addCircle(circle: CircleMessage, manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.addCircle(circle, to: manager?.id, completion: completion)
    }
    
    func addCircles(circles: [CircleMessage], manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.addCircles(circles, to: manager?.id, completion: completion)
    }
    
    func removeCircle(id: String, manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.removeCircle(id, from: manager?.id, completion: completion)
    }
    
    func removeAllCircles(manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.removeAllCircles(from: manager?.id, completion: completion)
    }
    
    // MARK: Polyline
    
    func addPolyline( polyline: PolylineMessage, manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.addPolyline(polyline, to: manager?.id, completion: completion)
    }
    
    func addPolylines( polylines: [PolylineMessage], manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.addPolylines(polylines, to: manager?.id, completion: completion)
    }
    
    func removePolyline( id: String, manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.removePolyline(id, from: manager?.id, completion: completion)
    }
    
    func removeAllPolylines(manager: MapObjectManagerMessage?, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.removeAllPolylines(from: manager?.id, completion: completion)
    }
    
    func setHighlighted( objectIds: [DgisObjectIdMessage], completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.setHighlighted(
            objectIds.map({
                DgisObjectId(
                    objectId: UInt64($0.objectId),
                    entranceId: UInt64($0.entranceId)
                )
            }),
            completion
        )
    }
    
    func addPanoramasMarkers(message: AddMarkersWithPhotoMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.addPanoramasMarkers(message: message)
         completion(Result.success(()))
    }
    
    func hidePanoramasMarkers(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.hidePanoramasMarkers()
         completion(Result.success(()))    }
    
    func showPanoramasMarkers(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.showPanoramasMarkers()
         completion(Result.success(()))
    }
    
    func removePanoramasMarkers(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.removePanoramasMarkers()
         completion(Result.success(()))
        
    }
    
    func setPanoramasPaddings( message: CameraSetPaddingMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let map = self.map else { return }
        self.objectTapHandler?.setPanoramasPadding(map: map, message: message)
         completion(Result.success(()))
    }
    
    func moveCameraToSelectedPanorama(completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let map = self.map else { return }
        self.objectTapHandler?.moveCameraToSelectedPanorama(map: map)
         completion(Result.success(()))
    }
    
    func unselectPanorama(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.unselectPanorama()
         completion(Result.success(()))
    }
    
    func showEsriIOLayer( message: AddLayerPointObjectsMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.addIoMarkers(message, completion)
    }
    
    func removeEsriIOLayer(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.removeAllMarkers(from: nil, completion: completion)
    }
    
    func setPanoramaMarkerAzimuth( message: MapDirectionMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.objectTapHandler?.setPanoramasAzimuth(degrees: message.degree)
         completion(Result.success(()))
    }
    
    func overlappedBy(outerRect: GeoRectMessage, innerRect: GeoRectMessage, completion: @escaping (Result<Int64, any Error>) -> Void) {
        let outer = outerRect.geoRect
        
        let inner = innerRect.geoRect
        
        completion(Result.success(outer.contains(rect2: inner) ? 1 : 0))
    }
    
    func contains(rect: GeoRectMessage, point: GeoPointMessage, completion: @escaping (Result<Bool, any Error>) -> Void) {
        completion(Result.success(rect.geoRect.contains(point: point.geoPoint)))
    }
    
    func containsRect(outer: GeoRectMessage, inner: GeoRectMessage, completion: @escaping (Result<Bool, any Error>) -> Void) {

        completion(Result.success( outer.geoRect.contains(rect2: inner.geoRect)))
    }
    
    func pointBearing(from: GeoPointMessage, to: GeoPointMessage, completion: @escaping (Result<Double, any Error>) -> Void) {
        completion(Result.success( from.geoPoint.bearing(point: to.geoPoint).value))
    }

    func onLocationPermissionGranted(
        desiredAccuracy: DesiredAccuracyMessage,
        completion: @escaping (Result<Void, any Error>) -> Void
    ) {
         completion(Result.success(()))
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
            controllerSettings:  MyLocationControllerSettings()
        ))
        
        self.map = map
        self.mapFactory = mapFactory
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
            imageFactory: try! self.sdk.imageFactory,
            routeHandler: self.routeHandler,
            eventChannel: eventChannel,
            registrar: self.registrar
        )
        
        mapView.addObjectTappedCallback(callback: MapObjectTappedCallback(
            callback: objectTapHandler.objectTapListener(_:)))


        mapView.addObjectLongPressCallback(callback: MapObjectTappedCallback(
            callback: objectTapHandler.objectLongTapListener(_:)))


        self.objectTapHandler = objectTapHandler
    }
    
    func setRouteParams(params: RouteEditorRouteParamsMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.routeHandler?.setRouteParams(params)
         completion(Result.success(()));
    }
    
    func hideRoutes(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.routeHandler?.setRoutesVisible(false)
         completion(Result.success(()));
    }

    func showRoutes(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.routeHandler?.setRoutesVisible(true)
         completion(Result.success(()));
    }


    func startNavigation(speedRangeZoom: [SpeedRangeZoom], completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let routeHandler = self.routeHandler else {
            completion(
                Result.failure(FlutterError(
                code: "NavigationError",
                message: "RouteHandler not initialized",
                details: nil
            )))
            return
        }
        let isPublicTransport = routeHandler.options == .publicTransport(PublicTransportRouteSearchOptions())
        self.routeHandler?.setRoutesVisible(isPublicTransport)
        if (isPublicTransport) {
            self.routeHandler?.setShowOnlyActiveRoute(true)
        }
        
        
        self.navigationHandler?.startNavigation(
            finishPoint: routeHandler.finishPoint,
            options: routeHandler.options,
            route: routeHandler.selectedRoute,
            speedRangeZoom: speedRangeZoom,
            completion: completion
        )
    }
    
    func simulationSpeed(speed: Double) {
        self.navigationHandler?.simulationSpeed(speed: speed)
    }
    
    func startNavigationSimulation( speedRangeZoom: [SpeedRangeZoom], completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let routeHandler = self.routeHandler else {
            completion(
                Result.failure(FlutterError(
                code: "NavigationError",
                message: "RouteHandler not initialized",
                details: nil
            )))
            return
        }
        let isPublicTransport = routeHandler.options == .publicTransport(PublicTransportRouteSearchOptions())
        self.routeHandler?.setRoutesVisible(isPublicTransport)
        if (isPublicTransport) {
            self.routeHandler?.setShowOnlyActiveRoute(true)
        }
        
        self.navigationHandler?.startSimulation(
            finishPoint: routeHandler.finishPoint,
            options: routeHandler.options,
            route: routeHandler.selectedRoute,
            speedRangeZoom: speedRangeZoom,
            completion: completion
        )
    }
    
    func stopNavigation(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.navigationHandler?.stopNavigation()
         completion(Result.success(()))
    }
    
    func saveNavigationState(completion: @escaping (Result<FlutterStandardTypedData, any Error>) -> Void) {
        self.navigationHandler?.saveNavigationState(completion: completion)
    }
    
    func restoreNavigationState(state: FlutterStandardTypedData, speedRangeZoom: [SpeedRangeZoom], completion: @escaping (Result<Void, any Error>) -> Void) {
        self.navigationHandler?.restoreNavigationState(state: state, speedRangeZoom: speedRangeZoom, completion: completion)
    }

    func getCurrentNavigationState(completion: @escaping (Result<NavigationStateMessage, any Error>) -> Void) {
        self.navigationHandler?.getCurrentNavigationState(completion: completion)
    }
    
    func onCompassClicked(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.compassControlHandler?.onClicked()
         completion(Result.success(()))
    }
    
    func startFreeRoam(speedRangeZoom: [SpeedRangeZoom], completion: @escaping (Result<Void, any Error>) -> Void) {
        self.navigationHandler?.startFreeRoam(speedRangeZoom: speedRangeZoom, completion: completion)
    }
    
    func stopFreeRoam(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.navigationHandler?.stopFreeRoam()
         completion(Result.success(()))
    }
    
    func setPublicTransportActiveRoute(routeIndex: Int64, completion: @escaping (Result<Void, any Error>) -> Void) {
        routeHandler?.setActiveRouteIndex(UInt64(routeIndex))
         completion(Result.success(()))
    }
    
    func onTrafficAndParkingAttached(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.trafficAndParkingControlHandler?.onAttachToMap()
         completion(Result.success(()))
    }
    
    func onTrafficAndParkingDetached(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.trafficAndParkingControlHandler?.onDetachFromMap()
         completion(Result.success(()))
    }
    
    func onParkingClicked(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.trafficAndParkingControlHandler?.onParkingClicked()
         completion(Result.success(()))
    }
    
    func onTrafficClicked(completion: @escaping (Result<Void, any Error>) -> Void) {
        self.trafficAndParkingControlHandler?.onTrafficClicked()
         completion(Result.success(()))
    }
    
    func setAppearance(appearance: MapAppearanceMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let mapView = self.mapView else {
            completion(
                Result.failure(
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                )))
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
        
         completion(Result.success(()))
    }
    
    func setZoomRestrictions(min: Double?, max: Double?, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let map = self.map else {
            completion(
                Result.failure(
                FlutterError(
                    code: "IllegalArgumentException",
                    message: "Map was not initialized properly",
                    details: nil
                )))
            return
        }
        
        try? map.camera.setZoomRestrictions(
            zoomRestrictions: CameraZoomRestrictions(
                minZoom: min.map {
                    Zoom(value: Float($0))
                } ?? Zoom(floatLiteral: 0),
                maxZoom: max.map {
                    Zoom(value: Float($0))
                } ?? Zoom(floatLiteral: 20)
            )
        )
        
         completion(Result.success(()))
    }

    func findBriefRouteInfos(routeSearchOptions: RouteSearchOptionsMessage, startPoint: RouteSearchPointMessage?, finishPoint: RouteSearchPointMessage?, completion: @escaping (Result<[BriefRouteInfoMessage], any Error>) -> Void) {
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

    func findRoute(startPoint: RouteSearchPointMessage, finishPoint: RouteSearchPointMessage, navType: RouteSearchOptionsMessage,
                   intermediatePoints: [RouteSearchPointMessage]?, completion: @escaping (Result<FindRouteResultMessage, any Error>) -> Void) {
        let routeSearchOptions = navType.toRouteSearchOptions()
        
        let startSearchPoint = startPoint.toRouteSearchPoint()
        let finishSearchPoint = finishPoint.toRouteSearchPoint()
        
        routeHandler?.findRoute(
            startPoint: startSearchPoint,
            finishPoint: finishSearchPoint,
            routeSearchOptions: routeSearchOptions,
            intermediatePoints: intermediatePoints?.map { $0.toRouteSearchPoint() },
            completion: completion
        )
    }

    func listPackages(completion: @escaping (Result<[PackageMessage], any Error>) -> Void) {
        packagesHandler?.listPackages(completion: completion)
    }

    func installPackage(id: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        packagesHandler?.installPackage(id, completion: completion)
    }

    func listVoices(completion: @escaping (Result<[VoiceMessage], any Error>) -> Void) {
        packagesHandler?.listVoices(completion: completion)
    }

    func installVoice(id: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        packagesHandler?.installVoice(id, completion: completion)
    }

    func setNavigatorVoice(id: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        navigationHandler?.setNavigatorVoice(id, completion: completion)
    }

    func toggleHeatmap(message: WeatherMapMessage, completion: @escaping (Result<Bool, any Error>) -> Void) {
        weatherHandler?.toggleHeatmap(message,completion: completion)
    }

    func toggleSatellite(message: SatelliteMapMessage, completion: @escaping (Result<Bool, any Error>) -> Void) {
        satelliteHandler?.toggleSatellite(message, completion: completion)
    }
    
    func betterRouteResponse(response: BetterRouteResponseMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        navigationHandler?.betterRouteResponse(response: response)
         completion(Result.success(()))
    }
    
    func getBetterRouteSettings(completion: @escaping (Result<BetterRouteSettingsMessage, any Error>) -> Void) {
        navigationHandler?.getBetterRouteSettings(completion: completion)
    }
    
    func setBetterRouteSettings(message: BetterRouteSettingsMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        navigationHandler?.setBetterRouteSettings(settings: message)
         completion(Result.success(()))
    }
    
    func setBetterRouteEnabled(enabled: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        navigationHandler?.setBetterRouteEnabled(enabled: enabled)
        completion(Result.success(()))
    }
    
    
    func toggleVoiceInstruction( toggleType: SoundToggleType, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.navigationHandler?.toggleSounds(toggleType: toggleType)
        self.carPlayHandler?.toggleSounds(toggleType: toggleType)
        // sdk.audioSettings?.mute immediately silences the DGis audio pipeline
        // (including any in-flight utterance) when muting, and re-enables it on unmute.
        // This avoids AVAudioSession deactivation which leaves the DGis engine stopped.
        try? sdk.audioSettings?.mute = (toggleType == .none)

        DispatchQueue.main.async { Self.restoreInAppAudioVolume() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { Self.restoreInAppAudioVolume() }

        completion(Result.success(()))
    }

    private static func restoreInAppAudioVolume() {
        NotificationCenter.default.post(name: Notification.Name("com.balady.navigationVoiceEnded"), object: nil)
    }
    
    func authorizationNotification(isAuthorized: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.carPlayHandler?.onAuthorizationChanged(isAuthorized: isAuthorized)
        completion(Result.success(()))
    }

    func favouritesUpdateNotification(favouritesState: FavouritesStateMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        // It's not necessary to update favorites in CarPlay, as they don't appear permanently on main screen in CarPlay by design
        completion(Result.success(()))
    }

    func toggleOverSpeeding( toggleType overSpeeding: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.navigationHandler?.toggleOverSpeeding(overSpeeding: overSpeeding)
         completion(Result.success(()))
    }

    func toggleRoadCameras( toggleType roadCameras: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        self.navigationHandler?.toggleRoadCameras(roadCameras: roadCameras)
         completion(Result.success(()))
    }
    
    func setNavigatorVolume(volume: Int64, completion: @escaping (Result<Void, any Error>) -> Void) {
        do {
            try sdk.audioSettings?.volume = UInt32(volume)
             completion(Result.success(()))
        } catch {
            completion(
                Result.failure(FlutterError(code: "ERROR_SETTING_VOLUME", message: "Failed to set volume", details: error.localizedDescription)))
        }
    }

    func muteOtherSounds( mute: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        // This method is called from Flutter without a duration parameter (Pigeon: `muteOtherSounds(bool)`).
        // Instead of "mute", we implement a short "duck then restore" behavior:
        // - mute=true  -> set policy to .duck, then auto-restore to .ignore after a few seconds
        // - mute=false -> restore immediately and cancel any pending restore
        //
        // This reduces other audio volume briefly for guidance, then returns to normal.
        struct DuckingState {
            static var restoreWorkItem: DispatchWorkItem?
            static let duckDurationSeconds: TimeInterval = 3.0
        }

        do {
            // Cancel any previously scheduled restore to avoid races.
            DuckingState.restoreWorkItem?.cancel()
            DuckingState.restoreWorkItem = nil

            if mute {
                try sdk.audioSettings?.audioFocusPolicy = AudioFocusPolicy.duck

                let workItem = DispatchWorkItem { [weak self] in
                    guard let self else { return }
                    do {
                        try self.sdk.audioSettings?.audioFocusPolicy = AudioFocusPolicy.ignore
                    } catch {
                        // Best-effort restore; nothing to return to Flutter at this point.
                        NSLog("DgisMapView: Failed to restore audio focus policy: %@", error.localizedDescription)
                    }
                }
                DuckingState.restoreWorkItem = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + DuckingState.duckDurationSeconds, execute: workItem)
            } else {
                try sdk.audioSettings?.audioFocusPolicy = AudioFocusPolicy.ignore
            }

            completion(Result.success(()))
        } catch {
            completion(
                Result.failure(
                    FlutterError(
                        code: "ERROR_SETTING_AUDIO_POLICY",
                        message: "Failed to set audio focus policy",
                        details: error.localizedDescription
                    )
                )
            )
        }
    }
    
    func voicePlayWelcome(id: String, completion: @escaping (Result<Void, any Error>) -> Void) {
         completion(Result.success(()))
    }

    func getCarConnectionState(completion: @escaping (Result<Bool, any Error>) -> Void) {
        carPlayHandler?.getConnectionState(completion: completion)
    }
    
    func setMaxFps(maxFps: Int64?, completion: @escaping (Result<Void, any Error>) -> Void) {
        if let fps = maxFps {
            mapFactory?.energyConsumption.maxFps = Int(fps)
        } else {
            mapFactory?.energyConsumption.maxFps = nil
        }
        
        completion(Result.success(()))
    }
    
    func getSearchHistoryItems(completion: @escaping (Result<[SearchHistoryDirectoryObjectMessage], any Error>) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                Result.failure(FlutterError(
                code: "IllegalArgumentException",
                message: "Search Handler was not initialized properly",
                details: nil
            )))
            return
        }
        
        Task {
               do {
                   let result = try await searchHandler.getSearchHistoryItems()
                   completion(Result.success(result))
               } catch {
                   completion(
                       Result.failure(FlutterError(code: "SEARCH_HISTORY_ERROR", message: "Failed to get search history items", details: error.localizedDescription)))
               }
           }
    }

    
    func addSearchHistoryItem(item: SearchHistoryDirectoryObjectMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let objectId = item.id?.objectId else {
            searchHandler?.addQuerySearchHistoryItem(queryText: item.title)
            return completion(Result.success(()))
        }

        let entranceId = item.id?.entranceId ?? 0
        guard let searchHandler = self.searchHandler else {
            return completion(
                Result.failure(FlutterError(
                code: "IllegalArgumentException",
                message: "Search Handler was not initialized properly",
                details: nil
            )))
        }
        
        Task {
               do {
                   let directoryObject = try await searchHandler.searchByDirectoryObjectIdSync(objectId: DgisObjectId(objectId: UInt64(objectId), entranceId: UInt64(entranceId)))
                   if (directoryObject == nil) {
                       completion(
                           Result.failure(
                            FlutterError(
                                code: "SEARCH_HISTORY_ERROR",
                                message: "Failed to get directory object of id",
                                details: "objectId: \(objectId), entranceId: \(entranceId)"
                            )
                           )
                       )
                       return
                   }
                   searchHandler.addDirectoryObjectSearchHistoryItem(directoryObject: directoryObject!)
                   completion(Result.success(()))
               } catch {
                   completion(
                       Result.failure(FlutterError(code: "SEARCH_HISTORY_ERROR", message: "Failed to add search history items", details: error.localizedDescription)))
               }
           }
    }
    
    func removeSearchHistoryItem(index: Int64, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                Result.failure(FlutterError(
                code: "IllegalArgumentException",
                message: "Search Handler was not initialized properly",
                details: nil
            )))
            return
        }
        
        Task {
               do {
                   let items = try await searchHandler.getRawSearchHistoryItems()
                   searchHandler.removeSearchHistoryItem(item: items[Int(index)])
                   completion(Result.success(()))
               } catch {
                   completion(
                       Result.failure(FlutterError(code: "SEARCH_HISTORY_ERROR", message: "Failed to get search history items", details: error.localizedDescription)))
               }
           }
    }
    
    func clearSearchHistoryItems(completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let searchHandler = self.searchHandler else {
            completion(
                Result.failure(FlutterError(
                code: "IllegalArgumentException",
                message: "Search Handler was not initialized properly",
                details: nil
            )))
            return
        }
        
        searchHandler.clearSearchHistory()
        completion(Result.success(()))
    }
}
