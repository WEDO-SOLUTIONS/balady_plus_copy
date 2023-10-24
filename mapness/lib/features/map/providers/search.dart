import 'package:dgis_map/library.dart';
import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search.g.dart';

@riverpod
class Search extends _$Search {
  @override
  List<DirectoryObjectMessage> build() {
    ref.onDispose(() {
      removeMarkers();
    });

    print("rebuild suka");

    return [];
  }

  Future<void> search(String query) async {
    final dgisController = ref.watch(dgisControllerProvider);

    final result = await dgisController?.search(
      query,
      sortingType: SortingTypeMessage.byDistance,
    );

    List<Marker> markers = [];
    for (final markerInfo in result?.itemMarkerInfos ?? []) {
      markers.add(
        Marker(
          id: markerInfo?.objectId?.objectId.toString() ?? "invalid",
          options: MarkerOptionsMessage(
            position: markerInfo!.geoPoint,
            icon: MarkerIconMessage(
              path: "packages/mapness/assets/icons/svg/ic_marker.svg",
              width: 24,
            ),
          ),
        ),
      );
    }

    await removeMarkers();
    await dgisController?.addMarkers(markers);

    state =
        result?.firstPage?.items.whereType<DirectoryObjectMessage>().toList() ??
            [];
    print("set state to $state");
    // ref.invalidateSelf();
  }

  Future<void> removeMarkers() async {
    final dgisController = ref.watch(dgisControllerProvider);

    await dgisController?.removeAll();
  }
}
