import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/services.dart';

/// Class to communicate with plugin. Every method can throw [PlatformException] whenever something
/// goes wrong on platform side.
class DgisMapController {
  /// [_viewId] is the id returned by [onPlatformViewCreated] method when creating platform view.
  ///
  /// Instance of this class is typically obtained in [onMapCreated] callback of [DgisMap] widget.
  DgisMapController(this._viewId);

  final int _viewId;

  final _evergisFilters = <dynamic>[];
  final _instance = DgisMapPlugin();

  /// Zoom controls availability
  Stream<ZoomControlEnabledEvent> get zoomControlEnabledEvents => _instance.zoomControlEnabledEvents;

  /// Compass bearing
  Stream<CompassBearingEvent> get compassBearingEvents => _instance.compassBearingEvents;

  /// Location control availability
  Stream<LocationEnabledEvent> get locationEnabledEvents => _instance.locationEnabledEvents;

  /// Location follow state
  Stream<LocationFollowType> get locationFollowEvents =>
      _instance.locationFollowEvents.map((event) => event.followType);

  /// Names of indoor levels if any. Empty if there are no available levels.
  Stream<IndoorLevelsEvent> get indoorLevelNames => _instance.indoorLevelNames;

  /// Indoor levels hiding events.
  Stream<HideIndoorLevelsEvent> get hideIndoorLevels => _instance.hideIndoorLevels;

  /// Getting the IndoorLevelNames latest record values from a stream
  IndoorLevelsEvent? get lastIndoorLevelNames => _instance.lastIndoorLevelNames;

  /// Getting the IndoorActiveLevel latest record values from a stream
  IndoorActiveLevelEvent? get lastIndoorActiveLevel => _instance.lastIndoorActiveLevel;

  /// Selected indoor level index in [IndoorLevelsEvent::levelNames] list
  Stream<IndoorActiveLevelEvent> get indoorActiveIndex => _instance.indoorActiveIndex;

  /// Map tap events for all types of objects, that do not have specific stream
  /// (e.g. [markerWithPhotoTapEvents])
  Stream<TapEvent> get objectTapEvents => _instance.objectTapEvents;

  /// User taps route when there are several of them available.
  Stream<ActiveRouteChangedEvent> get activeRouteChangedEvents => _instance.activeRouteChangedEvents;

  /// Available routes update.
  Stream<RoutesInfoChangedEvent> get routesInfoChangedEvents => _instance.routesInfoChangedEvents;

  /// Better route availability update.
  Stream<BetterRouteInfoEvent> get betterRouteInfoEvents => _instance.betterRouteInfoEvents;

  /// Android Auto/CarPlay connection state.
  Stream<bool> get carConnectionEvents => _instance.androidAutoConnectionEvents;

  /// Events during navigation.
  Stream<NavigationEvent> get navigationEvents => _instance.navigationEvents;

  /// Sound on events
  Stream<SoundOnEvent> get soundOnEvents => _instance.soundOnEvents;

  /// Events of visible rect changes.
  Stream<VisibleRectEvent> get visibleRectEvents => _instance.visibleRectEvents;

  /// Events of camera position changes.
  Stream<CameraPositionMessage> get cameraPositionEvents => _instance.cameraPositionEvents;

  /// Events of camera state changes.
  Stream<CameraStateEvent> get cameraStateEvents => _instance.cameraStateEvents;

  /// Tap events for panorama markers.
  Stream<MarkerWithPhotoTapEvent> get markerWithPhotoTapEvents => _instance.markerWithPhotoTapEvents;

  /// Public transport routes changed events.
  Stream<PublicTransportRoutesChangedEvent> get publicTransportRoutesChangedEvents =>
      _instance.publicTransportRoutesChangedEvents;

  /// Public transport active route changed events.
  Stream<PublicTransportActiveRouteChanged> get publicTransportActiveRouteChangedEvents =>
      _instance.publicTransportActiveRouteChangedEvents;

  /// Package progress events.
  Stream<PackageProgressEvent> get packageProgressEvents => _instance.packageProgressEvents;

  /// Package info changed events.
  Stream<PackageInfoChangedEvent> get packagesInfoChangedEvents => _instance.packageInfoChangedEvents;

