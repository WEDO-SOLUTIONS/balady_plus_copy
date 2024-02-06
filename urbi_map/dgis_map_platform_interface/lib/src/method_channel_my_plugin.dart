import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/camera_state_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/indoor_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/location_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation/maneuver_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/marker_tap_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation/speed_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/object_tap_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/package_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/public_transport_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/traffic_and_parking_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/visible_rect_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/zoom_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation/dashboard_event_handler.dart';
import 'package:dgis_map_platform_interface/src/events/object_tap_events.dart';
import 'package:flutter/foundation.dart' show Factory, defaultTargetPlatform;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'control_handlers/navigation/message_event_handler.dart';
import 'control_handlers/navigation/compass_event_handler.dart';
import 'control_handlers/route_event_handler.dart';

// This is used in the platform side to register the view.
const String _viewType = 'com.dgis.map_view';

/// An implementation of [DgisMapPlugin] that uses method channels.
class MethodChannelDgisMapPlugin implements DgisMapPlugin, FlutterMapApi {
  /// The method channel used to interact with the native platform.
  final _api = MapApi();

  int? _viewId;
  bool _isInitialized = false;

  StreamSubscription? _eventChannelSubscription;

  late final _zoomEventHandler = ZoomEventHandler(_api);
  late final _locationEventHandler = LocationEventHandler(_api);
  late final _indoorEventHandler = IndoorEventHandler(_api);
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
  late final _trafficAndParkingStateEventHandler =
      TrafficAndParkingEventHandler();
  late final _packagesHandler = PackageEventHandler();

  @override
  Stream<ZoomControlEnabledEvent> get zoomControlEnabledEvents =>
      _zoomEventHandler.zoomControlEnabledEvents;

  @override
  Stream<LocationEnabledEvent> get locationEnabledEvents =>
      _locationEventHandler.locationEnabledEvents;

  @override
  Stream<LocationFollowEvent> get locationFollowEvents =>
      _locationEventHandler.locationFollowEvents;

  @override
  Stream<IndoorLevelsEvent> get indoorLevelNames =>
      _indoorEventHandler.indoorLevelNames;

  @override
  Stream<IndoorActiveLevelEvent> get indoorActiveIndex =>
      _indoorEventHandler.indoorActiveLevel;

  @override
  Stream<TapEvent> get objectTapEvents =>
      _objectTapEventHandler.objectTapEvents;

  @override
  Stream<VisibleRectEvent> get visibleRectEvents =>
      _visibleRectEventHandler.visibleRectEvents;

  @override
  Stream<CameraPositionMessage> get cameraPositionEvents =>
      _visibleRectEventHandler.cameraPositionEvents;

  @override
  Stream<CameraStateEvent> get cameraStateEvents =>
      _cameraStateEventHandler.cameraStateEvents;

  @override
  Stream<MarkerWithPhotoTapEvent> get markerWithPhotoTapEvents =>
      _markerTapEventHandler.markerWithPhotoTapEvents;

  @override
  Stream<ActiveRouteChangedEvent> get activeRouteChangedEvents =>
      _routesEventHandler.activeRouteChangedEvents;

  @override
  Stream<RoutesInfoChangedEvent> get routesInfoChangedEvents =>
      _routesEventHandler.routesInfoChangedEvents;

  @override
  Stream<NavigationEvent> get navigationEvents =>
      _navigationEventHandler.navigationEvents;

  @override
  Stream<NaviDashboardEvent> get naviDashboardEvents =>
      _naviDashboardEventHandler.dashboardEvents;

  @override
  Stream<CompassBearingEvent> get compassBearingEvents =>
      _compassEventHandler.compassBearingEvents;

  @override
  Stream<NaviSpeedEvent> get naviSpeedEvents =>
      _naviSpeedEventHandler.speedEvents;

  @override
  Stream<NaviMessageEvent> get naviMessageEvents =>
      _naviMessageEventHandler.messageEvents;

  @override
  Stream<NaviManeuverEvent> get naviManeuverEvents =>
      _naviManeuverEventHandler.maneuverEvents;

  @override
  Stream<PublicTransportRoutesChangedEvent>
      get publicTransportRoutesChangedEvents =>
          _publicTransportEventHandler.routesChangedEvents;

  @override
  Stream<ParkingStateEvent> get parkingStateEvents =>
      _trafficAndParkingStateEventHandler.parkingStateEvents;

  @override
  Stream<TrafficStateEvent> get trafficStateEvents =>
      _trafficAndParkingStateEventHandler.trafficStateEvents;

