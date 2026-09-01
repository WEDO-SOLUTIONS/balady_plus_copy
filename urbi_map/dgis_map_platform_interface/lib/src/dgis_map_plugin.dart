import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/android_auto_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/camera_state_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/indoor_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/location_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/marker_tap_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation/dashboard_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation/maneuver_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation/speed_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/object_tap_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/package_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/public_transport_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/traffic_and_parking_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/visible_rect_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/zoom_event_handler.dart';
import 'package:dgis_map_platform_interface/src/events/object_tap_events.dart';
import 'package:flutter/services.dart';

import 'control_handlers/navigation/compass_event_handler.dart';
import 'control_handlers/navigation/message_event_handler.dart';
import 'control_handlers/route_event_handler.dart';
import 'proxy_binary_mesenger.dart';

/// An implementation of [DgisMapPlugin] that uses method channels.
class DgisMapPlugin extends FlutterMapApi {
  /// The method channel used to interact with the native platform.
  late MapApi _api;

  int? _viewId;
  bool _isInitialized = false;

  StreamSubscription? _eventChannelSubscription;

  late final ZoomEventHandler _zoomEventHandler;
  late final LocationEventHandler _locationEventHandler;
  late final IndoorEventHandler _indoorEventHandler;
  late final _objectTapEventHandler = ObjectTapEventHandler();
  late final _visibleRectEventHandler = VisibleRectEventHandler();
  late final _cameraStateEventHandler = CameraStateEventHandler();
  late final _markerTapEventHandler = MarkerTapEventHandler();
  late final _routesEventHandler = RoutesEventHandler();
  late final _navigationEventHandler = NavigationEventHandler();
  late final _naviSpeedEventHandler = SpeedEventHandler();
  late final _naviDashboardEventHandler = DashboardEventHandler();
  late final _androidAutoHandler = AndroidAutoHandler();
  late final _compassEventHandler = CompassEventHandler();
  late final _publicTransportEventHandler = PublicTransportEventHandler();
  late final _naviMessageEventHandler = MessageEventHandler();
  late final _naviManeuverEventHandler = ManeuverEventHandler();
  late final _trafficAndParkingStateEventHandler = TrafficAndParkingEventHandler();
  late final _packagesHandler = PackageEventHandler();

  /// Zoom control enabled events stream.
  Stream<ZoomControlEnabledEvent> get zoomControlEnabledEvents => _zoomEventHandler.zoomControlEnabledEvents;

  /// Location enabled events stream.
  Stream<LocationEnabledEvent> get locationEnabledEvents => _locationEventHandler.locationEnabledEvents;

  /// Location follow events stream.
  Stream<LocationFollowEvent> get locationFollowEvents => _locationEventHandler.locationFollowEvents;

  /// Indoor levels names events stream.
  Stream<IndoorLevelsEvent> get indoorLevelNames => _indoorEventHandler.indoorLevelNames;

  /// Indoor levels hiding events stream.
  Stream<HideIndoorLevelsEvent> get hideIndoorLevels => _indoorEventHandler.hideIndoorLevels;

  /// Last indoor active level event.
  IndoorActiveLevelEvent? get lastIndoorActiveLevel => _indoorEventHandler.lastIndoorActiveLevel;

  /// Last indoor level names event.
  IndoorLevelsEvent? get lastIndoorLevelNames => _indoorEventHandler.lastIndoorLevelNames;

  /// Indoor active index stream.
  Stream<IndoorActiveLevelEvent> get indoorActiveIndex => _indoorEventHandler.indoorActiveLevel;

  /// Object tap events stream.
  Stream<TapEvent> get objectTapEvents => _objectTapEventHandler.objectTapEvents;

  /// Visible rect events stream.
  Stream<VisibleRectEvent> get visibleRectEvents => _visibleRectEventHandler.visibleRectEvents;

  /// Camera position events stream.
  Stream<CameraPositionMessage> get cameraPositionEvents => _visibleRectEventHandler.cameraPositionEvents;

  /// Camera state events stream.
  Stream<CameraStateEvent> get cameraStateEvents => _cameraStateEventHandler.cameraStateEvents;

  /// Marker with photo tap events stream.
  Stream<MarkerWithPhotoTapEvent> get markerWithPhotoTapEvents => _markerTapEventHandler.markerWithPhotoTapEvents;

  /// Active route changed events stream.
  Stream<ActiveRouteChangedEvent> get activeRouteChangedEvents => _routesEventHandler.activeRouteChangedEvents;

  /// Routes info changed events stream.
  Stream<RoutesInfoChangedEvent> get routesInfoChangedEvents => _routesEventHandler.routesInfoChangedEvents;

  /// Better route info events stream.
  Stream<BetterRouteInfoEvent> get betterRouteInfoEvents => _routesEventHandler.betterRouteInfoEvents;

  /// Navigation events stream.
  Stream<NavigationEvent> get navigationEvents => _navigationEventHandler.navigationEvents;

  /// Sound on events stream.
  Stream<SoundOnEvent> get soundOnEvents => _navigationEventHandler.soundOnEvents;

  /// Android Auto connection events stream.
  Stream<bool> get androidAutoConnectionEvents => _androidAutoHandler.androidAutoEvents;

  /// Navi dashboard events stream.
  Stream<NaviDashboardEvent> get naviDashboardEvents => _naviDashboardEventHandler.dashboardEvents;

