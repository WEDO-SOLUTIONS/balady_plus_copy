import 'package:dgis_map_platform_interface/library.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_my_plugin.dart';

/// The interface that implementations of my_plugin must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `DgisMapPlugin`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [DgisMapPlugin] methods.
abstract class DgisMapPlugin extends PlatformInterface {
  /// Constructs a DgisMapPlugin.
  DgisMapPlugin() : super(token: _token);

  static final Object _token = Object();

  static DgisMapPlugin _instance = MethodChannelDgisMapPlugin();

  /// The default instance of [DgisMapPlugin] to use.
  ///
  /// Defaults to [MethodChannelDgisMapPlugin].
  static DgisMapPlugin get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [DgisMapPlugin] when they register themselves.
  static set instance(DgisMapPlugin instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Stream<ZoomControlEnabledEvent> get zoomControlEnabledEvents;

  Stream<LocationEnabledEvent> get locationEnabledEvents;

  Stream<LocationFollowEvent> get locationFollowEvents;

  Stream<IndoorLevelsEvent> get indoorLevelNames;

  Stream<IndoorActiveLevelEvent> get indoorActiveIndex;

  Stream<TapEvent> get objectTapEvents;

  Stream<VisibleRectEvent> get visibleRectEvents;

  Stream<CameraPositionMessage> get cameraPositionEvents;

  Stream<CameraStateEvent> get cameraStateEvents;

  Stream<MarkerWithPhotoTapEvent> get markerWithPhotoTapEvents;

  Stream<ActiveRouteChangedEvent> get activeRouteChangedEvents;

  Stream<RoutesInfoChangedEvent> get routesInfoChangedEvents;

  Stream<NavigationEvent> get navigationEvents;

  Stream<NaviSpeedEvent> get naviSpeedEvents;

  Stream<NaviDashboardEvent> get naviDashboardEvents;

  Stream<NaviMessageEvent> get naviMessageEvents;

  Stream<CompassBearingEvent> get compassBearingEvents;

  Stream<NaviManeuverEvent> get naviManeuverEvents;

  Stream<ParkingStateEvent> get parkingStateEvents;

  Stream<TrafficStateEvent> get trafficStateEvents;

  Stream<PublicTransportRoutesChangedEvent>
      get publicTransportRoutesChangedEvents;

  Stream<PublicTransportActiveRouteChanged>
      get publicTransportActiveRouteChangedEvents;

  Stream<RouteOptionsEvent> get routeOptionsEvent;

  Stream<PackageProgressEvent> get packageProgressEvents;

  Stream<PackageInfoChangedEvent> get packageInfoChangedEvents;

  Future<InitializeMessage> initialize(int viewId);

  bool get isInitialized;

  Future<void> dispose();

  Future<void> onZoomAction(ZoomControlType btn, {required bool isPressed});

  Future<void> changeFollowState();

  Future<void> selectIndoorLevel(int index);

  Future<void> loadStyles(String asset);

  Future<void> overrideLocales(List<String> locales);

  Future<void> setCameraPosition(CameraPositionMessage cameraPosition);

  Future<void> setCameraPadding(CameraSetPaddingMessage cameraPadding);

  Future<void> moveCamera(
    CameraPositionMessage cameraPosition,
    double duration,
    CameraAnimationTypeMessage animationType,
  );

  Future<CameraPositionMessage> getCameraPosition();

  Future<CameraPositionMessage> calcPositionForMarkers(
    List<String> markers,
    CalcPositionOptionsMessage options,
  );

  Future<CameraPositionMessage> calcPositionForPolygons(
    List<String> polygons,
    CalcPositionOptionsMessage options,
  );

  Future<CameraPositionMessage> calcPositionForPolylines(
    List<String> polylines,
    CalcPositionOptionsMessage options,
  );

  Future<void> unselectPanorama();

  Future<DirectoryObjectMessage> searchByObjectId(DgisObjectIdMessage objectId);

  Widget buildView({
    Key? key,
    required PlatformViewCreatedCallback onPlatformViewCreated,
    bool androidUseExpensive = true,
  });

  Future<List<DistanceResponseMessage?>> getDistanceTo(
      List<DistanceRequestMessage> points);

  Future<SearchResultMessage> search(
    String queryText, {
    List<SearchCategoryMessage>? categories,
    List<GeoPointMessage>? spatialRestriction,
    required SortingTypeMessage sortingType,
    GeoRectMessage? searchRect,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
  });

  Future<SearchResultMessage> searchByQuery(
    SearchQueryMessage query, {
    List<GeoPointMessage>? spatialRestriction,
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
  });

  Future<SearchResultMessage> searchByCategory(
    SearchCategoryMessage query, {
    List<GeoPointMessage>? spatialRestriction,
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
  });

  Future<SearchResultMessage> searchByRubrics(
    List<int> rubrics, {
    List<GeoPointMessage>? spatialRestriction,
    required SortingTypeMessage sortingType,
    required int pageSize,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
  });

  Future<PageMessage> fetchPrevPage(PageIdMessage pageId);

  Future<PageMessage> fetchNextPage(PageIdMessage pageId);

  Future<void> releasePage(PageIdMessage pageId);

  Future<SuggestResultMessage> fetchSuggests(
    String queryText, {
    GeoRectMessage? searchRect,
    List<SuggestedTypeMessage_>? allowedResultTypes,
  });

  Future<void> setMarkerOptions(MarkerOptionsMessageOld markerOptions);

  Future<void> addMarker(
    Marker marker,
    MapObjectManagerMessage? manager,
  );

  Future<void> addMarkers(
    List<Marker> markers,
    MapObjectManagerMessage? manager,
  );

  Future<void> removeMarker(String id, MapObjectManagerMessage? manager);

  Future<void> removeAllMarkers(MapObjectManagerMessage? manager);

  Future<MapObjectManagerMessage> createMapObjectManagerWithClustering(
    ClusteringMapObjectManager manager,
  );

  Future<MapObjectManagerMessage> createMapObjectManager();

  Future<void> removeMapObjectManager(MapObjectManagerMessage manager);

  Future<void> setMapObjectManagerIsVisible(
    bool isVisible,
    MapObjectManagerMessage? manager,
  );

  Future<void> addPolygon(
    Polygon polygon,
  );

  Future<void> addPolygons(
    List<Polygon> polygons,
  );

  Future<void> removePolygon(String id);

  Future<void> removeAllPolygons();

  Future<void> addPolyline(
    Polyline polyline,
  );

  Future<void> addPolylines(
    List<Polyline> polylines,
  );

  Future<void> removePolyline(String id);

  Future<void> removeAllPolylines();

  Future<void> setHighlighted(List<DgisObjectIdMessage> objectIds);

  Future<void> onLocationPremissionGranted(
      DesiredAccuracyMessage desiredAccuracy);

  Future<void> addPanoramasMarkers(AddMarkersWithPhotoMessage markers);

  Future<void> hidePanoramasMarkers();

  Future<void> showPanoramasMarkers();

  Future<void> removePanoramasMarkers();

  Future<void> setRouteParams(RouteEditorRouteParamsMessage params);

  Future<void> hideRoutes();

  Future<void> startNavigation();

  Future<void> startNavigationSimulation();

  Future<void> stopNavigation();

  Future<int> overlappedBy(
    GeoRectMessage outerRect,
    GeoRectMessage innerRect,
  );

  Future<bool> contains(
    GeoRectMessage rect,
    GeoPointMessage point,
  );

  Future<bool> containsRect(
    GeoRectMessage outer,
    GeoRectMessage inner,
  );

  Future<double> pointBearing(
    GeoPointMessage from,
    GeoPointMessage to,
  );

  Future<void> setPanoramasPaddings(CameraSetPaddingMessage message);

  Future<void> moveCameraToSelectedPanorama();

  Future<void> setPanoramaMarkerAzimuth(MarkerAzimuthMessage message);

  Future<void> showEsriIOLayer(AddLayerPointObjectsMessage message);

  Future<void> removeEsriIOLayer();

  Future<void> onCompassClicked();

  Future<void> startFreeRoam();

  Future<void> stopFreeRoam();

  Future<void> toggleSound();

  Future<void> onTrafficAndParkingAttached();

  Future<void> onTrafficAndParkingDetached();

  Future<void> onParkingClicked();

  Future<void> onTrafficClicked();

  Future<void> setAppearance(MapAppearanceMessage appearance);

  Future<void> setZoomRestrictions(double? min, double? max);

  Future<void> setPublicTransportActiveRoute(int routeIndex);

  Future<List<BriefRouteInfoMessage?>> findBriefRouteInfos(
    RouteSearchOptionsMessage routeSearchOptions,
    RouteSearchPointMessage? startPoint,
    RouteSearchPointMessage? finishPoint,
  );

  Future<List<PackageMessage?>> listPackages();

  Future<List<PackageMessage?>> listVoices();

  Future<void> installPackage(String id);

  Future<void> installVoice(String id);

  Future<bool> toggleHeatmap(WeatherMapMessage message);

  Future<void> setNavigatorVoice(String id);
}
