import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Routes every provider failure into [logger].
///
/// Without an observer, a provider that throws during `build` - or an
/// `AsyncNotifier` whose future emits an error - fails silently unless some
/// widget happens to be watching it and rendering the error state. That makes
/// provider-level breakage invisible in release builds, which is precisely how
/// a screen ends up stuck with no visible cause.
///
/// Registered once on the root [ProviderScope] in `entry_point.dart`.
final class ProviderErrorObserver extends ProviderObserver {
  const ProviderErrorObserver();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    logger.log(
      'provider "${context.provider.name ?? context.provider.runtimeType}" failed: $error\n$stackTrace',
      logLevel: MapnessLogLevel.error,
    );
  }
}
