import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_marker.g.dart';

// TODO(@alexstrnik): переписать немного
@riverpod
class SelectedMarker extends _$SelectedMarker {
  final settings = MapObjectManagerSettings.selectedMarker();
  @override
  Marker? build() => null;

  Future<void> showMarker(Marker marker) async {
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
    await read.removeMarkerById(id);
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
    state = null;
  }
}
