import 'dart:async';

import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/favourites/providers/favourite_markers.dart';
import 'package:mapness/features/friends_on_map/providers/friends_layer_visible_provider.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';
import 'package:mapness/features/jeddah_bus/provider.dart';
import 'package:mapness/features/jeddah_bus/repo.dart';
import 'package:mapness/features/jeddah_bus/visible_provider.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/lifestyle_layers/helpers/layers_type_extension.dart';
import 'package:mapness/features/lifestyle_layers/models/building_compliance_certificate.dart';
import 'package:mapness/features/lifestyle_layers/models/investment_sites.dart';
import 'package:mapness/features/lifestyle_layers/models/map_enums.dart';
import 'package:mapness/features/lifestyle_layers/models/map_requests_params.dart';
import 'package:mapness/features/lifestyle_layers/models/point_layers_data.dart';
import 'package:mapness/features/lifestyle_layers/models/white_lands.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layer.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/features/lifestyle_layers/providers/lifestyle_repository.dart';
import 'package:mapness/features/makkah_bus/provider.dart';
import 'package:mapness/features/makkah_bus/repo.dart';
import 'package:mapness/features/makkah_bus/visible_provider.dart';
import 'package:mapness/features/map_dimensions/map_dimensions_control_provider.dart';
import 'package:mapness/features/metro/metro_layer_provider.dart';
import 'package:mapness/features/metro/metro_layer_repository.dart';
import 'package:mapness/features/metro/metro_layer_visible_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_card_closing.dart';
import 'package:mapness/features/shuttle_bus/provider.dart';
import 'package:mapness/features/shuttle_bus/repo.dart';
import 'package:mapness/features/shuttle_bus/visible_provider.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/search/compute_camera_position.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/parking_state.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/map/traffic_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'layers_controls.g.dart';

@riverpod
class SelectedLayer extends _$SelectedLayer {
  // ignore: use_setters_to_change_properties
  void setLayerType(LayerType? layerType) {
    state = layerType;
  }

  @override
  LayerType? build(LayerType? layerType) => null;
}

enum LayersType { lifestyle, business }

enum LayersPanelType { layers, busLayers, parking }

class LayersState {
  LayersState({
    required this.isLoading,
    required this.layersVisible,
    required this.selectedType,
    required this.investmentsMarkers,
    required this.polylines,
    required this.polygons,
    this.layersPanelType = LayersPanelType.layers,
    this.layersType = LayersType.lifestyle,
  });

  final bool layersVisible;
  final LayerType? selectedType;
  final bool isLoading;

  Map<String, Marker> investmentsMarkers = {};
  Map<String, Polyline> polylines = {};
  Map<String, Polygon> polygons = {};

  final LayersPanelType layersPanelType;
  final LayersType layersType;

  LayersState copyWith({
    bool? layersVisible,
    LayerType? selectedType,
    bool? isLoading,
    Map<String, Marker>? investmentsMarkers,
    Map<String, Polyline>? polylines,
    Map<String, Polygon>? polygons,
    LayersPanelType? layersWidgetType,
    LayersType? layersType,
  }) => LayersState(
    isLoading: isLoading ?? this.isLoading,
    layersVisible: layersVisible ?? this.layersVisible,
    selectedType: selectedType ?? this.selectedType,
    investmentsMarkers: investmentsMarkers ?? this.investmentsMarkers,
    polylines: polylines ?? this.polylines,
    polygons: polygons ?? this.polygons,
    layersPanelType: layersWidgetType ?? layersPanelType,
    layersType: layersType ?? this.layersType,
  );
}

const duration = Duration(milliseconds: 700);

@riverpod
class LayersControls extends _$LayersControls {
  static const duration = Duration(milliseconds: 250);
  StreamSubscription? _viewPortSubscription;
  CancelToken? _cancelToken;

  final esriMapObjectSettings = MapObjectManagerSettings.esri();
  final favouritesMapObjectSettings = MapObjectManagerSettings.favourites();

  final tapSubject = PublishSubject<LayerType>();
  StreamSubscription? _tapSubscription;

