import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_repository.dart';
import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';
import 'package:mapness/_features/lifestyle_layers/domain/esri_feature.dart';
import 'package:mapness/_features/lifestyle_layers/domain/map_requests_params.dart';
import 'package:mapness/_features/lifestyle_layers/domain/white_lands.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/layer_details.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'layers_controls.g.dart';

const mapLayerName = 'esri_markers';
const iwishLayerName = 'iwish_markers';
const _markerPrefix = 'esri_markers-';

enum LayerType { favourites, invest, buildings, fencing, joy }

extension LayerTypeExt on LayerType {
  String esriLayerId() {
    return switch (this) {
      LayerType.favourites => '',
      LayerType.invest => '2',
      LayerType.buildings => '7',
      LayerType.fencing => '8',
      LayerType.joy => '',
    };
  }

  String iconPath() {
    return switch (this) {
      LayerType.favourites => "assets/icons/svg/layers/bookmark.svg",
      LayerType.invest => "assets/icons/svg/layers/Invest.svg",
      LayerType.buildings => "assets/icons/svg/layers/buildings.svg",
      LayerType.fencing => "assets/icons/svg/layers/fence.svg",
      LayerType.joy => "assets/icons/svg/layers/joy.svg",
    };
  }

  String title(AppLocalizations l10n) {
    return switch (this) {
      LayerType.favourites => l10n.favourites,
      LayerType.invest => l10n.investmentOpportunities,
      LayerType.buildings => l10n.compilanceBuildings,
      LayerType.fencing => l10n.fencingVacantLands,
      LayerType.joy => l10n.joyParks,
    };
  }
}

class LayersState {
  final bool layersVisible;
  final Set<LayerType> selectedType;
  final bool isLoading;

  List<Marker>? investmentsMarkers;

  WhiteLands? whiteLands;

  LayersState({
    required this.isLoading,
    required this.layersVisible,
    this.whiteLands,
    required this.selectedType,
    this.investmentsMarkers,
  });
}

@riverpod
class LayersControls extends _$LayersControls {
  final visibleRectSub = BehaviorSubject<VisibleRectEvent>();

  @override
  LayersState build() {
    final dgisController = ref.watch(dgisControllerProvider).value;

    var listen = dgisController?.visibleRectEvents
        .listen((event) => visibleRectSub.add(event));

    ref.onDispose(() {
      state = LayersState(
        layersVisible: false,
        selectedType: {},
        isLoading: false,
      );
      listen?.cancel();
    });

    return LayersState(
      layersVisible: false,
      selectedType: {},
      isLoading: false,
    );
  }