  /// Navi speed controller events.
  late NaviSpeedController naviSpeedController = NaviSpeedController(_instance.naviSpeedEvents.asBroadcastStream());

  /// Navi message controller
  late NaviMessageController naviMessageController = NaviMessageController(
    _instance.naviMessageEvents.asBroadcastStream(),
  );

  /// Navi maneuver controller
  late NaviManeuverController naviManeuverController = NaviManeuverController(
    _instance.naviManeuverEvents.asBroadcastStream(),
  );

  /// Navi compass controller
  late NaviCompassController naviCompassController = NaviCompassController(
    _instance.compassBearingEvents.asBroadcastStream(),
    _instance.onCompassClicked,
  );

  /// Navi zoom controller
  late NaviZoomController naviZoomController = NaviZoomController(
    _instance.zoomControlEnabledEvents.asBroadcastStream(),
    _instance.onZoomAction,
  )..init();

  /// Navi traffic and parking controller
  late NaviTrafficParkingController naviTrafficParkingController = NaviTrafficParkingController(
    parkingStateEvents: _instance.parkingStateEvents.asBroadcastStream(),
    trafficStateEvents: _instance.trafficStateEvents.asBroadcastStream(),
    onAttached: _instance.onTrafficAndParkingAttached,
    onDetached: _instance.onTrafficAndParkingDetached,
    onTrafficClicked: _instance.onTrafficClicked,
    onParkingClicked: _instance.onParkingClicked,
    setParkingFilter: (filter) =>
        _instance.setMapAttributeString(NaviTrafficParkingController.parkingFilterAttribute, filter.attributeValue),
  );

  /// Free roam controller
  late NaviFreeRoamController freeRoamController = NaviFreeRoamController(
    _instance.navigationEvents,
    start: _instance.startFreeRoam,
    stop: _instance.stopFreeRoam,
  );

  /// Navi dashboard Events
  Stream<NaviDashboardEvent> get naviDashboardEvents => _instance.naviDashboardEvents;

  /// Route options events
  Stream<RouteOptionsEvent> get routeOptionEvents => _instance.routeOptionsEvent;

  /// Must be called **once** when controller becomes available to initialize plugin.
  Future<InitializeMessage> initialize() async => _instance.initialize(_viewId);

  /// Dispose [naviZoomController] and plugin instance.
  Future<void> dispose() async {
    naviZoomController.dispose();
    await _instance.dispose();
  }

  /// Load map styles from asset.
  Future<void> loadStyles(String asset) async => _instance.loadStyles(asset);

  /// Load map styles from an absolute filesystem path.
  /// Use it when the `.2gis` archive lives outside the app bundle — e.g. a
  /// repacked copy in the support directory with overridden GLB models.
  Future<void> loadStylesFromPath(String absolutePath) async => _instance.loadStylesFromPath(absolutePath);

  /// Override locale for map. Uses string format "en-US", "ar-SA".
  Future<void> overrideLocales(List<String> locales) => _instance.overrideLocales(locales);

  /// Changes state of location follow. Observe state listening to [locationFollowEvents].
  Future<void> toggleFollowState() => _instance.toggleFollowState();

  /// Changes state of location follow in navigation mode.
  Future<void> followNavigation() => _instance.followNavigation();

  /// Changes state of location follow in navigation mode.
  Future<void> stopFollowNavigation() => _instance.stopFollowNavigation();

  /// Changes state of location follow in navigation mode.
  Future<void> startFollowNavigation() => _instance.startFollowNavigation();

  /// Changes selected indoor level. Observe state listening to [indoorActiveIndex].
  Future<void> selectIndoorLevel(IndoorLevel level) => _instance.selectIndoorLevel(level.levelIndex);

  /// Enables or disables indoor floor plans.
  Future<void> setIndoorFloorPlansEnabled({required bool enabled}) =>
      _instance.setIndoorFloorPlansEnabled(enabled: enabled);

  /// Changes map camera position immediately without animation.
  Future<void> setCameraPosition(CameraPositionMessage cameraPosition) => _instance.setCameraPosition(cameraPosition);

