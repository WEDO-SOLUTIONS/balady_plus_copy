import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as pb;
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_marker.dart';
import 'package:mapness/shared/providers/dgis_network.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_markers.g.dart';

@riverpod
class _IwishMarkers extends _$IwishMarkers {
  static const mapLayerName = 'iwish-markers';
  void refresh() {
    ref.invalidateSelf();
  }

  @override
  Future<List<IwishMarker>> build() async {
    final dio = ref.watch(dGisNetworkProvider);
    final raw = await dio.get('iwish');
    final response = pb.IWishMarkersResponse.fromBuffer(raw.data);

    return response.markers
        .map(
          (e) => IwishMarker(
            id: e.id,
            category: switch (e.category) {
              pb.IWishCategory.IWISH_CATEGORY_JOY_PARKS =>
                IwishCategory.joyParks,
              pb.IWishCategory.IWISH_CATEGORY_UNKNOWN => IwishCategory.unknown,
              _ => IwishCategory.unknown,
            },
            location: GeoPointMessage(
              latitude: e.location.point.latitude,
              longitude: e.location.point.longitude,
            ),
          ),
        )
        .toList();
  }

  Future<void> showMarkersOnMap(BuildContext context) async {
    if (!state.hasValue) return;
    final markers = state.requireValue;
    final controller =
        ref.read(mapObjectManagerProvider(named: mapLayerName).notifier);

    controller.addMarkers(
      markers
          .map(
            (next) => Marker(
              id: next.id,
              options: MarkerOptionsMessage(
                position: GeoPointWithElevationMessage(
                  latitude: next.location.latitude,
                  longitude: next.location.longitude,
                  elevation: 0,
                ),
                icon: MarkerIconMessage(
                  path: "packages/mapness/assets/icons/svg/ic_joy_parks.svg",
                  width: 32,
                ),
              ),
              onTap: () {
                if (!context.mounted) return;
                IwishCardRoute(iwishId: next.id).push(context);
              },
            ),
          )
          .toList(),
    );
  }

  void hideMarkersOnMap() {
    final controller =
        ref.read(mapObjectManagerProvider(named: mapLayerName).notifier);

    controller.removeAllMarkers();
  }

  Future<void> focusMarkersOnMap() async {
    final dgisController = ref.read(dgisControllerProvider);
    if (!state.hasValue) return;

    final cameraPosition = await dgisController?.calcPositionForMarkers(
      state.requireValue.map((e) => e.id).toList(),
      CalcPositionOptionsMessage(),
    );
    if (cameraPosition != null) {
      ref.read(cameraPositionProvider.notifier).animateTo(cameraPosition);
    }
  }
}

final iwishMarkersProvider = _iwishMarkersProvider;
