import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:mapness/shared/lib/auth/auth_token_interceptors.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/package_info.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:mapness/shared/utils/common_function.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/logger/talker_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

part 'dgis_hmac_netwrok.g.dart';

@Riverpod(keepAlive: true)
class DgisHmacNetwrok extends _$DgisHmacNetwrok {
  @override
  Future<Dio> build() async {
    const timeout = Duration(seconds: 5);
    final appLanguage = ref.watch(appLanguageProvider);
    final uuid = ref.watch(uuidProviderProvider);
    final version = ref.watch(packageInfoProvider).value?.version;
    final env = await ref.read(dgisEnvironmentProvider.future);

    return Dio(
      BaseOptions(
        sendTimeout: timeout,
        receiveTimeout: timeout,
        connectTimeout: timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Device-ID': uuid,
          'X-Device-Platform': Platform.isIOS ? 'ios' : 'android',
          'X-App-Version': version ?? '1.0.0',
          'X-Locale': appLanguage == Language.arabic ? 'ar_SA' : 'en_SA',
          'X-Language': appLanguage == Language.arabic ? 'ar' : 'en',
          'X-Proxy-Host': env.proxy,
        },
      ),
    )..interceptors.addAll([
        AuthTokenInterceptor.tokenInterceptor(
          ref,
          BaseOptions(
            responseType: ResponseType.bytes,
            sendTimeout: timeout,
            receiveTimeout: timeout,
            connectTimeout: timeout,
          ),
        ),
        QueuedInterceptorsWrapper(
          onRequest: (options, handler) {
            final hasProxy = (options.headers['X-Proxy-Host'] as String? ?? '').isNotEmpty == true;

            final isHttp = options.path.startsWith('http');

            var baseUrl = '';

            if (hasProxy) {
              baseUrl = 'https://apiservicesstg.balady.gov.sa'; // TODO: Move to const or env
            } else if (isHttp) {
              // if path is http url, get host from options path
              baseUrl = Uri.tryParse(options.path)?.host ?? '';
            } else {
              baseUrl = Uri.tryParse(options.baseUrl)?.host ?? '';
            }

            final path = isHttp ? Uri.tryParse(options.path)?.path : options.path;

            final method = options.method;
            final coreliationId = Random().nextInt(100000000);

            final queryParameters = options.queryParameters.isEmpty
                ? ''
                : options.queryParameters.entries
                    .map((e) => '${e.key}=${e.value}') // TODO: add url encoding
                    .join('&');

            final url = queryParameters.isEmpty ? 'https://$baseUrl$path' : 'https://$baseUrl$path?$queryParameters';

            final hash = hashRequest(
              url,
              method,
              authorization: true,
              corelationId: coreliationId.toString(),
            );

            final headers = options.headers;
            headers['verifyingKEY'] = hash;
            headers['x-correlation-id'] = coreliationId;

            options.headers = headers;

            return handler.next(options);
          },
        ),
        if (logger is TalkerMapnessLogger)
          TalkerDioLogger(
            talker: (logger as TalkerMapnessLogger).talker,
            settings: const TalkerDioLoggerSettings(
              printRequestHeaders: true,
              printResponseHeaders: true,
              printResponseData: false,
            ),
          ),
      ]);
  }
}