  /// The intersection area between the camera's visibility pyramid and the map surface.
  Future<PolygonGeometryMessage> getVisibleArea() => _instance.getCameraVisibleArea();

  /// Changes map camera position point
  Future<void> setCameraPositionPoint(CameraPositionPointMessage cameraPosition) =>
      _instance.setCameraPositionPoint(cameraPosition);

  /// Changes map camera padding immediately without animation.
  Future<void> setCameraPadding(CameraSetPaddingMessage cameraPadding) => _instance.setCameraPadding(cameraPadding);

  /// Smoothly changes camera positions
  Future<void> moveCamera(
    CameraPositionMessage cameraPosition,
    double duration,
    CameraAnimationTypeMessage animationType,
  ) => _instance.moveCamera(cameraPosition, duration, animationType);

  /// Calculates camera position for route in navigation mode
  Future<CameraPositionMessage> calcPositionForRoute(CalcPositionOptionsMessage options) =>
      _instance.calcPositionForRoute(options);

  /// Calculates camera position for given list of markers to be visible
  Future<CameraPositionMessage> calcPositionForMarkers(List<String> markers, CalcPositionOptionsMessage options) =>
      _instance.calcPositionForMarkers(markers, options);

  /// Calculates camera position for given list of polygons to be visible
  Future<CameraPositionMessage> calcPositionForPolygons(List<String> polygons, CalcPositionOptionsMessage options) =>
      _instance.calcPositionForPolygons(polygons, options);

  /// Calculates camera position for given list of polylines to be visible
  Future<CameraPositionMessage> calcPositionForPolylines(List<String> polylines, CalcPositionOptionsMessage options) =>
      _instance.calcPositionForPolylines(polylines, options);

  /// Calculates camera position for given list of geo points to be visible
  Future<CameraPositionMessage> calcPositionForGeoPoints(
    List<GeoPointMessage> points,
    CalcPositionOptionsMessage options,
  ) => _instance.calcPositionForGeoPoints(points, options);

  /// Animation of the camera to the representative area (or out view port) of the search.
  /// Search returns a Geometry that represents the best area to show.
  Future<void> animateToRepresentativeArea(
    GeometryMessage area,
    CalcPositionOptionsMessage options,
    double duration,
    CameraAnimationTypeMessage animationType,
  ) => _instance.animateToRepresentativeArea(area, options, duration, animationType);

  /// Returns map camera position.
  Future<CameraPositionMessage> getCameraPosition() => _instance.getCameraPosition();

  /// Swap the navigation-cursor 3D model on the live map (raw GLB bytes).
  /// The native side applies it only while turn-by-turn guidance is active
  /// and resets the marker when the session ends (BALADY-3772).
  Future<void> setNavigationCursorModel(Uint8List glb) => _instance.setNavigationCursorModel(glb);

  /// Returns nearest objects to camera position.
  Future<List<RenderedObjectMessage>> getNearestObjects() => _instance.getNearestObjects();

  /// Set panoramas paddings.
  Future<void> setPanoramasPaddings({int left = 0, int top = 0, int right = 0, int bottom = 0}) =>
      _instance.setPanoramasPaddings(
        CameraSetPaddingMessage(leftPadding: left, topPadding: top, rightPadding: right, bottomPadding: bottom),
      );

  /// Center camera on selected panorama marker.
  Future<void> moveCameraToSelectedPanorama() => _instance.moveCameraToSelectedPanorama();

  /// Resets selected panorama.
  Future<void> unselectPanorama() => _instance.unselectPanorama();

  /// Set panorama marker to follow user's sight on 360° panorama.
  Future<void> setPanoramaMarkerAzimuth(double degree) =>
      _instance.setPanoramaMarkerAzimuth(MapDirectionMessage(degree: degree));

  /// Returns directory object info by it's id.
  Future<DirectoryObjectMessage> searchByObjectId(DgisObjectIdMessage objectId) => _instance.searchByObjectId(objectId);

