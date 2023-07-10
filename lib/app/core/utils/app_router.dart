import 'package:flutter/material.dart'
    show AppBar, Center, MaterialPageRoute, Route, RouteSettings, Scaffold;
import 'package:flutter/widgets.dart' show SizedBox;

import '../../core/utils/utils_exports.dart'
    show RouteName, ScaleRotatePage, SliderUpPage;
import '../../features/_shared_feature_/shared_feature_exports.dart';
import '../../features/authentication/sign_in/sign_in_exports.dart'
    show SignInPage;
import '../../features/bottom_navigation/bottom_navigation_exports.dart'
    show BottomNavigationPage;
import '../../features/entry_point/entry_point_exports.dart' show SsoUserInfo;
import '../../features/municipal_services/municipal_advisor/municipal_advisor_exports.dart'
    show LocationPage, MunicipalAdvisorBloc, MunicipalAdvisorPage;
import '../../features/profile_features/dashboard/dashboard_exports.dart'
    show DashBoardPage;
import '../../features/profile_features/invoices/invoices_exports.dart'
    show InvoiceDetailsPage, InvoiceEntity, InvoicesPage;
import '../../features/profile_features/licenses/licenses_exports.dart'
    show LicensesPage;
import '../../features/profile_features/personal_information/personal_information_exports.dart'
    show PersonalInformationPage;
import '../../features/profile_features/requests/requests_exports.dart'
    show RequestsPage;
import '../../features/public_services_features/prayer_times/prayer_times_exports.dart'
    show PrayerTimesCubit, PrayerTimesPage;
import '../../features/public_services_features/qiblah_compass/qiblah_compass_exports.dart'
    show QiblahCompassPage;
import '../../features/services/services_exports.dart'
    show ServiceCardsPage, ServiceEntity;
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
      case RouteName.qiblahCompass:
        return MaterialPageRoute(
          builder: (_) => const QiblahCompassPage(),
        );
      //? Municipal Services
      case RouteName.municipalAdvisor:
        return MaterialPageRoute(
          builder: (_) => const MunicipalAdvisorPage(),
        );
      case RouteName.locationPage:
        return MaterialPageRoute(
          builder: (_) => LocationPage(
            bloc: settings.arguments as MunicipalAdvisorBloc,
          ),
        );

      //! Setting
      //? personalInformation page
      case RouteName.personalInformation:
        return MaterialPageRoute(
          builder: (_) => PersonalInformationPage(
            userInfo: settings.arguments as SsoUserInfo,
          ),
        );
      //? dashboard page
      case RouteName.dashboard:
        return MaterialPageRoute(builder: (_) => const DashBoardPage());
      //? requests page
      case RouteName.requests:
        return MaterialPageRoute(builder: (_) => const RequestsPage());
      //? invoices page
      case RouteName.invoices:
        return MaterialPageRoute(builder: (_) => const InvoicesPage());
      case RouteName.invoiceDetails:
        return MaterialPageRoute(
          builder: (_) => InvoiceDetailsPage(
            invoiceEntity: settings.arguments as InvoiceEntity,
          ),
        );
      //? licenses page
      case RouteName.licenses:
        return MaterialPageRoute(builder: (_) => const LicensesPage());
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
}
