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
  final favouritesSettings = MapObjectManagerSettings.favourites();
  final Map<String, ({MapObjectManagerSettings settings, Marker marker})> _hiddenMarkers = {};

  @override
  Marker? build() => null;

  MapObjectManager get mapObjectManager => _managerFor(settings);

  MapObjectManager _managerFor(MapObjectManagerSettings layerSettings) => ref.read(
    mapObjectManagerProvider(
      named: layerSettings.name,
      layerId: layerSettings.layerId,
    ).notifier,
  );

  Future<void> showMarker(Marker marker, {MapObjectManagerSettings? settings, int? objectId}) async {
    _showHiddenMarkersIfPresent();

    final position = LatLng(latitude: marker.options.position.latitude, longitude: marker.options.position.longitude);

    // Hide a duplicate marker for the same place in the search layer and in
    // the favourites layer — otherwise its icon would peek out from under
    // the selection pin drawn below.
    for (final layerSettings in [settings ?? searchSettings, favouritesSettings]) {
      final manager = _managerFor(layerSettings);
      final currentMarker =
          manager.markerByGeoPoint(position) ?? (objectId != null ? manager.markerById(objectId.toString()) : null);
      if (currentMarker != null) {
        _hideMarker(layerSettings, currentMarker);
      }
    }

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.addMarker(marker);
    state = marker;
  }

  Future<void> removeMarker(String id) async {
    _showHiddenMarkersIfPresent();
    await mapObjectManager.removeMarkerById(id);
    state = null;
  }

  Future<void> removeAllMarkers() async {
    await mapObjectManager.removeAllMarkers();
    _showHiddenMarkersIfPresent();
    state = null;
  }

  void _hideMarker(MapObjectManagerSettings layerSettings, Marker marker) {
    _hiddenMarkers[layerSettings.name] = (settings: layerSettings, marker: marker);
    _setMarkerIsVisible(layerSettings, marker, isVisible: false);
  }

  void _showHiddenMarkersIfPresent() {
    if (_hiddenMarkers.isEmpty) {
      return;
    }
    for (final entry in _hiddenMarkers.values) {
      _setMarkerIsVisible(entry.settings, entry.marker, isVisible: true);
    }
    _hiddenMarkers.clear();
  }

  Future<void> _setMarkerIsVisible(
    MapObjectManagerSettings layerSettings,
    Marker marker, {
    required bool isVisible,
  }) async {
    await _managerFor(layerSettings).setMarkerOptions(
      marker.id,
      ChangeMarkerOptionsMessage(isVisible: marker.options.isVisible = isVisible),
    );
  }

  Future<void> clear() async {
    await mapObjectManager.removeAllMarkers();
    _showHiddenMarkersIfPresent();
    state = null;
  }
}