  /// Returns distance in meters from current location to every point in [points] list.
  /// Works offline. Doesn't require network access.
  ///
  /// Returns null when last location is unavailable, e.g. location is disabled on device.
  Future<List<DistanceResponseMessage>?> getDistanceTo(List<DistanceRequestMessage> points) async {
    try {
      final response = await _instance.getDistanceTo(points);

      return response.whereType<DistanceResponseMessage>().toList();
    } catch (_) {
      // Last location is unavailable
      return null;
    }
  }

  /// Runs directory search by [queryText] query.
  /// [spatialRestriction] is search area limit in the form of a polygon
  /// [searchRect] is rectangular region of interest in geographic coordinates. A typical value
  /// is visible rect of the viewport
  Future<SearchResultMessage> search(
    String queryText, {
    List<int>? rubricIds,
    List<GeoPointMessage>? spatialRestriction,
    SortingTypeMessage sortingType = SortingTypeMessage.byRelevance,
    GeoRectMessage? searchRect,
    bool isOpenNow = false,
    int pageSize = 20,
    String? locale,
  }) {
    return _instance.search(
      queryText,
      rubricIds: rubricIds,
      spatialRestriction: spatialRestriction,
      sortingType: sortingType,
      weekTime: isOpenNow ? WeekTimeFactory.openNow() : null,
      pageSize: pageSize,
      searchRect: searchRect,
      locale: locale,
    );
  }

  /// Runs directory search by [SearchQueryMessage] query.
  /// [spatialRestriction] is search area limit in the form of a polygon
  /// [searchRect] is rectangular region of interest in geographic coordinates. A typical value
  /// is visible rect of the viewport
  Future<SearchResultMessage> searchByQuery(
    SearchQueryMessage query, {
    List<GeoPointMessage>? spatialRestriction,
    SortingTypeMessage sortingType = SortingTypeMessage.byRelevance,
    GeoRectMessage? searchRect,
    bool isOpenNow = false,
    int pageSize = 20,
    String? locale,
  }) {
    return _instance.searchByQuery(
      query,
      spatialRestriction: spatialRestriction,
      sortingType: sortingType,
      weekTime: isOpenNow ? WeekTimeFactory.openNow() : null,
      pageSize: pageSize,
      searchRect: searchRect,
      locale: locale,
    );
  }

  /// Runs directory search by rubrics.
  /// [spatialRestriction] is search area limit in the form of a polygon
  /// [searchRect] is rectangular region of interest in geographic coordinates. A typical value
  /// is visible rect of the viewport
  Future<SearchResultMessage> searchByRubrics(
    List<int> rubrics, {
    List<GeoPointMessage>? spatialRestriction,
    SortingTypeMessage sortingType = SortingTypeMessage.byRelevance,
    GeoRectMessage? searchRect,
    bool isOpenNow = false,
    int pageSize = 20,
    String? locale,
  }) {
    return _instance.searchByRubrics(
      rubrics,
      spatialRestriction: spatialRestriction,
      sortingType: sortingType,
      weekTime: isOpenNow ? WeekTimeFactory.openNow() : null,
      pageSize: pageSize,
      searchRect: searchRect,
      locale: locale,
    );
  }

  /// Fetches next page for given page
  Future<PageMessage> fetchPrevPage(PageMessage page) => _instance.fetchPrevPage(page.id);

  /// Fetches prev page for given page
  Future<PageMessage> fetchNextPage(PageMessage page) => _instance.fetchNextPage(page.id);

  /// Releases page from memory
  Future<void> releasePage(PageMessage page) => _instance.releasePage(page.id);

  /// Add marker to map.
  Future<void> addMarker(Marker marker, {MapObjectManagerMessage? toManager}) => _instance.addMarker(marker, toManager);

  /// Change marker options.
  Future<void> setMarkerOptions(String id, ChangeMarkerOptionsMessage options) =>
      _instance.setMarkerOptions(id, options);

  /// Add several markers to map.
  Future<void> addMarkers(List<Marker> markers, {MapObjectManagerMessage? toManager}) =>
      _instance.addMarkers(markers, toManager);

  /// Remove marker by id.
  Future<void> removeMarker(String id, {MapObjectManagerMessage? fromManager}) =>
      _instance.removeMarker(id, fromManager);

