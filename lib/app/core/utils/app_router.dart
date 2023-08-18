import 'package:flutter/material.dart'
    show AppBar, Center, MaterialPageRoute, Route, RouteSettings, Scaffold;
import 'package:flutter/widgets.dart';

import '../../core/utils/utils_exports.dart'
    show RouteName, ScaleRotatePage, SliderUpPage;
import '../../features/_shared_feature_/presentation/pages/view_dms_image_screen.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart';
import '../../features/_shared_feature_/data/entities/success_screen_args.dart';
import '../../features/_shared_feature_/presentation/pages/success_screen.dart';
import '../../features/bottom_navigation/bottom_navigation_exports.dart'
    show BottomNavigationPage;
import '../../features/map_page/data/model/investment_details_response.dart';
import '../../features/map_page/data/model/rental_details_response.dart';
import '../../features/map_page/presentation/mvvm/point_view_model.dart';
import '../../features/map_page/presentation/pages/map_details_page.dart';
import '../../features/services/services_exports.dart'
    show ServiceCardsPage, ServiceEntity;
import '../../features/splash/splash_exports.dart' show SplashPage;
import '../../features/weather/presentation/pages/weather_main_page.dart';

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

      //! Setting
      // personalInformation page

      case RouteName.successRoute:
        final args = settings.arguments as SuccessScreenArgs;
        return MaterialPageRoute(
          builder: (_) => SuccessScreen(
            successScreenArgs: args,
          ),
        );

      case RouteName.weatherMainPage:
        return MaterialPageRoute(
          builder: (_) => const WeatherMainPage(),
        );

      case RouteName.investmentPage:
        InvestmentDetailsResponse? data =
            settings.arguments as InvestmentDetailsResponse?;
        return MaterialPageRoute(
          builder: (_) => Container(),
        );
      case RouteName.tempRentalPage:
        RentalDetailsResponse? data =
            settings.arguments as RentalDetailsResponse?;

        return MaterialPageRoute(
          builder: (_) => Container(),
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
