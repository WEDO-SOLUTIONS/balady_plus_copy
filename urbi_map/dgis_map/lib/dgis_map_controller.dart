import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'states.dart';

final _instance = DgisMapPlugin.instance;

/// Class to comunicate with plugin. Every method can throw [PlatformException] whenever something
/// goes wrong on platform side.
class DgisMapController {
  /// [_viewId] is the id returned by [onPlatformViewCreated] method when creating platform view.
  ///
  /// Instance of this class is typically obtained in [onMapCreated] callback of [DgisMap] widget.
  DgisMapController(this._viewId);

  final int _viewId;

  final _availableLayers = <_LayerState>[];

  final _activeLayerState = ValueNotifier(LayerState.initial());

  final _evergisFilters = <dynamic>[];

  /// Active [BusinessLayers] wrapped with [LayerState] for convinience
  ValueListenable<LayerState> get activeLayerState => _activeLayerState;

  /// Zoom controls availability
  Stream<ZoomControlEnabledEvent> get zoomControlEnabledEvents =>
      _instance.zoomControlEnabledEvents;

  /// Location control availability
  Stream<LocationEnabledEvent> get locationEnabledEvents =>
      _instance.locationEnabledEvents;

  /// Location follow state
  Stream<LocationFollowType> get locationFollowEvents =>
      _instance.locationFollowEvents.map((event) => event.followType);

  /// Names of indoor levels if any. Empty if there are no available levels.
  Stream<IndoorLevelsEvent> get indoorLevelNames => _instance.indoorLevelNames;

  /// Selected indoor level index in [IndoorLevelsEvent::levelNames] list
  Stream<IndoorActiveLevelEvent> get indoorActiveIndex =>
      _instance.indoorActiveIndex;

  /// Map tap events for all types of objects, that do not have specific stream
  /// (e.g. [markerWithPhotoTapEvents])
  Stream<TapEvent> get objectTapEvents => _instance.objectTapEvents;

  /// User taps route when there are several of them available.
  Stream<RouteChangedEvent> get routeChangedEvents =>
      _instance.routeChangedEvents;

  /// Events during navigation.
  Stream<NavigationEvent> get navigationEvents => _instance.navigationEvents;

  /// Events of visible rect changes.
  Stream<VisibleRectEvent> get visibleRectEvents => _instance.visibleRectEvents;

  /// Tap events for panorama markers.
  Stream<MarkerWithPhotoTapEvent> get markerWithPhotoTapEvents =>
      _instance.markerWithPhotoTapEvents;

  Stream<PublicTransportRoutesChangedEvent>
      get publicTransportRoutesChangedEvents =>
          _instance.publicTransportRoutesChangedEvents;

  Stream<PublicTransportActiveRouteChanged>
      get publicTransportActiveRouteChangedEvents =>
          _instance.publicTransportActiveRouteChangedEvents;

  late NaviSpeedController naviSpeedController = NaviSpeedController(
    _instance.naviSpeedEvents.asBroadcastStream(),
  );

  late NaviMessageController naviMessageController = NaviMessageController(
    _instance.naviMessageEvents.asBroadcastStream(),
  );

  late NaviManeuverController naviManeuverController = NaviManeuverController(
    _instance.naviManeuverEvents.asBroadcastStream(),
  );

  late NaviCompassController naviCompassController = NaviCompassController(
    _instance.compassBearingEvents.asBroadcastStream(),
    _instance.onCompassClicked,
  );

  late NaviZoomController naviZoomController = NaviZoomController(
    _instance.zoomControlEnabledEvents.asBroadcastStream(),
    _instance.onZoomAction,
  )..init();

  late NaviTrafficParkingController naviTrafficParkingController =
      NaviTrafficParkingController(
    parkingStateEvents: _instance.parkingStateEvents.asBroadcastStream(),
    trafficStateEvents: _instance.trafficStateEvents.asBroadcastStream(),
    onAttached: _instance.onTrafficAndParkingAttached,
    onDetached: _instance.onTrafficAndParkingDetached,
    onTrafficClicked: _instance.onTrafficClicked,
    onParkingClicked: _instance.onParkingClicked,
  );

