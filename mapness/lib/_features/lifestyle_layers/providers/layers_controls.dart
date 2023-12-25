import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_repository.dart';
import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';
import 'package:mapness/_features/lifestyle_layers/domain/investment_sites.dart';
import 'package:mapness/_features/lifestyle_layers/domain/map_requests_params.dart';
import 'package:mapness/_features/lifestyle_layers/domain/white_lands.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/_features/lifestyle_layers/providers/lib/layers_type_extension.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/layer_details.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../domain/building_compliance_certificate.dart';
import '../domain/point_layers_data.dart';

part 'layers_controls.g.dart';

const mapLayerName = 'esri_markers';

@riverpod
class SelectedLayer extends _$SelectedLayer {
  void setLayerType(LayerType? layerType) {
    state = layerType;
  }

  @override
  LayerType? build(LayerType? layerType) {
    return null;
  }
}

class LayersState {
  final bool layersVisible;
  final LayerType? selectedType;
  final bool isLoading;

  List<Marker>? investmentsMarkers;
  List<Polyline>? polylines;

  LayersState({
    required this.isLoading,
    required this.layersVisible,
    required this.selectedType,
    required this.investmentsMarkers,
  });
}

@riverpod
class LayersControls extends _$LayersControls {
  StreamSubscription? viewPortSubscription;
  CancelToken? cancelToken;

  final tapSubject = BehaviorSubject<LayerType>();

  @override
  LayersState build() {
    ref.onDispose(() {
      viewPortSubscription?.cancel();
    });

    tapSubject.debounceTime(const Duration(milliseconds: 250)).listen((value) {
      var currentState = state.selectedType;

      cancelToken?.cancel();
      viewPortSubscription?.cancel();

      switch (value) {
        // case LayerType.favourites:
        //   if (currentState == (LayerType.favourites)) {
        //     await ref.read(favouriteToggleProvider.notifier).disable();
        //   } else {
        //     await ref.read(favouriteToggleProvider.notifier).enable();
        //   }
        // // _toggleSelected(value);

        case LayerType.buildings:
          toggleComplianceBuildings();
        case LayerType.invest:
          toggleInvestOpportunities();
        case LayerType.fencing:
          toggleWhiteLands();
        case LayerType.joy:
          toggleIwish(currentState, value);
      }
    });

    return LayersState(
      layersVisible: false,
      selectedType: null,
      isLoading: false,
      investmentsMarkers: [],
    );
  }

  void update({
    bool? visible,
    // LayerType? selectedType,
    bool? isLoading,
    List<Marker>? investmentsMarkers,
  }) {
    state = LayersState(
      investmentsMarkers: investmentsMarkers ?? state.investmentsMarkers,
      layersVisible: visible ?? state.layersVisible,
      selectedType: state.selectedType,
      isLoading: isLoading ?? state.isLoading,
    );
  }

  void setSelection({
    LayerType? selectedType,
  }) {
    state = LayersState(
      investmentsMarkers: state.investmentsMarkers,
      layersVisible: state.layersVisible,
      selectedType: selectedType,
      isLoading: state.isLoading,
    );
  }

  Future<void> focusIwish() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    final markers = await ref.read(iwishMarkersProvider.future);
    final markerIds = markers.map((e) => e.id).toList();

    if (markerIds.isEmpty) return;

