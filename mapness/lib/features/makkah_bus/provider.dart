import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/makkah_buses/model.dart';
import 'package:mapness/features/makkah_bus/repo.dart';
import 'package:mapness/features/makkah_bus/visible_provider.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
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
    ref..onDispose(() => _isDisposed = true)
    ..watch(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ));

    final list = await ref.watch(makkahBusLayerRepoProvider.future);
    if (_isDisposed) {
      return list;
    }

    bool isDrawn = false;

    ref..listen(cameraPositionProvider, (prev, position) {
      if (_isDisposed) {
        return;
      }
      final isShown = ref.read(makkahBusLayerVisibleProvider);
      if (isShown && !isDrawn) {
        isDrawn = true;
        unawaited(show());
      } else if (!isShown && isDrawn) {
        isDrawn = false;
        unawaited(hide());
      }
    })

    ..listen(makkahBusLayerVisibleProvider, (prev, isShown) {
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

    final isShown = ref.read(makkahBusLayerVisibleProvider);
    if (isShown) {
      isDrawn = true;
      unawaited(show(data: list));
    }

    return list;
  }

  Future<void> show({List<MakkahBusModel>? data}) async {
    final list = data ?? state.value;
    if (list == null || list.isEmpty) {
      return;
    }
    final mapManager = ref.read(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ).notifier);

    final darkMode = await ref.read(darkModeProvider.future);
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
          id: 'makkah_bus_${bus.id ?? i}',
          options: PolylineOptionsMessage(
            points: geoPoints,
            width: 5,
            borderWidth: 2,
            borderColor: (isDarkMode ? const Color(0xFF262E3B) : Colors.white).value,
            color: colorValue,
            zIndex: 0,
          ),
        ),
      );
    }

    await mapManager.addPolyLines(polylines);
    ref.read(makkahBusLayerRepoProvider.notifier).show();
  }

  Future<void> hide() async {
    final mapManager = ref.read(mapObjectManagerProvider(
      named: mapOptions.name,
      layerId: mapOptions.layerId,
    ).notifier);
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