  Future<void> _hideAllSelectedMarkers() async {
    final selectedPoint = ref.read(selectedMarkerProvider.notifier);
    final controller = await ref.read(dgisControllerProvider.future);
    await selectedPoint.removeAllMarkers();
    await controller.removeAllHighlights();
    await controller.removeAllPolylines();
  }

  @override
  LayersState build() {
    ref.onDispose(() {
      _viewPortSubscription?.cancel();
      _tapSubscription?.cancel();
    });

    _tapSubscription = tapSubject.debounceTime(duration).listen(_tapHandler);

    final selectedLayerState = _getLayerState();

    return LayersState(
      layersVisible: false,
      selectedType: selectedLayerState,
      isLoading: false,
      investmentsMarkers: {},
      polygons: {},
      polylines: {},
    );
  }

  void initialize() {
    final selectedLayerState = _getLayerState();

    Future.delayed(Duration.zero, () async {
      if (selectedLayerState != null) {
        await toggle(selectedLayerState);
      }
    });

    final LayersType actualSelectedLayersType = LayerType.lifestyle.contains(selectedLayerState ?? LayerType.favourites)
        ? LayersType.lifestyle
        : LayersType.business;

    state = LayersState(
      layersVisible: false,
      selectedType: null,
      layersType: actualSelectedLayersType,
      isLoading: false,
      investmentsMarkers: {},
      polygons: {},
      polylines: {},
    );
  }

  void onError() {
    setSelection();
    update(isLoading: false);
  }

  Future<void> hideActiveLayer() async {
    final currentState = state.selectedType;

    if (currentState != null) {
      await _hidePreviousLayers(currentState);
    }
  }

  Future<void> toggleLayers(LayerType value) async {
    switch (value) {
      case LayerType.three3D:
        await toggle3D();
        break;
      // case LayerType.roadEvents:
      //   await toggleRoadEvents();
      //   break;
      case LayerType.traffic:
        await toggleTraffic();
        break;
      case LayerType.favourites:
        await toggleFavourites();
        break;
      case LayerType.buildings:
        await toggleComplianceBuildings();
        break;
      case LayerType.invest:
        await toggleInvestOpportunities();
        break;
      case LayerType.fencing:
        await toggleWhiteLands();
        break;
      case LayerType.parkingLots:
        await toggleParking();
        break;
      case LayerType.metro:
        toggleMetro();
        break;
      case LayerType.busSubMenu:
        // no op
        break;
      case LayerType.makkahBus:
        toggleMakkahBuses();
        break;
      case LayerType.shuttleBus:
        toggleHaramShuttle();
        break;
      case LayerType.jeddahBus:
        toggleJeddahBuses();
        break;
      case LayerType.friends:
        await toggleFriends();
        break;
      // case LayerType.joy:
      //   await toggleIwish();
    }
  }

  Future<void> toggleFriends() async {
    ref.read(friendsLayerVisibleProvider.notifier).toggle();
  }

  Future<void> showActiveLayerOnMap() async {
    final layerType = ref.read(activeLayerProvider);

    if (layerType case LayerType.favourites) {
      await ref.read(favouriteToggleProvider.notifier).enable();
      setSelection(selectedType: LayerType.favourites);
    } else if (layerType case LayerType.parkingLots) {
      await ref.read(parkingStateProvider.notifier).showParking();
      setSelection(selectedType: LayerType.parkingLots);
    } else if (layerType case LayerType.metro) {
      ref.read(metroLayerRepositoryProvider.notifier).showMetro();
      setSelection(selectedType: LayerType.metro);
    } else if (layerType case LayerType.makkahBus) {
      ref.read(makkahBusLayerRepoProvider.notifier).show();
      setSelection(selectedType: LayerType.makkahBus);
    } else if (layerType case LayerType.shuttleBus) {
      ref.read(shuttleBusLayerRepoProvider.notifier).show();
      setSelection(selectedType: LayerType.shuttleBus);
    } else if (layerType case LayerType.jeddahBus) {
      ref.read(jeddahBusLayerRepoProvider.notifier).show();
      setSelection(selectedType: LayerType.jeddahBus);
    }
  }

