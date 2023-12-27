import 'package:dgis_map/library.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

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
  Stream<SearchResultMessage?> build() {
    final filter = ref.watch(searchByRubricsQueryProvider);
    if (filter == null) return Stream.value(null);

    return ref
        .watch(dgisControllerProvider.notifier)
        .visibleRectSubject
        .debounceTime(const Duration(milliseconds: 750))
        .map((event) => event.visibleRect)
        .asyncMap(
      (event) async {
        final result = await performSearch(filter.$1, event.geoRectMessage());

        if (ref.read(searchByRubricsQueryProvider) == filter) {
          return result;
        }
        return null;
      },
    );
  }

  Future<SearchResultMessage?> performSearch(
      QuickFilter filter, GeoRectMessage searchRect) async {
    final dgisController = ref.watch(dgisControllerProvider).value;

    if (filter.rubrics.isEmpty && filter.query != null) {
      final category = getCategoryByTag(filter.query!);
      if (category == null) return null;

      return await dgisController?.searchByCategory(
        category,
        sortingType: SortingTypeMessage.byRelevance,
        searchRect: searchRect,
      );
    }

    return await dgisController?.searchByRubrics(
      filter.rubrics,
      sortingType: SortingTypeMessage.byRelevance,
      searchRect: searchRect,
    );
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
