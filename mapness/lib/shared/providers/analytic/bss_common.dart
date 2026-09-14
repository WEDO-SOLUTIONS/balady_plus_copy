import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/features/app_feedback/device_info_provider.dart';
import 'package:mapness/shared/providers/analytic/models/bss_common.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'bss_common.g.dart';

@riverpod
Future<BssCommon> bssCommon(Ref ref) async {
  // According to data we have to use this IDs for Balady product (instead of 86 and 87 for iOS and Android for 2GIS)
  const iOSProductId = 88;
  const androidProductId = 89;

  final languageCode = ref.watch(appLanguageProvider).languageCode;
  final deviceInfo = await ref.read(deviceInfoProvider.future);
  final packageInfo = await PackageInfo.fromPlatform();

  final isIOS = deviceInfo.mobileOS == AppFeedbackMobileOs.ios;
  final product = isIOS ? iOSProductId : androidProductId;

  return BssCommon(
    appVersion: packageInfo.version,
    appInstanceId: deviceInfo.deviceId ?? 'unknown',
    product: product,
    sessionId: const Uuid().v4(),
    user: deviceInfo.authId ?? deviceInfo.deviceId ?? '',
    deviceLocale: languageCode,
  );
}