  /// Compass bearing events stream.
  Stream<CompassBearingEvent> get compassBearingEvents => _compassEventHandler.compassBearingEvents;

  /// Navi speed events stream.
  Stream<NaviSpeedEvent> get naviSpeedEvents => _naviSpeedEventHandler.speedEvents;

  /// Navi message events stream.
  Stream<NaviMessageEvent> get naviMessageEvents => _naviMessageEventHandler.messageEvents;

  /// Navi maneuver events stream.
  Stream<NaviManeuverEvent> get naviManeuverEvents => _naviManeuverEventHandler.maneuverEvents;

  /// Public transport routes changed events stream.
  Stream<PublicTransportRoutesChangedEvent> get publicTransportRoutesChangedEvents =>
      _publicTransportEventHandler.routesChangedEvents;

  /// Parking state events stream.
  Stream<ParkingStateEvent> get parkingStateEvents => _trafficAndParkingStateEventHandler.parkingStateEvents;

  /// Traffic state events stream.
  Stream<TrafficStateEvent> get trafficStateEvents => _trafficAndParkingStateEventHandler.trafficStateEvents;

  /// Public transport active route changed events stream.
  Stream<PublicTransportActiveRouteChanged> get publicTransportActiveRouteChangedEvents =>
      _publicTransportEventHandler.activeRouteChangedEvents;

  /// Package progress events stream.
  Stream<PackageProgressEvent> get packageProgressEvents => _packagesHandler.packageProgressEvents;

  /// Package info changed events stream.
  Stream<PackageInfoChangedEvent> get packageInfoChangedEvents => _packagesHandler.packagesInfoChangedEvents;

  /// Route options events stream.
  Stream<RouteOptionsEvent> get routeOptionsEvent => _navigationEventHandler.routeOptionEvents;

  /// isInitialized getter.
  bool get isInitialized => _isInitialized;

  /// Initializes the plugin with the given [viewId].
  Future<InitializeMessage> initialize(int viewId) async {
    _viewId = viewId;

    final messenger = ProxyBinaryMessenger(suffix: 'map_$viewId');
    _api = MapApi(binaryMessenger: messenger);

    final response = await _api.initialize();
    if (response.wasInitialized) {
      _eventChannelSubscription = _initEventChannel();

      _isInitialized = true;
    }

    _zoomEventHandler = ZoomEventHandler(_api);
    _locationEventHandler = LocationEventHandler(_api);
    _indoorEventHandler = IndoorEventHandler(_api);

    FlutterMapApi.setUp(this);

    return response;
  }

  /// Disposes the plugin and close all streams
  Future<void> dispose() async {
    await _eventChannelSubscription?.cancel();
    await _zoomEventHandler.dispose();
    await _locationEventHandler.dispose();
    await _indoorEventHandler.dispose();
    await _objectTapEventHandler.dispose();
    await _routesEventHandler.dispose();
    await _navigationEventHandler.dispose();
    await _naviSpeedEventHandler.dispose();
    await _naviDashboardEventHandler.dispose();
    await _androidAutoHandler.dispose();
    await _compassEventHandler.dispose();
    await _naviManeuverEventHandler.dispose();
    await _trafficAndParkingStateEventHandler.dispose();
    await _publicTransportEventHandler.dispose();
  }

  /// On zoom action event.
  Future<void> onZoomAction(ZoomControlType btn, {required bool isPressed}) async {
    return _zoomEventHandler.onZoomAction(btn, isPressed: isPressed);
  }

  /// Toggle follow state.
  Future<void> toggleFollowState() {
    return _locationEventHandler.toggleFollowState();
  }

  /// Follow navigation.
  Future<void> followNavigation() {
    return _api.followNavigation();
  }

  /// Start follow in navigation mode.
  Future<void> startFollowNavigation() {
    return _api.startFollowNavigation();
  }

  /// Stop follow in navigation mode.
  Future<void> stopFollowNavigation() {
    return _api.stopFollowNavigation();
  }