  /// Creates [MapObjectManagerMessage] with clustering.
  Future<MapObjectManagerMessage> createMapObjectManagerWithClustering(
    ClusteringMapObjectManager manager, {
    String? layerId,
  }) => _instance.createMapObjectManagerWithClustering(manager, layerId: layerId);

  /// Creates [MapObjectManagerMessage] without clustering.
  Future<MapObjectManagerMessage> createMapObjectManager({String? layerId}) =>
      _instance.createMapObjectManager(layerId: layerId);

  /// Removes [MapObjectManagerMessage].
  Future<void> removeMapObjectManager(MapObjectManagerMessage manager) => _instance.removeMapObjectManager(manager);

  /// Changes [MapObjectManagerMessage] visibility
  Future<void> setMapObjectManagerIsVisible({required bool isVisible, MapObjectManagerMessage? manager}) =>
      _instance.setMapObjectManagerIsVisible(isVisible: isVisible, manager: manager);

  /// Remove all markers added with [addMarker].
  Future<void> removeAllMarkers({MapObjectManagerMessage? fromManager}) => _instance.removeAllMarkers(fromManager);

  /// Add 3D model to map.
  Future<void> addModel(ModelMapObject model, {MapObjectManagerMessage? toManager}) =>
      _instance.addModel(model, toManager);

  /// Change 3D model options.
  Future<void> setModelOptions(String id, ChangeModelMapObjectOptionsMessage options) =>
      _instance.setModelOptions(id, options);

  /// Add several 3D models to map.
  Future<void> addModels(List<ModelMapObject> models, {MapObjectManagerMessage? toManager}) =>
      _instance.addModels(models, toManager);

  /// Remove 3D model by id.
  Future<void> removeModel(String id, {MapObjectManagerMessage? fromManager}) => _instance.removeModel(id, fromManager);

  /// Remove all 3D models added with [addModel].
  Future<void> removeAllModels({MapObjectManagerMessage? fromManager}) => _instance.removeAllModels(fromManager);

  /// Remove all markers, polygons, polylines
  /// that were added with [addMarker], [addPolygons], [addPolyline].
  Future<void> removeAll({MapObjectManagerMessage? fromManager}) async {
    await _instance.removeAllMarkers(fromManager);
    await _instance.removeAllModels(fromManager);
    await _instance.removeAllPolygons(fromManager);
    await _instance.removeAllPolylines(fromManager);
    await _instance.removeAllCircles(fromManager);
  }

  /// Add circle to map
  Future<void> addCircle(Circle circle, {MapObjectManagerMessage? toManager}) => _instance.addCircle(circle, toManager);

  /// Add several circles to map.
  Future<void> addCircles(List<Circle> circles, {MapObjectManagerMessage? toManager}) =>
      _instance.addCircles(circles, toManager);

  /// Remove circle by id.
  Future<void> removeCircle(String id, {MapObjectManagerMessage? fromManager}) =>
      _instance.removeCircle(id, fromManager);

  /// Remove all circles added with [addCircle].
  Future<void> removeAllCircles({MapObjectManagerMessage? fromManager}) => _instance.removeAllCircles(fromManager);

  /// Add polygon to map.
  Future<void> addPolygon(Polygon polygon, {MapObjectManagerMessage? toManager}) =>
      _instance.addPolygon(polygon, toManager);

  /// Add several polygons to map.
  Future<void> addPolygons(List<Polygon> polygons, {MapObjectManagerMessage? toManager}) =>
      _instance.addPolygons(polygons, toManager);

  /// Remove polygon by id.
  Future<void> removePolygon(String id, {MapObjectManagerMessage? fromManager}) =>
      _instance.removePolygon(id, fromManager);

  /// Remove all polygons added with [addPolygon].
  Future<void> removeAllPolygons({MapObjectManagerMessage? fromManager}) => _instance.removeAllPolygons(fromManager);

  /// Add polyline to map.
  Future<void> addPolyline(Polyline polyline, {MapObjectManagerMessage? toManager}) =>
      _instance.addPolyline(polyline, toManager);

  /// Add several polylines to map.
  Future<void> addPolylines(List<Polyline> polyline, {MapObjectManagerMessage? toManager}) =>
      _instance.addPolylines(polyline, toManager);