  @override
  Stream<PublicTransportActiveRouteChanged>
      get publicTransportActiveRouteChangedEvents =>
          _publicTransportEventHandler.activeRouteChangedEvents;

  @override
  Stream<PackageProgressEvent> get packageProgressEvents =>
      _packagesHandler.packageProgressEvents;

  @override
  Stream<PackageInfoChangedEvent> get packageInfoChangedEvents =>
      _packagesHandler.packagesInfoChangedEvents;

  @override
  Stream<RouteOptionsEvent> get routeOptionsEvent =>
      _navigationEventHandler.routeOptionEvents;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<InitializeMessage> initialize(int viewId) async {
    _viewId = viewId;

    final response = await _api.initialize();
    if (response.wasInitialized) {
      _eventChannelSubscription = _initEventChannel();

      _isInitialized = true;
    }

    FlutterMapApi.setup(this);

    return response;
  }

  @override
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

  @override
  Future<void> onZoomAction(ZoomControlType btn,
      {required bool isPressed}) async {
    return _zoomEventHandler.onZoomAction(btn, isPressed: isPressed);
  }

  @override
  Future<void> setFollowState(FollowStateMessage state) {
    return _locationEventHandler.setFollowState(state);
  }

  @override
  Future<void> followNavigation() {
    return _api.followNavigation();
  }

