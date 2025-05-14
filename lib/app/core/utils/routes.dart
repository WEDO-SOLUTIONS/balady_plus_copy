import 'package:balady_plus/app/features/force_update/presentation/pages/forceUpdatePage.dart';
import 'package:balady_plus/app/features/splash/presentation/pages/splash_page.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_app_pages/mini_apps_main_screen.dart';
import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Center,
        MaterialPageRoute,
        Route,
        RouteSettings,
        Scaffold,
        Widget;

import '../../core/utils/utils_exports.dart' show RouteName;
import '../../features/_shared_feature_/presentation/pages/qiblah_webview_page.dart';
import '../../features/_shared_feature_/presentation/pages/view_apigee_image_screen.dart';
import '../../features/_shared_feature_/presentation/pages/view_dms_image_screen.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart';
import '../../features/_shared_feature_/presentation/pages/success_screen.dart';
import '../../features/bottom_navigation/bottom_navigation_exports.dart' as b;




import 'package:balady_authorization/src/shared/authentication_routes/authentication_routes.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routesApp = {
    RouteName.bottomNavigation: (context) => const b.BottomNavigationPage(),
    RouteName.splashScreen: (context) => const SplashPage(),
    RouteName.forceUpdateRoute: (context) => ForceUpdatePage(),
    RouteName.inappWebview: (context) => const InAppWebViewPage(),
    RouteName.dmsImageFullScreen: (context) => const ViewDMSImageScreen(),
    RouteName.apigeeImageFullScreen: (context) => const ViewAPIGEEImageScreen(),
    RouteName.qiblahCompass: (context) => const QiblahWebViewPage(),
    RouteName.successRoute: (context) => const SuccessScreen(),

    RouteName.miniAppsMainScreen: (context) => const MiniAppsMainScreen(),
  };

  static Map<String, Widget Function(BuildContext)> routes() {
    Map<String, Widget Function(BuildContext)> all = {};
    all.addAll(routesApp);
    all.addAll(AuthenticationRoutes.routes);
    return all;
  }
}

class AppRouter1 {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    Route<dynamic>? route = etmamRoutes(settings);
    if (route != null) return route;
    switch (settings.name) {
      // error page
      //? error page
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const CustomTextWidget("Error"),
            ),
            body: const Center(
              child: CustomTextWidget("Page not found"),
            ),
          ),
        );
    }
  }

  static Route<dynamic>? etmamRoutes(RouteSettings settings) {
    switch (settings.name) {
      // bottom-navigation-bar page
    }
    return null;
  }
}
