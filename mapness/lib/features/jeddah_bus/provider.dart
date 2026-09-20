import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/entities/bus/model.dart';
import 'package:mapness/features/jeddah_bus/repo.dart';
import 'package:mapness/features/jeddah_bus/visible_provider.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/map_layer_visibility_sync.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

/// Degrees ~1.1 m: below this, consecutive gist points are near-duplicates
/// that make the 2GIS gradient polyline renderer drop the segment at high zoom.
const jeddahBusMinPointDeltaDegrees = 1e-5;

/// Collapses consecutive points closer than [jeddahBusMinPointDeltaDegrees] in
/// both lat and lon, keeping the first point of each run. Does not affect
/// [BusLine.stations] matching, which uses the untouched coordinates.
List<BusCoordinates> dropNearDuplicatePoints(Iterable<BusCoordinates> coordinates) {
  final result = <BusCoordinates>[];
  for (final c in coordinates) {
    final prev = result.lastOrNull;
    if (prev != null &&
        (prev.latitude - c.latitude).abs() < jeddahBusMinPointDeltaDegrees &&
        (prev.longitude - c.longitude).abs() < jeddahBusMinPointDeltaDegrees) {
      continue;
    }
    result.add(c);
  }
  return result;
}

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

    // Visibility is driven from two independent listeners, and show/hide both
    // clear and repopulate the same object manager - overlapping calls used to
    // leave the layer half-drawn. The sync serialises them and collapses
    // bursts into the last requested state.
    final visibility = MapLayerVisibilitySync(
      apply: ({required visible}) => visible ? show(data: lines) : hide(),
      isDisposed: () => _isDisposed,
      tag: 'jeddahBus.layer',
    );

    ref
      ..listen(cameraPositionProvider, (_, __) => visibility.request(visible: ref.read(jeddahBusLayerVisibleProvider)))
      ..listen(jeddahBusLayerVisibleProvider, (_, isShown) => visibility.request(visible: isShown));

    visibility.request(visible: ref.read(jeddahBusLayerVisibleProvider));

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

    await mapManager.removeAllMarkers();
    await mapManager.removeAllPolyLines();

    final List<Polyline> polylines = [];

    for (int i = 0; i < list.length; i++) {
      final line = list[i];

      final geoPoints = dropNearDuplicatePoints(
        line.polylineCoordinates,
      ).map((c) => GeoPointMessage(latitude: c.latitude, longitude: c.longitude)).toList();

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