  StreamSubscription _initEventChannel() {
    return EventChannel('com.dgis.map_view_events_$_viewId').receiveBroadcastStream().listen((event) {
      final map = event as Map<dynamic, dynamic>;
      switch (map['event']) {
        case MyLocationTapEvent.name:
          return _objectTapEventHandler.myLocationTapEvent(map);
        case ZoomControlEnabledEvent.zoomInEvent:
          return _zoomEventHandler.zoomInEvent(map);
        case ZoomControlEnabledEvent.zoomOutEvent:
          return _zoomEventHandler.zoomOutEvent(map);
        case LocationEnabledEvent.name:
          return _locationEventHandler.enabledEvent(map);
        case LocationFollowEvent.name:
          return _locationEventHandler.followEvent(map);
        case IndoorLevelsEvent.name:
          return _indoorEventHandler.levelNamesEvent(map);
        case HideIndoorLevelsEvent.name:
          return _indoorEventHandler.hideLevelsEvent();
        case IndoorActiveLevelEvent.name:
          return _indoorEventHandler.activeLevelEvent(map);
        case ObjectTapEvent.name:
          return _objectTapEventHandler.objectTapEvent(map);

        case RoadEventTapEvent.name:
          return _objectTapEventHandler.roadEventTapEvent(map);
        case MarkerTapEvent.name:
          return _objectTapEventHandler.markerTapEvent(map);
        case ModelTapEvent.name:
          return _objectTapEventHandler.modelTapEvent(map);
        case ClusterTapEvent.name:
          unawaited(
            _objectTapEventHandler.clusterTapEvent(map, _api).then((value) async {
              await _api.releaseCluster(map["cluster"]["id"]);
            }),
          );
          break;
        case PolygonTapEvent.name:
          return _objectTapEventHandler.polygonTapEvent(map);
        case PolylineTapEvent.name:
          return _objectTapEventHandler.polylineTapEvent(map);
        case CircleTapEvent.name:
          return _objectTapEventHandler.circleTapEvent(map);
        case VisibleRectEvent.name:
          return _visibleRectEventHandler.visibleRectEvent(map);
        case "cameraPositionChanged":
          return _visibleRectEventHandler.cameraPositionEvent(map);
        case CameraStateEvent.name:
          return _cameraStateEventHandler.cameraStateEvent(map);
        case MarkerWithPhotoTapEvent.name:
          return _markerTapEventHandler.markerWithPhotoTapEvent(map);
        case ActiveRouteChangedEvent.name:
          return _routesEventHandler.activeRouteChangedEvent(map);
        case RoutesInfoChangedEvent.name:
          return _routesEventHandler.routesInfoChangedEvent(map);
        case BetterRouteInfoEvent.name:
          return _routesEventHandler.betterRouteInfoEvent(map);
        case NavigationEvent.name:
          return _navigationEventHandler.handleNavigationEvent(map);
        case CarConnectionEvent.name:
          return _androidAutoHandler.handleAndroidAutoConnectionEvent(map);
        case IoTapEvent.name:
          return _objectTapEventHandler.onIoTap(map);
        case IdleTapEvent.name:
          return _objectTapEventHandler.onIdleTap(map);
        case NaviSpeedEvent.name:
          return _naviSpeedEventHandler.handleNavigationEvent(map);
        case NaviDashboardEvent.name:
          return _naviDashboardEventHandler.handleDashboardEvent(map);
        case CompassBearingEvent.name:
          return _compassEventHandler.compassBearingChangedEvent(map);
        case RouteOptionsEvent.name:
          return _navigationEventHandler.routeOptionsEvent(map);
        case SoundOnEvent.name:
          return _navigationEventHandler.soundOnEvent(map);
        case NaviMessageEvent.name:
          return _naviMessageEventHandler.handleMessageEvent(map);
        case ManeuverEvent.name:
          return _naviManeuverEventHandler.handleManeuverEvent(map);
        case ManeuverAdditionalEvent.name:
          return _naviManeuverEventHandler.handleAdditionalManeuverEvent(map);
        case ParkingStateEvent.name:
          return _trafficAndParkingStateEventHandler.parkingStateChanged(map);
        case TrafficStateEvent.name:
          return _trafficAndParkingStateEventHandler.trafficStateChanged(map);
        case PublicTransportRoutesChangedEvent.name:
          return _publicTransportEventHandler.routesChangedEvent(map);
        case PublicTransportActiveRouteChanged.name:
          return _publicTransportEventHandler.activeRouteChangedEvent(map);
        case PackageProgressEvent.name:
          return _packagesHandler.packageProgressEvent(map);
        case PackageInfoChangedEvent.name:
          return _packagesHandler.packageInfoChangedEvent(map);
      }
    });
  }

  /// Select indoor level.
  Future<void> selectIndoorLevel(int index) {
    return _indoorEventHandler.selectIndoorLevel(index);
  }

  /// Enables or disables indoor floor plans.
  Future<void> setIndoorFloorPlansEnabled({required bool enabled}) {
    return _api.setIndoorFloorPlansEnabled(enabled);
  }

  /// Load styles from asset.
  Future<void> loadStyles(String asset) {
    return _api.loadStyles(asset);
  }

  /// Load styles from an absolute filesystem path (e.g. a repacked `.2gis`
  /// written to the app's support/cache directory).
  Future<void> loadStylesFromPath(String absolutePath) {
    return _api.loadStylesFromPath(absolutePath);
  }

  /// Override locales.
  Future<void> overrideLocales(List<String> locales) {
    return _api.overrideLocales(locales);
  }

  /// Set Camera position.
  Future<void> setCameraPosition(CameraPositionMessage cameraPosition) {
    return _api.setCameraPosition(cameraPosition);
  }

  /// Return the visible area of the screen that user looks at. Return
  /// coordinates of the rectangle
  Future<PolygonGeometryMessage> getCameraVisibleArea() {
    return _api.getCameraVisibleArea();
  }

  /// Set camera position point.
  Future<void> setCameraPositionPoint(CameraPositionPointMessage cameraPosition) {
    return _api.setCameraPositionPoint(cameraPosition);
  }

  /// Set camera padding.
  Future<void> setCameraPadding(CameraSetPaddingMessage cameraPadding) {
    return _api.setCameraPadding(cameraPadding);
  }

  /// Move Camera to the specified [cameraPosition].
  Future<void> moveCamera(
    CameraPositionMessage cameraPosition,
    double duration,
    CameraAnimationTypeMessage animationType,
  ) {
    return _api.moveCamera(cameraPosition, duration, animationType);
  }

  /// Set map attribute string.
  Future<void> setMapAttributeString(String name, String value) {
    return _api.setMapAttributeString(name, value);
  }

  /// Set map attribute bool.
  Future<void> setMapAttributeBool(String name, {required bool value}) {
    return _api.setMapAttributeBool(name, value);
  }

