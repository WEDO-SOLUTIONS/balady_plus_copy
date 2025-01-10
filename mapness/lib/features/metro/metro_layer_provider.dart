import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/metro/metro_line_model.dart';
import 'package:mapness/features/metro/metro_layer_repository.dart';
import 'package:mapness/features/metro/metro_layer_visible_provider.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metro_layer_provider.g.dart';

@riverpod
class MetroLayer extends _$MetroLayer {
  final mapOptions = MapObjectManagerSettings.metro();

  @override
  Future<List<MetroLineModel>> build() async {
    final metroLayerJsonDatasource = await ref.watch(metroLayerRepositoryProvider.future);
    ref
      ..watch(darkModeProvider)
      ..watch(mapObjectManagerProvider(
        named: mapOptions.name,
        layerId: mapOptions.layerId,
      ));

    final isMetroShown = ref.read(metroLayerVisibleProvider);
    if (isMetroShown) {
      unawaited(showMetro());
    }

    return metroLayerJsonDatasource;
  }

  Future<void> showMetro() async {
    if (state.hasValue == false || state.valueOrNull == null || state.valueOrNull?.isEmpty == true) {
      return;
    }

    final metroLines = state.value!;

    final mapManager = ref.read(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ).notifier);
    final darkMode = await ref.read(darkModeProvider.future);
    final isDarkMode = darkMode.isDark;

    await mapManager.removeAllPolyLines();

    for (final line in metroLines) {
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

      if (points == null || points.isEmpty) {
        continue;
      }
      final geoPoints = points.map((e) => GeoPointMessage(latitude: e.lat!, longitude: e.lon!)).toList();

      await mapManager.addPolyLines([
        Polyline(
          id: 'metro_line_${line.hashCode}',
          options: PolylineOptionsMessage(
            points: geoPoints,
            width: 5,
            color: lineColor.value,
            borderWidth: 2,
            borderColor: (isDarkMode ? const Color(0xFF262E3B) : Colors.white).value,
          ),
        ),
      ]);
    }

    ref.read(metroLayerRepositoryProvider.notifier).showMetro();
  }

  Future<void> hideMetro() async {
    final mapManager = ref.read(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ).notifier);
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
