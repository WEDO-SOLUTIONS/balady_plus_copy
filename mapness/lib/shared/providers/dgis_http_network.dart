import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:mapness/shared/lib/auth/auth_token_interceptors.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/package_info.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/logger/talker_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

part 'dgis_http_network.g.dart';

final defaultCacheOptions = buildCacheOptions(
  const Duration(days: 7),
  forceRefresh: true,
);

@Riverpod(keepAlive: true)
class _DGisHttpNetwork extends _$DGisHttpNetwork {
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
        sendTimeout: timeout,
        receiveTimeout: timeout,
        connectTimeout: timeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-Device-ID': uuid,
          'X-Device-Platform': Platform.isIOS ? 'ios' : 'android',
          'X-App-Version': version ?? '1.0.0',
          'X-Locale': appLanguage == Language.arabic ? 'ar_SA' : 'en_SA',
          'X-Language': appLanguage == Language.arabic ? 'ar' : 'en',
        },
      ),
    );
    dio.interceptors.addAll(
      [
        if (logger is TalkerMapnessLogger)
          TalkerDioLogger(
            talker: (logger as TalkerMapnessLogger).talker,
            settings: const TalkerDioLoggerSettings(
              printRequestHeaders: true,
              printResponseHeaders: true,
              printResponseData: false,
            ),
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
            logger.log('RETRY LOG: $message', logLevel: MapnessLogLevel.critical);
          }, // specify log function (optional)
          retries: 2, // retry count (optional)
          retryDelays: const [
            Duration(seconds: 1), // wait 1 sec before the first retry
            Duration(seconds: 1), // wait 2 sec before the second retry
          ],
        ),
      ],
    );
    return dio;
  }
}

final dGisHttpService = _dGisHttpNetworkProvider;
