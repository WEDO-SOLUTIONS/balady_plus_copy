import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/shared/providers/saudi_day_splash.dart';

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
      // Show Saudi Day splash
      resolver.redirect(
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
