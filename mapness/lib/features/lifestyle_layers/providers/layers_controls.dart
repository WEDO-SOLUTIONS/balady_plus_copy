import 'dart:async';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/features/favourites/providers/favourite_markers.dart';
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
import 'package:mapness/features/satellite/providers/satellite_map_controller.dart';
import 'package:mapness/features/shuttle_bus/provider.dart';
import 'package:mapness/features/shuttle_bus/repo.dart';
import 'package:mapness/features/shuttle_bus/visible_provider.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/geo/geo_utils.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/parking_state.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/map/traffic_state.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
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

// BALADY-3730: keepAlive so `selectedType` survives the auth flow. Without
// it the provider auto-disposes the moment the layers sheet is covered by
// the login route — the callback then reads/creates a fresh instance,
// toggles Favorites on it, and both that mutation and the later re-mount
// lose the selection. Same pattern SatelliteMapController uses.
@Riverpod(keepAlive: true)
class LayersControls extends _$LayersControls {
  static const duration = Duration(milliseconds: 250);
  StreamSubscription? _viewPortSubscription;
  StreamSubscription? _authStateSubscription;
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
      _authStateSubscription?.cancel();
    });

    // BALADY-3730 follow-up: if the user logs out while the Favorites layer
    // is active, disable it — the layer needs an authenticated session and
    // would otherwise keep stale selection/markers. Listen to the
    // EntryPointCubit stream directly (same source authAndOpen uses):
    // relying on authMethodsProvider here doesn't work because it is only
    // re-evaluated when the autoDispose authProvider happens to be alive to
    // invalidate it. The cubit stream replays the current state on
    // subscription, so guard on an explicit logged-in -> logged-out
    // transition. Mutation is deferred via microtask — stream callbacks
    // must not touch providers synchronously from the notifier frame.
    bool? wasLoggedIn;
    _authStateSubscription?.cancel();
    _authStateSubscription = CommonProperties.userStateStream.listen((event) {
      final isLoggedIn = event.userInfo != null;
      final loggedOut = wasLoggedIn == true && !isLoggedIn;
      wasLoggedIn = isLoggedIn;
      if (loggedOut && state.selectedType == LayerType.favourites) {
        Future.microtask(() async {
          await ref.read(favouriteToggleProvider.notifier).disable();
          setSelection();
        });
      }
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
        await toggleMetro();
        break;
      case LayerType.busSubMenu:
        // no op
        break;
      case LayerType.makkahBus:
        await toggleMakkahBuses();
        break;
      case LayerType.shuttleBus:
        await toggleHaramShuttle();
        break;
      case LayerType.jeddahBus:
        await toggleJeddahBuses();
        break;
      case LayerType.defaultMap:
        await ref.read(satelliteMapControllerProvider.notifier).disable();
        break;
      case LayerType.satellite:
        await ref.read(satelliteMapControllerProvider.notifier).enable();
        break;
      // case LayerType.joy:
      //   await toggleIwish();
    }
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
    final currentState = state.selectedType;
    await _viewPortSubscription?.cancel();
    await _removeAll();
    _cancelToken?.cancel();

    if (currentState != LayerType.favourites) {
      // BALADY-3730: same mutual-exclusion guard as toggleParking — when
      // favourites is activated while another overlay is on (e.g. traffic
      // or metro), hide the previous native layer so the two don't render
      // side-by-side. Idempotent (each branch checks isEnabled), so the
      // double-call from _tapHandler stays safe.
      if (currentState != null) {
        await _hidePreviousLayers(currentState);
      }
      await ref.read(favouriteToggleProvider.notifier).enable();
      setSelection(selectedType: LayerType.favourites);
    } else {
      await ref.read(favouriteToggleProvider.notifier).disable();
      setSelection();
    }
  }

  Future<void> toggleMetro() async {
    final currentState = state.selectedType;
    final isVisible = ref.read(metroLayerVisibleProvider);
    if (isVisible) {
      await ref.read(metroLayerProvider.notifier).hideMetro();
      if (currentState == LayerType.metro) {
        setSelection();
      }
    } else {
      if (currentState != null && currentState != LayerType.metro) {
        await _hidePreviousLayers(currentState);
      }
      await ref.read(metroLayerProvider.notifier).showMetro();
      setSelection(selectedType: LayerType.metro);
    }
  }

  Future<void> toggleMakkahBuses() async {
    final currentState = state.selectedType;
    final isVisible = ref.read(makkahBusLayerVisibleProvider);
    if (isVisible) {
      await ref.read(makkahBusLayerProvider.notifier).hide();
      if (currentState == LayerType.makkahBus) {
        setSelection();
      }
    } else {
      if (currentState != null && currentState != LayerType.makkahBus) {
        await _hidePreviousLayers(currentState);
      }
      await ref.read(makkahBusLayerProvider.notifier).show();
      setSelection(selectedType: LayerType.makkahBus);
    }
  }

  Future<void> toggleHaramShuttle() async {
    final currentState = state.selectedType;
    final isVisible = ref.read(shuttleBusLayerVisibleProvider);
    if (isVisible) {
      await ref.read(shuttleBusLayerProvider.notifier).hide();
      if (currentState == LayerType.shuttleBus) {
        setSelection();
      }
    } else {
      if (currentState != null && currentState != LayerType.shuttleBus) {
        await _hidePreviousLayers(currentState);
      }
      await ref.read(shuttleBusLayerProvider.notifier).show();
      setSelection(selectedType: LayerType.shuttleBus);
    }
  }

  Future<void> toggleJeddahBuses() async {
    final currentState = state.selectedType;
    final isVisible = ref.read(jeddahBusLayerVisibleProvider);
    if (isVisible) {
      await ref.read(jeddahBusLayerProvider.notifier).hide();
      if (currentState == LayerType.jeddahBus) {
        setSelection();
      }
    } else {
      if (currentState != null && currentState != LayerType.jeddahBus) {
        await _hidePreviousLayers(currentState);
      }
      await ref.read(jeddahBusLayerProvider.notifier).show();
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
      if (currentState != null) {
        await _hidePreviousLayers(currentState);
      }
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
      if (currentState != null) {
        await _hidePreviousLayers(currentState);
      }
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
      if (currentState != null) {
        await _hidePreviousLayers(currentState);
      }
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
      // BALADY-3615: when parking is activated while another overlay is
      // on (e.g. via the dashboard quick action that calls toggleParking
      // directly, bypassing _tapHandler), the previous layer kept
      // rendering alongside parking. Hide the previous layer here so the
      // toggle stays mutually exclusive regardless of call site.
      // _hidePreviousLayers is idempotent (each branch checks isEnabled
      // before disabling), so the double-call from _tapHandler is safe.
      if (currentState != null) {
        await _hidePreviousLayers(currentState);
      }
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
    detach(_removeMapObjects(), tag: 'layersControls.removeMapObjects');
    final currentState = state.selectedType;
    // TEMP(BALADY-3615): trace — remove after QA confirms.
    logger.log(
      'layers: enableParking selectedType=$currentState '
      'trafficEnabled=${ref.read(trafficStateProvider.notifier).isTrafficEnabled}',
      logLevel: MapnessLogLevel.info,
    );
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

    await _computeCameraPosition(
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
    // Satellite / default base-map switch is independent of overlay layers —
    // do not clear the active overlay or its selection state.
    if (value == LayerType.satellite || value == LayerType.defaultMap) {
      await toggleLayers(value);
      return;
    }

    final currentState = state.selectedType;

    // TEMP(BALADY-3615): trace the mutex chain — remove after QA confirms.
    logger.log(
      'layers: tap=$value selectedType=$currentState '
      'trafficEnabled=${ref.read(trafficStateProvider.notifier).isTrafficEnabled}',
      logLevel: MapnessLogLevel.info,
    );

    _cancelToken?.cancel();
    await _viewPortSubscription?.cancel();
    await _hideAllSelectedMarkers();
    ref.read(poiCardClosingProvider.notifier).close();

    // BALADY-3615: do NOT call _hidePreviousLayers here. Every toggle*
    // reached via toggleLayers hides the previous overlay itself (they must,
    // because dashboard/free-roam call them directly). Calling it here too
    // fired the traffic hide TWICE: hiding traffic is a native toggle-click
    // (onTrafficTap), and the disabled event does not land between the two
    // calls — the second click re-enabled traffic, leaving it rendered
    // under the newly selected overlay.
    await toggleLayers(value);

    // TEMP(BALADY-3615): post-toggle state.
    logger.log(
      'layers: after tap=$value selectedType=${state.selectedType} '
      'trafficEnabled=${ref.read(trafficStateProvider.notifier).isTrafficEnabled}',
      logLevel: MapnessLogLevel.info,
    );
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
        // TEMP(BALADY-3615): trace — remove after QA confirms.
        logger.log(
          'layers: hidePrevious(traffic) trafficEnabled=${trafficNotifier.isTrafficEnabled}',
          logLevel: MapnessLogLevel.info,
        );
        if (trafficNotifier.isTrafficEnabled) {
          trafficNotifier.onTrafficTap();
        }
        break;
      case LayerType.three3D:
      case LayerType.defaultMap:
      case LayerType.satellite:
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
                    fontName: MapnessConstants.poiMapFontAr,
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
    final currentState = state.selectedType;

    // TEMP(BALADY-3615): trace — remove after QA confirms.
    logger.log(
      'layers: toggleTraffic wasEnabled=$wasEnabled selectedType=$currentState',
      logLevel: MapnessLogLevel.info,
    );

    Metrics.logEventAdvanced(
      MetricsConstants.exploreKeys.trafficLightButton,
      group: MetricsConstants.exploreTag,
      action: MetricAction.tap.name,
    );

    // BALADY-3615: when enabling traffic while another overlay is on, hide
    // the previous layer first so the two don't render side-by-side.
    if (!wasEnabled && currentState != null && currentState != LayerType.traffic) {
      await _hidePreviousLayers(currentState);
    }

    trafficNotifier.onTrafficTap();

    if (wasEnabled) {
      if (currentState == LayerType.traffic) {
        setSelection();
      }
    } else {
      setSelection(selectedType: LayerType.traffic);
    }
  }
}

/// Frames the camera so the nearby [markers] fit, without zooming in past
/// whatever the camera is already showing.
///
/// This used to live in `shared/lib/search` and carried a deprecation saying
/// Search zooms by itself now. It does - but the lifestyle layers are not
/// Search, and this was its only remaining caller, so it moved here and became
/// private rather than staying deprecated-but-in-use.
Future<void> _computeCameraPosition(
  List<Marker> markers,
  CameraPositionMessage? cameraPosition,
  Position? userLocation,
  Future<void> Function(CameraPositionMessage) animateTo,
) async {
  var location = cameraPosition?.point;
  if (location == null && userLocation != null) {
    location = GeoPointMessage(latitude: userLocation.latitude, longitude: userLocation.longitude);
  }

  if (location == null) {
    return;
  }

  var zoom = await GeoUtils.zoomByMarkersNearby(
    markers: markers,
    position: location,
  );
  if (cameraPosition?.zoom != null) {
    zoom = cameraPosition!.zoom < zoom ? cameraPosition.zoom : zoom;
  }

  await animateTo(
    CameraPositionMessage(
      point: location,
      tilt: cameraPosition?.tilt ?? 0.0,
      bearing: cameraPosition?.bearing ?? 0.0,
      zoom: zoom,
    ),
  );
}
