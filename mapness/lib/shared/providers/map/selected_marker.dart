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

  Future<void> showMarker(
    Marker marker, {
    MapObjectManagerSettings? settings,
    int? objectId,
    String? favouriteMarkerId,
  }) async {
    await _showHiddenMarkersIfPresent();

    final position = LatLng(latitude: marker.options.position.latitude, longitude: marker.options.position.longitude);

    // Hide a duplicate marker for the same place in the search layer and in
    // the favourites layer — otherwise its icon would peek out from under
    // the selection pin drawn below. The favourites layer uses its own id
    // format (see constructFavoriteListPlaceMarker), so it can't be matched
    // via the raw DGIS objectId like the search layer can.
    for (final layerSettings in [settings ?? searchSettings, favouritesSettings]) {
      final manager = _managerFor(layerSettings);
      final idToMatch = layerSettings.name == favouritesSettings.name ? favouriteMarkerId : objectId?.toString();
      final currentMarker =
          manager.markerByGeoPoint(position) ?? (idToMatch != null ? manager.markerById(idToMatch) : null);
      if (currentMarker != null) {
        await _hideMarker(layerSettings, currentMarker);
      }
    }

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.addMarker(marker);
    state = marker;
  }

  Future<void> removeMarker(String id) async {
    await _showHiddenMarkersIfPresent();
    await mapObjectManager.removeMarkerById(id);
    state = null;
  }

  Future<void> removeAllMarkers() async {
    await mapObjectManager.removeAllMarkers();
    await _showHiddenMarkersIfPresent();
    state = null;
  }

  Future<void> _hideMarker(MapObjectManagerSettings layerSettings, Marker marker) async {
    _hiddenMarkers[layerSettings.name] = (settings: layerSettings, marker: marker);
    // A plain isVisible=false mutation isn't reliably reflected back by the native map SDK when
    // restored later — actually remove/re-add the marker instead, which is a proven path.
    await _managerFor(layerSettings).removeMarkerById(marker.id);
  }

  Future<void> _showHiddenMarkersIfPresent() async {
    if (_hiddenMarkers.isEmpty) {
      return;
    }
    final entries = _hiddenMarkers.values.toList();
    _hiddenMarkers.clear();
    for (final entry in entries) {
      await _managerFor(entry.settings).addMarker(entry.marker);
    }
  }

  Future<void> clear() async {
    await mapObjectManager.removeAllMarkers();
    await _showHiddenMarkersIfPresent();
    state = null;
  }
}
