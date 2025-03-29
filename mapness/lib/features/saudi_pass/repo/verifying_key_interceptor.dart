import 'package:dio/dio.dart';
import 'package:mapness/shared/utils/common_function.dart';

class VerifyingKeyInterceptor extends QueuedInterceptorsWrapper {
  VerifyingKeyInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (!options.headers.containsKey('Authorization')) {
      final uri = options.uri;

      final verifyingKEY = hashRequest(uri.toString(), options.method, body: options.data);

      final modifiedOptions = options.copyWith(
        headers: {...options.headers, 'verifyingKEY': verifyingKEY},
      );

      return handler.next(modifiedOptions);
    }

    handler.next(options);
  }
}
