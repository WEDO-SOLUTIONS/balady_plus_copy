/*import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/faq.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/services_page_params.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        PreviousWorksDetailsPage,
        PreviousWorksPage,
        SuccessScreen,
        SuccessScreenArgs;
import 'package:balady_plus/etmam_app/features/bottom_navigation/bottom_navigation_exports.dart'
    show BottomNavigationPage;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        HomePage,
        MainServiceResponse,
        MainServicesPage,
        SubServicePageArgs,
        SubServicesPage;
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show
        EvaluateOrderPage,
        OrderDetailsPage,
        OrderDetailsPageParams,
        OrdersPage,
        RatingPageParams;
import 'package:balady_plus/etmam_app/features/on_boarding_cities/presentation/pages/on_boarding_cities_page.dart';
import 'package:balady_plus/etmam_app/features/otp/otp_exports.dart'
    show OTPPageParams, OtpScreen;
import 'package:balady_plus/etmam_app/features/profile/profile_exports.dart'
    show HelpPage, PersonalInfoPage;
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show ProviderDetailsPage, ProviderDetailsResponse, ProvidersPage;
import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show SearchPage;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show
        Branch,
        BranchesMapPage,
        FaqPage,
        OfficeInfoPage,
        Project,
        Provider,
        ServiceDetailsPage,
        ServiceDetailsResponse,
        ServicesPage;
import 'package:balady_plus/etmam_app/features/splash/splash_exports.dart'
    show SplashPage;
import 'package:balady_plus/etmam_app/features/submit_request/data/models/relation/provider_relation_page_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_page_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart';
import 'package:flutter/material.dart'
    show MaterialPageRoute, Route, RouteSettings;
import 'package:flutter/widgets.dart' show SizedBox;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show RouteName;

class AppRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      // splash page
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      // bottom-navigation-bar page
      case RouteName.bottomNavigation:
        return MaterialPageRoute(builder: (_) => const BottomNavigationPage());

      // home page
      case RouteName.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      // search page
      case RouteName.searchPage:
        return MaterialPageRoute(builder: (_) => const SearchPage());

      // Main Services Page
      case RouteName.mainServicesPage:
        final MainServiceResponse resopnse =
            settings.arguments as MainServiceResponse;
        return MaterialPageRoute(
            builder: (_) => MainServicesPage(
                  mainServiceResponse: resopnse,
                ));

      // Sub Services Page
      case RouteName.subServicesPage:
        final SubServicePageArgs resopnse =
            settings.arguments as SubServicePageArgs;
        return MaterialPageRoute(
            builder: (_) => SubServicesPage(
                  subServicePageArgs: resopnse,
                ));

      // Providers By Service
      case RouteName.providersByService:
        final ServicePageParams args = settings.arguments as ServicePageParams;
        // final ServiceResponse resopnse = settings.arguments as ServiceResponse;
        return MaterialPageRoute(
            builder: (_) => ServicesPage(
                  args: args,
                ));
      case RouteName.serviceProvidersDetails:
        final ServiceDetailsResponse response =
            settings.arguments as ServiceDetailsResponse;
        return MaterialPageRoute(
            builder: (_) =>
                ServiceDetailsPage(serviceDetailsResponse: response));
      case RouteName.faqPage:
        List<Faq> faqList = settings.arguments as List<Faq>;
        return MaterialPageRoute(
            builder: (_) => FaqPage(
                  faqList: faqList,
                ));
      case RouteName.officeInfoPage:
        Provider args = settings.arguments as Provider;
        return MaterialPageRoute(
            builder: (_) => OfficeInfoPage(
                  provider: args,
                ));
      case RouteName.branchesMapPage:
        final List<Branch> args = settings.arguments as List<Branch>;
        return MaterialPageRoute(
            builder: (_) => BranchesMapPage(
                  branches: args,
                ));

      case RouteName.providersDetails:
        ProviderDetailsResponse args =
            settings.arguments as ProviderDetailsResponse;
        return MaterialPageRoute(
            builder: (_) => ProviderDetailsPage(
                  args: args,
                ));

      // on boarding
      case RouteName.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingCitiesPage());

      // Submit Request
      case RouteName.relationsList:
        RelationPageParam args = settings.arguments as RelationPageParam;

        return MaterialPageRoute(
            builder: (_) => RelationRequestPage(
                  args: args,
                ));

      case RouteName.providersListPage:
        //ProviderResponse response = settings.arguments as ProviderResponse;
        return MaterialPageRoute(
            builder: (_) => ProvidersPage(
                //  providerResponse: response,
                ));

      case RouteName.previousWorksPage:
        List<Project>? projects = settings.arguments as List<Project>?;
        return MaterialPageRoute(
            builder: (_) => PreviousWorksPage(
                  projects: projects,
                ));
      case RouteName.previousWorksDetailsPage:
        Project project = settings.arguments as Project;
        return MaterialPageRoute(
            builder: (_) => PreviousWorksDetailsPage(
                  project: project,
                ));

      case RouteName.serviceTypesList:
        final ProviderRelationPageParams args =
            settings.arguments as ProviderRelationPageParams;

        return MaterialPageRoute(
            builder: (_) => ServiceProvidersRelations(args: args));

      case RouteName.orderInfo:
        SubmitPageParams args = settings.arguments as SubmitPageParams;
        return MaterialPageRoute(
            builder: (_) => SubmitRequestPage(
                  args: args,
                ));

      case RouteName.myOrdersPage:
        return MaterialPageRoute(builder: (_) => OrdersPage());
      // Success Page
      case RouteName.successRoute:
        final args = settings.arguments as SuccessScreenArgs;
        return MaterialPageRoute(
          builder: (_) => SuccessScreen(
            successScreenArgs: args,
          ),
        );

      // otp page
      case RouteName.otpRoute:
        final OTPPageParams? args = settings.arguments as OTPPageParams;
        return MaterialPageRoute(
            builder: (_) => OtpScreen(
                  args: args,
                ));

      // orders details page
      case RouteName.orderDetailsRoute:
        OrderDetailsPageParams args =
            settings.arguments as OrderDetailsPageParams;
        return MaterialPageRoute(
            builder: (_) => OrderDetailsPage(
                  args: args,
                ));

      // evaluate order
      case RouteName.evaluateOrderRoute:
        RatingPageParams args = settings.arguments as RatingPageParams;
        return MaterialPageRoute(
            builder: (_) => EvaluateOrderPage(
                  args: args,
                ));

      // personal info
      case RouteName.personalInfoRoute:
        return MaterialPageRoute(builder: (_) => const PersonalInfoPage());

      // help
      case RouteName.helpRoute:
        return MaterialPageRoute(builder: (_) => const HelpPage());

      // error page
      default:
        return MaterialPageRoute(builder: (_) => const SizedBox());
    }
  }
}*/
