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

part 'saudi_pass_dio_riverpod.g.dart';

final saudiPassDioProvider = _saudiPassDioRiverpodProvider;

@riverpod
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
        // TODO weatherApi should be semantically renamed to apiservicesBalady cause it used wider then only for the Weather
        baseUrl: '${env.weatherApi}/v1/balady-business-saudi-pass-services/user',
        sendTimeout: timeout,
        receiveTimeout: timeout,
        connectTimeout: timeout,
        headers: {
          // TODO: !!! temporary authorization token from postman collection for testing, remove before release !!!
          'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjhFRDBCN0UzRjNDOTFBOEQwMUU3MEMxRUM4MTNGQTJBRjgxOEQ5MUZSUzI1NiIsIng1dCI6Imp0QzM0X1BKR28wQjV3d2V5QlA2S3ZnWTJSOCIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EiLCJuYmYiOjE3NDE3MTI2ODcsImlhdCI6MTc0MTcxMjY4NywiZXhwIjoxNzczMjQ4Njg3LCJhdWQiOlsiaHR0cHM6Ly9zc29hcHBkZXYubW9tcmEuZ292LnNhL3Jlc291cmNlcyIsIklkZW50aXR5U2VydmVyQ29uc3RhbnRzLkxvY2FsQXBpLlNjb3BlTmFtZSIsIkVtcGxveWVlQWRtaW5zdHJhdGlvbi5BcGkiXSwic2NvcGUiOlsiRW1wbG95ZWVBZG1pbnN0cmF0aW9uLkFwaSIsIm9wZW5pZCIsInByb2ZpbGUiLCJlbWFpbCIsInJvbGVzIiwicHJvZmlsZSIsInRlbmFudCIsIklkZW50aXR5U2VydmVyQXBpIiwiSWRlbnRpdHlTZXJ2ZXJDb25zdGFudHMuTG9jYWxBcGkuU2NvcGVOYW1lIiwib2ZmbGluZV9hY2Nlc3MiXSwiY2xpZW50X2lkIjoiYmFsYWR5X21vYmlsZV9hcHAiLCJ1c2VyX2lkIjoiMWVjZDY2NTYtMzlhMC00YmFkLTg2OWQtNjIxZGFmNWY4YmYyIiwicGhvbmVfbnVtYmVyIjoiMDA5NjY1NDQ4MzUwNjEiLCJqdGkiOiJGRkYzRURGM0MxODk5RjkyRTM5NTNEOTI0OTgxQzU0MSJ9.SdkcjL_bEIuLF7X15XMZTFro0XrEkFneZzt-1zv6iqmuQi9cuA1UgCbecKwMs2Ba39JRWVW-WesChyDiYDWGplrTcqa5Ppsif758Zh50zgdThJFHdzcOA8FEkVDKaFAy1YvVamkpMZK7GDV0tvFNIif77qhamuPFvD8lIs3foPNbQtDiqwNaHkNPvLbCFPUVEdrnrpiqNwNIPYLfBNnRX9ltd-jTBqH2cdtJkYi1AQgbsKzBqOAqasCqRmVB3rkEnMxqWSjth0MgpHYf1PMuZnTfKpNSWl3nxZIWWrZ8e-dl6xLvLtLQ7KQRXKSZTiIDgg9FpGqGTHRPPMSx0wA3OA',
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
