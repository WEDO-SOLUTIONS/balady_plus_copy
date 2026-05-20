import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dgis_environment.dart';
import 'dgis_http_network.dart';

part 'short_link_repository.g.dart';

@riverpod
class ShortLinkRepository extends _$ShortLinkRepository {
  @override
  ShortLinkRepository build() => this;

  Future<Uri?> resolveLink(String shortCode) async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final apiKey = env.shortLinkApiKey;
    final dio = await ref.read(dGisHttpService.future);
    final baseUri = Uri.parse(dio.options.baseUrl);

    final response = await dio.get<Map<String, dynamic>>(
      '${baseUri.origin}/short/link/$shortCode',
      options: Options(
        headers: {
          if (apiKey != null) 'x-api-key': apiKey,
        },
      ),
    );

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
