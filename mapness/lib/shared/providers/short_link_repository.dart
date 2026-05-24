import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

  Future<String> createLink(ShortLinkRequest data) async {
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

    final response = ShortLinkResponse.fromJson(responseData);
    return response.shortUrl;
  }
}

@freezed
abstract class ShortLinkRequest with _$ShortLinkRequest {
  const factory ShortLinkRequest({
    required String poiId,
    double? lat,
    double? lon,
  }) = _ShortLinkRequest;

  factory ShortLinkRequest.fromJson(Map<String, dynamic> json) => _$ShortLinkRequestFromJson(json);
}

@freezed
abstract class ShortLinkResponse with _$ShortLinkResponse {
  const factory ShortLinkResponse({
    required String code,
    required String shortUrl,
    required ShortLinkPayload payload,
    required String longUrl,
    required DateTime createdAt,
    required bool isDeleted,
  }) = _ShortLinkResponse;

  factory ShortLinkResponse.fromJson(Map<String, dynamic> json) => _$ShortLinkResponseFromJson(json);
}

@freezed
abstract class ShortLinkPayload with _$ShortLinkPayload {
  const factory ShortLinkPayload({
    required String poiId,
    double? lat,
    double? lon,
  }) = _ShortLinkPayload;

  factory ShortLinkPayload.fromJson(Map<String, dynamic> json) => _$ShortLinkPayloadFromJson(json);
}
