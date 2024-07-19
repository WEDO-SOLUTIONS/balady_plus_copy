import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/home_shell.dart' as home;
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final appFeatures = ref.watch(appFeaturesProvider);

  final homeRoute = home.homeShellRoute(naviEnabled: appFeatures.naviEnabled);

  final router = GoRouter(
    initialLocation: '/landing',
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      homeRoute,
      ...$appRoutes,
    ],
  );
  router.routerDelegate.addListener(() {
    Future.delayed(
      Duration.zero,
      () {
        ref.read(currentRouteProvider.notifier).update(
              router.routerDelegate.currentConfiguration.last.matchedLocation,
            );
        ref.read(urbiAnalyticsProvider).screen(router.routerDelegate.currentConfiguration.last.matchedLocation);
      },
    );
  });

  return router;
}