  /// Calculate [CameraPositionMessage] for the specified route.
  Future<CameraPositionMessage> calcPositionForRoute(CalcPositionOptionsMessage options) {
    return _api.calcPositionForRoute(options);
  }

  /// Calculate [CameraPositionMessage] for the specified markers.
  Future<CameraPositionMessage> calcPositionForMarkers(List<String> markers, CalcPositionOptionsMessage options) {
    return _api.calcPositionForMarkers(markers, options);
  }

  /// Calculate [CameraPositionMessage] for the specified polygons.
  Future<CameraPositionMessage> calcPositionForPolygons(List<String> polygons, CalcPositionOptionsMessage options) {
    return _api.calcPositionForPolygons(polygons, options);
  }

  /// Calculate [CameraPositionMessage] for the specified polylines.
  Future<CameraPositionMessage> calcPositionForPolylines(List<String> polylines, CalcPositionOptionsMessage options) {
    return _api.calcPositionForPolylines(polylines, options);
  }

  /// Calculate [CameraPositionMessage] for the specified points.
  Future<CameraPositionMessage> calcPositionForGeoPoints(
    List<GeoPointMessage> points,
    CalcPositionOptionsMessage options,
  ) {
    return _api.calcPositionForGeoPoints(points, options);
  }

  /// Animation of the camera to the representative area (or out view port) of the search.
  /// Search returns a Geometry that represents the best area to show.
  Future<void> animateToRepresentativeArea(
    GeometryMessage area,
    CalcPositionOptionsMessage options,
    double duration,
    CameraAnimationTypeMessage animationType,
  ) {
    return _api.animateToRepresentativeArea(area, options, duration, animationType);
  }

  /// Get current camera position.
  Future<CameraPositionMessage> getCameraPosition() {
    return _api.getCameraPosition();
  }

  /// Get nearest objects.
  Future<List<RenderedObjectMessage>> getNearestObjects() async {
    return (await _api.getNearestObjects()).whereType<RenderedObjectMessage>().toList();
  }

  /// Search by object id.
  Future<DirectoryObjectMessage> searchByObjectId(DgisObjectIdMessage objectId) {
    return _api.searchByObjectId(objectId);
  }

  /// Search method. Returns a list of objects that match the search query.
  /// The search is performed with [queryText] and [categories] parameters.
  /// - [spatialRestriction] - spatial restriction for search. Search is bounded by this rectangle.
  /// - [sortingType] - sorting type for search results. Could be by distance, by rating or by relevance.
  /// - [pageSize] - number of objects in the search result.
  /// - [weekTime] - week time for search. If not null, search will be performed by week time.
  /// - [searchRect] - user viewport. If not null, search will be performed for this viewport and will give
  /// more relevant results.
  Future<SearchResultMessage> search(
    String queryText, {
    List<int>? rubricIds,
    List<GeoPointMessage>? spatialRestriction,
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    String? locale,
  }) {
    return _api.search(queryText, rubricIds, spatialRestriction, weekTime, searchRect, sortingType, pageSize, locale);
  }

  /// Search by query.
  /// - [spatialRestriction] - spatial restriction for search. Search is bounded by this rectangle.
  /// - [sortingType] - sorting type for search results. Could be by distance, by rating or by relevance.
  /// - [pageSize] - number of objects in the search result.
  /// - [weekTime] - week time for search. If not null, search will be performed by week time.
  /// - [searchRect] - user viewport. If not null, search will be performed for this viewport and will give
  /// more relevant results.
  Future<SearchResultMessage> searchByQuery(
    SearchQueryMessage query, {
    List<GeoPointMessage>? spatialRestriction,
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    String? locale,
  }) {
    return _api.searchByQuery(query, spatialRestriction, weekTime, searchRect, sortingType, pageSize, locale);
  }

  /// Search by rubrics.
  /// - [spatialRestriction] - spatial restriction for search. Search is bounded by this rectangle.
  /// - [sortingType] - sorting type for search results. Could be by distance, by rating or by relevance.
  /// - [pageSize] - number of objects in the search result.
  /// - [weekTime] - week time for search. If not null, search will be performed by week time.
  /// - [searchRect] - user viewport. If not null, search will be performed for this viewport and will give
  /// more relevant results.
  Future<SearchResultMessage> searchByRubrics(
    List<int> rubrics, {
    List<GeoPointMessage>? spatialRestriction,
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    String? locale,
  }) {
    return _api.searchByRubrics(rubrics, spatialRestriction, weekTime, searchRect, sortingType, pageSize, locale);
  }

  /// Fetch Previous Page.
  Future<PageMessage> fetchPrevPage(PageIdMessage pageId) => _api.fetchPrevPage(pageId);

  /// Fetch Next Page.
  Future<PageMessage> fetchNextPage(PageIdMessage pageId) => _api.fetchNextPage(pageId);

  /// Release Page.
  Future<void> releasePage(PageIdMessage pageId) => _api.releasePage(pageId);

  /// Fetch Suggests.
  /// This method returns a list of suggestions for the search query for [queryText].
  /// - [allowedResultTypes] - list of allowed result types.
  /// - [searchRect] - user viewport. If not null, search will be performed for this viewport and will give
  /// - [locale] - locale for the search. If not null, search will be performed for this locale.
  /// - [suggestorType] - suggestor type for the search. If not null, search will return only suggestions of this type.
  /// - [limit] - limit for the search. If not null, search will return only this number of suggestions. By default it is 10.
  Future<SuggestResultMessage> fetchSuggests(
    String queryText, {
    List<SuggestedTypeMessage_>? allowedResultTypes,
    GeoRectMessage? searchRect,
    String? locale,
    SuggestorTypeEnum? suggestorType,
    int? limit,
  }) => _api.fetchSuggests(queryText, allowedResultTypes, searchRect, locale, suggestorType, limit);

