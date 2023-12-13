import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as pb;
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_marker.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_markers.g.dart';

const mapLayerName = 'iwish-markers';
const _markerPrefix = 'iwish-marker-';

@riverpod
class _IwishMarkers extends _$IwishMarkers {
  void refresh() {
    ref.invalidateSelf();
  }

  @override
  Future<List<IwishMarker>> build() async {
    final mapObjectManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);
    final dio = ref.watch(dGisNetworkProvider);
    final raw = await dio.get('iwish');
    final response = pb.IWishMarkersResponse.fromBuffer(raw.data);

    final markers = response.markers
        .map(
          (serverMarker) => IwishMarker(
            id: serverMarker.id,
            category: switch (serverMarker.category) {
              pb.IWishCategory.IWISH_CATEGORY_JOY_PARKS =>
                IwishCategory.joyParks,
              pb.IWishCategory.IWISH_CATEGORY_UNKNOWN => IwishCategory.unknown,
              _ => IwishCategory.unknown,
            },
            location: GeoPointMessage(
              latitude: serverMarker.location.point.latitude,
              longitude: serverMarker.location.point.longitude,
            ),
          ),
        )
        .toList();

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.addMarkers(
      markers
          .map(
            (stateMarker) => Marker(
              id: "$_markerPrefix${stateMarker.id}",
              options: MarkerOptionsMessage(
                position: GeoPointWithElevationMessage(
                  latitude: stateMarker.location.latitude,
                  longitude: stateMarker.location.longitude,
                  elevation: 0,
                ),
                icon: MarkerIconMessage(
                  path: "packages/mapness/assets/icons/svg/ic_joy_parks.svg",
                  width: 30,
                ),
                text: "JOY Parks",
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
                IwishCardRoute.open(
                  ref.read(goRouterProvider),
                  stateMarker,
                );
              },
            ),
          )
          .toList(),
    );

    return markers;
  }

  Future<void> removeMarkers() async {
    final mapObjectManager =
        ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);
    await mapObjectManager.removeAllMarkers();
  }

  Future<void> focusMarkersOnMap() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    if (!state.hasValue) return;

    final cameraPosition = await dgisController.calcPositionForMarkers(
      state.requireValue.map((e) => "$_markerPrefix${e.id}").toList(),
      CalcPositionOptionsMessage(),
    );
    ref.read(cameraPositionProvider.notifier).animateTo(cameraPosition);
  }
}

final iwishMarkersProvider = _iwishMarkersProvider;
