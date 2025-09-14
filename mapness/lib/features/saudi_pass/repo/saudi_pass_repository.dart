import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mapness/entities/saudi_pass/offer_feedback.dart';
import 'package:mapness/features/saudi_pass/repo/get_preferences_body.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/offer_details_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/features/saudi_pass/repo/set_preferences_request.dart';

class SaudiPassRepository {
  final Dio _dio;

  SaudiPassRepository(this._dio);

  Future<Lookups> getAllLookups() async {
    _dio.interceptors.add(CurlLoggerInterceptor());
    final response = await _dio.get('/lookups');

    return LookupsBody.fromJson(response.data).dataOrThrow();
  }

  Future<Promotions> getPromotions({
    required Set<String> cityIds,
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
    if (cityIds.isEmpty) {
      throw Exception('Cities MUST NOT be empty');
    }

    final queryParameters = <String, Object?>{
      'city-id': [...cityIds],
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
    final z = PromotionsBody.fromJson(response.data).dataOrThrow();
    print('amr ${z.records.length}');
    print('amr ${z.records.map((e) => e.name,)}');

    return z;
  }

  Future<OfferDetails> getOfferDetails({required String offerId}) async {
    final response = await _dio.get('/promotions/$offerId');

    return OfferDetailsBody.fromJson(response.data).dataOrThrow();
  }

  ({String url, Map<String, String> headers}) getPromotionsImagesUri({required String imageId}) {
    final options = Options();

    final requestOptions = options.compose(
      _dio.options,
      '/promotions/images/$imageId',
      sourceStackTrace: StackTrace.current,
    );

    final requestOptionsIntercepted = _RequestInterceptorHandler(_dio).combine(requestOptions);

    final requestHeaders = requestOptionsIntercepted.headers..removeWhere((key, value) => value is! String);

    return (url: requestOptionsIntercepted.uri.toString(), headers: requestHeaders.cast());
  }

  Future<Response> sendFeedback({
    required String offerId,
    required OfferFeedback feedbackModel,
  }) async {
    final response = await _dio.post(
      '/promotions/$offerId/feedback',
      data: feedbackModel.toJson(),
    );
    return response;
  }

  Future<Preferences> getPreferences() async {
    final response = await _dio.get('/preferences');

    return GetPreferencesBody.fromJson(response.data).dataOrThrow();
  }

  Future<void> setPreferences(SetPreferencesRequest requestModel) async {
    await _dio.put(
      '/preferences',
      data: requestModel.toJson(),
    );
  }
}

enum Sort { asc, desc }

class _RequestInterceptorHandler extends RequestInterceptorHandler {
  final Dio dio;

  _RequestInterceptorHandler(this.dio);

  late RequestOptions effectiveRequestOptions;

  @override
  void next(RequestOptions requestOptions) => effectiveRequestOptions = requestOptions;

  RequestOptions combine(RequestOptions requestOptions) {
    effectiveRequestOptions = requestOptions;

    final iterator = dio.interceptors.iterator;

    while (iterator.moveNext()) {
      iterator.current.onRequest(requestOptions, this);
    }

    return effectiveRequestOptions;
  }
}

class CurlLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method.toUpperCase();
    final url = options.uri.toString();

    final curl = StringBuffer();

    curl.write('curl -X $method');

    // Add headers
    options.headers.forEach((k, v) {
      curl.write(' -H "${k}: ${v.toString().replaceAll('"', '\\"')}"');
    });

    // Add data
    if (options.data != null) {
      if (options.data is Map || options.data is List) {
        final data = json.encode(options.data);
        curl.write(' -d \'$data\'');
      } else {
        curl.write(' -d "${options.data.toString()}"');
      }
    }

    curl.write(' "$url"');

    print('===== 🌐 cURL Request =====');
    print(curl.toString());
    print('===========================');

    super.onRequest(options, handler);
  }
}
