import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/makkah_buses/model.dart';
import 'package:mapness/shared/providers/dark_mode.dart' show darkModeProvider;
import 'repo.dart';
import 'visible_provider.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/map_layer_visibility_sync.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class ShuttleBusLayer extends _$ShuttleBusLayer {
  final mapOptions = MapObjectManagerSettings.shuttleBus();

  bool _isDisposed = false;

  @override
  Future<List<MakkahBusModel>> build() async {
    _isDisposed = false;
    ref
      ..onDispose(() => _isDisposed = true)
      ..watch(
        mapObjectManagerProvider(
          named: mapOptions.name,
          layerId: mapOptions.layerId,
        ),
      );

    final list = await ref.watch(shuttleBusLayerRepoProvider.future);
    if (_isDisposed) {
      return list;
    }

    // Visibility is driven from two independent listeners, and show/hide both
    // clear and repopulate the same object manager - overlapping calls used to
    // leave the layer half-drawn. The sync serialises them and collapses
    // bursts into the last requested state.
    final visibility = MapLayerVisibilitySync(
      apply: ({required visible}) => visible ? show(data: list) : hide(),
      isDisposed: () => _isDisposed,
      tag: 'shuttleBus.layer',
    );

    ref
      ..listen(cameraPositionProvider, (_, __) => visibility.request(visible: ref.read(shuttleBusLayerVisibleProvider)))
      ..listen(shuttleBusLayerVisibleProvider, (_, isShown) => visibility.request(visible: isShown));

    visibility.request(visible: ref.read(shuttleBusLayerVisibleProvider));

    return list;
  }

  Future<void> show({List<MakkahBusModel>? data}) async {
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
    if (_isDisposed) {
      return;
    }
    final isDarkMode = darkMode.isDark;
    await mapManager.removeAllMarkers();
    await mapManager.removeAllPolyLines();

    final List<Polyline> polylines = [];

    for (int i = 0; i < list.length; i++) {
      final bus = list[i];
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
          id: 'shuttle_bus_${bus.id ?? i}',
          options: PolylineOptionsMessage(
            points: geoPoints,
            width: 5,
            color: colorValue,
            zIndex: 0,
            borderWidth: 2,
            borderColor: (isDarkMode ? const Color(0xFF262E3B) : Colors.white).value,
          ),
        ),
      );
    }

    await mapManager.addPolyLines(polylines);
    ref.read(shuttleBusLayerRepoProvider.notifier).show();
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
    ref.read(shuttleBusLayerRepoProvider.notifier).hide();
  }

  Future<void> toggle() async {
    final isVisible = ref.read(shuttleBusLayerVisibleProvider);
    if (isVisible) {
      await hide();
    } else {
      await show();
    }
  }
}