  /// Get distance to the specified points.
  Future<List<DistanceResponseMessage?>> getDistanceTo(List<DistanceRequestMessage> points) {
    return _api.getDistanceTo(points);
  }

  /// Add marker on the map.
  Future<void> addMarker(Marker marker, MapObjectManagerMessage? manager) {
    if (marker.onTap != null) {
      _objectTapEventHandler.addMarkerHandler(marker.id, marker.onTap!, manager?.id);
    }
    return _api.addMarker(MarkerMessage(id: marker.id, options: marker.options), manager);
  }

  Future<void> setMarkerOptions(String id, ChangeMarkerOptionsMessage options) {
    return _api.setMarkerOptions(id, options);
  }

  /// Add markers on the map.
  Future<void> addMarkers(List<Marker> markers, MapObjectManagerMessage? manager) {
    for (var marker in markers) {
      if (marker.onTap != null) {
        _objectTapEventHandler.addMarkerHandler(marker.id, marker.onTap!, manager?.id);
      }
    }
    return _api.addMarkers(
      markers.map((marker) => MarkerMessage(id: marker.id, options: marker.options)).toList(),
      manager,
    );
  }

  /// Remove marker from the map by id
  Future<void> removeMarker(String id, MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeMarkerHandler(id);
    return _api.removeMarker(id, manager);
  }

  /// Remove all markers from the map related to the [manager].
  Future<void> removeAllMarkers(MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeAllMarkerHandlers(manager?.id);
    return _api.removeAllMarkers(manager);
  }

  /// Add 3D model on the map.
  Future<void> addModel(ModelMapObject model, MapObjectManagerMessage? manager) {
    if (model.onTap != null) {
      _objectTapEventHandler.addModelHandler(model.id, model.onTap!, manager?.id);
    }
    return _api.addModel(ModelMapObjectMessage(id: model.id, options: model.options), manager);
  }

  /// Change 3D model options.
  Future<void> setModelOptions(String id, ChangeModelMapObjectOptionsMessage options) {
    return _api.setModelOptions(id, options);
  }

  /// Add 3D models on the map.
  Future<void> addModels(List<ModelMapObject> models, MapObjectManagerMessage? manager) {
    for (var model in models) {
      if (model.onTap != null) {
        _objectTapEventHandler.addModelHandler(model.id, model.onTap!, manager?.id);
      }
    }
    return _api.addModels(
      models.map((model) => ModelMapObjectMessage(id: model.id, options: model.options)).toList(),
      manager,
    );
  }

  /// Remove 3D model from the map by id.
  Future<void> removeModel(String id, MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeModelHandler(id);
    return _api.removeModel(id, manager);
  }

  /// Remove all 3D models from the map related to the [manager].
  Future<void> removeAllModels(MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeAllModelHandlers(manager?.id);
    return _api.removeAllModels(manager);
  }

  /// Create map object manager with clustering.
  Future<MapObjectManagerMessage> createMapObjectManagerWithClustering(
    ClusteringMapObjectManager manager, {
    String? layerId,
  }) async {
    final result = await _api.createMapObjectManagerWithClustering(manager.options, layerId);
    _objectTapEventHandler.addClusterRenderer(result.id, manager.renderCluster);
    if (manager.onTap != null) {
      _objectTapEventHandler.addClusterHandler(result.id, manager.onTap!);
    }
    return result;
  }

  /// Create map object manager.
  Future<MapObjectManagerMessage> createMapObjectManager({String? layerId}) async {
    final result = await _api.createMapObjectManager(layerId);
    return result;
  }

  /// Remove map object manager.
  Future<void> removeMapObjectManager(MapObjectManagerMessage manager) {
    _objectTapEventHandler.removeClusterRenderer(manager.id);
    return _api.removeMapObjectManager(manager);
  }

  /// Set map object manager visible.
  Future<void> setMapObjectManagerIsVisible({required bool isVisible, required MapObjectManagerMessage? manager}) {
    return _api.setMapObjectManagerIsVisible(isVisible, manager);
  }

  @override
  SimpleClusterOptionsMessage renderCluster(MapObjectManagerMessage manager, int objectCount) {
    return _objectTapEventHandler.clusterRenderers[manager.id]!(objectCount);
  }

  /// --- POLYGON ---

  /// Add polygon on the map related to the [manager].
  Future<void> addPolygon(Polygon polygon, MapObjectManagerMessage? manager) {
    if (polygon.onTap != null) {
      _objectTapEventHandler.addPolygonHandler(polygon.id, polygon.onTap!, manager?.id);
    }
    return _api.addPolygon(PolygonMessage(id: polygon.id, options: polygon.options), manager);
  }

  /// Add polygons on the map related to the [manager].
  Future<void> addPolygons(List<Polygon> polygons, MapObjectManagerMessage? manager) {
    for (var polygon in polygons) {
      if (polygon.onTap != null) {
        _objectTapEventHandler.addPolygonHandler(polygon.id, polygon.onTap!, manager?.id);
      }
    }
    return _api.addPolygons(
      polygons.map((polygon) => PolygonMessage(id: polygon.id, options: polygon.options)).toList(),
      manager,
    );
  }

