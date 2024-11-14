import 'package:smart_advisor/app/features/details/presentation/pages/new_details.dart';
import 'package:smart_advisor/app/features/details/presentation/pages/regulations_page.dart';
import 'package:smart_advisor/app/features/home_page/presentation/pages/new_home_page.dart';

import '../../features/details/presentation/pages/violation_page.dart';
import '../../features/select_activity/presentation/pages/main_flow_page.dart';
import '../../features/self_rating/presentation/pages/ratings_page.dart';
import '/app/features/details/presentation/pages/entity_details.dart';
import '/app/features/fees_calculator/domain/entities/fees_calculator_response.dart';
import '/app/features/documents/Appendix_No1.dart';
import '/app/features/documents/commercial_condition_regulation.dart';
import '/app/features/map/presentation/pages/area_page.dart';
import '/app/features/map/presentation/pages/map_page.dart';
import '/app/features/qr_scan/presentation/pages/qr_scan_page.dart';
import '/app/features/select_activity/domain/entities/activites_page_params.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/select_activity/domain/entities/categories_page_params.dart';
import '/app/features/select_activity/domain/entities/isics_page_params.dart';
import '/app/features/select_activity/presentation/pages/categories_page.dart';
import '/app/features/select_activity/presentation/pages/sectors_page.dart';
import '/app/features/onboarding/pages/onbordingPage.dart';
import 'package:flutter/material.dart'
    show MaterialPageRoute, Route, RouteSettings, Widget, WidgetBuilder;
import 'package:flutter/widgets.dart' show SizedBox;

import '../../core/utils/utils_exports.dart' show RouteName;

import '../../features/bottom_navigation/bottom_navigation_exports.dart'
    show BottomNavigationPage;
import '../../features/fees_calculator/presentation/pages/result_page.dart';
import '../../features/home_page/presentation/pages/homePage.dart';
import '../../features/select_activity/presentation/pages/activites_page.dart';
import '../../features/select_activity/presentation/pages/addetional_activities_page.dart';
import '../../features/select_activity/presentation/pages/isics_page.dart';
import '../../features/select_activity/presentation/pages/permits_page.dart';
import '../../features/splash/splash_exports.dart' show SplashPage;

class AppRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      // splash page
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      // bottom-navigation-bar page
      case RouteName.bottomNavigation:
        return MaterialPageRoute(builder: (_) => const BottomNavigationPage());

      // Home Page
      case RouteName.home:
        return MaterialPageRoute(builder: (_) => const NewHomePage());

      // Sectors Page
      case RouteName.sectors:
        return MaterialPageRoute(builder: (_) => const SectorsPage());

      //onbording
      case RouteName.onbording:
        return MaterialPageRoute(builder: (_) => const NewHomePage());

      //Categories Page
      case RouteName.categoriesPage:
        CategoriesPageParams args = settings.arguments as CategoriesPageParams;
        return MaterialPageRoute(
            builder: (_) => CategoriesPage(
                  args: args,
                ));

      //Isics Page
      case RouteName.isicsPage:
        IsicsPageParams args = settings.arguments as IsicsPageParams;
        return MaterialPageRoute(
            builder: (_) => IsicsPage(
                  args: args,
                ));

      //Activites Page
      case RouteName.activitesPage:
        ActivitesPageParams args = settings.arguments as ActivitesPageParams;
        return MaterialPageRoute(
            builder: (_) => ActivitesPage(
                  args: args,
                ));

      //Addetional Activites Page
      case RouteName.addetionalActivitesPage:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return MaterialPageRoute(
            builder: (_) => AddetionalActivitesPage(
                  params: args,
                ));

      //Permits Page
      case RouteName.permitsPage:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return MaterialPageRoute(
            builder: (_) => PermitsPage(
                  args: args,
                ));

      case RouteName.mapPage:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return MaterialPageRoute(
            builder: (_) => MapPage(
                  args: args,
                ));

      case RouteName.areaPage:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return MaterialPageRoute(
            builder: (_) => AreaPage(
                  params: args,
                ));

      case RouteName.activityDetails:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return MaterialPageRoute(
            builder: (_) => EntityDetails(
                  args: args,
                ));

      case RouteName.calculatorResultsPage:
        FeesCalculatorResponse args =
            settings.arguments as FeesCalculatorResponse;
        return MaterialPageRoute(
            builder: (_) => CalculatorResultPage(
                  args: args,
                ));

      case RouteName.qrDetails:
        return MaterialPageRoute(builder: (_) => QrScanPage());

      case RouteName.AppendixNo1:
        return MaterialPageRoute(builder: (_) => const AppendixNo1());

      case RouteName.CommercialConditionRegulation:
        return MaterialPageRoute(
            builder: (_) => const CommercialConditionRegulation());

      case RouteName.mainFlowPage:
        return MaterialPageRoute(builder: (_) => const MainFlowPage());

      case RouteName.violationPage:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return MaterialPageRoute(
            builder: (_) => ViolationPage(
                  args: args,
                ));

      case RouteName.regulationPage:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return MaterialPageRoute(
            builder: (_) => RegulationsPage(
                  args: args,
                ));

      case RouteName.newDetails:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return MaterialPageRoute(builder: (_) => NewDetails(args: args));

      case RouteName.ratingItemsPage:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return MaterialPageRoute(builder: (_) => RatingItemsPage(args: args));

      // error page
      default:
        return MaterialPageRoute(builder: (_) => const SizedBox());
    }
  }

  static WidgetBuilder getRoutes(RouteSettings settings) {
    switch (settings.name) {
      // splash page
      case RouteName.splash:
        return (context) => const SplashPage();
      // bottom-navigation-bar page
      case RouteName.bottomNavigation:
        return (context) => const BottomNavigationPage();

      // Home Page
      case RouteName.home:
        return (context) => const NewHomePage();

      // Sectors Page
      case RouteName.sectors:
        return (context) => const SectorsPage();

      //onbording
      case RouteName.onbording:
        return (context) => const Onbordingpage();

      //Categories Page
      case RouteName.categoriesPage:
        CategoriesPageParams args = settings.arguments as CategoriesPageParams;
        return (context) => CategoriesPage(
              args: args,
            );

      //Isics Page
      case RouteName.isicsPage:
        IsicsPageParams args = settings.arguments as IsicsPageParams;
        return (context) => IsicsPage(
              args: args,
            );

      //Activites Page
      case RouteName.activitesPage:
        ActivitesPageParams args = settings.arguments as ActivitesPageParams;
        return (context) => ActivitesPage(
              args: args,
            );

      //Addetional Activites Page
      case RouteName.addetionalActivitesPage:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return (context) => AddetionalActivitesPage(
              params: args,
            );

      //Permits Page
      case RouteName.permitsPage:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return (context) => PermitsPage(
              args: args,
            );

      case RouteName.mapPage:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return (context) => MapPage(
              args: args,
            );

      case RouteName.areaPage:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return (context) => AreaPage(
              params: args,
            );

      case RouteName.activityDetails:
        ActivityDetailsPageParams args =
            settings.arguments as ActivityDetailsPageParams;
        return (context) => EntityDetails(
              args: args,
            );

      case RouteName.calculatorResultsPage:
        FeesCalculatorResponse args =
            settings.arguments as FeesCalculatorResponse;
        return (context) => CalculatorResultPage(
              args: args,
            );

/*
      case RouteName.qrDetails:
        return MaterialPageRoute(builder: (_) => QrScanPage());
*/
      case RouteName.AppendixNo1:
        return (context) => const AppendixNo1();

      case RouteName.CommercialConditionRegulation:
        return (context) => const CommercialConditionRegulation();

      case RouteName.mainFlowPage:
        return (context) => const MainFlowPage();

      // error page
      default:
        return (context) => const SizedBox();
    }
  }
}
