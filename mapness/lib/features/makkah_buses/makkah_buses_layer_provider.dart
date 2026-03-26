import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/makkah_buses/makkah_buses_model.dart';
import 'package:mapness/features/makkah_buses/makkah_buses_layer_repository.dart';
import 'package:mapness/features/makkah_buses/makkah_buses_layer_visible_provider.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../lifestyle_layers/configs/layers_consts.dart';

part 'makkah_buses_layer_provider.g.dart';

@riverpod
class MakkahBusesLayer extends _$MakkahBusesLayer {
  final mapOptions = MapObjectManagerSettings.makkahBuses();

  bool _isDisposed = false;

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
    _isDisposed = false;
    ref..onDispose(() => _isDisposed = true)
    // Watch synchronous or separate providers before any async gap
    ..watch(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ));

    final makkahBusesLayerJsonDatasource = await ref.watch(makkahBusesLayerRepositoryProvider.future);
    if (_isDisposed) return makkahBusesLayerJsonDatasource;

    final isMakkahBusesShown = ref.read(makkahBusesLayerVisibleProvider);
    if (isMakkahBusesShown) {
      unawaited(showMakkahBuses());
    }

    ref.listen(cameraPositionProvider, (prev, positon) {
      if (_isDisposed) return;
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
    if (!state.hasValue || state.value == null || state.value!.isEmpty) {
      return;
    }

    final makkahBuses = state.value!;
    final mapManager = ref.read(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ).notifier);

    await mapManager.removeAllMarkers();
    await mapManager.removeAllPolyLines();

    final List<Polyline> polylines = [];

    for (int i = 0; i < makkahBuses.length; i++) {
      final bus = makkahBuses[i];
      final coordinates = bus.coordinates;
      final colorCode = bus.colorCode;

      if (coordinates == null || coordinates.isEmpty) {
        continue;
      }

      int colorValue = 0xFF000000;
      if (colorCode != null && colorCode.isNotEmpty) {
        try {
          colorValue = int.parse(colorCode.replaceAll('#', '0xFF'));
        } catch (e) {
          colorValue = 0xFF000000;
        }
      }

      final geoPoints = coordinates.map((coord) {
        final lon = coord[0];
        final lat = coord[1];
        return GeoPointMessage(latitude: lat, longitude: lon);
      }).toList();

      polylines.add(
        Polyline(
          id: 'makkah_bus_${bus.id ?? i}',
          options: PolylineOptionsMessage(
            points: geoPoints,
            width: 5,
            color: colorValue,
            borderWidth: 2,
            zIndex: 0,
            borderColor: 0xFFFFFFFF,
          ),
        ),
      );
    }

    await mapManager.addPolyLines(polylines);
    ref.read(makkahBusesLayerRepositoryProvider.notifier).showMakkahBuses();
  }

  Future<void> hideMakkahBuses() async {
    final mapManager = ref.read(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ).notifier);
    await mapManager.removeAllMarkers();
    await mapManager.removeAllPolyLines();

    if (_isDisposed) return;
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
