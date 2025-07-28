import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/features/app_feedback/device_info_provider.dart';
import 'package:mapness/shared/providers/analytic/models/bss_common.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/map_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:uuid/uuid.dart';

part 'bss_service.g.dart';

@riverpod
class BssService extends _$BssService {
  static Dio? _dio;
  int ordinalId = 0;
  BssCommon? common;

  @override
  Future<void> build() async {
    final baseDio = await ref.read(dGisHttpService.future);
    final env = await ref.read(dgisEnvironmentProvider.future);

    await _createCommon();

    _dio = Dio(baseDio.options.copyWith(
      baseUrl: env.bssApi,
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

    ref.onDispose(() {
      _dio?.close();
      _dio = null;
    });
  }

  Future<void> _createCommon() async {
    final locale = ref.read(appLanguageProvider).languageCode;
    final deviceInfo = await ref.read(deviceInfoProvider.future);
    final packageInfo = await PackageInfo.fromPlatform();

    final isIOS = deviceInfo.mobileOS == AppFeedbackMobileOs.ios;
    final product = isIOS ? 87 : 86;

    common = BssCommon(
      appVersion: packageInfo.version,
      appInstanceId: deviceInfo.deviceId ?? 'unknown',
      product: product,
      sessionId: const Uuid().v4(),
      user: deviceInfo.authId ?? deviceInfo.deviceId ?? 'unknown',
      deviceLocale: locale,
    );
  }

  Future<void> updateSessionId() async {
    final sessionId = const Uuid().v4();
    common = common?.copyWith(sessionId: sessionId);
  }

  Future<void> sendEvent(BssRequest request) async {
    final searchRect = ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect;
    try {
      final dio = _dio;
      if (dio == null) {
        throw StateError('BssService has not been initialized. Call initialize() first.');
      }
      if (common == null) {
        throw StateError('BssService has not been initialized. Call initialize() first.');
      }
      final requestJson = request.toJson(
        eventOrdinal: ordinalId,
        common: common!,
        map: searchRect?.toBssMap() ?? emptyBssMap,
      );
      await dio.post('/bss/3', data: requestJson);
      ordinalId++;
    } catch (e) {
      debugPrint('Error sending event: $e');
    }
  }
}
