import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/entities/bus/model.dart';
import 'package:mapness/features/jeddah_bus/repo.dart';
import 'package:mapness/features/jeddah_bus/visible_provider.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class JeddahBusLayer extends _$JeddahBusLayer {
  final mapOptions = MapObjectManagerSettings.jeddahBus();

  bool _isDisposed = false;

  @override
  Future<List<BusLine>> build() async {
    _isDisposed = false;
    ref
      ..onDispose(() => _isDisposed = true)
      ..watch(
        mapObjectManagerProvider(
          named: mapOptions.name,
          layerId: mapOptions.layerId,
        ),
      );

    final busModel = await ref.watch(jeddahBusLayerRepoProvider.future);
    final lines = busModel.lines.values.toList();
    if (_isDisposed) {
      return lines;
    }

    bool isDrawn = false;

    ref
      ..listen(cameraPositionProvider, (prev, position) {
        if (_isDisposed) {
          return;
        }
        final isShown = ref.read(jeddahBusLayerVisibleProvider);
        if (isShown && !isDrawn) {
          isDrawn = true;
          unawaited(show());
        } else if (!isShown && isDrawn) {
          isDrawn = false;
          unawaited(hide());
        }
      })
      ..listen(jeddahBusLayerVisibleProvider, (prev, isShown) {
        if (_isDisposed) {
          return;
        }
        if (isShown && !isDrawn) {
          isDrawn = true;
          unawaited(show());
        } else if (!isShown && isDrawn) {
          isDrawn = false;
          unawaited(hide());
        }
      });

    final isShown = ref.read(jeddahBusLayerVisibleProvider);
    if (isShown) {
      isDrawn = true;
      unawaited(show(data: lines));
    }

    return lines;
  }

  Future<void> show({List<BusLine>? data}) async {
    final list = data ?? state.value;
    if (list == null || list.isEmpty) {
      return;
    }
    final mapManager = ref.read(
      mapObjectManagerProvider(
        named: mapOptions.name,
        layerId: mapOptions.layerId,
      ).notifier,
    );

    final darkMode = await ref.read(darkModeProvider.future);
    final isDarkMode = darkMode.isDark;

    await mapManager.removeAllMarkers();
    await mapManager.removeAllPolyLines();

    final List<Polyline> polylines = [];

    for (int i = 0; i < list.length; i++) {
      final line = list[i];

      final geoPoints = line.polylineCoordinates
          .map((c) => GeoPointMessage(latitude: c.latitude, longitude: c.longitude))
          .toList();

      if (geoPoints.isEmpty) {
        continue;
      }

      polylines.add(
        Polyline(
          id: 'jeddah_bus_${line.id.name}_${line.id.direction.name}',
          options: PolylineOptionsMessage(
            points: geoPoints,
            width: 5,
            color: line.color,
            zIndex: i,
          ),
        ),
      );
    }

    await mapManager.addPolyLines(polylines);
    ref.read(jeddahBusLayerRepoProvider.notifier).show();
  }

  Future<void> hide() async {
    final mapManager = ref.read(
      mapObjectManagerProvider(
        named: mapOptions.name,
        layerId: mapOptions.layerId,
      ).notifier,
    );
    await mapManager.removeAllMarkers();
    await mapManager.removeAllPolyLines();

    if (_isDisposed) {
      return;
    }
    ref.read(jeddahBusLayerRepoProvider.notifier).hide();
  }

  Future<void> toggle() async {
    final isVisible = ref.read(jeddahBusLayerVisibleProvider);
    if (isVisible) {
      await hide();
    } else {
      await show();
    }
  }
}
