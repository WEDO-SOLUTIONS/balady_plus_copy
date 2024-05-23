import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/landing/providers/scroll_to_selected_filter.dart';
import 'package:mapness/_features/landing/providers/search_in_rect.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/features/quick_filters/providers/quick_filters.dart';
import 'package:mapness/features/quick_filters/providers/quick_filters_data.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_by_rubrics.g.dart';

@riverpod
class SearchByRubricsQuery extends _$SearchByRubricsQuery {
  @override
  QuickFilter? build() => null;

  void update(QuickFilter? filter) {
    if (filter?.type != null) {
      // If we have type of filter and this filter is selected, we need to scroll all quick filter rows to selected filter
      // We do it to show the selected filter on the screen, not hidden
      final quickFilters = ref.read(quickFiltersProvider);
      final selectedFilter = quickFilters.valueOrNull?.firstWhereOrNull((e) => e.type == filter?.type);
      if (selectedFilter != null) {
        ref.read(scrollToSelectedQuickFilterProvider.notifier).scrollToSelected();
      }
    }

    state = filter;
  }

  void selectFilter(QuickFilterType type) {
    final quickFilters = ref.read(quickFiltersProvider);
    final selectedFilter = quickFilters.valueOrNull?.firstWhereOrNull((e) => e.type == type);
    if (selectedFilter != null) {
      update(selectedFilter);
    }
  }
}

@riverpod
class SearchByRubrics extends _$SearchByRubrics {
  @override
  Future<List<Marker>?> build() async {
    final filter = ref.watch(searchByRubricsQueryProvider);
    if (filter == null) {
      return null;
    }

    final searchRect = ref.watch(searchInRectProvider.select((value) => value.$1));
    final dgisController = ref.read(dgisControllerProvider.notifier);

    unawaited(performSearch(
      filter,
      searchRect ?? dgisController.visibleRectSubject.value?.visibleRect.geoRectMessage(),
    ));

    return null;
  }

  Future<void> performSearch(QuickFilter filter, GeoRectMessage? searchRect) async {
    final dgisController = ref.watch(dgisControllerProvider).value;

    if (dgisController == null) {
      return;
    }
    SearchResultMessage? searchResults;
    if (filter.rubrics.isEmpty && filter.query != null) {
      final category = getCategoryByTag(filter.query!);
      if (category == null) {
        return;
      }

      searchResults = await dgisController.searchByCategory(
        category,
        sortingType: SortingTypeMessage.byRelevance,
        searchRect: searchRect,
      );
    } else {
      searchResults = await dgisController.searchByRubrics(
        filter.rubrics,
        sortingType: SortingTypeMessage.byRelevance,
        searchRect: searchRect,
      );
    }
    final currentFilter = ref.watch(searchByRubricsQueryProvider);
    if (currentFilter?.type == filter.type) {
      final markers = await _showAndReturnMarkers(searchResults);
      state = AsyncValue.data(markers);
    }
  }

  Future<List<Marker>?> _showAndReturnMarkers(SearchResultMessage value) async {
    final mapSetting = MapObjectManagerSettings.quickFilter();
    final searchObjectManager = ref.read(
      mapObjectManagerProvider(
        named: mapSetting.name,
        layerId: mapSetting.layerId,
      ).notifier,
    );

    final selectedFilter = ref.watch(searchByRubricsQueryProvider);
    final markers = <Marker>[];
    for (final markerInfo in value.itemMarkerInfos ?? List<ItemMarkerInfoMessage>.empty()) {
      markers.add(
        Marker(
          id: markerInfo?.objectId?.objectId.toString() ?? 'invalid',
          onTap: () {
            Metrics.logEventAdvanced(MetricsConstants.poiKeys.marker,
                group: MetricsConstants.poiTag,
                action: MetricAction.tap.toString(),
                props: {'objectId': markerInfo.objectId!.objectId});
            PoiMapRoute.open(
              ref.read(goRouterProvider),
              markerInfo.objectId!.objectId,
            );
          },
          options: MarkerOptionsMessage(
            position: markerInfo!.geoPoint,
            icon: (selectedFilter == null ? LayersSvgPaths.basicMarker : 'packages/mapness/${selectedFilter.mapIcon}')
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
