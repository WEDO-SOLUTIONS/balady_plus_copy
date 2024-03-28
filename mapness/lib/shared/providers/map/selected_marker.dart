import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_marker.g.dart';

const selectedMarkerManagerId = 'selected-marker';
const _layerId = '977194';

// TODO(@alexstrnik): переписать немного
@riverpod
class SelectedMarker extends _$SelectedMarker {
  @override
  Marker? build() => null;

  Future<void> showMarker(Marker marker) async {
    final mapObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: selectedMarkerManagerId,
        layerId: _layerId,
      ).notifier,
    );
    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.addMarker(marker);
    state = marker;
  }

  Future<void> removeMarker(String id) async {
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: selectedMarkerManagerId,
        layerId: _layerId,
      ).notifier,
    );
    await mapObjectManager.removeMarkerById(id);
    state = null;
  }

  Future<void> removeAllMarkers() async {
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: selectedMarkerManagerId,
        layerId: _layerId,
      ).notifier,
    );
    await mapObjectManager.removeAllMarkers();
    state = null;
  }
}
