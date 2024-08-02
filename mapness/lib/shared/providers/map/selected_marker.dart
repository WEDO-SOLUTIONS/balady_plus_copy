import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_marker.g.dart';

// TODO(@alexstrnik): переписать немного
@riverpod
class SelectedMarker extends _$SelectedMarker {
  final settings = MapObjectManagerSettings.selectedMarker();
  final searchSettings = MapObjectManagerSettings.search();
  Marker? _hiddenMarker;

  @override
  Marker? build() => null;

  Future<void> showMarker(Marker marker) async {
    final searchObjectManager = ref.read(
      mapObjectManagerProvider(
        named: searchSettings.name,
        layerId: searchSettings.layerId,
      ).notifier,
    );

    if (_hiddenMarker != null) {
      _showHiddenMarker();
    }

    final position = LatLng(
      latitude: marker.options.position.latitude,
      longitude: marker.options.position.longitude,
    );
    final currentSearchMarker = searchObjectManager.markerByGeoPoint(position);
    if (currentSearchMarker != null) {
      _hiddenMarker = currentSearchMarker;
      unawaited(searchObjectManager.removeMarkerById(currentSearchMarker.id));
    }

    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.addMarker(marker);
    state = marker;
  }

  Future<void> removeMarker(String id) async {
    final read = ref.read(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );
    _showHiddenMarker();
    unawaited(read.removeMarkerById(id));
    state = null;
  }

  Future<void> removeAllMarkers() async {
    final read = ref.read(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );
    await read.removeAllMarkers();
    _showHiddenMarker();
    state = null;
  }

  void _showHiddenMarker() {
    if (_hiddenMarker != null) {
      ref
          .read(
            mapObjectManagerProvider(
              named: searchSettings.name,
              layerId: searchSettings.layerId,
            ).notifier,
          )
          .addMarker(_hiddenMarker!);
      _hiddenMarker = null;
    }
  }
}
