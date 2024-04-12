import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search.g.dart';

@riverpod
class Search extends _$Search {
  PageMessage? _currentPage;

  static const name = 'search';

  @override
  List<DirectoryObjectMessage> build() {
    ref.onDispose(_dispose);

    return [];
  }

  Future<void> searchByText(
    String query, {
    MarkerIconMessage? icon,
    Function(DgisObjectIdMessage?)? onTap,
  }) async {
    final dgisController = ref.read(dgisControllerProvider);

    final result = await dgisController.value?.search(
      query,
      sortingType: SortingTypeMessage.byDistance,
    );

    await _handleResult(result, icon: icon, onTap: onTap);
  }

  Future<void> searchByQuery(SearchQueryMessage query) async {
    final dgisController = ref.read(dgisControllerProvider);

    final result = await dgisController.value?.searchByQuery(
      query,
      sortingType: SortingTypeMessage.byDistance,
    );

    await _handleResult(result);
  }

  Future<void> removeMarkers() async {
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: name,
      ).notifier,
    );

    await mapObjectManager.removeAll();
  }

  Future<void> _dispose() async {
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: name,
      ).notifier,
    );
    await mapObjectManager.removeAll();

    final dgisController = ref.read(dgisControllerProvider);
    if (_currentPage != null) {
      await dgisController.value?.releasePage(_currentPage!);
    }
  }

  Future<void> _handleResult(
    SearchResultMessage? result, {
    MarkerIconMessage? icon,
    Function(DgisObjectIdMessage?)? onTap,
  }) async {
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: name,
      ).notifier,
    );

    final markers = <Marker>[];
    for (final markerInfo
        in result?.itemMarkerInfos ?? List<ItemMarkerInfoMessage>.empty()) {
      markers.add(
        Marker(
          id: markerInfo?.objectId?.objectId.toString() ?? 'invalid',
          onTap: () {
            onTap?.call(markerInfo.objectId);
          },
          options: MarkerOptionsMessage(
            position: markerInfo!.geoPoint,
            icon: icon ??
                MarkerIconMessage(
                  path: 'packages/mapness/assets/icons/svg/ic_marker.svg',
                  width: 24,
                ),
          ),
        ),
      );
    }

    await removeMarkers();
    await mapObjectManager.addMarkers(markers);

    _currentPage = result?.firstPage;

    state =
        _currentPage?.items.whereType<DirectoryObjectMessage>().toList() ?? [];
  }

  Future<bool> fetchNext() async {
    if (_currentPage == null) {
      return false;
    }

    final dgisController = ref.read(dgisControllerProvider);

    PageMessage? page;
    try {
      page = await dgisController.value?.fetchNextPage(_currentPage!);
    } on Exception catch (_) {
      return false;
    }

    if (page == null) {
      return false;
    }

    await dgisController.value?.releasePage(_currentPage!);
    _currentPage = page;
    state = [
      ...state,
      ...page.items.whereType<DirectoryObjectMessage>(),
    ];
    return true;
  }
}