  Future<void> disable() async {
    if (state.selectedType != null) {
      handleTap(state.selectedType!);
    }
  }

  Future<void> toggle(LayerType? type) async {
    if (type == null) {
      return;
    }
    final activeLayerNotifier = ref.read(activeLayerProvider.notifier);

    final isCurrentState = ref.read(activeLayerProvider) == type;
    if (isCurrentState) {
      await activeLayerNotifier.removeActiveLayer();
    } else {
      await activeLayerNotifier.setActiveLayer(type);
    }

    setSelection(selectedType: type);
  }

  Future<void> toggleFavourites() async {
    await _viewPortSubscription?.cancel();
    await _removeAll();
    _cancelToken?.cancel();

    if (state.selectedType != (LayerType.favourites)) {
      await ref.read(favouriteToggleProvider.notifier).enable();
      setSelection(selectedType: LayerType.favourites);
    } else {
      await ref.read(favouriteToggleProvider.notifier).disable();
      setSelection();
    }
  }

  void toggleMetro() {
    final isVisible = ref.read(metroLayerVisibleProvider);
    if (isVisible) {
      ref.read(metroLayerProvider.notifier).hideMetro();
      if (state.selectedType == LayerType.metro) {
        setSelection();
      }
    } else {
      ref.read(metroLayerProvider.notifier).showMetro();
      setSelection(selectedType: LayerType.metro);
    }
  }

  void toggleMakkahBuses() {
    final isVisible = ref.read(makkahBusLayerVisibleProvider);
    if (isVisible) {
      ref.read(makkahBusLayerProvider.notifier).hide();
      if (state.selectedType == LayerType.makkahBus) {
        setSelection();
      }
    } else {
      ref.read(makkahBusLayerProvider.notifier).show();
      setSelection(selectedType: LayerType.makkahBus);
    }
  }

  void toggleHaramShuttle() {
    final isVisible = ref.read(shuttleBusLayerVisibleProvider);
    if (isVisible) {
      ref.read(shuttleBusLayerProvider.notifier).hide();
      if (state.selectedType == LayerType.shuttleBus) {
        setSelection();
      }
    } else {
      ref.read(shuttleBusLayerProvider.notifier).show();
      setSelection(selectedType: LayerType.shuttleBus);
    }
  }

  void toggleJeddahBuses() {
    final isVisible = ref.read(jeddahBusLayerVisibleProvider);
    if (isVisible) {
      ref.read(jeddahBusLayerProvider.notifier).hide();
      if (state.selectedType == LayerType.jeddahBus) {
        setSelection();
      }
    } else {
      ref.read(jeddahBusLayerProvider.notifier).show();
      setSelection(selectedType: LayerType.jeddahBus);
    }
  }

  void update({
    bool? visible,
    bool? isLoading,
    Map<String, Marker>? investmentsMarkers,
    Map<String, Polyline>? polylines,
    Map<String, Polygon>? polygons,
    LayersPanelType? layersWidgetType,
    LayersType? layersType,
  }) {
    state = state.copyWith(
      investmentsMarkers: investmentsMarkers ?? state.investmentsMarkers,
      layersVisible: visible ?? state.layersVisible,
      selectedType: state.selectedType,
      isLoading: isLoading ?? state.isLoading,
      polygons: polygons ?? state.polygons,
      polylines: polylines ?? state.polylines,
      layersWidgetType: layersWidgetType ?? state.layersPanelType,
      layersType: layersType ?? state.layersType,
    );
  }

