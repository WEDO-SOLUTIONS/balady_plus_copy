import 'dart:async';

import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_repository.dart';
import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';
import 'package:mapness/_features/lifestyle_layers/domain/building_compliance_certificate.dart';
import 'package:mapness/_features/lifestyle_layers/domain/investment_sites.dart';
import 'package:mapness/_features/lifestyle_layers/domain/map_requests_params.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';
import 'package:mapness/_features/lifestyle_layers/domain/white_lands.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/_features/lifestyle_layers/providers/lib/layers_type_extension.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/layer_details.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/search/compute_camera_position.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/parking_state.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
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

enum LayersPanelType { layers, parking }

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
  }) =>
      LayersState(
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
  }

  @override
  LayersState build() {
    ref.onDispose(() {
      _viewPortSubscription?.cancel();
      _tapSubscription?.cancel();
    });

    _tapSubscription = tapSubject.debounceTime(duration).listen(_tapHandler);

    final selectedLayerState = _getLayerState();

    // Wait for the state to be initialized
    Future.delayed(Duration.zero, () async {
      if (selectedLayerState != null) {
        await _tapHandler(selectedLayerState);
        await toggle(selectedLayerState);
      }
    });

    return LayersState(
      layersVisible: false,
      selectedType: null,
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

  Future<void> _tapHandler(value) async {
    final currentState = state.selectedType;

    _cancelToken?.cancel();
    await _viewPortSubscription?.cancel();

    await _hideAllSelectedMarkers();

    switch (value) {
      case LayerType.favourites:
        await toggleFavourites(currentState);
      case LayerType.buildings:
        await toggleComplianceBuildings();
      case LayerType.invest:
        await toggleInvestOpportunities();
      case LayerType.fencing:
        await toggleWhiteLands();
      case LayerType.parkingLots:
        await toggleParking();
      case LayerType.joy:
        await toggleIwish();
    }
  }

  void updateLayerInfo() {
    final selectedLayerState = _getLayerState();
    if (selectedLayerState != null) {
      setSelection(selectedType: selectedLayerState);
    } else {
      setSelection();
    }
  }

  LayerType? _getLayerState() {
    final sharedPrefs = ref.watch(sharedPrefsProvider);
    final string = sharedPrefs.getString(MapnessConstants.activeLayerKey);

    final layerState = LayerTypeEx.stringToType(string);
    return layerState;
  }

  Future<void> _saveLayersState(LayerType type) async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    await sharedPrefs.setString(MapnessConstants.activeLayerKey, type.name);
  }

  Future<void> _removeLayersState() async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    await sharedPrefs.remove(
      MapnessConstants.activeLayerKey,
    );
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
    final sharedPrefs = ref.read(sharedPrefsProvider);

    final name = type.name;
    final currentState = sharedPrefs.getString(MapnessConstants.activeLayerKey) == name;
    if (currentState) {
      await sharedPrefs.remove(MapnessConstants.activeLayerKey);
    } else {
      await sharedPrefs.setString(
        MapnessConstants.activeLayerKey,
        name,
      );
    }

    setSelection(selectedType: type);
  }

  Future<void> toggleFavourites(LayerType? currentState) async {
    await _viewPortSubscription?.cancel();
    await _removeAll();
    _cancelToken?.cancel();

    if (currentState == (LayerType.favourites)) {
      await ref.read(favouriteToggleProvider.notifier).disable();
      setSelection();
    } else {
      await ref.read(favouriteToggleProvider.notifier).enable();
      setSelection(selectedType: LayerType.favourites);
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

  void setSelection({
    LayerType? selectedType,
  }) {
    if (selectedType != null) {
      _saveLayersState(selectedType);
      Metrics.logEventAdvanced(MetricsConstants.layersKeys.layerSelect,
          group: MetricsConstants.layersTag,
          action: MetricAction.tap.toString(),
          props: {
            'type': selectedType.titleLocale(
              AppLocalizationsEn(),
            ),
          });
    } else {
      _removeLayersState();
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

  Future<void> toggleIwish() async {
    final layers = ref.watch(layersControlsProvider.notifier);
    final currentState = state.selectedType;
    await _viewPortSubscription?.cancel();

    if (currentState == LayerType.joy) {
      await ref
          .read(mapObjectManagerProvider(
            named: esriMapObjectSettings.name,
            layerId: esriMapObjectSettings.layerId,
          ).notifier)
          .removeAllMarkers();
      layers
        ..setSelection()
        ..update(isLoading: false);
    } else {
      setSelection(selectedType: LayerType.joy);
      await showIwish();
    }
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
    final layersControls = ref.watch(layersControlsProvider.notifier);
    final currentState = state.selectedType;
    if (currentState != (LayerType.invest)) {
      await layersControls._showInvestmentOpportunities(LayerType.invest);
    } else {
      await _removeAll();

      layersControls
        ..setSelection()
        ..update(
          isLoading: false,
        );
    }
  }

  Future<void> toggleWhiteLands() async {
    final layersControls = ref.watch(layersControlsProvider.notifier);
    final currentState = state.selectedType;
    if (currentState != (LayerType.fencing)) {
      await layersControls._showWhiteLands();
    } else {
      await _viewPortSubscription?.cancel();
      await _removeAll();

      layersControls
        ..setSelection()
        ..update(
          isLoading: false,
        );
    }
  }

  Future<void> toggleParking() async {
    final layers = ref.watch(layersControlsProvider.notifier);
    final currentState = state.selectedType;
    await _viewPortSubscription?.cancel();
    await _removeAll();

    if (currentState == LayerType.parkingLots) {
      final manager = ref.read(mapObjectManagerProvider(
        named: esriMapObjectSettings.name,
        layerId: esriMapObjectSettings.layerId,
      ).notifier);
      await manager.removeAllMarkers();

      layers
        ..setSelection()
        ..update(isLoading: false);

      await ref.read(parkingStateProvider.notifier).hideParking();
    } else {
      setSelection(selectedType: LayerType.parkingLots);
      await ref.read(parkingStateProvider.notifier).showParking();
    }
  }

  Future<void> enableParking() async {
    await _viewPortSubscription?.cancel();

    await _removeMapObjects();

    if (state.selectedType != LayerType.parkingLots) {
      setSelection(selectedType: LayerType.parkingLots);
      await ref.read(parkingStateProvider.notifier).showParking();
    }
  }

  MapRequestParams _createParams(
    VisibleRect visibleRect,
    LayerType layer,
    EnvironmentConfig env,
  ) =>
      MapRequestParams(
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

    final map = ref.watch(mapObjectManagerProvider(
      named: esriMapObjectSettings.name,
      layerId: esriMapObjectSettings.layerId,
    ).notifier);

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
          (visibleRect) => controller.getEsriPoints(
            params: _createParams(visibleRect, layerType, env),
            cancelToken: _cancelToken,
          ),
        )
        .map(_makeMarkers)
        .listen(
      (markers) async {
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
      },
    );
  }

  Future<void> _showWhiteLands() async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);

    final mapManager = ref.watch(mapObjectManagerProvider(
      named: esriMapObjectSettings.name,
      layerId: esriMapObjectSettings.layerId,
    ).notifier);

    setSelection(selectedType: LayerType.fencing);
    update(
      isLoading: true,
    );

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
              layer: GISMapLayers.BSWhiteParcelS,
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

    final mapObjectManager = ref.watch(mapObjectManagerProvider(
      named: esriMapObjectSettings.name,
      layerId: esriMapObjectSettings.layerId,
    ).notifier);

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
        .listen(
      (data) async {
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
      },
    );
  }

  List<Polyline> _makePolylineWithPoint(
    List<BuildingComplianceCertificate>? pointList,
  ) {
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
                options: PolylineOptionsMessage(
                  points: i,
                  width: 2,
                  color: 0xff358281,
                ),
                onTap: () => _showEsriCard(element),
              ),
            );
          }
        }
      }
    }
    return polylines;
  }

  List<Marker> _makeMarkers(
    List<InvestmentSites>? response,
  ) {
    final markers = response
            ?.whereNotNull()
            .map<Marker>(
              (e) => Marker(
                id: e.id,
                options: MarkerOptionsMessage(
                  position: GeoPointWithElevationMessage(
                    latitude: e.latLng?.latitude ?? 0,
                    longitude: e.latLng?.longitude ?? 0,
                    elevation: 0,
                  ),
                  icon: LayersSvgPaths.invest.markerIcon(),
                  textStyle: MarkerTextStyleMessage(
                    color: NonThemeColor.color26.value,
                    strokeColor: Colors.white.value,
                    strokeWidth: 1,
                    fontSize: 14,
                    fontName: 'Frutiger',
                    textPlacement: MarkerTextPlacementMessage(
                      placement: TextPlacementMessage.bottomCenter,
                    ),
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
                contours: [e.paths],
              ),
              onTap: () => _showEsriCard(e),
            ),
          )
          .toList() ??
      [];

  Future<void> showIwish() async {
    update(isLoading: true);
    const duration = Duration(seconds: 10);
    final markers = await ref.read(iwishMarkersProvider.future).onError((error, stackTrace) {
      onError();
      return [];
    }).timeout(
      duration,
      onTimeout: () {
        onError();
        return [];
      },
    );
    await _removeAll();
    await ref
        .read(mapObjectManagerProvider(
          named: esriMapObjectSettings.name,
          layerId: esriMapObjectSettings.layerId,
        ).notifier)
        .addMarkers(markers)
        .onError((error, stackTrace) => onError())
        .timeout(duration, onTimeout: onError);
    update(isLoading: false);

    await computeCameraPosition(
      markers,
      ref.read(cameraPositionProvider),
      ref.read(cameraPositionProvider.notifier).animateTo,
    );
  }

  void onError() {
    setSelection();
    update(isLoading: false);
  }

  void _showEsriCard(PointLayersData e) {
    final goRouter = ref.read(goRouterProvider);
    LayerDetailsRoute.open(goRouter, e);
  }

  Future<void> _removeAll() async {
    await _removeMapObjects();
    await ref.read(parkingStateProvider.notifier).hideParking();
  }

  Future<void> _removeMapObjects() async {
    update(polylines: {}, polygons: {}, investmentsMarkers: {});
    final map = ref.watch(mapObjectManagerProvider(
      named: esriMapObjectSettings.name,
      layerId: esriMapObjectSettings.layerId,
    ).notifier);

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

  void showParking() {
    update(layersWidgetType: LayersPanelType.parking);
  }
}
