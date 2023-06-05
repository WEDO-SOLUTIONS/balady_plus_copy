import 'package:flutter/material.dart'
    show MaterialPageRoute, Route, RouteSettings;
import 'package:flutter/widgets.dart' show SizedBox;

import '../../core/utils/utils_exports.dart'
    show RouteName, ScaleRotatePage, SliderUpPage;
import '../../features/authentication/sign_in/sign_in_exports.dart'
    show SignInPage;
import '../../features/bottom_navigation/bottom_navigation_exports.dart'
    show BottomNavigationPage;
import '../../features/splash/splash_exports.dart' show SplashPage;

class AppRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      // splash page
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      // sign-in page
      case RouteName.signIn:
        // return MaterialPageRoute(builder: (_) => const SignInPage());
        return ScaleRotatePage(page: const SignInPage());
      // sign-up page
      case RouteName.signUp:
        return MaterialPageRoute(builder: (_) => const SizedBox());
      // otp page
      case RouteName.otp:
        return MaterialPageRoute(builder: (_) => const SizedBox());
      // bottom-navigation-bar page
      case RouteName.bottomNavigation:
        // return MaterialPageRoute(builder: (_) => const BottomNavigationPage());
        return SliderUpPage(page: const BottomNavigationPage());
      // error page
      default:
        return MaterialPageRoute(builder: (_) => const SizedBox());
    }
  }
}
