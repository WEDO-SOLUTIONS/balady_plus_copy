import 'package:flutter/material.dart'
    show AppBar, Center, MaterialPageRoute, Route, RouteSettings, Scaffold;
import 'package:flutter/widgets.dart' show SizedBox;

import '../../core/utils/utils_exports.dart'
    show RouteName, ScaleRotatePage, SliderUpPage;
import '../../features/_shared_feature_/presentation/pages/view_dms_image_screen.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart';
import '../../features/_shared_feature_/data/entities/success_screen_args.dart';
import '../../features/_shared_feature_/presentation/pages/success_screen.dart';
import '../../features/bottom_navigation/bottom_navigation_exports.dart'
    show BottomNavigationPage;
import '../../features/entry_point/entry_point_exports.dart' show SsoUserInfo;

import '../../features/profile_features/dashboard/dashboard_exports.dart'
    show DashBoardPage;
import '../../features/profile_features/invoices/invoices_exports.dart'
    show InvoicesPage;
import '../../features/profile_features/licenses/licenses_exports.dart'
    show LicensesPage;
import '../../features/profile_features/personal_information/personal_information_exports.dart'
    show PersonalInformationPage;
import '../../features/profile_features/requests/requests_exports.dart'
    show RequestsPage;
import '../../features/public_services_features/prayer_times/prayer_times_exports.dart'
    show PrayerTimesCubit, PrayerTimesPage;
import '../../features/public_services_features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../../features/services/services_exports.dart'
    show ServiceCardsPage, ServiceEntity;
import '../../features/splash/splash_exports.dart' show SplashPage;
import '../../features/vd/vd_exports.dart';

class AppRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      // splash page
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case RouteName.inappWebview:
        return MaterialPageRoute(
          builder: (_) => InAppWebViewPage(
            args: settings.arguments as ({String title, String url}),
          ),
        );
      // bottom-navigation-bar page
      case RouteName.bottomNavigation:
        // return MaterialPageRoute(builder: (_) => const BottomNavigationPage());
        return SliderUpPage(page: const BottomNavigationPage());

      case RouteName.dmsImageFullScreen:
        String url = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ViewDMSImageScreen(url: url),
        );
      //! Services
      case RouteName.serviceCards:
        return MaterialPageRoute(
          builder: (_) => ServiceCardsPage(
            service: settings.arguments as ServiceEntity,
          ),
        );
      //? General Services
      case RouteName.prayerTimes:
        return MaterialPageRoute(
          builder: (_) => PrayerTimesPage(
            cubit: settings.arguments as PrayerTimesCubit,
          ),
        );

      //! Setting
      // personalInformation page
      case RouteName.personalInformation:
        return MaterialPageRoute(
          builder: (_) => PersonalInformationPage(
            userInfo: settings.arguments as SsoUserInfo,
          ),
        );
      // dashboard page
      case RouteName.dashboard:
        return MaterialPageRoute(builder: (_) => const DashBoardPage());
      // requests page
      case RouteName.requests:
        return MaterialPageRoute(builder: (_) => const RequestsPage());
      // invoices page
      case RouteName.invoices:
        return MaterialPageRoute(builder: (_) => const InvoicesPage());
      // licenses page
      case RouteName.licenses:
        return MaterialPageRoute(builder: (_) => const LicensesPage());

      // -------  VD ---------
      case RouteName.vdCameraPage:
        CameraParamsPage params = settings.arguments as CameraParamsPage;

        return MaterialPageRoute(
          builder: (_) => VDCameraPage(
            params: params,
          ),
        );
      case RouteName.vdCreateVDDetailsPage:
        // CreateVDParamsPage params = settings.arguments as CreateVDParamsPage;
        return MaterialPageRoute(
          builder: (_) => CreateVDDetailsPage(),
        );

      case RouteName.vdMapRoute:
        MapScreenParams? params = settings.arguments != null
            ? settings.arguments as MapScreenParams
            : null;
        return MaterialPageRoute(
          builder: (_) => VDMapScreen(params: params),
        );
      case RouteName.vdGuestOtpScreen:
        return MaterialPageRoute(
          builder: (_) => VDGuestOtpScreen(),
        );

      case RouteName.successRoute:
        final args = settings.arguments as SuccessScreenArgs;
        return MaterialPageRoute(
          builder: (_) => SuccessScreen(
            successScreenArgs: args,
          ),
        );

      // error page
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
}
