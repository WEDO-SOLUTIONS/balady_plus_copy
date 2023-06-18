import 'package:flutter/material.dart'
    show MaterialPageRoute, Route, RouteSettings;
import 'package:flutter/widgets.dart' show SizedBox;

import '../../core/utils/utils_exports.dart'
    show RouteName, ScaleRotatePage, SliderUpPage;
import '../../features/authentication/sign_in/sign_in_exports.dart'
    show SignInPage;
import '../../features/bottom_navigation/bottom_navigation_exports.dart'
    show BottomNavigationPage;
import '../../features/entry_point/entry_point_exports.dart' show SsoUserInfo;
import '../../features/component_test/presentation/pages/components_test_page.dart';
import '../../features/facility_qr/facility_qr_exports.dart';
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

      //! Services
      case RouteName.serviceCards:
        return MaterialPageRoute(
          builder: (_) => ServiceCardsPage(
            service: settings.arguments as ServiceEntity,
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
          builder: (_) => ComponentTest(),
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

// QR

      case RouteName.qrFacilityRatingRoute:
        return MaterialPageRoute(
          builder: (_) => FacilityRatingScreen(),
        );

      case RouteName.qrFacilityScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const FacilityScreen(),
        );

      case RouteName.qrScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const QrScreen(),
        );

      case RouteName.qrPhotosRoute:
        return MaterialPageRoute(
          builder: (_) => const FacilityPhotosScreen(),
        );

      case RouteName.qrRatingRoute:
        return MaterialPageRoute(
          builder: (_) => FacilityRatingScreen(),
        );
      // error page
      default:
        return MaterialPageRoute(builder: (_) => const SizedBox());
    }
  }
}