  Future<void> showMarkers(WidgetRef ref, LayerType layerType) async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);

    var layersControls = ref.watch(layersControlsProvider.notifier);
    layersControls.update(
        isLoading: true,
        selectedType: state.selectedType.contains(layerType)
            ? {...state.selectedType.whereNot((e) => e == layerType)}
            : {...state.selectedType, layerType});

    final visibleRect = layersControls.visibleRectSub.value.visibleRect;

    final mapObjectManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);
    ref.watch(iwishMarkersProvider);

    var requestParams = MapRequestParams(
      layer: GISMapLayers.Opportunities,
      southWestLongitude: visibleRect.southWestLon,
      southWestLatitude: visibleRect.southWestLat,
      northEastLongitude: visibleRect.northEastLon,
      northEastLatitude: visibleRect.northEastLat,
      domain: env.url,
      proxy: env.proxy,
    );

    final response = await controller
        .getEsriPoints(
      params: requestParams,
    )
        .timeout(const Duration(minutes: 1), onTimeout: () {
      layersControls.update(
        isLoading: false,
      );
      return null;
    });

    var markers = response
            ?.whereNotNull()
            .map<Marker>(
              (e) => Marker(
                id: e.objectId,
                options: MarkerOptionsMessage(
                  position: GeoPointWithElevationMessage(
                    latitude: e.point.latitude,
                    longitude: e.point.longitude,
                    elevation: 0,
                  ),
                  icon: MarkerIconMessage(
                    // path: "packages/mapness/assets/icons/svg/ic_joy_parks.svg",
                    path: "packages/mapness/${layerType.iconPath()}",
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
                onTap: () {
                  ///open card for object
                  showMarkerInfo(e);
                },
              ),
            )
            .toList() ??
        [];

    layersControls.update(
      isLoading: false,
      investmentsMarkers: markers,
    );
    await removeAll();
    if (markers.isNotEmpty) {
      await mapObjectManager.addMarkers(markers);
      await ref.read(cameraPositionProvider.notifier).animateToMarkers(markers);
    }
  }

  Future<void> getLandFences(WidgetRef ref, LayerType layerType) async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);
    var layersControls = ref.watch(layersControlsProvider.notifier);
    final mapManager = ref.watch(
      mapObjectManagerProvider(
        named: mapLayerName,
      ).notifier,
    );

    layersControls.update(
      isLoading: true,
      selectedType: {...state.selectedType, layerType},
    );
    final visibleRect = ref
        .watch(layersControlsProvider.notifier)
        .visibleRectSub
        .value
        .visibleRect;

    var mapRequestParams = MapRequestParams(
      layer: GISMapLayers.BSWhiteParcelS,
      southWestLongitude: visibleRect.southWestLon,
      southWestLatitude: visibleRect.southWestLat,
      northEastLongitude: visibleRect.northEastLon,
      northEastLatitude: visibleRect.northEastLat,
      proxy: env.proxy,
      domain: env.url,
    );
    final response = await controller
        .getWhiteLands(mapRequestParams)
        .timeout(const Duration(minutes: 1), onTimeout: () {
      layersControls.update(
        isLoading: false,
      );
      return null;
    });

    var list = response?.map((e) {
          return Polygon(
              id: e.id,
              options: PolygonOptionsMessage(
                  strokeWidth: 2,
                  strokeColor: 0xFF000000,
                  color: 0x26000000,
                  contours: [e.paths]),
              onTap: () {
                ///open card for object
                showWhiteLands(e);
              });
        }).toList() ??
        [];

    layersControls.update(isLoading: false);
    await removeAll();
    await mapManager.addPolygons(list);
    await ref.read(cameraPositionProvider.notifier).animateToPolygons(list);
  }

  Future<void> buildingCompliance(WidgetRef ref, LayerType layerType) async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final visibleRect = ref
        .watch(layersControlsProvider.notifier)
        .visibleRectSub
        .value
        .visibleRect;

    var layersControls = ref.watch(layersControlsProvider.notifier);
    layersControls.update(
      isLoading: true,
      selectedType: {...state.selectedType, layerType},
    );

    final mapObjectManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);

    var layer = GISMapLayers.BSAimtithalBuildingsCertificateL;
    var mapRequestParams = MapRequestParams(
      layer: layer,
      southWestLongitude: visibleRect.southWestLon,
      southWestLatitude: visibleRect.southWestLat,
      northEastLongitude: visibleRect.northEastLon,
      northEastLatitude: visibleRect.northEastLat,
      proxy: env.proxy,
      domain: env.url,
    );
    final response = await controller
        .buildingComplianceCertificate(mapRequestParams)
        .timeout(const Duration(minutes: 1), onTimeout: () {
      layersControls.update(
        isLoading: false,
      );
      return null;
    });

    var polylines = addPolylineWithPoint(response, layer.layerId);
    layersControls.update(isLoading: false);
    await removeAll();
    await mapObjectManager.addPolyLines(polylines);
  }

  List<Polyline> addPolylineWithPoint(List? pointList, int layerId) {
    final List<Polyline> polylines = [];
    if (pointList != null && pointList.isNotEmpty) {
      for (var element in pointList) {
        for (List<GeoPointMessage> i in element.pathsGoogle) {
          int id = int.parse(element.id);
          String idPolyline = "${id.toString()}+${i}";
          polylines.add(
            Polyline(
              id: idPolyline,
              options: PolylineOptionsMessage(
                  points: i, width: 2, color: 0xff358281),
              onTap: () {},
            ),
          );
        }
      }
    }
    return polylines;
  }

  void update({
    bool? visible,
    Set<LayerType>? selectedType,
    bool? isLoading,
    List<Marker>? investmentsMarkers,
    WhiteLands? whiteLands,
  }) {
    state = LayersState(
      whiteLands: whiteLands,
      investmentsMarkers: investmentsMarkers ?? state.investmentsMarkers,
      layersVisible: visible ?? state.layersVisible,
      selectedType: selectedType ?? state.selectedType,
      isLoading: isLoading ?? state.isLoading,
    );
  }

  void _toggleSelected(
    LayerType selectedType,
  ) {
    state = LayersState(
      whiteLands: state.whiteLands,
      investmentsMarkers: state.investmentsMarkers,
      layersVisible: state.layersVisible,
      selectedType: state.selectedType.contains(selectedType)
          ? {...state.selectedType.whereNot((e) => e == selectedType)}
          : {...state.selectedType, selectedType},
      isLoading: state.isLoading,
    );
  }

  Future<void> handleTap(WidgetRef ref, LayerType value) async {
    var layersControls = ref.watch(layersControlsProvider.notifier);
    var currentState = state.selectedType;

    switch (value) {
      case LayerType.favourites:
        if (currentState.contains(LayerType.favourites)) {
          await ref.read(favouriteToggleProvider.notifier).disable();
        } else {
          await ref.read(favouriteToggleProvider.notifier).enable();
        }
      case LayerType.invest:
        layersControls.showMarkers(ref, value);
      case LayerType.buildings:
        if (!currentState.contains(LayerType.buildings)) {
          layersControls.buildingCompliance(ref, value);
        }

      case LayerType.fencing:
        if (currentState.contains(LayerType.fencing)) {
        } else {
          layersControls.getLandFences(ref, value);
        }
      case LayerType.joy:
        if (currentState.contains(LayerType.joy)) {
          ref
              .read(mapObjectManagerProvider(named: iwishLayerName).notifier)
              .removeAllMarkers();
        } else {
          showIwish();
        }
    }
    await removeAll();
    _toggleSelected(value);
  }

  Future<void> showIwish() async {
    final markers = await ref.read(iwishMarkersProvider.future);
    final iwishObjectManager =
        ref.read(mapObjectManagerProvider(named: iwishLayerName).notifier);

    await iwishObjectManager.addMarkers(markers);
  }

  void showWhiteLands(WhiteLands e) {
    update(whiteLands: e);
    ref
        .read(goRouterProvider)
        .push(LayerDetailsRoute().location, extra: {"data": e});
  }

  void showMarkerInfo(EsriPointFeature e) {
    ///NO OP
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

  Future<void> removeAll() async {
    final mapObjectManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.removeAllPolygons();
    await mapObjectManager.removeAllPolyLines();
  }
}
