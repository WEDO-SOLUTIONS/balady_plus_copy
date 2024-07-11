import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';
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
  late final _compassEventHandler = CompassEventHandler();
  late final _publicTransportEventHandler = PublicTransportEventHandler();
  late final _naviMessageEventHandler = MessageEventHandler();
  late final _naviManeuverEventHandler = ManeuverEventHandler();
  late final _trafficAndParkingStateEventHandler = TrafficAndParkingEventHandler();
  late final _packagesHandler = PackageEventHandler();

  Stream<ZoomControlEnabledEvent> get zoomControlEnabledEvents => _zoomEventHandler.zoomControlEnabledEvents;

  Stream<LocationEnabledEvent> get locationEnabledEvents => _locationEventHandler.locationEnabledEvents;

  Stream<LocationFollowEvent> get locationFollowEvents => _locationEventHandler.locationFollowEvents;

  Stream<IndoorLevelsEvent> get indoorLevelNames => _indoorEventHandler.indoorLevelNames;

  Stream<IndoorActiveLevelEvent> get indoorActiveIndex => _indoorEventHandler.indoorActiveLevel;

  Stream<TapEvent> get objectTapEvents => _objectTapEventHandler.objectTapEvents;

  Stream<VisibleRectEvent> get visibleRectEvents => _visibleRectEventHandler.visibleRectEvents;

  Stream<CameraPositionMessage> get cameraPositionEvents => _visibleRectEventHandler.cameraPositionEvents;

  Stream<CameraStateEvent> get cameraStateEvents => _cameraStateEventHandler.cameraStateEvents;

  Stream<MarkerWithPhotoTapEvent> get markerWithPhotoTapEvents => _markerTapEventHandler.markerWithPhotoTapEvents;

  Stream<ActiveRouteChangedEvent> get activeRouteChangedEvents => _routesEventHandler.activeRouteChangedEvents;

  Stream<RoutesInfoChangedEvent> get routesInfoChangedEvents => _routesEventHandler.routesInfoChangedEvents;

  Stream<BetterRouteInfoEvent> get betterRouteInfoEvents => _routesEventHandler.betterRouteInfoEvents;

  Stream<NavigationEvent> get navigationEvents => _navigationEventHandler.navigationEvents;

  Stream<NaviDashboardEvent> get naviDashboardEvents => _naviDashboardEventHandler.dashboardEvents;

  Stream<CompassBearingEvent> get compassBearingEvents => _compassEventHandler.compassBearingEvents;

  Stream<NaviSpeedEvent> get naviSpeedEvents => _naviSpeedEventHandler.speedEvents;

  Stream<NaviMessageEvent> get naviMessageEvents => _naviMessageEventHandler.messageEvents;

  Stream<NaviManeuverEvent> get naviManeuverEvents => _naviManeuverEventHandler.maneuverEvents;

  Stream<PublicTransportRoutesChangedEvent> get publicTransportRoutesChangedEvents =>
      _publicTransportEventHandler.routesChangedEvents;

  Stream<ParkingStateEvent> get parkingStateEvents => _trafficAndParkingStateEventHandler.parkingStateEvents;

  Stream<TrafficStateEvent> get trafficStateEvents => _trafficAndParkingStateEventHandler.trafficStateEvents;

  Stream<PublicTransportActiveRouteChanged> get publicTransportActiveRouteChangedEvents =>
      _publicTransportEventHandler.activeRouteChangedEvents;

  Stream<PackageProgressEvent> get packageProgressEvents => _packagesHandler.packageProgressEvents;

  Stream<PackageInfoChangedEvent> get packageInfoChangedEvents => _packagesHandler.packagesInfoChangedEvents;

  Stream<RouteOptionsEvent> get routeOptionsEvent => _navigationEventHandler.routeOptionEvents;

  bool get isInitialized => _isInitialized;

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

    FlutterMapApi.setup(this, binaryMessenger: messenger);

    return response;
  }

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
    await _compassEventHandler.dispose();
    await _naviManeuverEventHandler.dispose();
    await _trafficAndParkingStateEventHandler.dispose();
    await _publicTransportEventHandler.dispose();
  }

  Future<void> onZoomAction(ZoomControlType btn, {required bool isPressed}) async {
    return _zoomEventHandler.onZoomAction(btn, isPressed: isPressed);
  }

  Future<void> toggleFollowState() {
    return _locationEventHandler.toggleFollowState();
  }

  Future<void> followNavigation() {
    return _api.followNavigation();
  }

  StreamSubscription _initEventChannel() {
    return EventChannel('com.dgis.map_view_events_$_viewId').receiveBroadcastStream().listen(
      (event) {
        final map = event as Map<dynamic, dynamic>;
        switch (map['event']) {
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
          case IndoorActiveLevelEvent.name:
            return _indoorEventHandler.activeLevelEvent(map);
          case ObjectTapEvent.name:
            return _objectTapEventHandler.objectTapEvent(map);
          case MyLocationTapEvent.name:
            return _objectTapEventHandler.myLocationTapEvent(map);
          case RoadEventTapEvent.name:
            return _objectTapEventHandler.roadEventTapEvent(map);
          case MarkerTapEvent.name:
            return _objectTapEventHandler.markerTapEvent(map);
          case ClusterTapEvent.name:
            unawaited(_objectTapEventHandler.clusterTapEvent(map, _api).then(
              (value) async {
                await _api.releaseCluster(map["cluster"]["id"]);
              },
            ));
            break;
          case PolygonTapEvent.name:
            return _objectTapEventHandler.polygonTapEvent(map);
          case PolylineTapEvent.name:
            return _objectTapEventHandler.polylineTapEvent(map);
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
      },
    );
  }

  Future<void> selectIndoorLevel(int index) {
    return _indoorEventHandler.selectIndoorLevel(index);
  }

  Future<void> loadStyles(String asset) {
    return _api.loadStyles(asset);
  }

  Future<void> overrideLocales(List<String> locales) {
    return _api.overrideLocales(locales);
  }

  Future<void> setCameraPosition(CameraPositionMessage cameraPosition) {
    return _api.setCameraPosition(cameraPosition);
  }

  Future<void> setCameraPositionPoint(CameraPositionPointMessage cameraPosition) {
    return _api.setCameraPositionPoint(cameraPosition);
  }

  Future<void> setCameraPadding(CameraSetPaddingMessage cameraPadding) {
    return _api.setCameraPadding(cameraPadding);
  }

  Future<void> moveCamera(
      CameraPositionMessage cameraPosition, double duration, CameraAnimationTypeMessage animationType) {
    return _api.moveCamera(cameraPosition, duration, animationType);
  }

  Future<void> setMapAttributeString(String name, String value) {
    return _api.setMapAttributeString(name, value);
  }

  Future<void> setMapAttributeBool(String name, bool value) {
    return _api.setMapAttributeBool(name, value);
  }

  Future<CameraPositionMessage> calcPositionForRoute(CalcPositionOptionsMessage options) {
    return _api.calcPositionForRoute(options);
  }

  Future<CameraPositionMessage> calcPositionForMarkers(List<String> markers, CalcPositionOptionsMessage options) {
    return _api.calcPositionForMarkers(markers, options);
  }

  Future<CameraPositionMessage> calcPositionForPolygons(List<String> polygons, CalcPositionOptionsMessage options) {
    return _api.calcPositionForPolygons(polygons, options);
  }

  Future<CameraPositionMessage> calcPositionForPolylines(List<String> polylines, CalcPositionOptionsMessage options) {
    return _api.calcPositionForPolylines(polylines, options);
  }

  Future<CameraPositionMessage> getCameraPosition() {
    return _api.getCameraPosition();
  }

  Future<List<RenderedObjectMessage>> getNearestObjects() async {
    return (await _api.getNearestObjects()).whereType<RenderedObjectMessage>().toList();
  }

  Future<DirectoryObjectMessage> searchByObjectId(DgisObjectIdMessage objectId) {
    return _api.searchByObjectId(objectId);
  }

  Future<SearchResultMessage> search(
    String queryText, {
    List<SearchCategoryMessage>? categories,
    List<GeoPointMessage>? spatialRestriction,
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
  }) {
    return _api.search(
      queryText,
      categories != null
          ? SearchCategoriesMessage(
              categories: categories
                  .map(
                    (e) => SearchCategoryMessage_(category: e),
                  )
                  .toList(),
            )
          : null,
      spatialRestriction,
      weekTime,
      searchRect,
      sortingType,
      pageSize,
    );
  }

  Future<SearchResultMessage> searchByQuery(
    SearchQueryMessage query, {
    List<GeoPointMessage>? spatialRestriction,
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
  }) {
    return _api.searchByQuery(
      query,
      spatialRestriction,
      weekTime,
      searchRect,
      sortingType,
      pageSize,
    );
  }

  Future<SearchResultMessage> searchByCategory(
    SearchCategoryMessage category, {
    List<GeoPointMessage>? spatialRestriction,
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
  }) {
    return _api.searchByCategory(
      category,
      spatialRestriction,
      weekTime,
      searchRect,
      sortingType,
      pageSize,
    );
  }

  Future<SearchResultMessage> searchByRubrics(
    List<int> rubrics, {
    List<GeoPointMessage>? spatialRestriction,
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
  }) {
    return _api.searchByRubrics(
      rubrics,
      spatialRestriction,
      weekTime,
      searchRect,
      sortingType,
      pageSize,
    );
  }

  Future<PageMessage> fetchPrevPage(PageIdMessage pageId) => _api.fetchPrevPage(pageId);

  Future<PageMessage> fetchNextPage(PageIdMessage pageId) => _api.fetchNextPage(pageId);

  Future<void> releasePage(PageIdMessage pageId) => _api.releasePage(pageId);

  Future<SuggestResultMessage> fetchSuggests(
    String queryText, {
    List<SuggestedTypeMessage_>? allowedResultTypes,
    GeoRectMessage? searchRect,
  }) =>
      _api.fetchSuggests(queryText, allowedResultTypes, searchRect);

  Future<List<DistanceResponseMessage?>> getDistanceTo(List<DistanceRequestMessage> points) {
    return _api.getDistanceTo(points);
  }

  Future<void> setMarkerOptions(MarkerOptionsMessageOld markerOptions) {
    return _api.setMarkerOptions(markerOptions);
  }

  Future<void> addMarker(
    Marker marker,
    MapObjectManagerMessage? manager,
  ) {
    if (marker.onTap != null) {
      _objectTapEventHandler.addMarkerHandler(
        marker.id,
        marker.onTap!,
        manager?.id,
      );
    }
    return _api.addMarker(
      MarkerMessage(id: marker.id, options: marker.options),
      manager,
    );
  }

  Future<void> addMarkers(
    List<Marker> markers,
    MapObjectManagerMessage? manager,
  ) {
    for (var marker in markers) {
      if (marker.onTap != null) {
        _objectTapEventHandler.addMarkerHandler(
          marker.id,
          marker.onTap!,
          manager?.id,
        );
      }
    }
    return _api.addMarkers(
      markers
          .map(
            (marker) => MarkerMessage(id: marker.id, options: marker.options),
          )
          .toList(),
      manager,
    );
  }

  Future<void> removeMarker(
    String id,
    MapObjectManagerMessage? manager,
  ) {
    _objectTapEventHandler.removeMarkerHandler(id);
    return _api.removeMarker(id, manager);
  }

  Future<void> removeAllMarkers(MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeAllMarkerHandlers(manager?.id);
    return _api.removeAllMarkers(manager);
  }

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

  Future<MapObjectManagerMessage> createMapObjectManager({
    String? layerId,
  }) async {
    final result = await _api.createMapObjectManager(layerId);
    return result;
  }

  Future<void> removeMapObjectManager(
    MapObjectManagerMessage manager,
  ) {
    _objectTapEventHandler.removeClusterRenderer(manager.id);
    return _api.removeMapObjectManager(manager);
  }

  Future<void> setMapObjectManagerIsVisible(bool isVisible, MapObjectManagerMessage? manager) {
    return _api.setMapObjectManagerIsVisible(isVisible, manager);
  }

  @override
  SimpleClusterOptionsMessage renderCluster(
    MapObjectManagerMessage manager,
    int objectCount,
  ) {
    return _objectTapEventHandler.clusterRenderers[manager.id]!(objectCount);
  }

  /// --- POYGON ---
  Future<void> addPolygon(
    Polygon polygon,
    MapObjectManagerMessage? manager,
  ) {
    if (polygon.onTap != null) {
      _objectTapEventHandler.addPolygonHandler(
        polygon.id,
        polygon.onTap!,
        manager?.id,
      );
    }
    return _api.addPolygon(
      PolygonMessage(id: polygon.id, options: polygon.options),
      manager,
    );
  }

  Future<void> addPolygons(
    List<Polygon> polygons,
    MapObjectManagerMessage? manager,
  ) {
    for (var polygon in polygons) {
      if (polygon.onTap != null) {
        _objectTapEventHandler.addPolygonHandler(
          polygon.id,
          polygon.onTap!,
          manager?.id,
        );
      }
    }
    return _api.addPolygons(
      polygons
          .map(
            (polygon) => PolygonMessage(id: polygon.id, options: polygon.options),
          )
          .toList(),
      manager,
    );
  }

  Future<void> removePolygon(
    String id,
    MapObjectManagerMessage? manager,
  ) {
    _objectTapEventHandler.removePolygonHandler(id);
    return _api.removePolygon(id, manager);
  }

  Future<void> removeAllPolygons(MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeAllPolygonHandlers();
    return _api.removeAllPolygons(manager);
  }

  /// --- POLYLINE ---
  Future<void> addPolyline(
    Polyline polyline,
    MapObjectManagerMessage? manager,
  ) {
    if (polyline.onTap != null) {
      _objectTapEventHandler.addPolylineHandler(polyline.id, polyline.onTap!, manager?.id);
    }
    return _api.addPolyline(
      PolylineMessage(id: polyline.id, options: polyline.options),
      manager,
    );
  }

  Future<void> addPolylines(
    List<Polyline> polylines,
    MapObjectManagerMessage? manager,
  ) {
    for (var polyline in polylines) {
      if (polyline.onTap != null) {
        _objectTapEventHandler.addPolylineHandler(polyline.id, polyline.onTap!, manager?.id);
      }
    }
    return _api.addPolylines(
      polylines
          .map(
            (polyline) => PolylineMessage(id: polyline.id, options: polyline.options),
          )
          .toList(),
      manager,
    );
  }

  Future<void> removePolyline(
    String id,
    MapObjectManagerMessage? manager,
  ) {
    _objectTapEventHandler.removePolylineHandler(id);
    return _api.removePolyline(id, manager);
  }

  Future<void> removeAllPolylines(MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeAllPolylineHandlers();
    return _api.removeAllPolylines(manager);
  }

  Future<void> showEsriIOLayer(AddLayerPointObjectsMessage message) {
    return _api.showEsriIOLayer(message);
  }

  Future<void> removeEsriIOLayer() {
    return _api.removeEsriIOLayer();
  }

  Future<void> setHighlighted(List<DgisObjectIdMessage> objectIds) {
    return _api.setHighlighted(objectIds);
  }

  Future<void> onLocationPremissionGranted(DesiredAccuracyMessage desiredAccuracy) {
    return _api.onLocationPremissionGranted(desiredAccuracy);
  }

  Future<void> addPanoramasMarkers(AddMarkersWithPhotoMessage markers) {
    return _api.addPanoramasMarkers(markers);
  }

  Future<void> hidePanoramasMarkers() {
    return _api.hidePanoramasMarkers();
  }

  Future<void> showPanoramasMarkers() {
    return _api.showPanoramasMarkers();
  }

  Future<void> removePanoramasMarkers() {
    return _api.removePanoramasMarkers();
  }

  Future<int> overlappedBy(
    GeoRectMessage outerRect,
    GeoRectMessage innerRect,
  ) {
    return _api.overlappedBy(outerRect, innerRect);
  }

  Future<bool> contains(GeoRectMessage rect, GeoPointMessage point) {
    return _api.contains(rect, point);
  }

  Future<bool> containsRect(GeoRectMessage outer, GeoRectMessage inner) {
    return _api.containsRect(outer, inner);
  }

  Future<double> pointBearing(GeoPointMessage from, GeoPointMessage to) {
    return _api.pointBearing(from, to);
  }

  Future<void> setRouteParams(RouteEditorRouteParamsMessage params) {
    return _api.setRouteParams(params);
  }

  Future<void> hideRoutes() {
    return _api.hideRoutes();
  }

  Future<void> showRoutes() {
    return _api.showRoutes();
  }

  Future<void> startNavigation(SpeedRangeZoom speedRangeZoon) {
    return _api.startNavigation(speedRangeZoon);
  }

  Future<void> startNavigationSimulation(SpeedRangeZoom speedRangeZoon) {
    return _api.startNavigationSimulation(speedRangeZoon);
  }

  Future<void> stopNavigation() {
    return _api.stopNavigation();
  }

  Future<void> moveCameraToSelectedPanorama() {
    return _api.moveCameraToSelectedPanorama();
  }

  Future<void> setPanoramasPaddings(CameraSetPaddingMessage message) {
    return _api.setPanoramasPaddings(message);
  }

  Future<void> unselectPanorama() {
    return _api.unselectPanorama();
  }

  Future<void> setPanoramaMarkerAzimuth(MarkerAzimuthMessage message) {
    return _api.setPanoramaMarkerAzimuth(message);
  }

  Future<void> onCompassClicked() {
    return _api.onCompassClicked();
  }

  Future<void> startFreeRoam() {
    return _api.startFreeRoam();
  }

  Future<void> stopFreeRoam() {
    return _api.stopFreeRoam();
  }

  Future<void> toggleSound({required bool enabled}) {
    return _api.toggleSound(enabled);
  }

  Future<void> onTrafficAndParkingAttached() {
    return _api.onTrafficAndParkingAttached();
  }

  Future<void> onTrafficAndParkingDetached() {
    return _api.onTrafficAndParkingDetached();
  }

  Future<void> onParkingClicked() {
    return _api.onParkingClicked();
  }

  Future<void> onTrafficClicked() {
    return _api.onTrafficClicked();
  }

  Future<void> setAppearance(MapAppearanceMessage appearance) {
    return _api.setAppearance(appearance);
  }

  Future<void> setZoomRestrictions(double? min, double? max) {
    return _api.setZoomRestrictions(min, max);
  }

  Future<void> setPublicTransportActiveRoute(int routeIndex) {
    return _api.setPublicTransportActiveRoute(routeIndex);
  }

  Future<List<BriefRouteInfoMessage?>> findBriefRouteInfos(
    RouteSearchOptionsMessage routeSearchOptions,
    RouteSearchPointMessage? startPoint,
    RouteSearchPointMessage? finishPoint,
  ) {
    return _api.findBriefRouteInfos(
      routeSearchOptions,
      startPoint,
      finishPoint,
    );
  }

  Future<List<PackageMessage?>> listPackages() {
    return _api.listPackages();
  }

  Future<List<PackageMessage?>> listVoices() {
    return _api.listVoices();
  }

  Future<void> installPackage(String id) {
    return _api.installPackage(id);
  }

  Future<void> installVoice(String id) {
    return _api.installVoice(id);
  }

  Future<void> setNavigatorVoice(String id) {
    return _api.setNavigatorVoice(id);
  }

  Future<bool> toggleHeatmap(WeatherMapMessage message) => _api.toggleHeatmap(message);

  Future<void> betterRouteResponse(BetterRouteResponseMessage response) => _api.betterRouteResponse(response);

  Future<BetterRouteSettingsMessage> getBetterRouteSettings() => _api.getBetterRouteSettings();

  Future<void> setBetterRouteSettings(BetterRouteSettingsMessage message) => _api.setBetterRouteSettings(message);
}
