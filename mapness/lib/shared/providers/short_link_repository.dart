import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_language.dart';
import 'base_dio.dart';
import 'dgis_environment.dart';

part 'short_link_repository.freezed.dart';
part 'short_link_repository.g.dart';

@riverpod
class ShortLinkRepository extends _$ShortLinkRepository {
  @override
  ShortLinkRepository build() => this;

  Future<Dio> _dio() async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final baseUrl = env.shortLinkUrl;
    final apiKey = env.shortLinkApiKey;

    final dio = ref.read(baseDioProvider);
    final appLanguage = ref.read(appLanguageProvider);
    return Dio(
      dio.options.copyWith(
        baseUrl: baseUrl,
        headers: {
          ...dio.options.headers,
          if (apiKey != null) 'x-api-key': apiKey,
          'X-Locale': appLanguage == Language.arabic ? 'ar_SA' : 'en_SA',
        },
      ),
    );
  }

  Future<ShortLinkResponse> createLink(ShortLinkRequest data) async {
    final dio = await _dio();
    final responseJson = await dio.post<Map<String, dynamic>>(
      '/',
      data: jsonEncode(data.toJson()),
      options: Options(contentType: Headers.jsonContentType),
    );

    final responseData = responseJson.data;
    if (responseData == null) {
      throw Exception('Response is empty');
    }

    return ShortLinkResponse.fromJson(responseData);
  }

  Future<ShortLinkResponse> getLinkDetails(String code) async {
    final dio = await _dio();
    final responseJson = await dio.get<Map<String, dynamic>>(
      '/$code',
      options: Options(contentType: Headers.jsonContentType),
    );

    final responseData = responseJson.data;
    if (responseData == null) {
      throw Exception('Response is empty');
    }

    return ShortLinkResponse.fromJson(responseData);
  }
}

@Freezed(unionKey: 'contentType')
sealed class ShortLinkRequest with _$ShortLinkRequest {
  const factory ShortLinkRequest.poi({
    required ShortLinkPayloadPoi payload,
    ShortLinkVisibility? visibility,
    bool? forceNew,
  }) = _ShortLinkRequestPoi;

  const factory ShortLinkRequest.point({
    required ShortLinkPayloadPoint payload,
    ShortLinkVisibility? visibility,
    bool? forceNew,
  }) = _ShortLinkRequestPoint;

  const factory ShortLinkRequest.trip({
    required ShortLinkPayloadTrip payload,
    ShortLinkVisibility? visibility,
    bool? forceNew,
  }) = _ShortLinkRequestTrip;

  factory ShortLinkRequest.fromJson(Map<String, dynamic> json) => _$ShortLinkRequestFromJson(json);
}

enum ShortLinkVisibility { public, unlisted }

enum ShortLinkTransportType {
  driving,
  walking,
  taxi,
  bicycle,
  scooter,
  emergency,
  truck,
  motorcycle,
  metro;

  static ShortLinkTransportType message(RouteSearchOptionsMessage type) => switch (type) {
    RouteSearchOptionsMessage.car => ShortLinkTransportType.driving,
    RouteSearchOptionsMessage.publicTransport => ShortLinkTransportType.metro,
    RouteSearchOptionsMessage.bicycle => ShortLinkTransportType.bicycle,
    RouteSearchOptionsMessage.pedestrian => ShortLinkTransportType.walking,
    RouteSearchOptionsMessage.scooter => ShortLinkTransportType.scooter,
    RouteSearchOptionsMessage.truck => ShortLinkTransportType.truck,
    RouteSearchOptionsMessage.taxi => ShortLinkTransportType.taxi,
  };

  RouteSearchOptionsMessage toMessage() => switch (this) {
    ShortLinkTransportType.driving => RouteSearchOptionsMessage.car,
    ShortLinkTransportType.walking => RouteSearchOptionsMessage.pedestrian,
    ShortLinkTransportType.taxi => RouteSearchOptionsMessage.taxi,
    ShortLinkTransportType.bicycle => RouteSearchOptionsMessage.bicycle,
    ShortLinkTransportType.scooter => RouteSearchOptionsMessage.scooter,
    ShortLinkTransportType.emergency => RouteSearchOptionsMessage.car,
    ShortLinkTransportType.truck => RouteSearchOptionsMessage.truck,
    ShortLinkTransportType.motorcycle => RouteSearchOptionsMessage.scooter,
    ShortLinkTransportType.metro => RouteSearchOptionsMessage.publicTransport,
  };
}

