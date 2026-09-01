import 'package:dio/dio.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bytedance_dio.g.dart';

@riverpod
class BytedanceDio extends _$BytedanceDio {
  @override
  Future<Dio> build() async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final baseUrl = env.bytedanceApiUrl;
    final apiKey = env.bytedanceApiKey;

    final dio = ref.read(baseDioProvider);
    return Dio(
      dio.options.copyWith(
        baseUrl: baseUrl,
        headers: {
          ...dio.options.headers,
          'Authorization': 'Bearer $apiKey',
        },
      ),
    );
  }
}
