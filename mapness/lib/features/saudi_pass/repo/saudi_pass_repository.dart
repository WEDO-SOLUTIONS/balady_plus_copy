import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:dgis_map/library.dart';
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
    final response = await _dio.get('/lookups');

    return LookupsBody.fromJson(response.data).dataOrThrow();
  }

  Future<Promotions> getPromotions({
    required Set<String> cityIds,
    GeoPointMessage? mapPoint,
    int range = 10000,
    int pageNumber = 0,
    int? pageSize = 10,
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

    LatLng? userPoint;
    if (mapPoint != null) {
      userPoint = LatLng(
        latitude: mapPoint.latitude,
        longitude: mapPoint.longitude,
      );
    } else {
      userPoint = await Helpers.getCurrentLocation();
    }

    final queryParameters = <String, Object?>{
      'city-id': [...cityIds],
      'page-no': pageNumber + 1,
      if (pageSize != null) 'page-size': pageSize,
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
      'range': range,
      if (userPoint != null) 'user-longitude': userPoint.longitude,
      if (userPoint != null) 'user-latitude': userPoint.latitude,
    }..removeWhere((_, value) => value == null);

    // It will be fixed as soon as the entire second version is ready.
    _dio.options.baseUrl = 'https://apiservicesstg.balady.gov.sa/v2/balady-business-saudi-pass-services/user';
    final response = await _dio.get('/promotions', queryParameters: queryParameters);
    _dio.options.baseUrl = 'https://apiservicesstg.balady.gov.sa/v1/balady-business-saudi-pass-services/user';
    return PromotionsBody.fromJson(response.data).dataOrThrow();
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
