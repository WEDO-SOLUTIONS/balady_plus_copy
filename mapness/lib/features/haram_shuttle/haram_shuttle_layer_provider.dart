import 'dart:async';

import 'package:dgis_map/library.dart';
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
    final haramShuttle = data ?? state.value;
    if (haramShuttle == null || haramShuttle.isEmpty) {
      return;
    }
    final mapManager = ref.read(
      mapObjectManagerProvider(
        named: mapOptions.name,
        layerId: mapOptions.layerId,
      ).notifier,
    );

    await mapManager.removeAllMarkers();
    await mapManager.removeAllPolyLines();

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

      polylines.add(
        Polyline(
          id: 'haram_shuttle_${bus.id ?? i}',
          options: PolylineOptionsMessage(
            points: geoPoints,
            width: 5,
            color: colorValue,
            zIndex: 0,
          ),
        ),
      );
    }

    await mapManager.addPolyLines(polylines);
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
      await showHaramShuttle();
    }
  }
}