  late NaviFreeRoamController freeRoamController = NaviFreeRoamController(
    _instance.navigationEvents,
    start: _instance.startFreeRoam,
    stop: _instance.stopFreeRoam,
  );

  late NaviPedestrianController naviPedestrianController =
      NaviPedestrianController(
    routeChangedEvents,
  )..init();

  Stream<NaviDashboardEvent> get naviDashboardEvents =>
      _instance.naviDashboardEvents;

  Stream<RouteOptionsEvent> get routeOptionEvents =>
      _instance.routeOptionsEvent;

  /// Must be called **once** when controller becomes avalilable to initialize plugin.
  Future<InitializeMessage> initialize() async => _instance.initialize(_viewId);

  Future<void> dispose() async {
    _activeLayerState.dispose();
    naviPedestrianController.dispose();
    naviZoomController.dispose();
    await _instance.dispose();
  }

  /// Load map styles from asset.
  Future<void> loadStyles(String asset) async => _instance.loadStyles(asset);

  /// Override locale for map. Uses string format "en-US", "ar-SA".
  Future<void> overrideLocales(List<String> locales) =>
      _instance.overrideLocales(locales);

  /// Changes state of location follow. Observe state listening to [locationFollowEvents].
  Future<void> changeFollowState() => _instance.changeFollowState();

  /// Changes selected indoor level. Observe state listening to [indoorActiveIndex].
  Future<void> selectIndoorLevel(IndoorLevel level) =>
      _instance.selectIndoorLevel(level.levelIndex);

  /// Changes map camera position immediately without animation.
  Future<void> setCameraPosition(CameraPositionMessage cameraPosition) =>
      _instance.setCameraPosition(cameraPosition);

  Future<void> setPanoramasPaddings({
    int left = 0,
    int top = 0,
    int right = 0,
    int bottom = 0,
  }) =>
      _instance.setPanoramasPaddings(
        CameraSetPaddingMessage(
          leftPadding: left,
          topPadding: top,
          rightPadding: right,
          bottomPadding: bottom,
        ),
      );

  /// Center camera on selected panorama marker.
  Future<void> moveCameraToSelectedPanorama() =>
      _instance.moveCameraToSelectedPanorama();

  /// Resets selected panorama.
  Future<void> unselectPanorama() => _instance.unselectPanorama();

  /// Set panomara marker to follow user's sight on 360° panorama.
  Future<void> setPanoramaMarkerAzimuth(double degree) =>
      _instance.setPanoramaMarkerAzimuth(MarkerAzimuthMessage(degree: degree));

  /// Returns directory object info by it's id.
  Future<ObjectInfoMessage> searchByObjectId(DgisObjectIdMessage objectId) =>
      _instance.searchByObjectId(objectId);

  /// Returns list of available filters if any. Filters may be available only after at least
  /// one [search] was completed. And should be update on every [search] call.
  ///
  /// Returns null if there are no filters.
  Future<List<FlagFilterMessage>?> getDirectoryDynamicFilters() async {
    final response = await _instance.getDirectoryDynamicFilters();

    final filtered = response.whereType<FlagFilterMessage>().where(
          (filter) =>
              filter.tagName == "general_payment_type_cash" ||
              filter.tagName == "general_payment_type_card",
        );

    return filtered.isNotEmpty ? filtered.toList() : null;
  }

  /// Applies selected filters to [search] result.
  /// Check available filters with [getDirectoryDynamicFilters].
  Future<List<ObjectInfoMessage>> applyDirectoryFilters({
    required List<FlagFilterMessage> filters,
    required WorkingHoursFilter isOpenFilter,
    required SortingTypeMessage sortingType,
  }) async {
    final response = await _instance.applyDirectoryFilters(
      filters: filters,
      isOpenFilter: isOpenFilter.toMessage(),
      sortingType: sortingType,
    );

    return response.whereType<ObjectInfoMessage>().toList();
  }

