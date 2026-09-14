import 'package:balady_plus/app/features/force_update/presentation/pages/force_update_page.dart';
import 'package:balady_plus/app/features/notifications/presentation/pages/notifications_details_screen.dart';
import 'package:balady_plus/app/features/notifications/presentation/pages/notifications_list_screen.dart';
import 'package:balady_plus/app/features/splash/presentation/pages/splash_page.dart';
import 'package:balady_plus/app/features/volunteer_profile/injection/volunteer_profile_injection.dart';
import 'package:balady_plus/app/features/weather/presentation/pages/weather_main_page.dart';
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
import '../../../super_app_js_bridge/camera/camera_page.dart';
import '../../core/utils/utils_exports.dart' show RouteName;
import '../../features/_shared_feature_/presentation/pages/qiblah_webview_page.dart';
import '../../features/events/presentation/pages/events_main_page.dart';
import '../../features/events/presentation/pages/single_image_page.dart';
import '../../features/_shared_feature_/presentation/pages/view_dms_image_screen.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart';
import '../../features/_shared_feature_/presentation/pages/success_screen.dart';
import '../../features/bottom_navigation/bottom_navigation_exports.dart' as b;
import '../../features/public_services_features/prayer_times/prayer_times_exports.dart'
    show PrayerTimesPage;


import '../../features/public_services_features/prayer_times/presentation/pages/prayer_times_page.dart';

import '../../features/volunteer_profile/presentation/bloc/volunteer_profile_bloc.dart';
import '../../features/volunteer_profile/presentation/screens/volunteer_profile_editing_screen.dart';
import '../../features/volunteer_profile/presentation/screens/volunteer_profile_screen.dart';
import '../../features/weather/weather_exports.dart';

import 'package:balady_authorization/src/shared/authentication_routes/authentication_routes.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> etmamRoutes = {
    //! Etmam Start
    // Success Page




//! Etmam End
  };
  static Map<String, Widget Function(BuildContext)> routesApp = {
    RouteName.bottomNavigation: (context) => const b.BottomNavigationPage(),
    RouteName.splashScreen: (context) => const SplashPage(),
    RouteName.vdCameraPage: (context) => const VDCameraPage(),



    RouteName.forceUpdateRoute: (context) => const ForceUpdatePage(),


    RouteName.inappWebview: (context) => const InAppWebViewPage(),

    RouteName.dmsImageFullScreen: (context) => const ViewDMSImageScreen(),
    // RouteName.serviceCards: (context) => const ServiceCardsPage(),

    //? General Services

    RouteName.prayerTimes: (context) => const PrayerTimesPage(),

    RouteName.qiblahCompass: (context) => const QiblahWebViewPage(),

    //? personalInformation page



    RouteName.successRoute: (context) => const SuccessScreen(),
    // ------ Commercial License -----

    // ------ Wallet -----


    RouteName.weatherMainPage: (context) => const WeatherMainPage(),

    RouteName.eventsMainPage: (context) => const EventsMainPage(),

    RouteName.eventsDetailsPage: (context) =>
        const SingleEventDescriptionPage(),

    RouteName.notificationsListScreen: (context) =>
        const NotificationsListScreen(),
    RouteName.notificationsDetailsScreen: (context) =>
        const NotificationsDetailsScreen(),
    RouteName.miniAppsMainScreen: (context) =>
    const MiniAppsMainScreen(),

    RouteName.VolunteerProfile: (context) =>
     VolunteerProfileScreen(
      volunteerProfileBloc:
      slVolunteer<VolunteerProfileBloc>(),
    ),
    RouteName.VolunteerEditProfile: (context) =>
        VolunteerProfileEditingScreen(
          volunteerProfileBloc:
          slVolunteer<VolunteerProfileBloc>(),
        ),








  };

  static Map<String, Widget Function(BuildContext)> routes() {
    Map<String, Widget Function(BuildContext)> all = {};
    all.addAll(routesApp);
    all.addAll(etmamRoutes);
    // all.addAll(CommercialRoutes.routes);
    all.addAll(AuthenticationRoutes.routes);
    // all.addAll(ClassificationCertificateRoutes.routes);
    // all.addAll(HomeServicesRoutes.routes);
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