  StreamSubscription _initEventChannel() {
    return EventChannel('com.dgis.map_view_events_$_viewId')
        .receiveBroadcastStream()
        .listen(
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

  @override
  Future<void> selectIndoorLevel(int index) {
    return _indoorEventHandler.selectIndoorLevel(index);
  }

  @override
  Future<void> loadStyles(String asset) {
    return _api.loadStyles(asset);
  }

  @override
  Future<void> overrideLocales(List<String> locales) {
    return _api.overrideLocales(locales);
  }

  @override
  Future<void> setCameraPosition(CameraPositionMessage cameraPosition) {
    return _api.setCameraPosition(cameraPosition);
  }

  @override
  Future<void> setCameraPadding(CameraSetPaddingMessage cameraPadding) {
    return _api.setCameraPadding(cameraPadding);
  }

  @override
  Future<void> moveCamera(CameraPositionMessage cameraPosition, double duration,
      CameraAnimationTypeMessage animationType) {
    return _api.moveCamera(cameraPosition, duration, animationType);
  }

  @override
  Future<CameraPositionMessage> calcPositionForRoute(
      CalcPositionOptionsMessage options) {
    return _api.calcPositionForRoute(options);
  }

  @override
  Future<CameraPositionMessage> calcPositionForMarkers(
      List<String> markers, CalcPositionOptionsMessage options) {
    return _api.calcPositionForMarkers(markers, options);
  }

  @override
  Future<CameraPositionMessage> calcPositionForPolygons(
      List<String> polygons, CalcPositionOptionsMessage options) {
    return _api.calcPositionForPolygons(polygons, options);
  }

  @override
  Future<CameraPositionMessage> calcPositionForPolylines(
      List<String> polylines, CalcPositionOptionsMessage options) {
    return _api.calcPositionForPolylines(polylines, options);
  }

  @override
  Future<CameraPositionMessage> getCameraPosition() {
    return _api.getCameraPosition();
  }

  @override
  Future<List<RenderedObjectMessage>> getNearestObjects() async {
    return (await _api.getNearestObjects()).whereType<RenderedObjectMessage>().toList();
  }

  @override
  Future<DirectoryObjectMessage> searchByObjectId(
      DgisObjectIdMessage objectId) {
    return _api.searchByObjectId(objectId);
  }

  @override
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

  @override
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

  @override
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

  @override
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

  @override
  Future<PageMessage> fetchPrevPage(PageIdMessage pageId) =>
      _api.fetchPrevPage(pageId);

  @override
  Future<PageMessage> fetchNextPage(PageIdMessage pageId) =>
      _api.fetchNextPage(pageId);

  @override
  Future<void> releasePage(PageIdMessage pageId) => _api.releasePage(pageId);

  @override
  Future<SuggestResultMessage> fetchSuggests(
    String queryText, {
    List<SuggestedTypeMessage_>? allowedResultTypes,
    GeoRectMessage? searchRect,
  }) =>
      _api.fetchSuggests(queryText, allowedResultTypes, searchRect);

  @override
  Future<List<DistanceResponseMessage?>> getDistanceTo(
      List<DistanceRequestMessage> points) {
    return _api.getDistanceTo(points);
  }

  @override
  Future<void> setMarkerOptions(MarkerOptionsMessageOld markerOptions) {
    return _api.setMarkerOptions(markerOptions);
  }

  @override
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

  @override
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

  @override
  Future<void> removeMarker(
    String id,
    MapObjectManagerMessage? manager,
  ) {
    _objectTapEventHandler.removeMarkerHandler(id);
    return _api.removeMarker(id, manager);
  }

  @override
  Future<void> removeAllMarkers(MapObjectManagerMessage? manager) {
    _objectTapEventHandler.removeAllMarkerHandlers(manager?.id);
    return _api.removeAllMarkers(manager);
  }

  @override
  Future<MapObjectManagerMessage> createMapObjectManagerWithClustering(
    ClusteringMapObjectManager manager, {
    String? layerId,
  }) async {
    final result = await _api.createMapObjectManagerWithClustering(
        manager.options, layerId);
    _objectTapEventHandler.addClusterRenderer(result.id, manager.renderCluster);
    if (manager.onTap != null) {
      _objectTapEventHandler.addClusterHandler(result.id, manager.onTap!);
    }
    return result;
  }

  @override
  Future<MapObjectManagerMessage> createMapObjectManager({
    String? layerId,
  }) async {
    final result = await _api.createMapObjectManager(layerId);
    return result;
  }

  @override
  Future<void> removeMapObjectManager(
    MapObjectManagerMessage manager,
  ) {
    _objectTapEventHandler.removeClusterRenderer(manager.id);
    return _api.removeMapObjectManager(manager);
  }

  @override
  Future<void> setMapObjectManagerIsVisible(
      bool isVisible, MapObjectManagerMessage? manager) {
    return _api.setMapObjectManagerIsVisible(isVisible, manager);
  }

  @override
  SimpleClusterOptionsMessage renderCluster(
    MapObjectManagerMessage manager,
    int objectCount,
  ) {
    return _objectTapEventHandler.clusterRenderers[manager.id]!(objectCount);
  }

  @override
  Future<void> addPolygon(
    Polygon polygon,
  ) {
    if (polygon.onTap != null) {
      _objectTapEventHandler.addPolygonHandler(polygon.id, polygon.onTap!);
    }
    return _api.addPolygon(
      PolygonMessage(id: polygon.id, options: polygon.options),
    );
  }

  @override
  Future<void> addPolygons(
    List<Polygon> polygons,
  ) {
    for (var polygon in polygons) {
      if (polygon.onTap != null) {
        _objectTapEventHandler.addPolygonHandler(polygon.id, polygon.onTap!);
      }
    }
    return _api.addPolygons(
      polygons
          .map(
            (polygon) =>
                PolygonMessage(id: polygon.id, options: polygon.options),
          )
          .toList(),
    );
  }

  @override
  Future<void> removePolygon(
    String id,
  ) {
    _objectTapEventHandler.removePolygonHandler(id);
    return _api.removePolygon(id);
  }

  @override
  Future<void> removeAllPolygons() {
    _objectTapEventHandler.removeAllPolygonHandlers();
    return _api.removeAllPolygons();
  }

  @override
  Future<void> addPolyline(
    Polyline polyline,
  ) {
    if (polyline.onTap != null) {
      _objectTapEventHandler.addPolylineHandler(polyline.id, polyline.onTap!);
    }
    return _api.addPolyline(
      PolylineMessage(id: polyline.id, options: polyline.options),
    );
  }

  @override
  Future<void> addPolylines(
    List<Polyline> polylines,
  ) {
    for (var polyline in polylines) {
      if (polyline.onTap != null) {
        _objectTapEventHandler.addPolylineHandler(polyline.id, polyline.onTap!);
      }
    }
    return _api.addPolylines(
      polylines
          .map(
            (polyline) =>
                PolylineMessage(id: polyline.id, options: polyline.options),
          )
          .toList(),
    );
  }

  @override
  Future<void> removePolyline(
    String id,
  ) {
    _objectTapEventHandler.removePolylineHandler(id);
    return _api.removePolyline(id);
  }

  @override
  Future<void> removeAllPolylines() {
    _objectTapEventHandler.removeAllPolylineHandlers();
    return _api.removeAllPolylines();
  }

  @override
  Future<void> showEsriIOLayer(AddLayerPointObjectsMessage message) {
    return _api.showEsriIOLayer(message);
  }

  @override
  Future<void> removeEsriIOLayer() {
    return _api.removeEsriIOLayer();
  }

  @override
  Future<void> setHighlighted(List<DgisObjectIdMessage> objectIds) {
    return _api.setHighlighted(objectIds);
  }

  @override
  Future<void> onLocationPremissionGranted(
      DesiredAccuracyMessage desiredAccuracy) {
    return _api.onLocationPremissionGranted(desiredAccuracy);
  }

  @override
  Widget buildView({
    Key? key,
    required PlatformViewCreatedCallback onPlatformViewCreated,
    bool androidUseExpensive = true,
  }) {
    return defaultTargetPlatform == TargetPlatform.android
        ? AndroidView(
            key: key,
            viewType: _viewType,
            onPlatformViewCreated: onPlatformViewCreated,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            layoutDirection: TextDirection.ltr,
          )
        : UiKitView(
            key: key,
            viewType: _viewType,
            layoutDirection: TextDirection.ltr,
            onPlatformViewCreated: onPlatformViewCreated,
          );
  }

  @override
  Future<void> addPanoramasMarkers(AddMarkersWithPhotoMessage markers) {
    return _api.addPanoramasMarkers(markers);
  }

  @override
  Future<void> hidePanoramasMarkers() {
    return _api.hidePanoramasMarkers();
  }

  @override
  Future<void> showPanoramasMarkers() {
    return _api.showPanoramasMarkers();
  }

  @override
  Future<void> removePanoramasMarkers() {
    return _api.removePanoramasMarkers();
  }

  @override
  Future<int> overlappedBy(
    GeoRectMessage outerRect,
    GeoRectMessage innerRect,
  ) {
    return _api.overlappedBy(outerRect, innerRect);
  }

  @override
  Future<bool> contains(GeoRectMessage rect, GeoPointMessage point) {
    return _api.contains(rect, point);
  }

  @override
  Future<bool> containsRect(GeoRectMessage outer, GeoRectMessage inner) {
    return _api.containsRect(outer, inner);
  }

  @override
  Future<double> pointBearing(GeoPointMessage from, GeoPointMessage to) {
    return _api.pointBearing(from, to);
  }

  @override
  Future<void> setRouteParams(RouteEditorRouteParamsMessage params) {
    return _api.setRouteParams(params);
  }

  @override
  Future<void> hideRoutes() {
    return _api.hideRoutes();
  }

  @override
  Future<void> startNavigation() {
    return _api.startNavigation();
  }

  @override
  Future<void> startNavigationSimulation() {
    return _api.startNavigationSimulation();
  }

  @override
  Future<void> stopNavigation() {
    return _api.stopNavigation();
  }

  @override
  Future<void> moveCameraToSelectedPanorama() {
    return _api.moveCameraToSelectedPanorama();
  }

  @override
  Future<void> setPanoramasPaddings(CameraSetPaddingMessage message) {
    return _api.setPanoramasPaddings(message);
  }

  @override
  Future<void> unselectPanorama() {
    return _api.unselectPanorama();
  }

  @override
  Future<void> setPanoramaMarkerAzimuth(MarkerAzimuthMessage message) {
    return _api.setPanoramaMarkerAzimuth(message);
  }

  @override
  Future<void> onCompassClicked() {
    return _api.onCompassClicked();
  }

  @override
  Future<void> startFreeRoam() {
    return _api.startFreeRoam();
  }

  @override
  Future<void> stopFreeRoam() {
    return _api.stopFreeRoam();
  }

  @override
  Future<void> toggleSound({required bool enabled}) {
    return _api.toggleSound(enabled);
  }

  @override
  Future<void> onTrafficAndParkingAttached() {
    return _api.onTrafficAndParkingAttached();
  }

  @override
  Future<void> onTrafficAndParkingDetached() {
    return _api.onTrafficAndParkingDetached();
  }

  @override
  Future<void> onParkingClicked() {
    return _api.onParkingClicked();
  }

  @override
  Future<void> onTrafficClicked() {
    return _api.onTrafficClicked();
  }

  @override
  Future<void> setAppearance(MapAppearanceMessage appearance) {
    return _api.setAppearance(appearance);
  }

  @override
  Future<void> setZoomRestrictions(double? min, double? max) {
    return _api.setZoomRestrictions(min, max);
  }

  Future<void> setPublicTransportActiveRoute(int routeIndex) {
    return _api.setPublicTransportActiveRoute(routeIndex);
  }

  @override
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

  @override
  Future<List<PackageMessage?>> listPackages() {
    return _api.listPackages();
  }

  @override
  Future<List<PackageMessage?>> listVoices() {
    return _api.listVoices();
  }

  @override
  Future<void> installPackage(String id) {
    return _api.installPackage(id);
  }

  @override
  Future<void> installVoice(String id) {
    return _api.installVoice(id);
  }

  @override
  Future<void> setNavigatorVoice(String id) {
    return _api.setNavigatorVoice(id);
  }

  @override
  Future<bool> toggleHeatmap(WeatherMapMessage message) =>
      _api.toggleHeatmap(message);
}