  /// Returns distance in meters from current location to every point in [points] list.
  /// Works offline. Doesn't require network access.
  ///
  /// Returns null when last location is unavailable, e.g. location is disabled on device.
  Future<List<DistanceResponseMessage>?> getDistanceTo(
      List<DistanceRequestMessage> points) async {
    try {
      final response = await _instance.getDistanceTo(points);

      return response.whereType<DistanceResponseMessage>().toList();
    } catch (_) {
      // Last location is unavailable
      return null;
    }
  }

  /// Runs directory search by [queryText] query.
  Future<List<ObjectInfoMessage>> search(
    String queryText, {
    required SortingTypeMessage sortingType,
    bool isOpenNow = false,
    int pageSize = 20,
  }) async {
    final response = await _instance.search(
      queryText,
      sortingType: sortingType,
      weekTime: isOpenNow ? WeekTimeFactory.openNow() : null,
      pageSize: pageSize,
    );
    return response.whereType<ObjectInfoMessage>().toList(growable: false);
  }

  /// Next page of [search] result. Available only after [search] call.
  Future<List<ObjectInfoMessage>?> getNextPage() async {
    final response = await _instance.getNextPage();

    return response?.whereType<ObjectInfoMessage>().toList();
  }

  /// Options for marker that appears on map on object tap. Used by [addMarker].
  Future<void> setMarkerOptions(MarkerOptionsMessageOld markerOptions) =>
      _instance.setMarkerOptions(markerOptions);

  /// Add marker to map.
  Future<void> addMarker({
    required int id,
    required MarkerOptionsMessage options,
    void Function()? onTap,
  }) =>
      _instance.addMarker(id, options, onTap);

  /// Remove marker by id.
  Future<void> removeMarker(int id) => _instance.removeMarker(id);

  /// Remove all markers added with [addMarker].
  Future<void> removeAllMarkers() => _instance.removeAllMarkers();

  /// Add polygon to map.
  Future<void> addPolygon({
    required int id,
    required PolygonOptionsMessage options,
    void Function()? onTap,
  }) =>
      _instance.addPolygon(id, options, onTap);

  /// Remove polygon by id.
  Future<void> removePolygon(int id) => _instance.removePolygon(id);

  /// Remove all polygons added with [addPolygon].
  Future<void> removeAllPolygons() => _instance.removeAllPolygons();

  /// Remove markers added by calling [search].
  Future<void> removeSearchMarkers() => _instance.removeSearchMarkers();

  /// Hightlighs objects by it's id.
  Future<void> setHighlighted(List<DgisObjectIdMessage> objectIds) =>
      _instance.setHighlighted(objectIds);

  /// Remove all objects highlighted with [setHighlighted].
  Future<void> removeAllHighlights() => setHighlighted([]);

  /// Fetch available EverGis layers.
  Future<void> fetchLayers() async {
    final response = await _instance.getLayers();

    _availableLayers.clear();
    _availableLayers.addAll(
      response.whereType<EverGisLayerMessage>().map((layer) => _LayerState(
            alias: layer.alias,
            name: layer.name,
          )),
    );
  }