  /// Remove polygon from the map by id related to the [manager].
  Future<void> removePolygon(String id, MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removePolygonHandler(id);
    return _api.removePolygon(id, manager);
  }

  /// Remove all polygons from the map related to the [manager].
  Future<void> removeAllPolygons(MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeAllPolygonHandlers(manager?.id);
    return _api.removeAllPolygons(manager);
  }

  /// --- CIRCLE ---

  /// Add circle on the map related to the [manager].
  Future<void> addCircle(Circle circle, MapObjectManagerMessage? manager) {
    if (circle.onTap != null) {
      _objectTapEventHandler.addCircleHandler(circle.id, circle.onTap!, manager?.id);
    }
    return _api.addCircle(CircleMessage(id: circle.id, options: circle.options), manager);
  }

  /// Add circles on the map related to the [manager].
  Future<void> addCircles(List<Circle> circles, MapObjectManagerMessage? manager) {
    for (var circle in circles) {
      if (circle.onTap != null) {
        _objectTapEventHandler.addCircleHandler(circle.id, circle.onTap!, manager?.id);
      }
    }
    return _api.addCircles(
      circles.map((circle) => CircleMessage(id: circle.id, options: circle.options)).toList(),
      manager,
    );
  }

  /// Remove circle from the map by id related to the [manager].
  Future<void> removeCircle(String id, MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeCircleHandler(id);
    return _api.removeCircle(id, manager);
  }

  /// Remove all circles from the map related to the [manager].
  Future<void> removeAllCircles(MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeAllCircleHandlers(manager?.id);
    return _api.removeAllCircles(manager);
  }

  /// --- POLYLINE ---

  /// Add polyline on the map related to the [manager].
  Future<void> addPolyline(Polyline polyline, MapObjectManagerMessage? manager) {
    if (polyline.onTap != null) {
      _objectTapEventHandler.addPolylineHandler(polyline.id, polyline.onTap!, manager?.id);
    }
    return _api.addPolyline(PolylineMessage(id: polyline.id, options: polyline.options), manager);
  }

  /// Add polylines on the map related to the [manager].
  Future<void> addPolylines(List<Polyline> polylines, MapObjectManagerMessage? manager) {
    for (var polyline in polylines) {
      if (polyline.onTap != null) {
        _objectTapEventHandler.addPolylineHandler(polyline.id, polyline.onTap!, manager?.id);
      }
    }
    return _api.addPolylines(
      polylines.map((polyline) => PolylineMessage(id: polyline.id, options: polyline.options)).toList(),
      manager,
    );
  }

  /// Remove polyline from the map by id related to the [manager].
  Future<void> removePolyline(String id, MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removePolylineHandler(id);
    return _api.removePolyline(id, manager);
  }

  /// Remove all polylines from the map related to the [manager].
  Future<void> removeAllPolylines(MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeAllPolylineHandlers(manager?.id);
    return _api.removeAllPolylines(manager);
  }

  /// Show Esri IO layer.
  Future<void> showEsriIOLayer(AddLayerPointObjectsMessage message) {
    return _api.showEsriIOLayer(message);
  }

  /// Remove Esri IO layer.
  Future<void> removeEsriIOLayer() {
    return _api.removeEsriIOLayer();
  }

  /// Set highlighted objects.
  Future<void> setHighlighted(List<DgisObjectIdMessage> objectIds) {
    return _api.setHighlighted(objectIds);
  }

  /// On location permission granted.
  Future<void> onLocationPermissionGranted(DesiredAccuracyMessage desiredAccuracy) {
    return _api.onLocationPermissionGranted(desiredAccuracy);
  }

  /// Add Panoramas markers.
  Future<void> addPanoramasMarkers(AddMarkersWithPhotoMessage markers) {
    return _api.addPanoramasMarkers(markers);
  }

  /// Hide Panoramas markers.
  Future<void> hidePanoramasMarkers() {
    return _api.hidePanoramasMarkers();
  }

  /// Show Panoramas markers.
  Future<void> showPanoramasMarkers() {
    return _api.showPanoramasMarkers();
  }

  /// Remove Panoramas markers.
  Future<void> removePanoramasMarkers() {
    return _api.removePanoramasMarkers();
  }

  /// Overlapped by.
  Future<int> overlappedBy(GeoRectMessage outerRect, GeoRectMessage innerRect) {
    return _api.overlappedBy(outerRect, innerRect);
  }

  /// Move camera to active route.
  Future<void> moveCameraToActiveRoute(int index) {
    return _api.moveCameraToActiveRoute(index);
  }

  /// Set active route index.
  Future<void> setActiveRouteIndex(int index) {
    return _api.setActiveRouteIndex(index);
  }

  /// Contains
  Future<bool> contains(GeoRectMessage rect, GeoPointMessage point) {
    return _api.contains(rect, point);
  }

  /// Contains rect
  Future<bool> containsRect(GeoRectMessage outer, GeoRectMessage inner) {
    return _api.containsRect(outer, inner);
  }

  /// Point bearing
  Future<double> pointBearing(GeoPointMessage from, GeoPointMessage to) {
    return _api.pointBearing(from, to);
  }

  /// Set route params.
  Future<void> setRouteParams(RouteEditorRouteParamsMessage params) {
    return _api.setRouteParams(params);
  }

