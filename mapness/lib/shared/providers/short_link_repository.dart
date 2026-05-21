import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_language.dart';
import 'base_dio.dart';
import 'dgis_environment.dart';

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

  Future<String> createLink(String poiId) async {
    final dio = await _dio();
    final response = await dio.post<Map<String, dynamic>>('/');

    final shortUrl = response.data?['shortUrl'] as String?;
    if (shortUrl == null || shortUrl.isEmpty) {
      throw Exception('Response does not contain shortUrl');
    }

    return shortUrl;
  }

  Future<Uri?> resolveLink(String shortCode) async {
    final dio = await _dio();
    final response = await dio.get<Map<String, dynamic>>('/$shortCode');

    final longUrl = response.data?['longUrl'] as String?;
    if (longUrl == null || longUrl.isEmpty) {
      throw Exception('Response does not contain longUrl');
    }

    final resolved = Uri.tryParse(longUrl);
    if (resolved == null) {
      throw Exception('Invalid longUrl format: $longUrl');
    }

    return resolved;
  }
}
