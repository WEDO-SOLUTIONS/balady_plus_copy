import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/makkah_buses/model.dart';
import 'package:mapness/features/makkah_bus/repo.dart';
import 'package:mapness/features/makkah_bus/visible_provider.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/map_layer_visibility_sync.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../lifestyle_layers/configs/layers_consts.dart';

part 'provider.g.dart';

@riverpod
class MakkahBusLayer extends _$MakkahBusLayer {
  final mapOptions = MapObjectManagerSettings.makkahBus();

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

    final list = await ref.watch(makkahBusLayerRepoProvider.future);
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
      tag: 'makkahBus.layer',
    );

    ref
      ..listen(cameraPositionProvider, (_, __) => visibility.request(visible: ref.read(makkahBusLayerVisibleProvider)))
      ..listen(makkahBusLayerVisibleProvider, (_, isShown) => visibility.request(visible: isShown));

    visibility.request(visible: ref.read(makkahBusLayerVisibleProvider));

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
          id: 'makkah_bus_${bus.id ?? i}',
          options: PolylineOptionsMessage(
            points: geoPoints,
            width: 5,
            // A dark-mode-aware border was sketched here but never enabled. The
            // `darkModeProvider` read that fed it has been dropped, so bringing
            // it back means reading dark mode again:
            //   borderWidth: 0,
            //   borderColor: (isDark ? const Color(0xFF262E3B) : Colors.white).value,
            color: colorValue,
          ),
        ),
      );
    }

    await mapManager.addPolyLines(polylines);
    ref.read(makkahBusLayerRepoProvider.notifier).show();
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
    ref.read(makkahBusLayerRepoProvider.notifier).hide();
  }

  Future<void> toggle() async {
    final isVisible = ref.read(makkahBusLayerVisibleProvider);
    if (isVisible) {
      await hide();
    } else {
      await show();
    }
  }
}
