import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/shared/providers/onboarding.dart';

final class OnboardRouteGuard extends AutoRouteGuard {
  const OnboardRouteGuard(this.ref);

  final Ref ref;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (ref.read(onboardingProvider)) {
      resolver.next();
    } else {
      ref.read(appAnalyticsProvider).onboardingFlowStarted();
      resolver.redirectUntil(
        OnboardRoute(
          onClose: () {
            ref.read(onboardingProvider.notifier).setIsOnboardingShown(isOnboardingShown: true);
            resolver.resolveNext(true);
          },
        ),
      );
    }
  }
}