  /// Set visible layer.
  void toggleLayerVisibility(BusinessLayers layer) {
    switch (layer) {
      case BusinessLayers.tourism:
        for (var layer in _availableLayers) {
          unawaited(_instance.setLayerVisible(layer.alias, false));
        }
        _activeLayerState.value = LayerState(
          layer: BusinessLayers.tourism,
          isSearchActive: true,
        );
        break;
      case BusinessLayers.idle:
        unawaited(_instance.setLayerVisible("bsWhiteParcelS", true));
        // unawaited(_instance.setLayerVisible("bsopportunitiesP", false));
        _activeLayerState.value = LayerState(
          layer: BusinessLayers.idle,
          isSearchActive: false,
        );
        break;
      case BusinessLayers.io:
        unawaited(_instance.setLayerVisible("bsWhiteParcelS", false));
        // unawaited(_instance.setLayerVisible("bsopportunitiesP", true));
        _activeLayerState.value = LayerState(
          layer: BusinessLayers.io,
          isSearchActive: false,
        );
        break;
      case BusinessLayers.panoramas:
        for (var layer in _availableLayers) {
          unawaited(_instance.setLayerVisible(layer.alias, false));
        }
        _activeLayerState.value = LayerState(
          layer: BusinessLayers.panoramas,
          isSearchActive: false,
        );
        break;
    }
  }

  /// Returns suggest from directory. To run search excplicitly call [search].
  Future<List<SuggestMessage>> fetchSuggest(String queryText) async {
    final response = await _instance.fetchSuggests(queryText);

    return response.whereType<SuggestMessage>().toList();
  }

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

  Future<int> overlappedBy(
      VisibleRectMessage outer, VisibleRectMessage inner) async {
    return _instance.overlappedBy(outer, inner);
  }

  Future<void> setRouteParams(RouteEditorRouteParamsMessage params) async {
    return _instance.setRouteParams(params);
  }

  Future<void> hideRoutes() async {
    return _instance.hideRoutes();
  }

  Future<void> startNavigation() => _instance.startNavigation();

  /// Starts navigation sinulation.
  Future<void> startNavigationSimulation() =>
      _instance.startNavigationSimulation();

  /// Stops navigation. To hide navigation overlay call [hideNativeNavigationOverlay].
  Future<void> stopNavigation() => _instance.stopNavigation();

  Future<void> toggleSound() => _instance.toggleSound();

  /// Acquire object info by index from list returned by [fetchSuggest].
  Future<ObjectInfoMessage> getSuggestObject(int index) {
    return _instance.getSuggestObject(index);
  }

  /// Runs search by index from list returned by [fetchSuggest].
  Future<List<ObjectInfoMessage>> searchBySuggest(
    int index, {
    required SortingTypeMessage sortingType,
    bool isOpenNow = false,
    int pageSize = 20,
  }) async {
    final response = await _instance.searchBySuggest(
      index,
      sortingType: sortingType,
      weekTime: isOpenNow ? WeekTimeFactory.openNow() : null,
      pageSize: pageSize,
    );
    return response.whereType<ObjectInfoMessage>().toList(growable: false);
  }

  /// Used to setup platform. Should be called when permision was granted.
  /// Does not request permission by itself.
  Future<void> onLocationPremissionGranted({
    DesiredAccuracyMessage desiredAccuracy = DesiredAccuracyMessage.low,
  }) {
    return _instance.onLocationPremissionGranted(desiredAccuracy);
  }

  /// Add panorama markers to map.
  Future<void> addPanoramasMarkers(List<MarkerWithPhotoMessage> markers) {
    return _instance
        .addPanoramasMarkers(AddMarkersWithPhotoMessage(markers: markers));
  }

  Future<void> addIOLayerObjects(List<LayerPointObjectMessage> objects) {
    return _instance
        .showEsriIOLayer(AddLayerPointObjectsMessage(objects: objects));
  }

  Future<void> removeEsriIOLayer() {
    return _instance.removeEsriIOLayer();
  }

  /// Does not apply filters immediately. Resets inner state.
  void resetCurrentEvergisFiltersState() => _evergisFilters.clear();

  /// Explicitly clears active layer filters.
  Future<void> clearEverGisFilters() {
    return _instance.applyEverGisFilters(_activeLayerAlias, [], [], [], [], []);
  }

