import 'package:flutter/material.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

@riverpod
// ignore: unsupported_provider_value
GoRouter goRouter(GoRouterRef ref, List<Widget> routes) {
  final router = GoRouter(
    initialLocation: '/landing',
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: $appRoutes,
  );
  router.routerDelegate.addListener(() {
    router.routerDelegate.currentConfiguration.fullPath;

    Future.delayed(
      Duration.zero,
      () {
        ref.read(currentRouteProvider.notifier).update(
            router.routerDelegate.currentConfiguration.last.matchedLocation);
      },
    );
  });

  return router;
}