  /// Remove polyline by id.
  Future<void> removePolyline(String id, {MapObjectManagerMessage? fromManager}) =>
      _instance.removePolyline(id, fromManager);

  /// Remove all polyline added with [addPolyline].
  Future<void> removeAllPolylines({MapObjectManagerMessage? fromManager}) => _instance.removeAllPolylines(fromManager);

  /// Highlights objects by it's id.
  Future<void> setHighlighted(List<DgisObjectIdMessage> objectIds) => _instance.setHighlighted(objectIds);

  /// Remove all objects highlighted with [setHighlighted].
  Future<void> removeAllHighlights() => setHighlighted([]);

  /// Returns suggest from directory. To run search explicitly call [search].
  Future<SuggestResultMessage> fetchSuggest(
    String queryText, {
    GeoRectMessage? searchRect,
    List<SuggestedTypeMessage>? allowedResultTypes,
    String? locale,
    SuggestorTypeEnum? suggestorType,
    int? limit,
  }) => _instance.fetchSuggests(
    queryText,
    searchRect: searchRect,
    allowedResultTypes: allowedResultTypes?.map((e) => SuggestedTypeMessage_(type: e)).toList(),
    locale: locale,
    suggestorType: suggestorType,
    limit: limit,
  );

  /// Hide panorama markers. Used for optimization. In most cases should not be used directly.
  Future<void> hidePanoramasMarkers() async {
    await _instance.hidePanoramasMarkers();
  }

  /// Show available panorama markers. Observe tap listening to [markerWithPhotoTapEvents].
  Future<void> showPanoramasMarkers() async {
    await _instance.showPanoramasMarkers();
  }

  /// Remove all panorama markers from map.
  Future<void> removePanoramasMarkers() async {
    await _instance.removePanoramasMarkers();
  }

  /// Check if overlappedBy
  Future<int> overlappedBy(GeoRectMessage outer, GeoRectMessage inner) async {
    return _instance.overlappedBy(outer, inner);
  }

  /// Checks if [rect] contains [point]
  Future<bool> contains(GeoRectMessage rect, GeoPointMessage point) async {
    return _instance.contains(rect, point);
  }

  /// Checks if [outer] rect contains [inner]
  Future<bool> containsRect(GeoRectMessage outer, GeoRectMessage inner) async {
    return _instance.containsRect(outer, inner);
  }

  /// Checks if [outer] rect contains [inner]
  Future<double> pointBearing(GeoPointMessage from, GeoPointMessage to) async {
    return _instance.pointBearing(from, to);
  }

  /// By default routes is hidden. To show them call [showRoutes].
  Future<void> setRouteParams(RouteEditorRouteParamsMessage params) async {
    return _instance.setRouteParams(params);
  }

  /// Hide routes on map.
  Future<void> hideRoutes() async {
    return _instance.hideRoutes();
  }

  /// Show available routes. Observe tap listening to [routesInfoChangedEvents].
  Future<void> showRoutes() async {
    return _instance.showRoutes();
  }

  /// Move camera to active route.
  Future<void> moveCameraToActiveRoute(int index) {
    return _instance.moveCameraToActiveRoute(index);
  }

  /// Set active route index.
  Future<void> setActiveRouteIndex(int index) {
    return _instance.setActiveRouteIndex(index);
  }

  /// Starts navigation
  Future<void> startNavigation(List<SpeedRangeZoom> speedRangeZoom) => _instance.startNavigation(speedRangeZoom);

  /// Starts navigation simulation.
  Future<void> startNavigationSimulation(List<SpeedRangeZoom> speedRangeZoom) =>
      _instance.startNavigationSimulation(speedRangeZoom);

  /// Starts navigation simulation settings.
  Future<void> simulationSpeed(double speed) => _instance.simulationSpeed(speed);

  /// Starts navigation state.
  Future<Uint8List> saveNavigationState() => _instance.saveNavigationState();

  /// Restores navigation state.
  Future<void> restoreNavigationState(Uint8List state, List<SpeedRangeZoom> speedRangeZoom) =>
      _instance.restoreNavigationState(state, speedRangeZoom);

