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

  // Generation guard: for overlapping async requests, only the latest one
  // is allowed to apply its result — see this subtree's own AGENTS.md.
  // Without it, two overlapping `showMarker` calls (e.g. a marker/pin tap
  // fired twice for the same id) both call `removeAllMarkers()` before
  // either reaches `addMarker()`, leaving two native markers behind for the
  // same id — neither removed — so a single physical tap on the resulting
  // (visually coincident) pin fires its `onTap` once per duplicate.
  int _generation = 0;

  @override
  Marker? build() => null;

  MapObjectManager get mapObjectManager => ref.read(
    mapObjectManagerProvider(
      named: settings.name,
      layerId: settings.layerId,
    ).notifier,
  );

  Future<void> showMarker(Marker marker, {MapObjectManagerSettings? settings, int? objectId}) async {
    final generation = ++_generation;
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
    if (generation != _generation) {
      return;
    }
    await mapObjectManager.removeAllModels();
    if (generation != _generation) {
      return;
    }
    await mapObjectManager.addMarker(marker);
    if (generation != _generation) {
      return;
    }
    state = marker;
  }

  Future<void> removeMarker(String id) async {
    final generation = ++_generation;
    _showHiddenMarkerIfPresent();
    await mapObjectManager.removeMarkerById(id);
    if (generation != _generation) {
      return;
    }
    await mapObjectManager.removeAllModels();
    if (generation != _generation) {
      return;
    }
    state = null;
  }

  Future<void> removeAllMarkers() async {
    final generation = ++_generation;
    await mapObjectManager.removeAllMarkers();
    if (generation != _generation) {
      return;
    }
    await mapObjectManager.removeAllModels();
    if (generation != _generation) {
      return;
    }
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
    final generation = ++_generation;
    await mapObjectManager.removeAllMarkers();
    if (generation != _generation) {
      return;
    }
    await mapObjectManager.removeAllModels();
    if (generation != _generation) {
      return;
    }
    _showHiddenMarkerIfPresent();
    state = null;
  }
}
