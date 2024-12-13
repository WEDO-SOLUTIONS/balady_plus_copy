import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/metro/metro_line_model.dart';
import 'package:mapness/features/metro/metro_layer_repository.dart';
import 'package:mapness/features/metro/metro_layer_visible_provider.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metro_layer_provider.g.dart';

@riverpod
class MetroLayer extends _$MetroLayer {
  @override
  Future<List<MetroLineModel>> build() async {
    final metroLayerJsonDatasource = await ref.watch(metroLayerRepositoryProvider.future);

    return metroLayerJsonDatasource;
  }

  Future<void> showMetro() async {
    if (state.hasValue == false || state.valueOrNull == null || state.valueOrNull?.isEmpty == true) {
      return;
    }

    final metroLines = state.value!;

    final mapOptions = MapObjectManagerSettings.esri();
    final mapManager = ref.read(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ).notifier);

    await mapManager.removeAllPolyLines();

    for (final line in metroLines) {
      final points = line.points;
      final color = line.color;

      final lineColor = switch (color) {
        'red' => Colors.red,
        'green' => Colors.green,
        'blue' => Colors.blue,
        'yellow' => Colors.yellow,
        'purple' => Colors.purple,
        'orange' => Colors.orange,
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
          ),
        ),
      ]);
    }

    ref.read(metroLayerRepositoryProvider.notifier).showMetro();
  }

  Future<void> hideMetro() async {
    final mapOptions = MapObjectManagerSettings.esri();
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