  /// Stops navigation. To hide navigation overlay call [hideNativeNavigationOverlay].
  Future<void> stopNavigation() => _instance.stopNavigation();

  /// Current navigation state
  Future<NavigationStateMessage> getCurrentNavigationState() => _instance.getCurrentNavigationState();

  /// Controls sounds in navigation.
  Future<void> toggleVoiceInstruction({required SoundToggleType toggleType}) =>
      _instance.toggleVoiceInstruction(toggleType: toggleType);

  /// Notifies CarPlay and Android Auto about favourites state changes.
  Future<void> favouritesUpdateNotification(FavouritesStateMessage favouritesState) =>
      _instance.favouritesUpdateNotification(favouritesState);

  /// Notifies CarPlay and Android Auto about authorization state changes.
  Future<void> authorizationNotification({required bool isAuthorized}) =>
      _instance.authorizationNotification(isAuthorized: isAuthorized);

  /// Used to setup platform. Should be called when permission was granted.
  /// Does not request permission by itself.
  Future<void> onLocationPermissionGranted({DesiredAccuracyMessage desiredAccuracy = DesiredAccuracyMessage.low}) {
    return _instance.onLocationPermissionGranted(desiredAccuracy);
  }

  /// Controls sounds in navigation.
  Future<void> toggleOverSpeeding({required bool overSpeeding}) =>
      _instance.toggleOverSpeeding(overSpeeding: overSpeeding);

  /// Controls sounds Cameras in navigation.
  Future<void> toggleRoadCameras({required bool roadCameras}) => _instance.toggleRoadCameras(roadCameras: roadCameras);

  /// Mute other apps sounds when navigation notification received.
  Future<void> muteOtherSounds({required bool mute}) => _instance.muteOtherSounds(mute: mute);

  /// Set navigator volume.
  Future<void> setNavigatorVolume({required int volume}) => _instance.setNavigatorVolume(volume: volume);

  /// Add panorama markers to map.
  Future<void> addPanoramasMarkers(List<MarkerWithPhotoMessage> markers) {
    return _instance.addPanoramasMarkers(AddMarkersWithPhotoMessage(markers: markers));
  }

  /// Add IO Layer to map.
  Future<void> addIOLayerObjects(List<LayerPointObjectMessage> objects) {
    return _instance.showEsriIOLayer(AddLayerPointObjectsMessage(objects: objects));
  }

  /// Remove Esri IO Layer from map.
  Future<void> removeEsriIOLayer() {
    return _instance.removeEsriIOLayer();
  }

  /// Sets map appearance
  Future<void> setAppearance(MapAppearanceMessage appearance) {
    return _instance.setAppearance(appearance);
  }

  /// Sets zoom restrictions for camera
  Future<void> setZoomRestrictions({double? min, double? max}) {
    return _instance.setZoomRestrictions(min, max);
  }

  /// Does not apply filters immediately. Resets inner state.
  void resetCurrentEvergisFiltersState() => _evergisFilters.clear();

  ///Set Public Transport Active Route
  Future<void> setPublicTransportActiveRoute(int routeIndex) {
    return _instance.setPublicTransportActiveRoute(routeIndex);
  }

  /// Find brief route infos
  Future<List<BriefRouteInfoMessage?>> findBriefRouteInfos({
    required RouteSearchOptionsMessage options,
    RouteSearchPointMessage? startPoint,
    RouteSearchPointMessage? finishPoint,
  }) {
    return _instance.findBriefRouteInfos(options, startPoint, finishPoint);
  }

  /// Find route
  Future<FindRouteResultMessage> findRoute({
    required RouteSearchOptionsMessage options,
    required RouteSearchPointMessage startPoint,
    required RouteSearchPointMessage finishPoint,
    List<RouteSearchPointMessage>? intermediatePoints,
  }) {
    return _instance.findRoute(startPoint, finishPoint, options, intermediatePoints: intermediatePoints);
  }

  ///toggle heatmap
  Future<bool> toggleHeatmap({required WeatherMapMessage message}) => _instance.toggleHeatmap(message);

  ///toggle satellite raster tile overlay
  Future<bool> toggleSatellite({required SatelliteMapMessage message}) => _instance.toggleSatellite(message);

