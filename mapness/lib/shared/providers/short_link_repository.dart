import 'package:mapness/shared/providers/base_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'short_link_repository.g.dart';

@riverpod
class ShortLinkRepository extends _$ShortLinkRepository {
  @override
  ShortLinkRepository build() => this;

  Future<Uri> resolveLink(String shortCode) async {
    final dio = ref.read(baseDioProvider);

    final response = await dio.get<Map<String, dynamic>>(
      '/short/link/$shortCode',
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