  /// Hide routes.
  Future<void> hideRoutes() {
    return _api.hideRoutes();
  }

  /// Show routes.
  Future<void> showRoutes() {
    return _api.showRoutes();
  }

  /// Start navigation.
  Future<void> startNavigation(List<SpeedRangeZoom> speedRangeZoom) {
    return _api.startNavigation(speedRangeZoom);
  }

  /// Start navigation simulation.
  Future<void> startNavigationSimulation(List<SpeedRangeZoom> speedRangeZoom) {
    return _api.startNavigationSimulation(speedRangeZoom);
  }

  /// Simulation speed.
  Future<void> simulationSpeed(double speed) {
    return _api.simulationSpeed(speed);
  }

  /// Save navigation state.
  Future<Uint8List> saveNavigationState() {
    return _api.saveNavigationState();
  }

  /// Restore navigation state.
  Future<void> restoreNavigationState(Uint8List state, List<SpeedRangeZoom> speedRangeZoom) {
    return _api.restoreNavigationState(state, speedRangeZoom);
  }

  /// Stop navigation.
  Future<void> stopNavigation() {
    return _api.stopNavigation();
  }

  /// Get current navigation state.
  Future<NavigationStateMessage> getCurrentNavigationState() => _api.getCurrentNavigationState();

  /// Move camera to selected panorama.
  Future<void> moveCameraToSelectedPanorama() {
    return _api.moveCameraToSelectedPanorama();
  }

  /// Set panoramas paddings.
  Future<void> setPanoramasPaddings(CameraSetPaddingMessage message) {
    return _api.setPanoramasPaddings(message);
  }

  /// Unselect panorama.
  Future<void> unselectPanorama() {
    return _api.unselectPanorama();
  }

  /// Set panorama marker azimuth.
  Future<void> setPanoramaMarkerAzimuth(MapDirectionMessage message) {
    return _api.setPanoramaMarkerAzimuth(message);
  }

  /// on compass clicked.
  Future<void> onCompassClicked() {
    return _api.onCompassClicked();
  }

  /// Start Free Roam
  Future<void> startFreeRoam(List<SpeedRangeZoom> speedRangeZoom) {
    return _api.startFreeRoam(speedRangeZoom);
  }

  /// Stop Free Roam
  Future<void> stopFreeRoam() {
    return _api.stopFreeRoam();
  }

  /// Get Android Auto/CarPlay connection state.
  Future<bool> getCarConnectionState() {
    return _api.getCarConnectionState();
  }

  /// The [toggleVoiceInstruction] is responsible for switching the sound.
  ///
  /// Parameters:
  /// - [toggleType]: The type of toggle that determines which voice instructions
  /// will be enabled or disabled.
  ///
  /// if the [SoundToggleType.important] thing is selected so that the sounds of maneuvers are not heard,
  /// if [SoundToggleType.none] turns off all sounds
  /// [SoundToggleType.all], enable voice acting for all sounds.
  Future<void> toggleVoiceInstruction({required SoundToggleType toggleType}) {
    return _api.toggleVoiceInstruction(toggleType);
  }

  /// The [favouritesUpdateNotification] method notifies CarPlay and Android Auto about favourites state changes.
  ///
  /// Parameters:
  /// - [favouritesState]: A current favourites satet
  Future<void> favouritesUpdateNotification(FavouritesStateMessage favouritesState) {
    return _api.favouritesUpdateNotification(favouritesState);
  }

  /// The [authorizationNotification] method notifies CarPlay and Android Auto about authorization state changes.
  ///
  /// Parameters:
  /// - [isAuthorized]: A boolean value where `true` indicates the user is authorized,
  /// and `false` indicates the user is not authorized.
  Future<void> authorizationNotification({required bool isAuthorized}) {
    return _api.authorizationNotification(isAuthorized);
  }

  /// The [toggleRoadCameras] method is responsible for enabling or disabling
  /// notifications related to road cameras.
  ///
  /// Parameters:
  /// - [roadCameras]: A boolean value where `true` enables notifications for road cameras,
  /// and `false` disables them.
  Future<void> toggleRoadCameras({required bool roadCameras}) {
    return _api.toggleRoadCameras(roadCameras);
  }

  /// The [toggleOverSpeeding] method controls the notifications for overspeeding.
  ///
  /// Parameters:
  /// - [overSpeeding]: A boolean value where `true` enables overspeeding notifications,
  /// and `false` disables them.
  Future<void> toggleOverSpeeding({required bool overSpeeding}) {
    return _api.toggleOverSpeeding(overSpeeding);
  }

  /// The [setNavigatorVolume] method sets the volume for the navigator's voice instructions.
  ///
  /// Parameters:
  /// - [volume]: The [AudioVolumeMessage] that specifies the desired volume level.
  Future<void> setNavigatorVolume({required int volume}) {
    return _api.setNavigatorVolume(volume);
  }

  /// The [muteOtherSounds] method is responsible for muting or unmuting other sounds
  /// while the navigator is active.
  ///
  /// Parameters:
  /// - [mute]: A boolean value where `true` mutes other sounds,
  /// and `false` allows other sounds to play.
  Future<void> muteOtherSounds({required bool mute}) {
    return _api.muteOtherSounds(mute);
  }

  /// Notifies the system when traffic and parking data have been attached.
  ///
  /// This method is called to signal that the traffic and parking information
  /// has been successfully linked to the map. It returns a [Future] that
  /// completes when the operation is finished.
  Future<void> onTrafficAndParkingAttached() {
    return _api.onTrafficAndParkingAttached();
  }

