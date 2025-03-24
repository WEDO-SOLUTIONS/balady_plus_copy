import 'package:dio/dio.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/offer_details_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';

class SaudiPassRepository {
  final Dio _dio;

  SaudiPassRepository(this._dio);

  Future<Lookups> getAllLookups() async {
    final response = await _dio.get('/lookups');

    return LookupsBody.fromJson(response.data).dataOrThrow();
  }

  Future<Promotions> getPromotions({
    required Set<City> cities,
    int pageNumber = 0,
    int pageSize = 10,
    Set<String> licenseIds = const {},
    bool? applyPreference,
    String? rubricId,
    Set<RecommendedType> recommendedTypes = const {},
    Sort? sort,
    Set<Category> categories = const {},
    Sort? recencySort,
    Sort? ratingSort,
    Sort? discountSort,
    bool? favorites,
  }) async {
    if (cities.isEmpty) {
      throw Exception('Cities MUST NOT be empty');
    }

    final queryParameters = <String, Object?>{
      'city-id': [for (final city in cities) city.id],
      'page-no': pageNumber + 1,
      'page-size': pageSize,
      'license-id': [...licenseIds],
      'apply-pref': applyPreference,
      'rubric-id': rubricId,
      'recommended-type': [for (final recommendedType in recommendedTypes) recommendedType.id],
      'sort': sort?.name,
      'category-id': [for (final category in categories) category.id],
      'recency': recencySort?.name,
      'rating': ratingSort?.name,
      'discount': discountSort?.name,
      'favorites': favorites,
    }..removeWhere((_, value) => value == null);

    final response = await _dio.get('/promotions', queryParameters: queryParameters);

    return PromotionsBody.fromJson(response.data).dataOrThrow();
  }

  Future<OfferDetails> getOfferDetails({required String offerId}) async {
    final response = await _dio.get('/promotions/$offerId');

    return OfferDetailsBody.fromJson(response.data).dataOrThrow();
  }
}

enum Sort { asc, desc }
