import 'package:dio/dio.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class BssService {
  static BssService? _instance;
  static Dio? _dio;
  static bool _isInitialized = false;

  // Private constructor to prevent instantiation
  BssService._();

  // Singleton instance getter
  static BssService get instance {
    _instance ??= BssService._();
    return _instance!;
  }

  // Initialize method
  static Future<void> initialize({
    required Dio baseDio,
    required String bssApi,
  }) async {
    if (_isInitialized) {
      return; // Already initialized
    }

    _dio = Dio(baseDio.options.copyWith(
      baseUrl: bssApi,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
    ));

    _dio?.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
        ),
      ),
    );

    _isInitialized = true;
  }

  static Future<void> sendEvent(BssRequest request) async {
    final dio = instance.dio;
    if (dio == null) {
      throw StateError('BssService has not been initialized. Call initialize() first.');
    }
    await dio.post('/bss/3', data: request.toJson());
  }

  // Get the Dio instance
  Dio? get dio {
    if (!_isInitialized) {
      throw StateError('BssService has not been initialized. Call initialize() first.');
    }
    return _dio;
  }

  // Check if service is initialized
  bool get isInitialized => _isInitialized;

  // Dispose method to clean up resources
  static void dispose() {
    _dio?.close();
    _dio = null;
    _isInitialized = false;
  }

  // Reset instance (useful for testing)
  static void reset() {
    dispose();
    _instance = null;
  }
}