  void setSelection({LayerType? selectedType}) {
    if (selectedType != null) {
      _saveLayersState(selectedType);
      Metrics.logEventAdvanced(
        MetricsConstants.layersKeys.layerSelect,
        group: MetricsConstants.layersTag,
        action: MetricAction.tap.toString(),
        props: {'type': selectedType.titleLocale(AppLocalizationsEn())},
      );
    } else {
      _removeLayersState();

      /// FIX(BSA-669): Added this function to remove favorites and other markers when
      /// we disable it from layers or favorites screen
      _removeAll();
    }

    ref
      ..invalidate(favouriteToggleProvider)
      ..invalidate(favouriteMarkersProvider);

    state = LayersState(
      layersType: state.layersType,
      layersPanelType: state.layersPanelType,
      investmentsMarkers: state.investmentsMarkers,
      layersVisible: state.layersVisible,
      selectedType: selectedType,
      isLoading: state.isLoading,
      polygons: state.polygons,
      polylines: state.polylines,
    );
  }

  void handleTap(LayerType value) {
    tapSubject.add(value);
  }

  Future<void> toggleComplianceBuildings() async {
    final currentState = state.selectedType;
    if (currentState != (LayerType.buildings)) {
      setSelection(selectedType: LayerType.buildings);
      update(isLoading: true);
      await _showBuildingCompliance();
    } else {
      await _viewPortSubscription?.cancel();
      await _removeAll();
      setSelection();
      update(isLoading: false);
    }
  }

  Future<void> toggleInvestOpportunities() async {
    final currentState = state.selectedType;
    if (currentState != (LayerType.invest)) {
      await _showInvestmentOpportunities(LayerType.invest);
    } else {
      await _removeAll();

      setSelection();
      update(isLoading: false);
    }
  }

  Future<void> toggleWhiteLands() async {
    final currentState = state.selectedType;
    if (currentState != (LayerType.fencing)) {
      await _showWhiteLands();
    } else {
      await _viewPortSubscription?.cancel();
      await _removeAll();

      setSelection();
      update(isLoading: false);
    }
  }

  Future<void> toggleParking() async {
    final currentState = state.selectedType;
    await _viewPortSubscription?.cancel();

    if (currentState == LayerType.parkingLots) {
      await _removeAll();
      final manager = ref.read(
        mapObjectManagerProvider(named: esriMapObjectSettings.name, layerId: esriMapObjectSettings.layerId).notifier,
      );
      await manager.removeAllMarkers();

      setSelection();
      update(isLoading: false);

      await ref.read(parkingStateProvider.notifier).hideParking();
    } else {
      await _removeMapObjects();
      setSelection(selectedType: LayerType.parkingLots);
      await ref.read(parkingStateProvider.notifier).showParking();
    }
  }

  Future<void> enableParking({bool isFromDeepLink = false}) async {
    LayersState? oldState;
    if (isFromDeepLink) {
      oldState = state;
      state = LayersState(
        layersVisible: false,
        selectedType: null,
        isLoading: true,
        investmentsMarkers: {},
        polygons: {},
        polylines: {},
      );
    }

    await _viewPortSubscription?.cancel();
    unawaited(_removeMapObjects());
    final currentState = state.selectedType;
    if (currentState != null && currentState != LayerType.parkingLots) {
      await _hidePreviousLayers(currentState);
    }
    if (currentState != LayerType.parkingLots) {
      setSelection(selectedType: LayerType.parkingLots);
      await ref.read(parkingStateProvider.notifier).showParking();
    }
    if (isFromDeepLink && oldState != null) {
      state = oldState;
    }
  }

  Future<void> hideParking() async {
    await _viewPortSubscription?.cancel();

    await _removeMapObjects();

    setSelection();
    await ref.read(parkingStateProvider.notifier).hideParking();
  }

  void updateLayerInfo() {
    final selectedLayerState = _getLayerState();
    if (selectedLayerState != null) {
      setSelection(selectedType: selectedLayerState);
    } else {
      setSelection();
    }
  }

  Future<void> showIwish() async {
    update(isLoading: true);
    const duration = Duration(seconds: 10);
    final markers = await ref
        .read(iwishMarkersProvider.future)
        .onError((error, stackTrace) {
          onError();
          return [];
        })
        .timeout(
          duration,
          onTimeout: () {
            onError();
            return [];
          },
        );
    await _removeAll();
    await ref
        .read(
          mapObjectManagerProvider(named: esriMapObjectSettings.name, layerId: esriMapObjectSettings.layerId).notifier,
        )
        .addMarkers(markers)
        .onError((error, stackTrace) => onError())
        .timeout(duration, onTimeout: onError);
    update(isLoading: false);

    await computeCameraPosition(
      markers,
      ref.read(cameraPositionProvider),
      ref.read(locationProvider),
      ref.read(cameraPositionProvider.notifier).animateTo,
    );
  }

