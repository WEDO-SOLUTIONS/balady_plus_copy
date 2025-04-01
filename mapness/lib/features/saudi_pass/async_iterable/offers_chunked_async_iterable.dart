import 'package:collection/collection.dart';
import 'package:mapness/features/saudi_pass/async_iterable/chunked_async_iterable.dart';
import 'package:mapness/features/saudi_pass/repo/get_preferences_body.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/features/saudi_pass/repo/saudi_pass_repository.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog.dart';

class OffersChunkedAsyncIterable extends ChunkedAsyncIterable<Offer> {
  final SaudiPassRepository saudiPassRepository;
  final Set<City> cities;
  final Set<RecommendedType> recommendedTypes;
  final Set<Category> categories;
  final Preferences? preferences;
  final bool? favorites;
  final Sorting? sorting;

  OffersChunkedAsyncIterable({
    required this.saudiPassRepository,
    required this.cities,
    this.recommendedTypes = const {},
    this.categories = const {},
    this.favorites,
    this.sorting,
  }) : preferences = null;

  OffersChunkedAsyncIterable.byPrefs({
    required this.saudiPassRepository,
    required Preferences this.preferences,
  })  : recommendedTypes = preferences.recommendedTypes.toSet(),
        categories = preferences.categories.toSet(),
        favorites = null,
        sorting = null,
        cities = preferences.cities.toSet();

  @override
  int get chunkSize => 20;

  @override
  Future<Chunk<Offer>> getChunk(int chunkIndex) async {
    final promotions = await saudiPassRepository.getPromotions(
      pageNumber: chunkIndex,
      pageSize: chunkSize,
      cities: cities,
      recommendedTypes: recommendedTypes,
      categories: categories,
      applyPreference: preferences != null ? true : null,
      favorites: favorites,
      recencySort: sorting == Sorting.byRecency ? Sort.desc : null,
      ratingSort: sorting == Sorting.byRating ? Sort.desc : null,
    );

    return OffersChunk(promotions);
  }
}

class OffersChunk extends DelegatingIterable<Offer> implements Chunk<Offer> {
  final Promotions promotions;

  OffersChunk(this.promotions) : super(promotions.records);

  @override
  int get totalChunks => promotions.pagingStatus.pagesCount;

  @override
  int get totalItems => promotions.pagingStatus.totalRecordsCount;
}
