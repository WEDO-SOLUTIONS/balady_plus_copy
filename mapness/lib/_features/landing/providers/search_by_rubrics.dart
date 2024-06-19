import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/landing/providers/quick_filter_request_source_screen.dart';
import 'package:mapness/_features/landing/providers/search_in_rect.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/features/quick_filters/providers/quick_filters_data.dart' as data;
import 'package:mapness/features/quick_filters/providers/quick_filters_data.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_by_rubrics.g.dart';

// TODO(Sergei): remove when quick search feature is approved
@riverpod
class SearchByRubricsQuery extends _$SearchByRubricsQuery {
  @override
  QuickFilter? build() => null;

  // ignore: use_setters_to_change_properties
  void update(QuickFilter? filter) => state = filter;

  void selectFilter(QuickFilterType type) {
    final selectedFilter = data.quickFilters.firstWhereOrNull((e) => e.type == type);
    if (selectedFilter != null) {
      ref.read(quickFiltersRequestSourceScreenProvider.notifier).setSourceScreen();
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
    final language = ref.read(appLanguageProvider);
    final query = filter.query[language];
    if (filter.rubrics.isEmpty && query != null) {
      final category = getCategoryByTag(query);
      if (category == null) {
        return;
      }

      searchResults = await dgisController.searchByCategory(
        category,
        sortingType: SortingTypeMessage.byRelevance,
        searchRect: searchRect,

        /// TODO: Check if we need to set pageSize to better performance
        pageSize: 15000,
      );
    } else {
      searchResults = await dgisController.searchByRubrics(
        filter.rubrics,
        sortingType: SortingTypeMessage.byRelevance,
        searchRect: searchRect,

        /// TODO: Check if we need to set pageSize to better performance
        pageSize: 15000,
      );
    }

    final currentFilter = ref.watch(searchByRubricsQueryProvider);
    if (currentFilter?.type == filter.type) {
      final markers = await _showAndReturnMarkers(searchResults);
      state = AsyncValue.data(markers);
    }
  }

  Future<List<Marker>?> _showAndReturnMarkers(SearchResultMessage value) async {
    final mapSetting = MapObjectManagerSettings.search();
    final searchObjectManager = ref.read(
      mapObjectManagerProvider(
        named: mapSetting.name,
        layerId: mapSetting.layerId,
      ).notifier,
    );

    final selectedFilter = ref.watch(searchByRubricsQueryProvider);
    final markerIconPath = selectedFilter?.markerType?.iconPath;
    final icon =
        markerIconPath != null ? markerIconPath.markerIcon(size: 32) : LayersSvgPaths.basicMarker.markerIcon(size: 16);
    final markers = await value.getMarkers(router: ref.read(goRouterProvider), icon: icon);

    await searchObjectManager.removeAllMarkers();
    await searchObjectManager.addMarkers(markers);

    return markers;
  }

  SearchCategoryMessage? getCategoryByTag(String? tag) => switch (tag) {
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
