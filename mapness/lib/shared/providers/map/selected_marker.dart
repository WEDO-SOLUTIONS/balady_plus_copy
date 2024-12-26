import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/extensions/change_marker_options_ext.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
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

    final position = LatLng(
      latitude: marker.options.position.latitude,
      longitude: marker.options.position.longitude,
    );

    final currentSearchMarker = searchObjectManager.markerByGeoPoint(position);

    if (currentSearchMarker != null) {
      _hiddenMarker = currentSearchMarker;
      marker.options.icon?.svgPath = currentSearchMarker.options.icon?.svgPath?.bigIconPath;

      final options = currentSearchMarker.options.copyWith(isVisible: false);
      unawaited(searchObjectManager.setMarkerOptions(currentSearchMarker.id, options));
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
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );

    if (_hiddenMarker != null) {
      final searchObjectManager = ref.read(
        mapObjectManagerProvider(
          named: searchSettings.name,
          layerId: searchSettings.layerId,
        ).notifier,
      );

      final options = _hiddenMarker!.options.copyWith(isVisible: true);
      unawaited(searchObjectManager.setMarkerOptions(_hiddenMarker!.id, options));
      _hiddenMarker = null;
    }

    unawaited(mapObjectManager.removeMarkerById(id));
    state = null;
  }

  Future<void> removeAllMarkers() async {
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );

    await mapObjectManager.removeAllMarkers();
    state = null;
  }
}
