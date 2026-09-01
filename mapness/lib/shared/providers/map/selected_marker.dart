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

  MapObjectManager get mapObjectManager => ref.read(
    mapObjectManagerProvider(
      named: settings.name,
      layerId: settings.layerId,
    ).notifier,
  );

  Future<void> showMarker(Marker marker, {MapObjectManagerSettings? settings, int? objectId}) async {
    final searchObjectManager = ref.read(
      mapObjectManagerProvider(
        named: settings?.name ?? searchSettings.name,
        layerId: settings?.layerId ?? searchSettings.layerId,
      ).notifier,
    );

    _showHiddenMarkerIfPresent();

    final position = LatLng(latitude: marker.options.position.latitude, longitude: marker.options.position.longitude);
    final currentSearchMarker =
        searchObjectManager.markerByGeoPoint(position) ??
        (objectId != null ? searchObjectManager.markerById(objectId.toString()) : null);
    if (currentSearchMarker != null) {
      _hideMarker(currentSearchMarker);
    }

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.removeAllModels();
    await mapObjectManager.addMarker(marker);
    state = marker;
  }

  Future<void> removeMarker(String id) async {
    _showHiddenMarkerIfPresent();
    await mapObjectManager.removeMarkerById(id);
    await mapObjectManager.removeAllModels();
    state = null;
  }

  Future<void> removeAllMarkers() async {
    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.removeAllModels();
    _showHiddenMarkerIfPresent();
    state = null;
  }

  void _hideMarker(Marker marker) {
    _hiddenMarker = marker;
    _setMarkerIsVisible(marker, isVisible: false);
  }

  void _showHiddenMarkerIfPresent() {
    final marker = _hiddenMarker;
    if (marker != null) {
      _setMarkerIsVisible(marker, isVisible: true);
      _hiddenMarker = null;
    }
  }

  Future<void> _setMarkerIsVisible(Marker marker, {required bool isVisible}) async {
    await mapObjectManager.setMarkerOptions(
      marker.id,
      ChangeMarkerOptionsMessage(isVisible: marker.options.isVisible = isVisible),
    );
  }

  Future<void> clear() async {
    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.removeAllModels();
    _showHiddenMarkerIfPresent();
    state = null;
  }
}
