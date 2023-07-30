import 'package:flutter/material.dart' show GlobalKey, NavigatorState;

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> bottomNavKey = GlobalKey<NavigatorState>();

  static Future? pushNamed({required String routeName, Object? args}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: args);
  }

  static void goBack() {
    navigatorKey.currentState!.pop();
  }
}
