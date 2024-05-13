import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_features/landing/providers/search_in_rect.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_by_rubrics.g.dart';

@riverpod
class SearchByRubricsQuery extends _$SearchByRubricsQuery {
  @override
  (QuickFilter, int)? build() => null;

  // ignore: use_setters_to_change_properties
  void update((QuickFilter filter, int index)? newState) => state = newState;
}

@riverpod
class SearchByRubrics extends _$SearchByRubrics {
  @override
  Future<List<Marker>?> build() async {
    final filter = ref.watch(searchByRubricsQueryProvider);
    if (filter == null) {
      return null;
    }

    final searchRect =
        ref.watch(searchInRectProvider.select((value) => value.$1));
    final dgisController = ref.read(dgisControllerProvider.notifier);

    unawaited(performSearch(
      filter.$1,
      searchRect ??
          dgisController.visibleRectSubject.value?.visibleRect.geoRectMessage(),
    ));

    return null;
  }

  Future<void> performSearch(
      QuickFilter filter, GeoRectMessage? searchRect) async {
    final dgisController = ref.watch(dgisControllerProvider).value;

    if (dgisController == null) {
      return;
    }

    if (filter.rubrics.isEmpty && filter.query != null) {
      final category = getCategoryByTag(filter.query!);
      if (category == null) {
        return;
      }

      final searchResults = await dgisController.searchByCategory(
        category,
        sortingType: SortingTypeMessage.byRelevance,
        searchRect: searchRect,
      );

      final markers = await _showAndReturnMarkers(searchResults);
      state = AsyncValue.data(markers);
    } else {
      final searchResults = await dgisController.searchByRubrics(
        filter.rubrics,
        sortingType: SortingTypeMessage.byRelevance,
        searchRect: searchRect,
      );
      final markers = await _showAndReturnMarkers(searchResults);
      state = AsyncValue.data(markers);
    }
  }

  Future<List<Marker>?> _showAndReturnMarkers(SearchResultMessage value) async {
    final mapSetting = MapObjectManagerSettings.quickFilter();
    final searchObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: mapSetting.name,
        layerId: mapSetting.layerId,
      ).notifier,
    );

    final selectedFilter = ref.watch(searchByRubricsQueryProvider);
    final markers = <Marker>[];
    for (final markerInfo
        in value.itemMarkerInfos ?? List<ItemMarkerInfoMessage>.empty()) {
      markers.add(
        Marker(
          id: markerInfo?.objectId?.objectId.toString() ?? 'invalid',
          onTap: () {
            PoiMapRoute.open(
              ref.read(goRouterProvider),
              markerInfo.objectId!.objectId,
            );
          },
          options: MarkerOptionsMessage(
            position: markerInfo!.geoPoint,
            icon: (selectedFilter == null
                    ? LayersSvgPaths.basicMarker
                    : 'packages/mapness/${selectedFilter.$1.mapIcon}')
                .markerIcon(),
          ),
        ),
      );
    }

    await searchObjectManager.removeAllMarkers();
    await searchObjectManager.addMarkers(markers);
    return markers;
  }

  SearchCategoryMessage? getCategoryByTag(String tag) => switch (tag) {
        'beaches' => SearchCategoryMessage.beaches,
        'mousques' => SearchCategoryMessage.mousques,
        'gasStations' => SearchCategoryMessage.gasStations,
        'cafe' => SearchCategoryMessage.cafe,
        'restaurants' => SearchCategoryMessage.restaurants,
        'parks' => SearchCategoryMessage.parks,
        'hospitals' => SearchCategoryMessage.hospitals,
        'schools' => SearchCategoryMessage.schools,
        'pharmacies' => SearchCategoryMessage.pharmacies,
        'dentalCenters' => SearchCategoryMessage.dentalCenters,
        'hotels' => SearchCategoryMessage.hotels,
        'beautyCenters' => SearchCategoryMessage.beautyCenters,
        'recreationCenters' => SearchCategoryMessage.recreationCenters,
        _ => null,
      };
}
