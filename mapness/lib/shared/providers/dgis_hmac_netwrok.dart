import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:mapness/features/sso_auth/data/token_provider.dart';
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
  Dio build() {
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
        // TODO: Move it to separate file
        QueuedInterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await ref.read(tokenProvider.future);
            if (token.isNotEmpty) {
              final headers = options.headers;

              headers['Authorization'] = 'Bearer $token';
              options.headers = headers;
            }
            handler.next(options);
          },
          onError: (error, handler) async {
            if (error.response?.statusCode == 401) {
              try {
                await ref.read(tokenProvider.notifier).refreshToken();
                // Create dummy dio to rehandle data
                final dummyDio = Dio(BaseOptions(
                  responseType: ResponseType.bytes,
                  baseUrl: url,
                  sendTimeout: timeout,
                  receiveTimeout: timeout,
                  connectTimeout: timeout,
                ));
                final options = error.response!.requestOptions;

                // Add new refresh token to headers
                final token = await ref.read(tokenProvider.future);
                if (token.isEmpty) handler.reject(error);

                options.headers['Authorization'] = 'Bearer $token';
                final response = await dummyDio.request(
                  options.path,
                  data: options.data,
                  queryParameters: options.queryParameters,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                );
                handler.resolve(response);
              } catch (e) {
                if (e is DioException && e.response?.statusCode == 401) {
                  // TODO: Make logout and go to main page
                  handler.reject(error);
                } else if (e is DioException) {
                  handler.reject(e);
                } else {
                  handler.reject(error);
                }
              }
            }
            handler.next(error);
          },
        ),
      ]);
  }
}
