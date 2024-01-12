import 'package:dgis_map/library.dart';
import 'package:mapness/_features/landing/providers/search_in_rect.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_by_rubrics.g.dart';

@riverpod
class SearchByRubricsQuery extends _$SearchByRubricsQuery {
  @override
  (QuickFilter, int)? build() {
    return null;
  }

  void update((QuickFilter filter, int index)? newState) => state = newState;
}

@riverpod
class SearchByRubrics extends _$SearchByRubrics {
  @override
  Future<SearchResultMessage?> build() async {
    final filter = ref.watch(searchByRubricsQueryProvider);
    if (filter == null) return null;

    final searchRect =
        ref.watch(searchInRectProvider.select((value) => value.$1));
    final dgisController = ref.read(dgisControllerProvider.notifier);

    return await performSearch(
      filter.$1,
      searchRect ??
          dgisController.visibleRectSubject.value.visibleRect.geoRectMessage(),
    );
  }

  Future<SearchResultMessage?> performSearch(
      QuickFilter filter, GeoRectMessage searchRect) async {
    final dgisController = ref.watch(dgisControllerProvider).value;

    if (filter.rubrics.isEmpty && filter.query != null) {
      final category = getCategoryByTag(filter.query!);
      if (category == null) return null;
      dgisController
          ?.searchByCategory(
            category,
            sortingType: SortingTypeMessage.byRelevance,
            searchRect: searchRect,
          )
          .then(
            (value) => state = AsyncValue.data(value),
          );
      return null;
    }
    dgisController
        ?.searchByRubrics(
          filter.rubrics,
          sortingType: SortingTypeMessage.byRelevance,
          searchRect: searchRect,
        )
        .then(
          (value) => state = AsyncValue.data(value),
        );

    return null;
  }

  SearchCategoryMessage? getCategoryByTag(String tag) {
    return switch (tag) {
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
}
