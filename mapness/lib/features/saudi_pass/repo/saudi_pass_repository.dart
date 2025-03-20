import 'package:dio/dio.dart';

import 'lookups_body.dart';
import 'offer_details_body.dart';
import 'promotions_body.dart';

class SaudiPassRepository {
  final Dio _dio;

  SaudiPassRepository(this._dio);

  Future<Lookups> getAllLookups() async {
    final response = await _dio.get('/lookups');

    return LookupsBody.fromJson(response.data).dataOrThrow();
  }

  Future<Promotions> getPromotions({
    required City city,
    int pageNumber = 0,
    int pageSize = 10,
    String? licenseId,
    bool? applyPreference,
    String? rubricId,
    RecommendedType? recommendedType,
    Sort? sort,
    Category? category,
    Sort? recencySort,
    Sort? ratingSort,
    Sort? discountSort,
  }) async {
    final queryParameters = <String, Object?>{
      'city-id': city.id,
      'page-no': pageNumber + 1,
      'page-size': pageSize,
      'license-id': licenseId,
      'apply-pref': applyPreference,
      'rubric-id': rubricId,
      'recommended-type': recommendedType?.id,
      'sort': sort?.name,
      'category-id': category?.id,
      'recency': recencySort?.name,
      'rating': ratingSort?.name,
      'discount': discountSort?.name,
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
