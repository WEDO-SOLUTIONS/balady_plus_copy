import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:mapness/shared/lib/auth/auth_token_interceptors.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/integration_urls.dart';
import 'package:mapness/shared/providers/package_info.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_hmac_netwrok.g.dart';

@riverpod
class DgisHmacNetwrok extends _$DgisHmacNetwrok {
  @override
  Future<Dio> build() async {
    final url = ref.watch(integrationUrlsProvider);
    const timeout = Duration(seconds: 5);
    final appLanguage = ref.watch(appLanguageProvider);
    final uuid = ref.watch(uuidProviderProvider);
    final version = ref.watch(packageInfoProvider).value?.version;

    // TODO: Calculate it
    final verifyingKEY = '';

    return Dio(BaseOptions(
      responseType: ResponseType.json,
      baseUrl: url,
      sendTimeout: timeout,
      receiveTimeout: timeout,
      connectTimeout: timeout,
      headers: {
        'x-correlation-id': Random().nextInt(100000000),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Device-ID': uuid,
        'X-Device-Platform': Platform.isIOS ? "ios" : "android",
        "X-App-Version": version ?? "1.0.0",
        "verifyingKEY": verifyingKEY,
        "X-Locale": appLanguage == Language.arabic ? "ar_SA" : "en_SA",
        "X-Language": appLanguage == Language.arabic ? "ar" : "en",
      },
    ))
      ..interceptors.addAll([
        PrettyDioLogger(
          /// Since protobufs are just binary files what a purpose to print it
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
        )
      ]);
  }
}
