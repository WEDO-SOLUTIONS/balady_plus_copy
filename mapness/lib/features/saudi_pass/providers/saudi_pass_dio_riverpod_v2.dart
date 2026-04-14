import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:mapness/features/saudi_pass/repo/verifying_key_interceptor.dart';
import 'package:mapness/shared/lib/auth/auth_token_interceptors.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/package_info.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saudi_pass_dio_riverpod_v2.g.dart';

final saudiPassDioProviderV2 = _saudiPassDioRiverpodProvider;

@Riverpod(keepAlive: true)
class _SaudiPassDioRiverpod extends _$SaudiPassDioRiverpod {
  final _dioCacheManager = DioCacheManager(CacheConfig());

  @override
  Future<Dio> build() async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final url = env.url;
    const timeout = Duration(seconds: 5);
    final appLanguage = ref.watch(appLanguageProvider);
    final uuid = ref.watch(uuidProviderProvider);
    final version = ref.watch(packageInfoProvider).value?.version;

    final dio = Dio(
      BaseOptions(
        // TODO: add to env before release !!!
        baseUrl:
            'https://apiservicesstg.balady.gov.sa/v2/balady-business-saudi-pass-services/user',
        sendTimeout: timeout,
        receiveTimeout: timeout,
        connectTimeout: timeout,
        headers: {
          'X-Device-ID': uuid,
          'X-Device-Platform': Platform.isIOS ? 'ios' : 'android',
          'X-App-Version': version ?? '1.0.0',
          'X-Locale': appLanguage == Language.arabic ? 'ar_SA' : 'en_SA',
          'X-Language': appLanguage == Language.arabic ? 'ar' : 'en',
          'Accept-Language': appLanguage == Language.arabic ? 'ar' : 'en',
        },
      ),
    );
    dio.interceptors.addAll(
      [
        PrettyDioLogger(
          responseBody: false,
        ),
        AuthTokenInterceptor.tokenInterceptor(
          ref,
          BaseOptions(
            responseType: ResponseType.bytes,
            baseUrl: url,
            sendTimeout: timeout,
            receiveTimeout: timeout,
            connectTimeout: timeout,
          ),
        ),
        _dioCacheManager.interceptor as Interceptor,
        RetryInterceptor(
          dio: dio,
          logPrint: (message) {
            log('RETRY LOG: $message');
          }, // specify log function (optional)
          retries: 2, // retry count (optional)
          retryDelays: const [
            Duration(seconds: 1), // wait 1 sec before the first retry
            Duration(seconds: 1), // wait 2 sec before the second retry
          ],
        ),
        VerifyingKeyInterceptor(),
      ],
    );
    return dio;
  }
}
