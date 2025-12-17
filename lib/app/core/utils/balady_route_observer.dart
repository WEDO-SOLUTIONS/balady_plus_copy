import 'package:flutter/material.dart';

/// Singleton navigation observer that tracks when routes are NOT mapness screens.
///
/// This observer checks if the current route name exists in Routes.routes()
/// or RouteName constants. If a match is found, it emits a notification
/// indicating that the current screen is NOT a mapness screen.
class BaladyRouteObserver extends RouteObserver<ModalRoute<void>> {
  static final BaladyRouteObserver _instance = BaladyRouteObserver._internal();

  factory BaladyRouteObserver() => _instance;

  BaladyRouteObserver._internal();

  static const String _loginScreenRouteName = '/loginScreen';
  static bool _loginScreenPopped = false;
  static bool get loginScreenPopped => _loginScreenPopped;

  bool _isRouteBaladyLoginScreen(String routeName) {
    return routeName == _loginScreenRouteName;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    // When popping, check the previous route (which becomes current)
    final prevRouteName = previousRoute?.settings.name;
    final currentRouteName = route.settings.name;

    if (currentRouteName != null) {
      final isCurrentRouteIsBaladyLoginScreen = _isRouteBaladyLoginScreen(currentRouteName);
      final isPreviousRouteIsBaladyLoginScreen =
          prevRouteName != null ? _isRouteBaladyLoginScreen(prevRouteName) : false;
      _loginScreenPopped = isCurrentRouteIsBaladyLoginScreen && !isPreviousRouteIsBaladyLoginScreen;
    }
  }
}
