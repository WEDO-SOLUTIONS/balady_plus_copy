import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/makkah_buses/makkah_buses_model.dart';
import 'package:mapness/features/haram_shuttle/haram_shuttle_layer_repository.dart';
import 'package:mapness/features/haram_shuttle/haram_shuttle_layer_visible_provider.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'haram_shuttle_layer_provider.g.dart';

@riverpod
class HaramShuttleLayer extends _$HaramShuttleLayer {
  final mapOptions = MapObjectManagerSettings.haramShuttle();

  bool _isDisposed = false;

  @override
  Future<List<MakkahBusesModel>> build() async {
    _isDisposed = false;
    ref
      ..onDispose(() => _isDisposed = true)
      // Watch synchronous or separate providers before any async gap
      ..watch(
        mapObjectManagerProvider(
          named: mapOptions.name,
          layerId: mapOptions.layerId,
        ),
      );

    final haramShuttleLayerJsonDatasource = await ref.watch(haramShuttleLayerRepositoryProvider.future);
    if (_isDisposed) return haramShuttleLayerJsonDatasource;

    bool isDrawn = false;

    ref.listen(cameraPositionProvider, (prev, positon) {
      if (_isDisposed) return;
      final isShown = ref.read(haramShuttleLayerVisibleProvider);
      if (isShown && !isDrawn) {
        isDrawn = true;
        unawaited(showHaramShuttle());
      } else if (!isShown && isDrawn) {
        isDrawn = false;
        unawaited(hideHaramShuttle());
      }
    });

    ref.listen(haramShuttleLayerVisibleProvider, (prev, isShown) {
      if (_isDisposed) return;
      if (isShown && !isDrawn) {
        isDrawn = true;
        unawaited(showHaramShuttle());
      } else if (!isShown && isDrawn) {
        isDrawn = false;
        unawaited(hideHaramShuttle());
      }
    });

    final isHaramShuttleShown = ref.read(haramShuttleLayerVisibleProvider);
    if (isHaramShuttleShown) {
      isDrawn = true;
      unawaited(showHaramShuttle(data: haramShuttleLayerJsonDatasource));
    }

    return haramShuttleLayerJsonDatasource;
  }

  Future<void> showHaramShuttle({List<MakkahBusesModel>? data}) async {
    final haramShuttleData = data ?? state.value;
    // If data not loaded yet, wait for the repository to provide it
    final List<MakkahBusesModel> haramShuttle = (haramShuttleData == null || haramShuttleData.isEmpty)
        ? await ref.read(haramShuttleLayerRepositoryProvider.future)
        : haramShuttleData;
    if (_isDisposed) return;
    if (haramShuttle.isEmpty) {
      debugPrint('HaramShuttle: No data to show');
      return;
    }
    debugPrint('HaramShuttle: Showing ${haramShuttle.length} routes');

    final mapManagerFuture = ref.read(
      mapObjectManagerProvider(
        named: mapOptions.name,
        layerId: mapOptions.layerId,
      ).future,
    );
    final manager = await mapManagerFuture;
    if (_isDisposed) return;

    final mapManager = ref.read(
      mapObjectManagerProvider(
        named: mapOptions.name,
        layerId: mapOptions.layerId,
      ).notifier,
    );

    await mapManager.removeAllMarkers();
    if (_isDisposed) return;
    await mapManager.removeAllPolyLines();
    if (_isDisposed) return;

    final List<Polyline> polylines = [];

    for (int i = 0; i < haramShuttle.length; i++) {
      final bus = haramShuttle[i];
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

      debugPrint(
        'HaramShuttle: route ${bus.id ?? i} has ${geoPoints.length} points, first=${geoPoints.first.latitude},${geoPoints.first.longitude}',
      );

      polylines.add(
        Polyline(
          id: 'haram_shuttle_${bus.id ?? i}',
          options: PolylineOptionsMessage(
            points: geoPoints,
            width: 8,
            color: 0xFFFF0000, // RED for debugging
            zIndex: 100,
          ),
        ),
      );
    }

    await mapManager.addPolyLines(polylines);
    debugPrint('HaramShuttle: Added ${polylines.length} polylines to map');
    if (_isDisposed) return;
    ref.read(haramShuttleLayerRepositoryProvider.notifier).showHaramShuttle();
  }

  Future<void> hideHaramShuttle() async {
    final mapManager = ref.read(
      mapObjectManagerProvider(
        named: mapOptions.name,
        layerId: mapOptions.layerId,
      ).notifier,
    );
    await mapManager.removeAllMarkers();
    await mapManager.removeAllPolyLines();

    if (_isDisposed) return;
    ref.read(haramShuttleLayerRepositoryProvider.notifier).hideHaramShuttle();
  }

  Future<void> toggleHaramShuttle() async {
    final isHaramShuttleVisible = ref.read(haramShuttleLayerVisibleProvider);
    if (isHaramShuttleVisible) {
      await hideHaramShuttle();
    } else {
      // Set visible flag first so build() will show data when ready
      ref.read(haramShuttleLayerVisibleProvider.notifier).showHaramShuttle();
      await showHaramShuttle();
    }
  }
}