  /// Applies filters to selected EverGis layer. Select layer with [toggleLayerVisibility].
  Future<void> applyEverGisFilters() async {
    return _instance.applyEverGisFilters(
      _activeLayerAlias,
      _evergisFilters.whereType<EGStringFilterMessage>().toList(),
      _evergisFilters.whereType<EGDoubleFilterMessage>().toList(),
      _evergisFilters.whereType<EGIntFilterMessage>().toList(),
      _evergisFilters.whereType<EGDateRangeFilterMessage>().toList(),
      _evergisFilters.whereType<EGComplexDateFilterMessage>().toList(),
    );
  }

  /// Adds filter to inner state. Call [applyEverGisFilters] explicitly after adding filter.
  void addEvergisStringFilter(String attrName, String value) {
    _evergisFilters.add(EGStringFilterMessage(
      attrName: attrName,
      value: value,
    ));
  }

  /// Adds filter to inner state. Call [applyEverGisFilters] explicitly after adding filter.
  void addEvergisIntFilter(String attrName, int value) {
    _evergisFilters.add(EGIntFilterMessage(
      attrName: attrName,
      value: value,
    ));
  }

  /// Adds filter to inner state. Call [applyEverGisFilters] explicitly after adding filter.
  ///
  /// Requires: [to] > [from]
  void addEvergisDoubleRangeFilter({
    required String attrName,
    required double from,
    required double to,
  }) {
    if (to <= from) return;

    _evergisFilters.add(EGDoubleFilterMessage(
      attrName: attrName,
      from: from,
      to: to,
    ));
  }

  /// Adds filter to inner state. Call [applyEverGisFilters] explicitly after adding filter.
  ///
  /// Search bounds are: >= [from] AND <= [to]. One of bounds may be null.
  /// If both [from] and [to] are null filter will not be applied.
  void addEvergisDateRangeFilter({
    required String attrName,
    String? from,
    String? to,
  }) {
    if (from == null && to == null) return;

    _evergisFilters.add(EGDateRangeFilterMessage(
      attrName: attrName,
      from: from,
      to: to,
    ));
  }

  /// Adds filter to inner state. Call [applyEverGisFilters] explicitly after adding filter.
  ///
  /// Differs from [addEvergisDateRangeFilter] in that it uses
  /// separate attributes for [from] and [to] bounds.
  ///
  /// Search bounds are: >= [from] AND <= [to]. One of bounds may be null.
  /// If both [from] and [to] are null filter will not be applied.
  void addEvergisComplexDateFilter({
    required String attrFromName,
    required String attrToName,
    String? from,
    String? to,
  }) {
    if (from == null && to == null) return;

    _evergisFilters.add(EGComplexDateFilterMessage(
      attrFromName: attrFromName,
      attrToName: attrToName,
      from: from,
      to: to,
    ));
  }

  /// Shows search marker of object that was tapped last if any.
  Future<void> showLastSearchMarker() {
    return _instance.showLastSearchMarker();
  }

  String get _activeLayerAlias {
    switch (activeLayerState.value.layer) {
      case BusinessLayers.idle:
        return "bsWhiteParcelS";
      case BusinessLayers.io:
        return "bsopportunitiesP";
      case BusinessLayers.tourism:
      case BusinessLayers.panoramas:
        throw Exception("Layer alias not defined for active layer");
    }
  }

  Future<void> setPublicTransportActiveRoute(int routeIndex) {
    return _instance.setPublicTransportActiveRoute(routeIndex);
  }
}

enum BusinessLayers { tourism, idle, io, panoramas }

class _LayerState {
  _LayerState({
    required this.alias,
    required this.name,
    this.visible = false,
  });

  final String alias;
  final String name;
  final bool visible;

  _LayerState copyWith({required bool visible}) => _LayerState(
        alias: this.alias,
        name: this.name,
        visible: visible,
      );
}

extension WeekTimeFactory on WeekTimeSearchMessage {
  static WeekTimeSearchMessage openNow() =>
      WeekTimeSearchMessage(isOpenNow: true);
}

enum WorkingHoursFilter {
  isOpen,
  none,
  isOpen24x7;

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
