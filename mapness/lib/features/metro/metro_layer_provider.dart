import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/metro/metro_line_model.dart';
import 'package:mapness/features/metro/metro_layer_repository.dart';
import 'package:mapness/features/metro/metro_layer_visible_provider.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metro_layer_provider.g.dart';

@riverpod
class MetroLayer extends _$MetroLayer {
  final mapOptions = MapObjectManagerSettings.metro();

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

  bool _disposed = false;
  Future<void>? _showInFlight;

  @override
  Future<List<MetroLineModel>> build() async {
    ref
      ..onDispose(() => _disposed = true)
      ..watch(darkModeProvider)
      // .notifier: keep the manager alive by identity without rebuilding on
      // its loading/data churn (watching the AsyncValue was the feedback edge
      // of the cycle).
      ..watch(
        mapObjectManagerProvider(
          named: mapOptions.name,
          layerId: mapOptions.layerId,
        ).notifier,
      )
      ..listen(cameraPositionProvider, (prev, positon) {
        final oldZoomSeg = _zoomSegment(prev?.zoom.ceil());
        final newZoomSeg = _zoomSegment(positon?.zoom.ceil());
        if (oldZoomSeg == newZoomSeg) {
          return;
        }

        final isMetroShown = ref.read(metroLayerVisibleProvider);

        if (isMetroShown) {
          unawaited(showMetro());
        }
      });

    final metroLayerJsonDatasource = await ref.watch(metroLayerRepositoryProvider.future);

    final isMetroShown = ref.read(metroLayerVisibleProvider);

    if (isMetroShown) {
      unawaited(showMetro());
    }

    return metroLayerJsonDatasource;
  }

  /// Coalesces concurrent callers: build, the camera listener and the layer
  /// switcher can all ask at once, and 7 sequential awaits x N overlapping
  /// runs is what turned one manager dispose into thousands of events.
  Future<void> showMetro() {
    final inFlight = _showInFlight;
    if (inFlight != null) {
      return inFlight;
    }
    final run = _showMetro().whenComplete(() => _showInFlight = null);
    _showInFlight = run;
    return run;
  }

  Future<void> _showMetro() async {
    if (_disposed || state.hasValue == false || state.value == null || state.value?.isEmpty == true) {
      return;
    }

    final zoom = ref.read(cameraPositionProvider)?.zoom.ceil();

    final metroLines = state.value!;

    final mapManager = ref.read(
      mapObjectManagerProvider(
        named: mapOptions.name,
        layerId: mapOptions.layerId,
      ).notifier,
    );
    final darkMode = await ref.read(darkModeProvider.future);
    final isDarkMode = darkMode.isDark;
    if (_disposed) {
      return;
    }

    await mapManager.removeAllPolyLines();

    for (int i = 0; i < metroLines.length; i++) {
      if (_disposed) {
        return;
      }
      final line = metroLines[i];
      final points = line.points;
      final color = line.color;

      final lineColor = switch (color) {
        'red' => Colors.red,
        'green' => Colors.green,
        'blue' => Colors.blue,
        'yellow' => const Color(0xFFD5CD3E),
        'purple' => Colors.purple,
        'orange' => const Color(0xFFC76B27),
        _ => Colors.black,
      };

      //TODO: remove this when we have real data
      /// We need to move the lines a bit to avoid overlapping
      final delta = (color != 'yellow')
          ? 0
          : switch (zoom) {
              null => 0,
              >= 18 => 0,
              >= 17 => -0.00010,
              >= 16 => -0.00055,
              >= 14 => -0.00080,
              >= 5 => -0.00205,
              _ => 0,
            };

      if (points == null || points.isEmpty) {
        continue;
      }
      final geoPoints = points
          .map((e) {
            final lat = e.lat;
            final lon = e.lon;

            if (lat == null || lon == null) {
              return null;
            }

            return GeoPointMessage(latitude: lat, longitude: lon + delta);
          })
          .nonNulls
          .toList();

      await mapManager.addPolyLines([
        Polyline(
          id: 'metro_line_${i + 1}',
          options: PolylineOptionsMessage(
            points: geoPoints,
            width: 5,
            color: lineColor.value,
            borderWidth: 2,
            zIndex: color == 'purple' ? 1 : 0,
            borderColor: (isDarkMode ? const Color(0xFF262E3B) : Colors.white).value,
          ),
        ),
      ]);
    }

    if (_disposed) {
      return;
    }
    ref.read(metroLayerRepositoryProvider.notifier).showMetro();
  }

  Future<void> hideMetro() async {
    final mapManager = ref.read(
      mapObjectManagerProvider(
        named: mapOptions.name,
        layerId: mapOptions.layerId,
      ).notifier,
    );
    await mapManager.removeAllPolyLines();

    ref.read(metroLayerRepositoryProvider.notifier).hideMetro();
  }

  Future<void> toggleMetro() async {
    final isMetroVisible = ref.read(metroLayerVisibleProvider);
    if (isMetroVisible) {
      await hideMetro();
    } else {
      await showMetro();
    }
  }
}
