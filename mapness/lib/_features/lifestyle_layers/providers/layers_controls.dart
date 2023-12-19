import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_repository.dart';
import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';
import 'package:mapness/_features/lifestyle_layers/domain/investment_sites.dart';
import 'package:mapness/_features/lifestyle_layers/domain/map_requests_params.dart';
import 'package:mapness/_features/lifestyle_layers/domain/white_lands.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as pb;

import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/layer_details.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
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

  // WhiteLands? whiteLands;

  LayersState({
    required this.isLoading,
    required this.layersVisible,
    this.whiteLands,
    required this.selectedType,
    // this.whiteLands,
    this.selectedType,
    this.investmentsMarkers,
  });
}

@riverpod
class LayersControls extends _$LayersControls {
  final visibleRectSub = BehaviorSubject<VisibleRectEvent>();
  StreamSubscription? viewPortSubscription;
  List<Marker> allMarkers = [];

  @override
  LayersState build() {
    final dgisController = ref.watch(dgisControllerProvider.notifier);
    var listen = dgisController.visibleRectEvents
        .listen((event) => visibleRectSub.add(event));

    ref.onDispose(() {
      state = LayersState(
        layersVisible: false,
        selectedType: {},
        isLoading: false,
      );
      listen.cancel();
      viewPortSubscription?.cancel();
    });

    return LayersState(
      layersVisible: false,
      selectedType: {},
      isLoading: false,
    );
  }

  Future<void> showInvestmentOpportunities(
    WidgetRef ref,
    LayerType layerType,
  ) async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);

    var layersControls = ref.watch(layersControlsProvider.notifier);
    layersControls.update(
        isLoading: true,
        selectedType: state.selectedType.contains(layerType)
            ? {...state.selectedType.whereNot((e) => e == layerType)}
            : {...state.selectedType, layerType});
    final mapObjectManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);

    viewPortSubscription?.cancel();
    var currentState = state.selectedType;
    await removeAll();
    allMarkers.clear();
    if (currentState == LayerType.invest) {
      setSelected(null);
    } else {
      setSelected(LayerType.invest);

      layersControls.update(
        isLoading: true,
        selectedType: layerType,
      );

      viewPortSubscription = layersControls.visibleRectSub
          .debounceTime(const Duration(seconds: 1))
          .listen((value) async {
        final visibleRect = value.visibleRect;

        final requestParams = MapRequestParams(
          layer: GISMapLayers.Opportunities,
          southWestLongitude: visibleRect.southWestLon,
          southWestLatitude: visibleRect.southWestLat,
          northEastLongitude: visibleRect.northEastLon,
          northEastLatitude: visibleRect.northEastLat,
          domain: env.url,
          proxy: env.proxy,
        );
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
            .getEsriPoints(params: requestParams)
            .onError((error, stackTrace) {
          debugPrint("$stackTrace");
          layersControls.update(isLoading: false);
          return null;
        }).timeout(const Duration(minutes: 1), onTimeout: () {
          layersControls.update(isLoading: false);
          return null;
        });

        List<Marker> markers = createMarkers(response, layerType);

        layersControls.update(
          isLoading: false,
          investmentsMarkers: markers,
        );
        if (markers.isNotEmpty) {
          for (var newMarker in allMarkers) {
            markers.removeWhere((element) => element.id == newMarker.id);
          }
          // await removeAll();
          await mapObjectManager.addMarkers(markers);
          allMarkers.addAll(markers);
        }
      });
    }
  }

  List<Marker> createMarkers(
      List<InvestmentSites>? response, LayerType layerType) {
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
                onTap: () => showEsriCard(e),
              ),
            )
            .toList() ??
        [];
    return markers;
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
    var currentState = state.selectedType;

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
    viewPortSubscription?.cancel();
    if (currentState == LayerType.fencing) {
      await removeAll();
      setSelected(null);
    } else {
      setSelected(LayerType.fencing);

      viewPortSubscription = ref
          .watch(layersControlsProvider.notifier)
          .visibleRectSub
          .debounceTime(const Duration(seconds: 1))
          .map((event) => event.visibleRect)
          .listen((visibleRect) async {
        layersControls.update(
          isLoading: true,
          selectedType: layerType,
        );
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
            .onError((error, stackTrace) {
          debugPrint("$stackTrace");
          layersControls.update(isLoading: false);
          return null;
        }).timeout(const Duration(minutes: 1), onTimeout: () {
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
                  onTap: () => showEsriCard(e));
            }).toList() ??
            [];

        layersControls.update(isLoading: false);
        await removeAll();
        await mapManager.addPolygons(list);
      });
    }
  }

  Future<void> buildingCompliance(WidgetRef ref, LayerType layerType) async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    var currentState = state.selectedType;
    final env = await ref.read(dgisEnvironmentProvider.future);
    final mapObjectManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);
    var layersControls = ref.watch(layersControlsProvider.notifier);

    viewPortSubscription?.cancel();
    if (currentState == LayerType.buildings) {
      await removeAll();
      setSelected(null);
    } else {
      setSelected(LayerType.buildings);

      viewPortSubscription = ref
          .watch(layersControlsProvider.notifier)
          .visibleRectSub
          .debounceTime(const Duration(seconds: 1))
          .listen((value) async {
        var visibleRect = value.visibleRect;

    var layersControls = ref.watch(layersControlsProvider.notifier);
    layersControls.update(
      isLoading: true,
      selectedType: {...state.selectedType, layerType},
    );

        var mapRequestParams = MapRequestParams(
          layer: GISMapLayers.BSAimtithalBuildingsCertificateL,
          southWestLongitude: visibleRect.southWestLon,
          southWestLatitude: visibleRect.southWestLat,
          northEastLongitude: visibleRect.northEastLon,
          northEastLatitude: visibleRect.northEastLat,
          proxy: env.proxy,
          domain: env.url,
        );
        final response = await controller
            .buildingComplianceCertificate(mapRequestParams)
            .onError((error, stackTrace) {
          debugPrint("$stackTrace");
          layersControls.update(isLoading: false);
          return null;
        }).timeout(const Duration(minutes: 1), onTimeout: () {
          layersControls.update(
            isLoading: false,
          );
          return null;
        });

        layersControls.update(isLoading: false);
        await removeAll();
        await mapObjectManager.addPolyLines(
            addPolylineWithPoint(response, mapRequestParams.layer.layerId));
      });
    }
  }

  List<Polyline> addPolylineWithPoint(
      List<BuildingComplianceCertificate>? pointList, int layerId) {
    final List<Polyline> polylines = [];
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
                onTap: () {
                  showEsriCard(element);
                },
              ),
            );
          }
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
    // WhiteLands? whiteLands,
  }) {
    state = LayersState(
      // whiteLands: whiteLands,
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
      // whiteLands: state.whiteLands,
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
        layersControls.showInvestmentOpportunities(ref, value);
        layersControls.showMarkers(ref, value);
      case LayerType.buildings:
        layersControls.buildingCompliance(ref, value);
        if (!currentState.contains(LayerType.buildings)) {
          layersControls.buildingCompliance(ref, value);
        }

      case LayerType.fencing:
        layersControls.getLandFences(ref, value);
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

  void showEsriCard(PointLayersData e) {
    // update(whiteLands: e);
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
