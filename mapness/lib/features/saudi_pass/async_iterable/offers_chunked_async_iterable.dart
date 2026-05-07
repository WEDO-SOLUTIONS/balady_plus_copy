import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/features/saudi_pass/async_iterable/chunked_async_iterable.dart';
import 'package:mapness/features/saudi_pass/repo/get_preferences_body.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/features/saudi_pass/repo/saudi_pass_repository.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';

class OffersChunkedAsyncIterable extends ChunkedAsyncIterable<Offer> {
  final SaudiPassRepository saudiPassRepository;
  final Set<City> cities;
  final Set<RecommendedType> recommendedTypes;
  final Set<Category> categories;
  final Set<SubCategory> subCategories;
  final Preferences? preferences;
  final bool? favorites;
  final Sorting? sorting;
  final GeoPointMessage mapPoint;

  OffersChunkedAsyncIterable({
    required this.saudiPassRepository,
    required this.cities,
    required this.mapPoint,
    this.recommendedTypes = const {},
    this.categories = const {},
    this.subCategories = const {},
    this.favorites,
    this.sorting,
  }) : preferences = null;

  /// [resolvedCity] is the BRD-resolved fallback used when the user has no
  /// preference cities configured. It is computed by
  /// `byPreferenceCityResolverProvider` per the priority chain
  /// `Preference City → Current Location City → Riyadh` (BRD US-01,
  /// Jira BALADY-188).
  OffersChunkedAsyncIterable.byPrefs({
    required this.saudiPassRepository,
    required City resolvedCity,
    required Preferences this.preferences,
    required this.mapPoint,
  })  : recommendedTypes = preferences.recommendedTypes.toSet(),
        categories = preferences.categoriesOnly.toSet(),
        subCategories = preferences.subCategoriesOnly.toSet(),
        favorites = null,
        sorting = null,
        cities = {
          if (preferences.cities.isEmpty) resolvedCity,
          if (preferences.cities.isNotEmpty) ...preferences.cities,
        };

  @override
  int get chunkSize => 20;

  @override
  Future<Chunk<Offer>> getChunk(int chunkIndex) async {
    final promotions = await saudiPassRepository.getPromotions(
      pageNumber: chunkIndex,
      pageSize: chunkSize,
      cityIds: cities.map((city) => city.id).toSet(),
      recommendedTypes: recommendedTypes,
      categories: categories.toSet(),
      subCategories: subCategories.toSet(),
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
