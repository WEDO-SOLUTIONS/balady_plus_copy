import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart' show GlobalKey, NavigatorState, Route;

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> bottomNavKey = GlobalKey<NavigatorState>();

  static Future? pushNamed({required String routeName, Object? args}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: args);
  }

  static Future<dynamic> pushAndReplaceForceUpdate() {
    return navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(RouteName.forceUpdateRoute, (Route<dynamic> route) => true) ??
        Future.value(true);
  }

  static void goBack() {
    navigatorKey.currentState!.pop();
  }
}
