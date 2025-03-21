import 'package:dio/dio.dart';
import 'package:mapness/_features/lifestyle_layers/data/common_function.dart';

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

      handler.next(modifiedOptions);
    }

    handler.next(options);
  }
}