  /// Notifies the system when traffic and parking data have been detached.
  ///
  /// This method is called to signal that the traffic and parking information
  /// has been successfully removed or unlinked from the map. It returns a [Future]
  /// that completes when the operation is finished.
  Future<void> onTrafficAndParkingDetached() {
    return _api.onTrafficAndParkingDetached();
  }

  /// Parking clicked
  Future<void> onParkingClicked() {
    return _api.onParkingClicked();
  }

  /// Traffic clicked
  Future<void> onTrafficClicked() {
    return _api.onTrafficClicked();
  }

  /// Set appearance.
  Future<void> setAppearance(MapAppearanceMessage appearance) {
    return _api.setAppearance(appearance);
  }

  /// Set zoom restrictions.
  Future<void> setZoomRestrictions(double? min, double? max) {
    return _api.setZoomRestrictions(min, max);
  }

  /// Set public transport routes.
  Future<void> setPublicTransportActiveRoute(int routeIndex) {
    return _api.setPublicTransportActiveRoute(routeIndex);
  }

  /// Find Brief Route Infos.
  Future<List<BriefRouteInfoMessage?>> findBriefRouteInfos(
    RouteSearchOptionsMessage routeSearchOptions,
    RouteSearchPointMessage? startPoint,
    RouteSearchPointMessage? finishPoint,
  ) {
    return _api.findBriefRouteInfos(routeSearchOptions, startPoint, finishPoint);
  }

  /// Find Route.
  Future<FindRouteResultMessage> findRoute(
    RouteSearchPointMessage startPoint,
    RouteSearchPointMessage finishPoint,
    RouteSearchOptionsMessage routeSearchOptions, {
    List<RouteSearchPointMessage>? intermediatePoints,
  }) {
    return _api.findRoute(startPoint, finishPoint, routeSearchOptions, intermediatePoints: intermediatePoints);
  }

  /// Retrieves a list of available packages.
  ///
  /// Returns:
  /// - [Future<List<PackageMessage?>>]: A future that completes with a list of [PackageMessage] objects,
  /// representing the available packages.
  Future<List<PackageMessage?>> listPackages() {
    return _api.listPackages();
  }

  /// Retrieves a list of available voices.
  ///
  /// Returns:
  /// - [Future<List<VoiceMessage?>>]: A future that completes with a list of [VoiceMessage] objects,
  /// representing the available voices.
  Future<List<VoiceMessage?>> listVoices() {
    return _api.listVoices();
  }

  /// Plays a welcome message associated with a specific voice.
  ///
  /// Parameters:
  /// - [id]: The identifier of the welcome message to be played.
  ///
  /// Returns:
  /// - [Future<void>]: A future that completes when the action is done.
  Future<void> voicePlayWelcome(String id) {
    return _api.voicePlayWelcome(id);
  }

  /// Installs a package based on its identifier.
  ///
  /// Parameters:
  /// - [id]: The identifier of the package to be installed.
  ///
  /// Returns:
  /// - [Future<void>]: A future that completes when the installation is done.
  Future<void> installPackage(String id) {
    return _api.installPackage(id);
  }

  /// Installs a voice based on its identifier.
  ///
  /// Parameters:
  /// - [id]: The identifier of the voice to be installed.
  ///
  /// Returns:
  /// - [Future<void>]: A future that completes when the installation is done.
  Future<void> installVoice(String id) {
    return _api.installVoice(id);
  }

  /// Sets the navigator's voice based on its identifier.
  ///
  /// Parameters:
  /// - [id]: The identifier of the voice to be set as the navigator's voice.
  ///
  /// Returns:
  /// - [Future<void>]: A future that completes when the voice is set.
  Future<void> setNavigatorVoice(String id) {
    return _api.setNavigatorVoice(id);
  }

  /// Toggle heatmap.
  Future<bool> toggleHeatmap(WeatherMapMessage message) => _api.toggleHeatmap(message);

  /// Toggle satellite raster tile overlay.
  Future<bool> toggleSatellite(SatelliteMapMessage message) => _api.toggleSatellite(message);

  /// Better route response.
  Future<void> betterRouteResponse(BetterRouteResponseMessage response) => _api.betterRouteResponse(response);

  /// Get better route settings.
  Future<BetterRouteSettingsMessage> getBetterRouteSettings() => _api.getBetterRouteSettings();

  /// Set better route settings.
  Future<void> setBetterRouteSettings(BetterRouteSettingsMessage message) => _api.setBetterRouteSettings(message);

  /// Set better route enabled.
  Future<void> setBetterRouteEnabled({required bool enabled}) => _api.setBetterRouteEnabled(enabled);

  /// Set map max fps
  Future<void> setMaxFps(int? fps) => _api.setMaxFps(fps);

  /// Get search history items
  Future<List<SearchHistoryDirectoryObjectMessage>> getSearchHistoryItems() => _api.getSearchHistoryItems();

  /// Add search history item
  Future<void> addSearchHistoryItem(SearchHistoryDirectoryObjectMessage item) => _api.addSearchHistoryItem(item);

  /// Remove search history item
  Future<void> removeSearchHistoryItem(int index) => _api.removeSearchHistoryItem(index);

  /// Clear search history items
  Future<void> clearSearchHistoryItems() => _api.clearSearchHistoryItems();
}