  ///list packages
  Future<List<PackageMessage?>> listPackages() => _instance.listPackages();

  ///List voices
  Future<List<VoiceMessage?>> listVoices() => _instance.listVoices();

  /// Play Welcome Voice
  Future<void> voicePlayWelcome(String id) => _instance.voicePlayWelcome(id);

  ///Install package
  Future<void> installPackage(String id) => _instance.installPackage(id);

  ///Install voice
  Future<void> installVoice(String id) => _instance.installVoice(id);

  ///Set navigator voice
  Future<void> setNavigatorVoice(String id) => _instance.setNavigatorVoice(id);

  ///Set better route response
  Future<void> betterRouteResponse(BetterRouteResponseMessage response) => _instance.betterRouteResponse(response);

  ///Get better route settings
  Future<BetterRouteSettingsMessage> getBetterRouteSettings() => _instance.getBetterRouteSettings();

  ///Set better route settings
  Future<void> setBetterRouteSettings(BetterRouteSettingsMessage message) => _instance.setBetterRouteSettings(message);

  ///Set better route enabled
  Future<void> setBetterRouteEnabled({required bool enabled}) => _instance.setBetterRouteEnabled(enabled: enabled);

  ///Set map attribute bool
  Future<void> setMapAttributeBool(String name, {required bool value}) =>
      _instance.setMapAttributeBool(name, value: value);

  ///Set map attribute String
  Future<void> setMapAttributeString(String name, {required String value}) =>
      _instance.setMapAttributeString(name, value);

  /// Getting Android Auto/CarPlay connection state
  Future<bool> getCarConnectionState() => _instance.getCarConnectionState();

  /// Set map max fps
  Future<void> setMaxFps(int? maxFps) => _instance.setMaxFps(maxFps);

  /// Get search history items
  Future<List<SearchHistoryDirectoryObjectMessage>> getSearchHistoryItems() => _instance.getSearchHistoryItems();

  /// Add search history item
  Future<void> addSearchHistoryItem(SearchHistoryDirectoryObjectMessage item) => _instance.addSearchHistoryItem(item);

  /// Remove search history item
  Future<void> removeSearchHistoryItem(int index) => _instance.removeSearchHistoryItem(index);

  /// Clear search history items
  Future<void> clearSearchHistoryItems() => _instance.clearSearchHistoryItems();
}

/// Extension methods for `WeekTimeSearchMessage`.
extension WeekTimeFactory on WeekTimeSearchMessage {
  /// Creates a `WeekTimeSearchMessage` instance with `isOpenNow` set to `true`.
  ///
  /// This method provides a convenient way to create a `WeekTimeSearchMessage`
  /// that indicates the time is currently open. It sets the `isOpenNow` property
  /// to `true`, which can be useful for filtering or searching purposes.
  ///
  /// Returns:
  /// - [WeekTimeSearchMessage]: An instance of `WeekTimeSearchMessage` with `isOpenNow` set to `true`.
  static WeekTimeSearchMessage openNow() => WeekTimeSearchMessage(isOpenNow: true);
}

/// An enumeration representing different working hours filters.
enum WorkingHoursFilter {
  /// Filter to show only places that are currently open.
  isOpen,

  /// No specific filter applied.
  none,

  /// Filter to show only places that are open 24/7.
  isOpen24x7;

  /// Converts the [WorkingHoursFilter] enum to its corresponding [WorkingFilterMessage].
  ///
  /// Returns:
  /// - [WorkingFilterMessage.isOpen] if the filter is [WorkingHoursFilter.isOpen].
  /// - [WorkingFilterMessage.none] if the filter is [WorkingHoursFilter.none].
  /// - [WorkingFilterMessage.isOpen24x7] if the filter is [WorkingHoursFilter.isOpen24x7].
  WorkingFilterMessage toMessage() {
    switch (this) {
      case WorkingHoursFilter.isOpen:
        return WorkingFilterMessage.isOpen;
      case WorkingHoursFilter.none:
        return WorkingFilterMessage.none;
      case WorkingHoursFilter.isOpen24x7:
        return WorkingFilterMessage.isOpen24x7;
    }
  }
}
