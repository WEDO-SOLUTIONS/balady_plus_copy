import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
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
const iwishLayerName = 'iwish_markers';
const _markerPrefix = 'esri_markers-';

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

  @override
  LayersState build() {
    ref.onDispose(() {
      viewPortSubscription?.cancel();
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
    LayerType? selectedType,
    bool? isLoading,
    List<Marker>? investmentsMarkers,
  }) {
    state = LayersState(
      investmentsMarkers: investmentsMarkers ?? state.investmentsMarkers,
      layersVisible: visible ?? state.layersVisible,
      selectedType: selectedType ?? state.selectedType,
      isLoading: isLoading ?? state.isLoading,
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

  Future<void> handleTap(LayerType value) async {
    var layersControls = ref.watch(layersControlsProvider.notifier);
    var currentState = state.selectedType;

    switch (value) {
      // case LayerType.favourites:
      //   if (currentState == (LayerType.favourites)) {
      //     await ref.read(favouriteToggleProvider.notifier).disable();
      //   } else {
      //     await ref.read(favouriteToggleProvider.notifier).enable();
      //   }
      //   _toggleSelected(value);

      case LayerType.buildings:
        toggleComplienceBuildings();
      case LayerType.invest:
        toggleInvestOpportunities();
      case LayerType.fencing:
        toggleWhiteLands();
      case LayerType.joy:
        toggleIwish(currentState, value);
    }
    state = LayersState(
      investmentsMarkers: state.investmentsMarkers,
      layersVisible: state.layersVisible,
      selectedType: value == state.selectedType ? null : value,
      isLoading: state.isLoading,
    );
  }

  Future<void> toggleIwish(LayerType? currentState, LayerType value) async {
    var layersControls = ref.watch(layersControlsProvider.notifier);
    if (currentState == (LayerType.joy)) {
      await ref
          .read(mapObjectManagerProvider(named: iwishLayerName).notifier)
          .removeAllMarkers();
      layersControls.update(isLoading: false, selectedType: null);
    } else {
      showIwish();
    }
  }

  Future<void> toggleComplienceBuildings() async {
    var layersControls = ref.watch(layersControlsProvider.notifier);
    var currentState = state.selectedType;
    if (currentState != (LayerType.buildings)) {
      layersControls.update(isLoading: true, selectedType: LayerType.buildings);
      layersControls._showBuildingCompliance();
    } else {
      viewPortSubscription?.cancel();
      await _removeAll();
      layersControls.update(isLoading: false, selectedType: null);
    }
  }

  Future<void> _showObjectDetails(PointLayersData layerData) async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);

    var layersControls = ref.watch(layersControlsProvider.notifier);
    var mapController =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);

    update(isLoading: true);

    await layersControls._removeAll();
    await viewPortSubscription?.cancel();
    viewPortSubscription = ref
        .watch(dgisControllerProvider.notifier)
        .visibleRectSubject
        .debounceTime(const Duration(milliseconds: 2500))
        .map((event) => event.visibleRect)
        .asyncMap((visibleRect) => controller.getEsriPoints(
                params: MapRequestParams(
              layer: state.selectedType?.getLayerType(),
              southWestLongitude: visibleRect.southWestLon,
              southWestLatitude: visibleRect.southWestLat,
              northEastLongitude: visibleRect.northEastLon,
              northEastLatitude: visibleRect.northEastLat,
              domain: env.url,
              proxy: env.proxy,
              objectId: int.tryParse(layerData.id) ?? 0,
              pointsDetails: true,
            )))
        .map(_makeMarkers)
        .listen(
      (markers) async {
        layersControls.update(isLoading: false);
        await mapController.addMarkers(markers);
      },
    );
  }

  Future<void> _showInvestmentOpportunities(LayerType layerType) async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);

    var layersControls = ref.watch(layersControlsProvider.notifier);
    var mapController =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);

    update(isLoading: true, selectedType: layerType);

    await layersControls._removeAll();

    await viewPortSubscription?.cancel();
    viewPortSubscription = ref
        .watch(dgisControllerProvider.notifier)
        .visibleRectSubject
        .debounceTime(const Duration(milliseconds: 2500))
        .map((event) => event.visibleRect)
        .asyncMap((visibleRect) => controller.getEsriPoints(
                params: MapRequestParams(
              layer: GISMapLayers.Opportunities,
              southWestLongitude: visibleRect.southWestLon,
              southWestLatitude: visibleRect.southWestLat,
              northEastLongitude: visibleRect.northEastLon,
              northEastLatitude: visibleRect.northEastLat,
              domain: env.url,
              proxy: env.proxy,
            )))
        .map(_makeMarkers)
        .listen(
      (markers) async {
        layersControls.update(isLoading: false);
        await mapController.addMarkers(markers);
      },
    );
  }

  Future<void> _showWhiteLands() async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);
    var layersControls = ref.watch(layersControlsProvider.notifier);
    final mapManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);

    layersControls.update(isLoading: true, selectedType: LayerType.fencing);

    await layersControls._removeAll();
    await viewPortSubscription?.cancel();

    viewPortSubscription = ref
        .watch(dgisControllerProvider.notifier)
        .visibleRectSubject
        .debounceTime(const Duration(milliseconds: 2500))
        .map((event) => event.visibleRect)
        .asyncMap((visibleRect) => controller.getWhiteLands(MapRequestParams(
              layer: GISMapLayers.BSWhiteParcelS,
              southWestLongitude: visibleRect.southWestLon,
              southWestLatitude: visibleRect.southWestLat,
              northEastLongitude: visibleRect.northEastLon,
              northEastLatitude: visibleRect.northEastLat,
              proxy: env.proxy,
              domain: env.url,
            )))
        .map(_makePolygons)
        .listen((polygons) async {
      layersControls.update(isLoading: false);
      await mapManager.addPolygons(polygons);
    });
  }

  Future<void> _showBuildingCompliance() async {
    final layersControls = ref.watch(layersControlsProvider.notifier);
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);
    final mapObjectManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);

    await layersControls._removeAll();
    await viewPortSubscription?.cancel();

    viewPortSubscription = ref
        .watch(dgisControllerProvider.notifier)
        .visibleRectSubject
        .debounceTime(const Duration(milliseconds: 2500))
        .map((event) => event.visibleRect)
        .asyncMap((visibleRect) =>
            controller.buildingComplianceCertificate(MapRequestParams(
              layer: GISMapLayers.BSAimtithalBuildingsCertificateL,
              southWestLongitude: visibleRect.southWestLon,
              southWestLatitude: visibleRect.southWestLat,
              northEastLongitude: visibleRect.northEastLon,
              northEastLatitude: visibleRect.northEastLat,
              proxy: env.proxy,
              domain: env.url,
            )))
        .map(_makePolylineWithPoint)
        .listen((polylines) async {
      layersControls.update(isLoading: false);
      await mapObjectManager.addPolyLines(polylines);
    });
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
            String idPolyline = "${id.toString()}+${i}";
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
                    strokeColor: 0xFF000000,
                    color: 0x26000000,
                    contours: [e.paths]),
                onTap: () => _showEsriCard(e)))
            .toList() ??
        [];
  }

  void _toggleSelected(
    LayerType selectedType,
  ) {
    state = LayersState(
      investmentsMarkers: state.investmentsMarkers,
      layersVisible: state.layersVisible,
      selectedType: selectedType,
      isLoading: state.isLoading,
    );
  }

  Future<void> showIwish() async {
    if (state.selectedType == LayerType.joy) {
      return;
    }
    final markers = await ref.read(iwishMarkersProvider.future);
    await ref
        .read(mapObjectManagerProvider(named: iwishLayerName).notifier)
        .addMarkers(markers);
  }

  void _showEsriCard(PointLayersData e) {
    // _showObjectDetails(e);
    ref
        .read(goRouterProvider)
        .push(LayerDetailsRoute().location, extra: {"data": e});
  }

  Future<void> _removeAll() async {
    final mapObjectManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.removeAllPolygons();
    await mapObjectManager.removeAllPolyLines();
  }

  Future<void> toggleInvestOpportunities() async {
    var layersControls = ref.watch(layersControlsProvider.notifier);
    var currentState = state.selectedType;
    if (currentState != (LayerType.invest)) {
      layersControls._showInvestmentOpportunities(LayerType.invest);
    } else {
      viewPortSubscription?.cancel();
      await _removeAll();
      layersControls.update(isLoading: false, selectedType: null);
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
      layersControls.update(isLoading: false, selectedType: null);
    }
  }
}
