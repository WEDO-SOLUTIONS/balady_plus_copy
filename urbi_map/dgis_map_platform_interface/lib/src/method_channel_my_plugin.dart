import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/indoor_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/location_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation/maneuver_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/marker_tap_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation/speed_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/object_tap_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/public_transport_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/traffic_and_parking_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/visible_rect_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/zoom_event_handler.dart';
import 'package:dgis_map_platform_interface/src/control_handlers/navigation/dashboard_event_handler.dart';
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
class MethodChannelDgisMapPlugin extends DgisMapPlugin {
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
  late final _markerTapEventHandler = MarkerTapEventHandler();
  late final _routeChangedEventHandler = RouteChangedEventHandler();
  late final _navigationEventHandler = NavigationEventHandler();
  late final _naviSpeedEventHandler = SpeedEventHandler();
  late final _naviDashboardEventHandler = DashboardEventHandler();
  late final _compassEventHandler = CompassEventHandler();
  late final _publicTransportEventHandler = PublicTransportEventHandler();
  late final _naviMessageEventHandler = MessageEventHandler();
  late final _naviManeuverEventHandler = ManeuverEventHandler();
  late final _trafficAndParkingStateEventHandler =
      TrafficAndParkingEventHandler();

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
  Stream<MarkerWithPhotoTapEvent> get markerWithPhotoTapEvents =>
      _markerTapEventHandler.markerWithPhotoTapEvents;

  @override
  Stream<RouteChangedEvent> get routeChangedEvents =>
      _routeChangedEventHandler.routeChangedEvents;

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

    return response;
  }

  @override
  Future<void> dispose() async {
    await _eventChannelSubscription?.cancel();
    await _zoomEventHandler.dispose();
    await _locationEventHandler.dispose();
    await _indoorEventHandler.dispose();
    await _objectTapEventHandler.dispose();
    await _routeChangedEventHandler.dispose();
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
  Future<void> changeFollowState() {
    return _locationEventHandler.changeFollowState();
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
          case VisibleRectEvent.name:
            return _visibleRectEventHandler.visibleRectEvent(map);
          case MarkerWithPhotoTapEvent.name:
            return _markerTapEventHandler.markerWithPhotoTapEvent(map);
          case RouteChangedEvent.name:
            return _routeChangedEventHandler.routeChangedEvent(map);
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
  Future<ObjectInfoMessage> searchByObjectId(DgisObjectIdMessage objectId) {
    return _api.searchByObjectId(objectId);
  }

  @override
  Future<List<ObjectInfoMessage?>> search(
    String queryText, {
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
  }) {
    return _api.search(queryText, weekTime, sortingType, pageSize);
  }

  @override
  Future<List<ObjectInfoMessage?>?> getNextPage() {
    return _api.getNextPage();
  }

  @override
  Future<List<DistanceResponseMessage?>> getDistanceTo(
      List<DistanceRequestMessage> points) {
    return _api.getDistanceTo(points);
  }

  @override
  Future<void> setMarkerOptions(MarkerOptionsMessage markerOptions) {
    return _api.setMarkerOptions(markerOptions);
  }

  @override
  Future<void> addMarker(GeoPointMessage geoPoint) {
    return _api.addMarker(geoPoint);
  }

  @override
  Future<void> removeAllMarkers() {
    return _api.removeAllMarkers();
  }

  @override
  Future<void> removeSearchMarkers() {
    return _api.removeSearchMarkers();
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
  Future<List<EverGisLayerMessage?>> getLayers() {
    return _api.getLayers();
  }

  @override
  Future<void> setLayerVisible(String alias, bool visible) {
    return _api.setLayerVisible(alias, visible);
  }

  @override
  Future<List<SuggestMessage?>> fetchSuggests(String queryText) {
    return _api.fetchSuggests(queryText);
  }

  @override
  Future<ObjectInfoMessage> getSuggestObject(int index) {
    return _api.getSuggestObject(index);
  }

  @override
  Future<List<ObjectInfoMessage?>> searchBySuggest(
    int index, {
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
  }) {
    return _api.searchBySuggest(index, weekTime, sortingType, pageSize);
  }

  @override
  Future<void> onLocationPremissionGranted(
      DesiredAccuracyMessage desiredAccuracy) {
    return _api.onLocationPremissionGranted(desiredAccuracy);
  }

  @override
  Widget buildView({
    required PlatformViewCreatedCallback onPlatformViewCreated,
    bool androidUseExpensive = true,
  }) {
    // Pass parameters to the platform side.
    const Map<String, dynamic> creationParams = <String, dynamic>{};

    return defaultTargetPlatform == TargetPlatform.android
        ? PlatformViewLink(
            viewType: _viewType,
            surfaceFactory: (context, controller) {
              return AndroidViewSurface(
                controller: controller as AndroidViewController,
                gestureRecognizers: const <
                    Factory<OneSequenceGestureRecognizer>>{},
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
              );
            },
            onCreatePlatformView: (params) {
              final viewFactory = androidUseExpensive
                  ? PlatformViewsService.initExpensiveAndroidView
                  : PlatformViewsService.initAndroidView;

              final viewController = viewFactory(
                id: params.id,
                viewType: _viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () {
                  params.onFocusChanged(true);
                },
              );

              return viewController
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..addOnPlatformViewCreatedListener(onPlatformViewCreated)
                // ignore: discarded_futures
                ..create();
            },
          )
        : UiKitView(
            viewType: _viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
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
      VisibleRectMessage outerRect, VisibleRectMessage innerRect) {
    return _api.overlappedBy(outerRect, innerRect);
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
  Future<List<FlagFilterMessage?>> getDirectoryDynamicFilters() {
    return _api.getDirectoryDynamicFilters();
  }

  @override
  Future<List<ObjectInfoMessage?>> applyDirectoryFilters({
    required List<FlagFilterMessage> filters,
    required WorkingFilterMessage isOpenFilter,
    required SortingTypeMessage sortingType,
  }) {
    return _api.applyDirectoryFilters(filters, isOpenFilter, sortingType);
  }

  @override
  Future<void> applyEverGisFilters(
    String layerAlias,
    List<EGStringFilterMessage> stringFilters,
    List<EGDoubleFilterMessage> doubleFilters,
    List<EGIntFilterMessage> intFilters,
    List<EGDateRangeFilterMessage> dateRangeFilters,
    List<EGComplexDateFilterMessage> complexDateFilters,
  ) {
    return _api.applyEverGisFilters(
      layerAlias,
      stringFilters,
      doubleFilters,
      intFilters,
      dateRangeFilters,
      complexDateFilters,
    );
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
  Future<void> showLastSearchMarker() {
    return _api.showLastSearchMarker();
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
  Future<void> toggleSound() {
    return _api.toggleSound();
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
  Future<void> setPublicTransportActiveRoute(int routeIndex) {
    return _api.setPublicTransportActiveRoute(routeIndex);
  }
}