  // We need to store the previous layer to restore it when we go back
  LayerType? _previousLayer;

  void hideLayer(LayerType layer, {bool restorable = true}) {
    // Do not hide the same layer twice, it is already hidden
    if (layer == _previousLayer) {
      return;
    }
    if (state.selectedType == layer) {
      if (restorable) {
        _previousLayer = state.selectedType;
      }
      handleTap(layer);
    }
  }

  // We need to restore the previous layer when we go back
  void restorePreviousLayer() {
    if (_previousLayer != null) {
      handleTap(_previousLayer!);
      _previousLayer = null;
    }
  }

  MapRequestParams _createParams(VisibleRect visibleRect, LayerType layer, EnvironmentConfig env) => MapRequestParams(
    layer: layer.getGISLayerType(),
    southWestLongitude: visibleRect.southWestLon,
    southWestLatitude: visibleRect.southWestLat,
    northEastLongitude: visibleRect.northEastLon,
    northEastLatitude: visibleRect.northEastLat,
    domain: env.url,
    proxy: env.proxy,
  );

  Future<void> _showInvestmentOpportunities(LayerType layerType) async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);

    final map = ref.watch(
      mapObjectManagerProvider(named: esriMapObjectSettings.name, layerId: esriMapObjectSettings.layerId).notifier,
    );

    /// Loading
    setSelection(selectedType: layerType);
    update(isLoading: true);

    await _removeAll();

    _cancelToken = CancelToken();

    _viewPortSubscription = ref
        .watch(dgisControllerProvider.notifier)
        .visibleRectSubject
        .whereNotNull()
        .map((event) => event.visibleRect)
        .debounceTime(duration)
        .asyncMap(
          (visibleRect) =>
              controller.getEsriPoints(params: _createParams(visibleRect, layerType, env), cancelToken: _cancelToken),
        )
        .map(_makeMarkers)
        .listen((markers) async {
          update(isLoading: false);
          if (state.selectedType == LayerType.invest) {
            final stateMarkers = state.investmentsMarkers;
            markers.retainWhere((e) => !stateMarkers.containsKey(e.id));
            for (final element in markers) {
              stateMarkers[element.id] = element;
            }
            update(investmentsMarkers: stateMarkers);
            await map.addMarkers(markers);
          }
        });
  }

  Future<void> _tapHandler(LayerType value) async {
    // the friends layer is
    // independent of overlay layers — do not clear the active overlay or
    // its selection state.
    if (value == LayerType.friends) {
      await toggleLayers(value);
      return;
    }

    final currentState = state.selectedType;

    _cancelToken?.cancel();
    await _viewPortSubscription?.cancel();
    await _hideAllSelectedMarkers();
    ref.read(poiCardClosingProvider.notifier).close();

    if (currentState != null && currentState != value) {
      await _hidePreviousLayers(currentState);
    }
    await toggleLayers(value);
  }

  Future<void> _hidePreviousLayers(LayerType layer) async {
    switch (layer) {
      case LayerType.favourites:
        {
          await _removeAll();
          await ref.read(favouriteToggleProvider.notifier).disable();
          break;
        }

      case LayerType.buildings:
      case LayerType.invest:
      case LayerType.fencing:
        await _removeAll();
        break;
      case LayerType.parkingLots:
        {
          await ref
              .read(
                mapObjectManagerProvider(
                  named: esriMapObjectSettings.name,
                  layerId: esriMapObjectSettings.layerId,
                ).notifier,
              )
              .removeAllMarkers();
          await ref.read(parkingStateProvider.notifier).hideParking();
          break;
        }

      case LayerType.metro:
        await ref.read(metroLayerProvider.notifier).hideMetro();
        break;
      case LayerType.busSubMenu:
        // no op
        break;
      case LayerType.makkahBus:
        await ref.read(makkahBusLayerProvider.notifier).hide();
        break;
      case LayerType.shuttleBus:
        await ref.read(shuttleBusLayerProvider.notifier).hide();
        break;
      case LayerType.jeddahBus:
        await ref.read(jeddahBusLayerProvider.notifier).hide();
        break;
      case LayerType.traffic:
        final trafficNotifier = ref.read(trafficStateProvider.notifier);
        if (trafficNotifier.isTrafficEnabled) {
          trafficNotifier.onTrafficTap();
        }
        break;
      case LayerType.three3D:
      case LayerType.friends:
        break;
      // case LayerType.roadEvents:
      //   break;
    }
  }

  LayerType? _getLayerState() => ref.read(activeLayerProvider);

  Future<void> _saveLayersState(LayerType type) async {
    final activeLayerNotifier = ref.read(activeLayerProvider.notifier);
    await activeLayerNotifier.setActiveLayer(type);
  }

  Future<void> _removeLayersState() async {
    final activeLayerNotifier = ref.read(activeLayerProvider.notifier);
    await activeLayerNotifier.removeActiveLayer();
  }

  Future<void> _showWhiteLands() async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);

    final mapManager = ref.watch(
      mapObjectManagerProvider(named: esriMapObjectSettings.name, layerId: esriMapObjectSettings.layerId).notifier,
    );

    setSelection(selectedType: LayerType.fencing);
    update(isLoading: true);

    await _removeAll();

    _cancelToken = CancelToken();

    _viewPortSubscription = ref
        .watch(dgisControllerProvider.notifier)
        .visibleRectSubject
        .whereNotNull()
        .debounceTime(duration)
        .map((event) => event.visibleRect)
        .asyncMap(
          (visibleRect) => controller.getWhiteLands(
            MapRequestParams(
              layer: GISMapLayers.bsWhiteParcelS,
              southWestLongitude: visibleRect.southWestLon,
              southWestLatitude: visibleRect.southWestLat,
              northEastLongitude: visibleRect.northEastLon,
              northEastLatitude: visibleRect.northEastLat,
              proxy: env.proxy,
              domain: env.url,
            ),
            _cancelToken,
          ),
        )
        .map(_makePolygons)
        .listen((data) async {
          update(isLoading: false);
          await _removeAll();
          if (state.selectedType == LayerType.fencing) {
            final statePolygons = state.polygons;
            data.retainWhere((e) => !statePolygons.containsKey(e.id));
            for (final element in data) {
              statePolygons[element.id] = element;
            }
            update(polygons: statePolygons);

            await mapManager.addPolygons(data);
          }
        });
  }

  Future<void> _showBuildingCompliance() async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);

    final mapObjectManager = ref.watch(
      mapObjectManagerProvider(named: esriMapObjectSettings.name, layerId: esriMapObjectSettings.layerId).notifier,
    );

    await _removeAll();

    /// Cancel API calls
    _cancelToken = CancelToken();

    _viewPortSubscription = ref
        .watch(dgisControllerProvider.notifier)
        .visibleRectSubject
        .whereNotNull()
        .debounceTime(duration)
        .map((event) => event.visibleRect)
        .asyncMap(
          (visibleRect) => controller.buildingComplianceCertificate(
            _createParams(visibleRect, LayerType.buildings, env),
            _cancelToken,
          ),
        )
        .listen((data) async {
          update(isLoading: false);
          await _removeAll();
          if (state.selectedType == LayerType.buildings) {
            final polylineList = _makePolylineWithPoint(data);
            final statePolylines = state.polylines;
            polylineList.retainWhere((e) => !statePolylines.containsKey(e.id));
            for (final element in polylineList) {
              statePolylines[element.id] = element;
            }
            update(polylines: statePolylines);
            await mapObjectManager.addPolyLines(polylineList);
          }
        });
  }

  List<Polyline> _makePolylineWithPoint(List<BuildingComplianceCertificate>? pointList) {
    final polylines = <Polyline>[];
    if (pointList != null && pointList.isNotEmpty) {
      for (final element in pointList) {
        final pathsGoogle = element.pathsGoogle;
        if (pathsGoogle != null) {
          for (final i in pathsGoogle) {
            final id = int.parse(element.id);
            final idPolyline = '$id+$i';
            polylines.add(
              Polyline(
                id: idPolyline,
                options: PolylineOptionsMessage(points: i, width: 2, color: 0xff358281),
                onTap: () => _showEsriCard(element),
              ),
            );
          }
        }
      }
    }
    return polylines;
  }

  List<Marker> _makeMarkers(List<InvestmentSites>? response) {
    final markers =
        response?.nonNulls
            .map<Marker>(
              (e) => Marker(
                id: e.id,
                options: MarkerOptionsMessage(
                  position: GeoPointWithElevationMessage(
                    latitude: e.latLng?.latitude ?? 0,
                    longitude: e.latLng?.longitude ?? 0,
                    elevation: 0,
                  ),
                  icon: Assets.icons.svg.layers.icInvestPin.keyName.markerIcon(),
                  textStyle: MarkerTextStyleMessage(
                    color: NonThemeColor.color26.value,
                    strokeColor: Colors.white.value,
                    strokeWidth: 1,
                    fontSize: 14,
                    fontName: 'IBMPlexSansArabic-Bold',
                    textPlacement: MarkerTextPlacementMessage(placement: TextPlacementMessage.bottomCenter),
                  ),
                ),
                onTap: () => _showEsriCard(e),
              ),
            )
            .toList() ??
        [];
    return markers;
  }

  List<Polygon> _makePolygons(List<WhiteLands>? list) =>
      list
          ?.map(
            (e) => Polygon(
              id: e.id,
              options: PolygonOptionsMessage(
                strokeWidth: 2,
                strokeColor: e.strokeColor,
                color: e.color,
                contours: [PolylineGeometryMessage(points: e.paths)],
              ),
              onTap: () => _showEsriCard(e),
            ),
          )
          .toList() ??
      [];

  void _showEsriCard(PointLayersData e) {
    ref.read(appRouterProvider).push(LayersDetailsWidgetRoute(data: e));
  }

  Future<void> _removeAll() async {
    await _removeMapObjects();
    await ref.read(parkingStateProvider.notifier).hideParking();
  }

  Future<void> _removeMapObjects() async {
    update(polylines: {}, polygons: {}, investmentsMarkers: {});
    final map = ref.watch(
      mapObjectManagerProvider(named: esriMapObjectSettings.name, layerId: esriMapObjectSettings.layerId).notifier,
    );

    final mapObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: favouritesMapObjectSettings.name,
        layerId: favouritesMapObjectSettings.layerId,
      ).notifier,
    );

    await mapObjectManager.removeAllMarkers();
    await map.removeAllPolygons();
    await map.removeAllPolyLines();
  }

  Future<void> toggle3D() async {
    await ref.read(mapDimensionsControlProvider.notifier).toggleMapDimensions();
  }

  // Future<void> toggleRoadEvents() async {
  //   if (state.selectedType != (LayerType.roadEvents)) {
  //     ///TODO: implements road events here
  //     setSelection(selectedType: LayerType.roadEvents);
  //   } else {
  //     setSelection();
  //   }
  // }

  Future<void> toggleTraffic() async {
    final trafficNotifier = ref.read(trafficStateProvider.notifier);
    final wasEnabled = trafficNotifier.isTrafficEnabled;

    Metrics.logEventAdvanced(
      MetricsConstants.exploreKeys.trafficLightButton,
      group: MetricsConstants.exploreTag,
      action: MetricAction.tap.name,
    );

    trafficNotifier.onTrafficTap();

    if (wasEnabled) {
      if (state.selectedType == LayerType.traffic) {
        setSelection();
      }
    } else {
      setSelection(selectedType: LayerType.traffic);
    }
  }
}
