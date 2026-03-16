import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/makkah_buses/makkah_buses_model.dart';
import 'package:mapness/features/makkah_buses/makkah_buses_layer_repository.dart';
import 'package:mapness/features/makkah_buses/makkah_buses_layer_visible_provider.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'makkah_buses_layer_provider.g.dart';

@riverpod
class MakkahBusesLayer extends _$MakkahBusesLayer {
  final mapOptions = MapObjectManagerSettings.makkahBuses();

  // Performances improvements, we don't need to update the map on every zoom change
  int _zoomSegment(int? zoom) => switch (zoom) {
        null => 0,
        >= 18 => 1,
        >= 17 => 2,
        >= 16 => 3,
        >= 14 => 4,
        >= 5 => 5,
        _ => 6,
      };

  @override
  Future<List<MakkahBusesModel>> build() async {
    final makkahBusesLayerJsonDatasource = await ref.watch(makkahBusesLayerRepositoryProvider.future);
    ref.watch(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ));

    final isMakkahBusesShown = ref.read(makkahBusesLayerVisibleProvider);

    if (isMakkahBusesShown) {
      unawaited(showMakkahBuses());
    }

    ref.listen(cameraPositionProvider, (prev, positon) {
      final oldZoomSeg = _zoomSegment(prev?.zoom.ceil());
      final newZoomSeg = _zoomSegment(positon?.zoom.ceil());
      if (oldZoomSeg == newZoomSeg) {
        return;
      }

      final isMakkahBusesShown = ref.read(makkahBusesLayerVisibleProvider);

      if (isMakkahBusesShown) {
        unawaited(showMakkahBuses());
      }
    });

    return makkahBusesLayerJsonDatasource;
  }

  Future<void> showMakkahBuses() async {
    if (state.hasValue == false || state.value == null || state.value?.isEmpty == true) {
      return;
    }

    final makkahBuses = state.value!;

    final mapManager = ref.read(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ).notifier);

    await mapManager.removeAllMarkers();

    final markers = makkahBuses.map((bus) {
      final lat = bus.lat;
      final lon = bus.lon;
      final id = bus.id ?? '$lat,$lon';

      if (lat == null || lon == null) {
        return null;
      }

      return Marker(
        id: 'makkah_bus_$id',
        options: MarkerOptionsMessage(
          position: GeoPointWithElevationMessage(
            latitude: lat,
            longitude: lon,
            elevation: 0.0,
          ),
          icon: Assets.icons.svg.layers.icBusGreen.keyName.markerIcon(),
        ),
      );
    }).nonNulls.toList();

    await mapManager.addMarkers(markers);

    ref.read(makkahBusesLayerRepositoryProvider.notifier).showMakkahBuses();
  }

  Future<void> hideMakkahBuses() async {
    final mapManager = ref.read(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ).notifier);
    await mapManager.removeAllMarkers();

    ref.read(makkahBusesLayerRepositoryProvider.notifier).hideMakkahBuses();
  }

  Future<void> toggleMakkahBuses() async {
    final isMakkahBusesVisible = ref.read(makkahBusesLayerVisibleProvider);
    if (isMakkahBusesVisible) {
      await hideMakkahBuses();
    } else {
      await showMakkahBuses();
    }
  }
}