    final cameraPosition = await dgisController.calcPositionForMarkers(
      markerIds,
      CalcPositionOptionsMessage(),
    );
    await ref.read(cameraPositionProvider.notifier).animateTo(cameraPosition);
  }

  Future<void> disable() async {
    if (state.selectedType != null) {
      handleTap(state.selectedType!);
    }
  }

  void handleTap(LayerType value) => tapSubject.add(value);

  Future<void> toggleIwish(LayerType? currentState, LayerType value) async {
    var layersControls = ref.watch(layersControlsProvider.notifier);
    viewPortSubscription?.cancel();

    if (currentState == LayerType.joy) {
      await ref
          .read(mapObjectManagerProvider(named: mapLayerName).notifier)
          .removeAllMarkers();
      layersControls.setSelection(selectedType: null);
      layersControls.update(
        isLoading: false,
      );
    } else {
      setSelection(selectedType: LayerType.joy);
      showIwish();
    }
  }

  Future<void> toggleComplianceBuildings() async {
    var currentState = state.selectedType;
    if (currentState != (LayerType.buildings)) {
      setSelection(selectedType: LayerType.buildings);
      update(isLoading: true);
      _showBuildingCompliance();
    } else {
      viewPortSubscription?.cancel();
      await _removeAll();
      setSelection(selectedType: null);
      update(
        isLoading: false,
      );
    }
  }

  Future<void> toggleInvestOpportunities() async {
    var layersControls = ref.watch(layersControlsProvider.notifier);
    var currentState = state.selectedType;
    if (currentState != (LayerType.invest)) {
      layersControls._showInvestmentOpportunities(LayerType.invest);
    } else {
      await _removeAll();

      layersControls.setSelection(selectedType: null);
      layersControls.update(
        isLoading: false,
      );
    }
  }

  Future<void> toggleWhiteLands() async {
    var layersControls = ref.watch(layersControlsProvider.notifier);
    var currentState = state.selectedType;
    if (currentState != (LayerType.fencing)) {
      layersControls._showWhiteLands();
    } else {
      viewPortSubscription?.cancel();
      await _removeAll();

      layersControls.setSelection(selectedType: null);
      layersControls.update(
        isLoading: false,
      );
    }
  }

  _createParams(
          VisibleRect visibleRect, LayerType layer, EnvironmentConfig env) =>
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
    final map =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);

    ///загрузка
    setSelection(selectedType: layerType);
    update(isLoading: true);

    await _removeAll();

    cancelToken = CancelToken();

    viewPortSubscription = ref
        .watch(dgisControllerProvider.notifier)
        .visibleRectSubject
        .map((event) => event.visibleRect)
        .debounceTime(const Duration(milliseconds: 1000))
        .asyncMap(
          (visibleRect) => controller.getEsriPoints(
            params: _createParams(visibleRect, layerType, env),
            cancelToken: cancelToken,
          ),
        )
        .map(_makeMarkers)
        .listen(
      (markers) async {
        update(isLoading: false);
        // await mapController.removeAllMarkers();
        if (state.selectedType == LayerType.invest) {
          await map.addMarkers(markers);
        }
      },
    );
  }

  Future<void> _showWhiteLands() async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);
    final mapManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);

    setSelection(selectedType: LayerType.fencing);
    update(
      isLoading: true,
    );

    await _removeAll();

    cancelToken = CancelToken();

    viewPortSubscription = ref
        .watch(dgisControllerProvider.notifier)
        .visibleRectSubject
        .debounceTime(const Duration(milliseconds: 2500))
        .map((event) => event.visibleRect)
        .asyncMap((visibleRect) => controller.getWhiteLands(
              MapRequestParams(
                  layer: GISMapLayers.BSWhiteParcelS,
                  southWestLongitude: visibleRect.southWestLon,
                  southWestLatitude: visibleRect.southWestLat,
                  northEastLongitude: visibleRect.northEastLon,
                  northEastLatitude: visibleRect.northEastLat,
                  proxy: env.proxy,
                  domain: env.url),
              cancelToken,
            ))
        .map(_makePolygons)
        .listen((polygons) async {
      update(isLoading: false);
      await mapManager.removeAllPolygons();
      if (state.selectedType == LayerType.fencing) {
        await mapManager.addPolygons(polygons);
      }
    });
  }

  Future<void> _showBuildingCompliance() async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);
    final mapObjectManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);

    await _removeAll();

    ///завершаем API запросы
    cancelToken = CancelToken();

    viewPortSubscription = ref
        .watch(dgisControllerProvider.notifier)
        .visibleRectSubject
        .debounceTime(const Duration(milliseconds: 1000))
        .map((event) => event.visibleRect)
        .asyncMap((visibleRect) => controller.buildingComplianceCertificate(
            _createParams(visibleRect, LayerType.buildings, env), cancelToken))
        .listen(
      (polylines) async {
        update(isLoading: false);
        await mapObjectManager.removeAllPolyLines();
        if (state.selectedType == LayerType.buildings) {
          await mapObjectManager
              .addPolyLines(_makePolylineWithPoint(polylines));
        }
      },
    );
  }

  List<Polyline> _makePolylineWithPoint(
    List<BuildingComplianceCertificate>? pointList,
  ) {
    final polylines = <Polyline>[];
    if (pointList != null && pointList.isNotEmpty) {
      for (var element in pointList) {
        var pathsGoogle = element.pathsGoogle;
        if (pathsGoogle != null) {
          for (List<GeoPointMessage> i in pathsGoogle) {
            int id = int.parse(element.id);
            String idPolyline = "${id.toString()}+$i";
            polylines.add(
              Polyline(
                id: idPolyline,
                options: PolylineOptionsMessage(
                    points: i, width: 2, color: 0xff358281),
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
    var markers = response
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
                  icon: MarkerIconMessage(
                    path:
                        "packages/mapness/assets/icons/svg/layers/investment_opportunities.svg",
                    width: 30,
                  ),
                  textStyle: MarkerTextStyleMessage(
                    color: const Color(0xFF1BA136).value,
                    strokeColor: Colors.white.value,
                    strokeWidth: 1,
                    fontSize: 14,
                    fontName: "Frutiger",
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

  List<Polygon> _makePolygons(List<WhiteLands>? list) {
    return list
            ?.map((e) => Polygon(
                id: e.id,
                options: PolygonOptionsMessage(
                    strokeWidth: 2,
                    strokeColor: e.strokeColor,
                    color: e.color,
                    contours: [e.paths]),
                onTap: () => _showEsriCard(e)))
            .toList() ??
        [];
  }

  Future<void> showIwish() async {
    update(
      isLoading: true,
    );
    await _removeAll();
    final markers = await ref.read(iwishMarkersProvider.future);
    await ref
        .read(mapObjectManagerProvider(named: mapLayerName).notifier)
        .addMarkers(markers);
    update(
      isLoading: false,
    );
  }

  void _showEsriCard(PointLayersData e) {
    var goRouter = ref.read(goRouterProvider);
    LayerDetailsRoute.open(goRouter, e);
  }

  Future<void> _removeAll() async {
    final map =
        ref.read(mapObjectManagerProvider(named: mapLayerName).notifier);
    await map.removeAllMarkers();
    await map.removeAllPolygons();
    await map.removeAllPolyLines();
  }
}
