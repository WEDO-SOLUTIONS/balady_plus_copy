import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/shared/providers/saudi_day_splash.dart';

/// @deprecated Use [ThemeSplashGuard] instead.
///
/// This guard is deprecated and will be removed in a future release.
/// It has been replaced by the generic [ThemeSplashGuard] which handles
/// splash screens for all themed modes centrally.
///
/// **Migration:**
/// Replace `SaudiDaySplashGuard(ref)` with `ThemeSplashGuard(ref)` in your route guards.
///
/// See: /mapness/lib/app/auto_route/guards/theme_splash_guard.dart
@Deprecated('Use ThemeSplashGuard instead. Will be removed in next release.')
final class SaudiDaySplashGuard extends AutoRouteGuard {
  const SaudiDaySplashGuard(this.ref);

  final Ref ref;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (!SaudiNationalDay.isNow()) {
      resolver.next();
      return;
    }
    // Check if Saudi Day splash has been shown
    if (!ref.read(saudiDaySplashProvider)) {
      // This Screen not in the project

      // Show Saudi Day splash
      resolver.redirectUntil(
        SaudiDaySplashRoute(
          onClose: () {
            ref.read(saudiDaySplashProvider.notifier).setIsSaudiDayShown(isSaudiDayShown: true);
            resolver.resolveNext(true, reevaluateNext: false);
          },
        ),
      );
    } else {
      // Both onboarding and Saudi Day have been shown, continue to home page
      resolver.next();
    }
  }
}
