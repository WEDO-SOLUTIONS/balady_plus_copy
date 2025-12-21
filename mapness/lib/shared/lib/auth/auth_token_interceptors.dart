import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/sso_auth/data/token_provider.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/logger/talker_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class AuthTokenInterceptor {
  static QueuedInterceptorsWrapper tokenInterceptor(
    Ref ref,
    BaseOptions baseOptions,
  ) =>
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await ref.read(tokenProvider.future);
          final headers = options.headers;
          if (token.isNotEmpty) {
            headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options.copyWith(headers: headers));
        },
        onError: (error, handler) async {
          try {
            final token = await ref.read(tokenProvider.future);
            if (error.response?.statusCode == 401 && token.isNotEmpty) {
              await ref.read(tokenProvider.notifier).refreshToken();
              // Create dummy dio to rehandle data
              final dummyDio = Dio(baseOptions);
              if (logger is TalkerMapnessLogger) {
                dummyDio.interceptors.add(
                  TalkerDioLogger(
                    talker: (logger as TalkerMapnessLogger).talker,
                    settings: const TalkerDioLoggerSettings(
                      printRequestHeaders: true,
                      printResponseHeaders: true,
                      printResponseData: false,
                    ),
                  ),
                );
              }
              final options = error.response!.requestOptions;

              // Add new refresh token to headers
              final token = await ref.read(tokenProvider.future);
              if (token.isEmpty) {
                handler.reject(error);
              }

              final headers = options.headers;
              headers['Authorization'] = 'Bearer $token';
              final response = await dummyDio.request(
                options.path,
                data: options.data,
                queryParameters: options.queryParameters,
                options: Options(
                  method: options.method,
                  headers: headers,
                ),
              );
              handler.resolve(response);
            }
            // ignore: avoid_catches_without_on_clauses
          } catch (e) {
            if (e is DioException) {
              handler.reject(e);
            } else {
              handler.reject(error);
            }
          }

          handler.next(error);
        },
      );
}