@freezed
abstract class ShortLinkPayloadPoi with _$ShortLinkPayloadPoi {
  const factory ShortLinkPayloadPoi({
    required String poiId,
    double? lat,
    double? lon,
  }) = _ShortLinkPayloadPoi;

  factory ShortLinkPayloadPoi.fromJson(Map<String, dynamic> json) => _$ShortLinkPayloadPoiFromJson(json);
}

@freezed
abstract class ShortLinkPayloadPoint with _$ShortLinkPayloadPoint {
  const factory ShortLinkPayloadPoint({
    required double lat,
    required double lon,
  }) = _ShortLinkPayloadPoint;

  factory ShortLinkPayloadPoint.fromJson(Map<String, dynamic> json) => _$ShortLinkPayloadPointFromJson(json);
}

@freezed
abstract class ShortLinkPayloadTrip with _$ShortLinkPayloadTrip {
  const factory ShortLinkPayloadTrip({
    required ShortLinkPayloadTripRoute route,
  }) = _ShortLinkPayloadTrip;

  factory ShortLinkPayloadTrip.fromJson(Map<String, dynamic> json) => _$ShortLinkPayloadTripFromJson(json);
}

@freezed
abstract class ShortLinkPayloadTripRoute with _$ShortLinkPayloadTripRoute {
  const factory ShortLinkPayloadTripRoute({
    required ShortLinkPayloadTripRoutePoint startPoint,
    required ShortLinkPayloadTripRoutePoint endPoint,
    required ShortLinkTransportType type,
    List<ShortLinkPayloadTripRoutePoint>? midPoints,
    int? routeIndex,
  }) = _ShortLinkPayloadTripRoute;

  const ShortLinkPayloadTripRoute._();

  factory ShortLinkPayloadTripRoute.fromJson(Map<String, dynamic> json) => _$ShortLinkPayloadTripRouteFromJson(json);

  List<RouteParamsPointWithLabel> toRouteParamsPointWithLabels() => [
    (startPoint, 'A'),
    ...?midPoints?.mapIndexed((index, element) => (element, '${index + 1}')),
    (endPoint, 'B'),
  ].map((e) => e.$1.toRouteParamsPointWithLabel(e.$2)).toList();
}

@freezed
abstract class ShortLinkPayloadTripRoutePoint with _$ShortLinkPayloadTripRoutePoint {
  const factory ShortLinkPayloadTripRoutePoint({
    required double lat,
    required double lon,
    String? poiId,
    String? label,
  }) = _ShortLinkPayloadTripRoutePoint;

  const ShortLinkPayloadTripRoutePoint._();

  factory ShortLinkPayloadTripRoutePoint.fromJson(Map<String, dynamic> json) =>
      _$ShortLinkPayloadTripRoutePointFromJson(json);

  RouteParamsPointWithLabel toRouteParamsPointWithLabel(String fallbackLabel) {
    final poiId = this.poiId;
    return RouteParamsPointWithLabel(
      label: label ?? fallbackLabel,
      value: RouteParamsPoint(latitude: lat, longitude: lon, objectId: poiId == null ? null : int.tryParse(poiId)),
    );
  }
}

@Freezed(unionKey: 'contentType')
sealed class ShortLinkResponse with _$ShortLinkResponse {
  const factory ShortLinkResponse.poi({
    required String code,
    required String shortUrl,
    required ShortLinkPayloadPoi payload,
    required bool isDeleted,
    required DateTime createdAt,
    required String longUrl,
    ShortLinkVisibility? visibility,
  }) = ShortLinkResponsePoi;

  const factory ShortLinkResponse.point({
    required String code,
    required String shortUrl,
    required ShortLinkPayloadPoint payload,
    required bool isDeleted,
    required DateTime createdAt,
    required String longUrl,
    ShortLinkVisibility? visibility,
  }) = ShortLinkResponsePoint;

  const factory ShortLinkResponse.trip({
    required String code,
    required String shortUrl,
    required ShortLinkPayloadTrip payload,
    required bool isDeleted,
    required DateTime createdAt,
    String? longUrl,
    ShortLinkVisibility? visibility,
  }) = ShortLinkResponseTrip;

  factory ShortLinkResponse.fromJson(Map<String, dynamic> json) => _$ShortLinkResponseFromJson(json);
}
