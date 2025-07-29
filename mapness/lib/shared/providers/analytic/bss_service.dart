import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/features/app_feedback/device_info_provider.dart';
import 'package:mapness/shared/providers/analytic/models/bss_common.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/map_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:uuid/uuid.dart';

part 'bss_service.g.dart';

class BssService {
  static BssService? _instance;
  static Dio? _dio;

  int ordinalId = 0;
  BssCommon? common;
  bool _isInitialized = false;

  // Private constructor for Singleton
  BssService._();

  // Singleton instance getter
  // ignore: prefer_constructors_over_static_methods
  static BssService get instance {
    _instance ??= BssService._();
    return _instance!;
  }

  // Initialize the service
  Future<void> initialize({
    required Dio baseDio,
    required String bssApi,
    required String languageCode,
    required AppFeedbackContext deviceInfo,
    required PackageInfo packageInfo,
  }) async {
    if (_isInitialized) {
      return;
    }

    await _createCommon(
      languageCode: languageCode,
      deviceInfo: deviceInfo,
      packageInfo: packageInfo,
    );

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

  Future<void> _createCommon({
    required String languageCode,
    required AppFeedbackContext deviceInfo,
    required PackageInfo packageInfo,
  }) async {
    final isIOS = deviceInfo.mobileOS == AppFeedbackMobileOs.ios;
    final product = isIOS ? 87 : 86;

    common = BssCommon(
      appVersion: packageInfo.version,
      appInstanceId: deviceInfo.deviceId ?? 'unknown',
      product: product,
      sessionId: const Uuid().v4(),
      user: deviceInfo.authId ?? deviceInfo.deviceId ?? 'unknown',
      deviceLocale: languageCode,
    );
  }

  Future<void> updateSessionId() async {
    final sessionId = const Uuid().v4();
    common = common?.copyWith(sessionId: sessionId);
  }

  Future<void> sendEvent(
    BssRequest request, {
    required VisibleRect? visibleRect,
  }) async {
    // Note: This method now requires the controller to be passed from the provider
    // The visible rect should be obtained from the provider's visibleRectSubject
    //final searchRect = null; // TODO: Get from provider's visibleRectSubject

    try {
      final dio = _dio;
      if (dio == null) {
        throw StateError('BssService has not been initialized. Call initialize() first.');
      }
      if (common == null) {
        throw StateError('BssService common data is null. Call initialize() first.');
      }

      final requestJson = request.toJson(
        eventOrdinal: ordinalId,
        common: common!,
        map: visibleRect?.toBssMap() ?? emptyBssMap,
      );
      print('BSS REQUEST: $requestJson');
      await dio.post('/bss/3', data: requestJson);
      ordinalId++;
    } catch (e) {
      debugPrint('Error sending event: $e');
    }
  }

  // Dispose method to clean up resources
  void dispose() {
    _dio?.close();
    _dio = null;
    _isInitialized = false;
    _instance = null;
  }

  // Check if service is initialized
  bool get isInitialized => _isInitialized;
}

// Helper function to initialize BssService with Riverpod dependencies
@riverpod
Future<void> initializeBssService(Ref ref) async {
  final baseDio = await ref.read(dGisHttpService.future);
  final env = await ref.read(dgisEnvironmentProvider.future);
  final languageCode = ref.read(appLanguageProvider).languageCode;
  final deviceInfo = await ref.read(deviceInfoProvider.future);
  final packageInfo = await PackageInfo.fromPlatform();

  await BssService.instance.initialize(
    baseDio: baseDio,
    bssApi: env.bssApi,
    languageCode: languageCode,
    deviceInfo: deviceInfo,
    packageInfo: packageInfo,
  );
}
