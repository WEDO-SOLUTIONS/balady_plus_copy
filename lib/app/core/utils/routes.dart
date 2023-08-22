import 'package:balady_plus/app/features/daem/daem_exports.dart';
import 'package:balady_plus/app/features/commercial_license/commercial_license_exports.dart';
import 'package:balady_plus/app/features/athkar/presentation/pages/athkar_entity_content.dart';
import 'package:balady_plus/app/features/boarding/presentation/pages/boarding_main_page.dart';
import 'package:balady_plus/app/features/boarding/presentation/pages/boarding_pages.dart';
import 'package:balady_plus/app/features/force_update/presentation/pages/forceUpdatePage.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/create_objection_page_params.dart';
import 'package:balady_plus/app/features/objections/domain/entities/objection_details.dart';
import 'package:balady_plus/app/features/profile_features/incidents/presentation/pages/dc_details.dart';
import 'package:balady_plus/app/features/profile_features/incidents/presentation/pages/incident_details.dart';
import 'package:balady_plus/app/features/profile_features/about_balady/presentation/screens/about_balady_screen.dart';
import 'package:balady_plus/app/features/profile_features/help/presentation/screens/contact_information_screen.dart';
import 'package:balady_plus/app/features/profile_features/rate_us/rate_us.dart';
import 'package:balady_plus/app/features/quran/presentation/pages/quran_bookmarks.dart';
import 'package:balady_plus/app/features/quran/quran_exports.dart';
import 'package:balady_plus/app/features/wallet/core/models/wallet_item.dart';
import 'package:balady_plus/app/features/weather/presentation/pages/weather_main_page.dart';
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
import 'package:flutter/widgets.dart' show SizedBox;
import 'package:balady_plus/etmam_app/features/home/presentation/pages/etmam_home_page.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/presentation/pages/etmam_select_city_page.dart';
import '../../../etmam_app/features/home/presentation/pages/etmam_main_page.dart';
import '../../core/utils/utils_exports.dart'
    show
        EtmamRoutesNames,
        RouteName,
        ScaleRotatePage,
        SliderUpPage,
        RouteName,
        ScaleRotatePage,
        SliderUpPage;
import '../../features/_shared_feature_/presentation/pages/qiblah_webview_page.dart';
import '../../features/map_page/data/model/rental_details_response.dart';
import '../../features/qa/presentation/pages/qa_page.dart';
import '../../features/unknow/pages/investment_page.dart';
import '../../features/unknow/pages/temp_rental_page.dart';
import '../../features/_shared_feature_/presentation/pages/view_dms_image_screen.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart';
import '../../features/_shared_feature_/data/entities/success_screen_args.dart';
import '../../features/_shared_feature_/presentation/pages/success_screen.dart';
import '../../features/appointments/presentation/core/models/appointment_details_screen_args.dart';
import '../../features/appointments/presentation/pages/appointment_details_screen.dart';
import '../../features/appointments/presentation/pages/appointments_list_screen.dart';
import '../../features/appointments/presentation/pages/previous_appointments_screen.dart';
import '../../features/bottom_navigation/bottom_navigation_exports.dart' as b;
import '../../features/calculator/presentation/pages/service_calculator_location_screen.dart';
import '../../features/calculator/presentation/pages/service_calculator_screen.dart';
import '../../features/daem/presentation/pages/daem_ticket_page.dart';
import '../../features/athkar/athkar_exports.dart'
    show
        Athkar,
        AthkarEntities,
        AthkarEntitiesParams,
        AthkarEntityContentParams;

import '../../features/entry_point/entry_point_exports.dart' show SsoUserInfo;
import '../../features/health_certificate/presentation/core/models/health_request_details_screen_args.dart';
import '../../features/health_certificate/presentation/pages/health_license_details_screen.dart';
import '../../features/health_certificate/presentation/pages/health_request_details_screen.dart';
import '../../features/health_certificate/presentation/pages/new_health_certificate/new_health_certificate_page.dart';
import '../../features/map_page/data/model/excavations.dart';
import '../../features/map_page/data/model/investment_details_response.dart';
import '../../features/map_page/presentation/pages/digging_map_details_page.dart';
import '../../features/map_page/presentation/pages/investment_map_details_page.dart';
import '../../features/new_appointment/presentation/pages/new_appointment/new_appointment_page.dart';
import '../../features/objectable_transactions/objections_exports.dart'
    show ObjectableTransactionsPage;
import '../../features/facility_qr/facility_qr_exports.dart';
import '../../features/objectable_transactions/presentation/pages/create_objection_page.dart';
import '../../features/objectable_transactions/presentation/pages/objection_details_page.dart';
import '../../features/objectable_transactions/presentation/pages/transactions_details_page.dart';
import '../../features/municipal_services/municipal_advisor/municipal_advisor_exports.dart'
    show LocationPage, MunicipalAdvisorBloc, MunicipalAdvisorPage;

import '../../features/objections/presentation/pages/objections_page.dart';
import '../../features/profile_features/dashboard/dashboard_exports.dart'
    show DashBoardPage, NotificationPage;
import '../../features/profile_features/incidents/domain/entities/request_details_page_params.dart';
import '../../features/profile_features/incidents/presentation/pages/daem_details.dart';
import '../../features/profile_features/incidents/presentation/pages/inq_details.dart';
import '../../features/profile_features/incidents/presentation/pages/req_details.dart';
import '../../features/profile_features/incidents/presentation/pages/requests_page.dart';
import '../../features/profile_features/incidents/presentation/pages/vhr_details.dart';
import '../../features/profile_features/help/presentation/screens/help_screen.dart';
import '../../features/profile_features/invoices/invoices_exports.dart'
    show InvoiceDetailsPage, InvoiceEntity, InvoicesPage;
import '../../features/profile_features/licenses/licenses_exports.dart'
    show LicensesPage;
import '../../features/profile_features/personal_information/personal_information_exports.dart'
    show PersonalInformationPage;
import '../../features/profile_features/requests/requests_exports.dart'
    show RequestsPage;
import '../../features/objections/objections_exports.dart' show ObjectionsPage;
import '../../features/profile_features/violations/domain/entities/create_violation_objection_page_params.dart';
import '../../features/profile_features/violations/presentation/pages/create_objection_page.dart';
import '../../features/profile_features/violations/violations_exports.dart';
import '../../features/public_services_features/prayer_times/prayer_times_exports.dart'
    show PrayerTimesCubit, PrayerTimesPage;
import '../../features/quran/data/models/quran_sura_model.dart';
import '../../features/quran/presentation/pages/menu_quran_page.dart';
import '../../features/quran/presentation/pages/quran_doaa.dart';
import '../../features/quran/presentation/pages/quran_search_page.dart';
import '../../features/report_damaged_car/damaged_cars_exports.dart'
    show DCCameraPage, CreateDCDetailsPage, DCMapScreen;
import '../../features/retrive_car/data/model/veichles_list_page_params.dart';
import '../../features/retrive_car/domain/entities/create_retrive_page_params.dart';
import '../../features/retrive_car/presentation/pages/check_veichles_page/check_veichles_page.dart';
import '../../features/retrive_car/presentation/pages/check_veichles_page/veichles_list_page.dart';
import '../../features/retrive_car/presentation/pages/create_retrive_page.dart';
import '../../features/retrive_car/presentation/pages/dc_select_retrive_request_type.dart';
import '../../features/retrive_car/presentation/pages/dc_vehicles_page.dart';
import '../../features/public_services_features/qiblah_compass/qiblah_compass_exports.dart'
    show QiblahCompassPage;
import '../../features/public_services_features/qiblah_compass/qiblah_compass_exports.dart'
    show QiblahCompassPage;
import '../../features/public_services_features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../../features/services/services_exports.dart'
    show ServiceCardsPage, ServiceEntity;
import '../../features/splash/splash_exports.dart' show SplashPage;
import '../../features/transaction_inquiry/data/general_inquiry_data.dart';
import '../../features/transaction_inquiry/presentation/core/models/gis_location_result.dart';
import '../../features/transaction_inquiry/presentation/core/models/inquiry_transaction_response.dart';
import '../../features/transaction_inquiry/presentation/pages/inquiry/general_inquiry/general_inquiry_page.dart';
import '../../features/transaction_inquiry/presentation/pages/inquiry/transactions_inquiry/inquiry_details_screen.dart';
import '../../features/transaction_inquiry/presentation/pages/inquiry/transactions_inquiry/new_transaction_inquiry.dart';
import '../../features/transaction_inquiry/presentation/pages/inquiry/transactions_inquiry/transaction_inquiry_page.dart';
import '../../features/transaction_inquiry/presentation/pages/request_service/new_request_service/new_request_service_location_screen.dart';
import '../../features/transaction_inquiry/presentation/pages/request_service/new_request_service/new_request_service_page.dart';
import '../../features/vd/vd_exports.dart';
import '../../features/visual_distortion/visual_distoration_exports.dart';
import '../../features/weather/weather_exports.dart';
import '../../features/zmzm_points/presentation/pages/zmzm_points_page.dart';
import '../../features/wallet/wallet_exports.dart';
import 'package:balady_plus/etmam_app/app.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    as sharedEtmamFeature;

import 'enums/visual_distortion.dart';
import 'etmam_route_exports.dart' hide SplashPage;

class Routes {
  static Map<String, Widget Function(BuildContext)> routes() => {
        RouteName.bottomNavigation: (context) => const b.BottomNavigationPage(),
        RouteName.AppointmentsListScreen: (context) =>
            const AppointmentsListScreen(),
        EtmamRoutesNames.myOrdersPage: (context) => const OrdersPage(),

        RouteName.splash: (context) => const SplashPage(),
        RouteName.etmamMainPage: (context) => const EtmamMainPage(),

        //! Services

        RouteName.visualDistortionPage: (context) =>
            const VisualDistortionScreen(),

        //? Municipal Services

        RouteName.municipalAdvisor: (context) => const MunicipalAdvisorPage(),
        RouteName.locationPage: (context) => const LocationPage(),

        //? dashboard page
        RouteName.dashboard: (context) => const DashBoardPage(),

        RouteName.notificationPage: (context) => const NotificationPage(),
        //? requests page
        RouteName.requests: (context) => const RequestsPage(),
        //? invoices page
        RouteName.invoices: (context) => const InvoicesPage(),

        //? licenses page
        RouteName.licenses: (context) => const LicensesPage(),
        //? About Balady
        RouteName.aboutBalady: (context) => const AboutBaladyScreen(),

        //? About Balady
        RouteName.rateUs: (context) => const RateUs(),

        //? Help
        RouteName.help: (context) => const HelpScreen(),

        //? Contact Info
        RouteName.contactInfoPage: (context) =>
            const ContactInformationScreen(),

        //? objections page
        RouteName.objections: (context) => const ObjectionsPage(),

        //? incRequests page
        RouteName.incRequestsPage: (context) => const INCRequestsPage(),

//? objectable transactions page
        RouteName.objectableTransactions: (context) =>
            const ObjectableTransactionsPage(),

//? QR

        RouteName.qrFacilityRatingRoute: (context) => FacilityRatingScreen(),

        RouteName.qrFacilityScreenRoute: (context) => FacilityScreen(),

        RouteName.qrScreenRoute: (context) => QrScreen(),

        RouteName.qrPhotosRoute: (context) => FacilityPhotosScreen(),

        RouteName.forceUpdateRoute: (context) => ForceUpdatePage(),

        RouteName.QAPage: (context) => QAPage(),

//? Quran
        RouteName.quranScreen: (context) => QuranPage(),
        RouteName.menuQuranPage: (context) => MenuQuranPage(),
        RouteName.quranBookMarkPage: (context) => QuranBookMarkPage(),

        RouteName.quranDoaaPage: (context) => QuranDoaaPage(),

        RouteName.quranSearchPage: (context) => QuranSearchPage(),

        RouteName.ZmZmPointsPage: (context) => ZmZmPointsPage(),

        RouteName.inappWebview: (context) => InAppWebViewPage(),

        RouteName.dmsImageFullScreen: (context) => ViewDMSImageScreen(),

        RouteName.serviceCards: (context) => ServiceCardsPage(),

        //? General Services

        RouteName.prayerTimes: (context) => PrayerTimesPage(),

        RouteName.qiblahCompass: (context) => QiblahWebViewPage(),

        RouteName.visualDistortionDetailsPage: (context) =>
            VisualDistortionDetailsScreen(),
        //! Setting
        //? personalInformation page

        RouteName.personalInformation: (context) => PersonalInformationPage(),

        RouteName.invoiceDetails: (context) => InvoiceDetailsPage(),

        RouteName.createObjectionDetails: (context) => CreateObjectionPage(),

        // -------  VD ---------

        RouteName.vdCameraPage: (context) => VDCameraPage(),

        RouteName.vdCreateVDDetailsPage: (context) => CreateVDDetailsPage(),

        RouteName.vdMapRoute: (context) => VDMapScreen(),

        RouteName.vdGuestOtpScreen: (context) => VDGuestOtpScreen(),

        RouteName.successRoute: (context) => SuccessScreen(),
        // ------ Commercial License -----

        RouteName.commercialLicensePage: (context) => CommercialLicenseScreen(),

        // ------ Wallet -----

        RouteName.walletPage: (context) => WalletScreen(),

        RouteName.businessLicensePage: (context) => BusinessLicenseScreen(),

        // ------ Violations -------
        RouteName.violationsPage: (context) => ViolationsPage(),

/*
      case RouteName.violationDetailsPage:
        return MaterialPageRoute(
          builder: (_) => ViolationsDetailsPage(
            violationsEntity: settings.arguments as ViolationsEntity,
          ),
        );
      case RouteName.createViolationObjectionDetails:
        CreateViolationObjectionPageParams params =
            settings.arguments as CreateViolationObjectionPageParams;
        return MaterialPageRoute(
          builder: (_) => CreateViolationObjectionPage(
            params: params,
          ),
        );

      case RouteName.transactionDetailsPage:
        CreateObjectionPageParams? params =
            settings.arguments as CreateObjectionPageParams?;
        return MaterialPageRoute(
          builder: (_) => TransactionsDetailsPage(
            params: params!,
          ),
        );

      case RouteName.objectionsDetailsPage:
        ObjectionDetails? params = settings.arguments as ObjectionDetails?;
        return MaterialPageRoute(
          builder: (_) => ObjectionsDetailsPage(
            params: params!,
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
          builder: (_) => InvestmentPage(data: data!),
        );
      case RouteName.tempRentalPage:
        RentalDetailsResponse? data =
            settings.arguments as RentalDetailsResponse?;

        return MaterialPageRoute(
          builder: (_) => TempRentalPage(
            data: data!,
          ),
        );

      case RouteName.DCCameraPage:
        CameraParamsPage params = settings.arguments as CameraParamsPage;

        return MaterialPageRoute(
          builder: (_) => DCCameraPage(params: params),
        );

      case RouteName.createDCDetailsPage:
        return MaterialPageRoute(
          builder: (_) => const CreateDCDetailsPage(),
        );

      case RouteName.dcMapRoute:
        MapScreenParams? params = settings.arguments != null
            ? settings.arguments as MapScreenParams
            : null;
        return MaterialPageRoute(
          builder: (_) => DCMapScreen(params: params),
        );

      case RouteName.CheckVeichlesPage:
        String type = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CheckVeichlesPage(
            type: type,
          ),
        );

      case RouteName.VeichlesListPage:
        VeichlesListPageParams params =
            settings.arguments as VeichlesListPageParams;
        return MaterialPageRoute(
          builder: (_) => VeichlesListPage(params: params),
        );

      case RouteName.CreateRetriveDetailsPage:
        CreateRetrivePageParams params =
            settings.arguments as CreateRetrivePageParams;
        return MaterialPageRoute(
          builder: (_) => CreateRetriveDetailsPage(params: params),
        );

      case RouteName.DCVeichlePage:
        return MaterialPageRoute(
          builder: (_) => const DCVehiclesPage(),
        );

      case RouteName.DCSelectRetreiveTypePage:
        return MaterialPageRoute(
          builder: (_) => const DCSelectRetrieveTypePage(),
        );
      case RouteName.weatherMainPage:
        return MaterialPageRoute(
          builder: (_) => const WeatherMainPage(),
        );

      case RouteName.NewAppointmentPage:
        bool? withPreviousTransaction = settings.arguments as bool?;
        return MaterialPageRoute(
          builder: (_) => NewAppointmentPage(
            withPreviousTransaction: withPreviousTransaction ?? false,
          ),
        );

      case RouteName.newDaemTicket:
        final args = settings.arguments as NewTicketPageArgs;

        return MaterialPageRoute(
          builder: (_) => NewDaemPage(
            args: args,
          ),
        );

      case RouteName.newTransactionInquiryScreen:
        return MaterialPageRoute(
          builder: (_) => NewTransactionPage(),
        );

      case RouteName.inquiryDetailsScreen:
        InquiryTransactionResponse args =
            settings.arguments as InquiryTransactionResponse;
        return MaterialPageRoute(
          builder: (_) => InquiryDetailsScreen(
            result: args,
          ),
        );

      case RouteName.generalInquiryPage:
        CustomerVoiceReportTypeModel inqTypeModel =
            settings.arguments as CustomerVoiceReportTypeModel;
        return MaterialPageRoute(
          builder: (_) => GeneralInquiryPage(inqTypeModel: inqTypeModel),
        );

      case RouteName.previousAppointmentsRoute:
        return MaterialPageRoute(
          builder: (_) => const PreviousAppointmentsScreen(),
        );

      case RouteName.appointmentDetailsRoute:
        final args = settings.arguments as AppointmentDetailsScreenArgs;
        return MaterialPageRoute(
          builder: (_) => AppointmentDetailsScreen(
            // appointmentId: args,
            appointmentItemInfo: args.appointmentItemInfo,
            isCancelable: args.isCancelable,
            isPrintable: args.isPrintable,
            fromHomePage: args.fromHomePage,
          ),
        );

      case RouteName.newMSRPage:
        return MaterialPageRoute(
          builder: (_) => NewMSRPage(),
        );
      case RouteName.newMSRMapPage:
        final args = settings.arguments as CustomerVoiceReportTypeModel;
        return MaterialPageRoute(
          builder: (_) => NewRequestLocationScreen(reportType: args),
        );

      case RouteName.calculatorMapRoute:
        return MaterialPageRoute(
          builder: (_) => ServiceCalculatorLocationScreen(),
        );

      case RouteName.calculatorRoute:
        final args = settings.arguments as GisLocationResult;
        return MaterialPageRoute(
          builder: (_) => ServiceCalculatorScreen(
            gisLocationResult: args,
          ),
        );

      case RouteName.AppointmentsListScreen:
        return MaterialPageRoute(
          builder: (_) => AppointmentsListScreen(),
        );

      case RouteName.newHealthCertificatePage:
        bool? isRenew = settings.arguments as bool?;
        return MaterialPageRoute(
          builder: (_) => NewHealthCertificatePage(
            renew: isRenew ?? false,
          ),
        );

      case RouteName.healthLicenseDetailsScreen:
        final args = settings.arguments as HealthRequestDetailsScreenArgs;
        return MaterialPageRoute(
          builder: (_) => HealthLicenseDetailsScreen(
            args: args,
          ),
        );

      case RouteName.healthRequestDetailsScreen:
        final args = settings.arguments as HealthRequestDetailsScreenArgs;
        return MaterialPageRoute(
          builder: (_) => HealthRequestDetailsScreen(
            args: args,
          ),
        );

      case RouteName.DiggingMapDetailsPage:
        Excavations? item = settings.arguments as Excavations?;
        return MaterialPageRoute(
          builder: (_) => DiggingMapDetailsPage(
            item: item!,
          ),
        );

      case RouteName.InvestmentMapDetailsPage:
        InvestmentDetailsResponse? item =
            settings.arguments as InvestmentDetailsResponse?;
        return MaterialPageRoute(
          builder: (_) => InvestmentMapDetailsPage(
            item: item!,
          ),
        );

      case RouteName.InvestmentMapDetailsPage:
        InvestmentDetailsResponse? item =
            settings.arguments as InvestmentDetailsResponse?;
        return MaterialPageRoute(
          builder: (_) => InvestmentMapDetailsPage(
            item: item!,
          ),
        );

      case RouteName.InvestmentMapDetailsPage:
        InvestmentDetailsResponse? item =
            settings.arguments as InvestmentDetailsResponse?;
        return MaterialPageRoute(
          builder: (_) => InvestmentMapDetailsPage(
            item: item!,
          ),
        );

      case RouteName.DCDetails:
        RequestDetailsPageParams? item =
            settings.arguments as RequestDetailsPageParams?;
        return MaterialPageRoute(
          builder: (_) => DCDetailsPage(
            params: item!,
          ),
        );

      case RouteName.IncidentDetails:
        RequestDetailsPageParams? item =
            settings.arguments as RequestDetailsPageParams?;
        return MaterialPageRoute(
          builder: (_) => IncidentDetailsPage(
            params: item!,
          ),
        );
      case RouteName.InqDetails:
        RequestDetailsPageParams? item =
            settings.arguments as RequestDetailsPageParams?;
        return MaterialPageRoute(
          builder: (_) => InqDetailsPage(
            params: item!,
          ),
        );

      case RouteName.ReqDetails:
        RequestDetailsPageParams? item =
            settings.arguments as RequestDetailsPageParams?;
        return MaterialPageRoute(
          builder: (_) => ReqDetailsPage(
            params: item!,
          ),
        );

      case RouteName.VHRDetails:
        RequestDetailsPageParams? item =
            settings.arguments as RequestDetailsPageParams?;
        return MaterialPageRoute(
          builder: (_) => VHRDetailsPage(
            params: item!,
          ),
        );

      case RouteName.DaemDetails:
        RequestDetailsPageParams? item =
            settings.arguments as RequestDetailsPageParams?;
        return MaterialPageRoute(
          builder: (_) => DaemDetailsPage(
            params: item!,
          ),
        );

      case RouteName.mainAthkarPage:
        return MaterialPageRoute(
          builder: (_) => Athkar(),
        );
      case RouteName.boardingPage:
        return MaterialPageRoute(
          builder: (_) => BoardingMainPage(),
        );
      case RouteName.athkarEntitesPage:
        final params = settings.arguments as AthkarEntitiesParams;
        return MaterialPageRoute(
          builder: (_) => AthkarEntities(
            params: params,
          ),
        );
      case RouteName.athkarEntityContentPage:
        final params = settings.arguments as AthkarEntityContentParams;
        return MaterialPageRoute(
          builder: (_) => AthkarEntityContent(
            params: params,
            athkarEntitiesList: params.athkarEntitiesList, // Use params here
          ),
        );

*/
      };
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
      case EtmamRoutesNames.bottomNavigation:
        return MaterialPageRoute(builder: (_) => const BottomNavigationPage());

      // home page
      case EtmamRoutesNames.home:
        return MaterialPageRoute(builder: (_) => const EtmamHomePage());

      // search page
      case EtmamRoutesNames.searchPage:
        return MaterialPageRoute(builder: (_) => const SearchPage());

      // Main Services Page
      case EtmamRoutesNames.mainServicesPage:
        final MainServiceResponse resopnse =
            settings.arguments as MainServiceResponse;
        return MaterialPageRoute(
            builder: (_) => EtmamMainServicesPage(
                  mainServiceResponse: resopnse,
                ));

      // Sub Services Page
      case EtmamRoutesNames.subServicesPage:
        final SubServicePageArgs resopnse =
            settings.arguments as SubServicePageArgs;
        return MaterialPageRoute(
            builder: (_) => EtmamSubServicesPage(
                  subServicePageArgs: resopnse,
                ));

      // Providers By Service
      case EtmamRoutesNames.providersByService:
        final ServicePageParams args = settings.arguments as ServicePageParams;
        // final ServiceResponse resopnse = settings.arguments as ServiceResponse;
        return MaterialPageRoute(
            builder: (_) => ServicesPage(
                  args: args,
                ));
      case EtmamRoutesNames.serviceProvidersDetails:
        final ServiceDetailsResponse response =
            settings.arguments as ServiceDetailsResponse;
        return MaterialPageRoute(
            builder: (_) =>
                ServiceDetailsPage(serviceDetailsResponse: response));
      case EtmamRoutesNames.faqPage:
        List<Faq> faqList = settings.arguments as List<Faq>;
        return MaterialPageRoute(
            builder: (_) => FaqPage(
                  faqList: faqList,
                ));
      case EtmamRoutesNames.officeInfoPage:
        Provider args = settings.arguments as Provider;
        return MaterialPageRoute(
            builder: (_) => OfficeInfoPage(
                  provider: args,
                ));
      case EtmamRoutesNames.branchesMapPage:
        final List<Branch> args = settings.arguments as List<Branch>;
        return MaterialPageRoute(
            builder: (_) => BranchesMapPage(
                  branches: args,
                ));

      case EtmamRoutesNames.providersDetails:
        ProviderDetailsResponse args =
            settings.arguments as ProviderDetailsResponse;
        return MaterialPageRoute(
            builder: (_) => ProviderDetailsPage(
                  args: args,
                ));

      // on boarding
      case EtmamRoutesNames.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingCitiesPage());

      // Submit Request
      case EtmamRoutesNames.relationsList:
        RelationPageParam args = settings.arguments as RelationPageParam;

        return MaterialPageRoute(
            builder: (_) => RelationRequestPage(
                  args: args,
                ));

      case EtmamRoutesNames.providersListPage:
        //ProviderResponse response = settings.arguments as ProviderResponse;
        return MaterialPageRoute(
            builder: (_) => ProvidersPage(
                //  providerResponse: response,
                ));

      case EtmamRoutesNames.previousWorksPage:
        List<Project>? projects = settings.arguments as List<Project>?;
        return MaterialPageRoute(
            builder: (_) => PreviousWorksPage(
                  projects: projects,
                ));
      case EtmamRoutesNames.previousWorksDetailsPage:
        Project project = settings.arguments as Project;
        return MaterialPageRoute(
            builder: (_) => PreviousWorksDetailsPage(
                  project: project,
                ));

      case EtmamRoutesNames.serviceTypesList:
        final ProviderRelationPageParams args =
            settings.arguments as ProviderRelationPageParams;

        return MaterialPageRoute(
            builder: (_) => ServiceProvidersRelations(args: args));

      case EtmamRoutesNames.orderInfo:
        SubmitPageParams args = settings.arguments as SubmitPageParams;
        return MaterialPageRoute(
            builder: (_) => SubmitRequestPage(
                  args: args,
                ));

      case EtmamRoutesNames.myOrdersPage:
        return MaterialPageRoute(builder: (_) => OrdersPage());
      // Success Page
      case EtmamRoutesNames.successRoute:
        final args = settings.arguments as sharedEtmamFeature.SuccessScreenArgs;
        return MaterialPageRoute(
          builder: (_) => sharedEtmamFeature.SuccessScreen(
            successScreenArgs: args,
          ),
        );
      // Success Page
      case EtmamRoutesNames.successRoute:
        final args = settings.arguments as sharedEtmamFeature.SuccessScreenArgs;
        return MaterialPageRoute(
          builder: (_) => sharedEtmamFeature.SuccessScreen(
            successScreenArgs: args,
          ),
        );

      // otp page
      case EtmamRoutesNames.otpRoute:
        final OTPPageParams? args = settings.arguments as OTPPageParams;
        return MaterialPageRoute(
            builder: (_) => EtmamOtpScreen(
                  args: args,
                ));

      // orders details page
      case EtmamRoutesNames.orderDetailsRoute:
        OrderDetailsPageParams args =
            settings.arguments as OrderDetailsPageParams;
        return MaterialPageRoute(
            builder: (_) => OrderDetailsPage(
                  args: args,
                ));

      // evaluate order
      case EtmamRoutesNames.evaluateOrderRoute:
        RatingPageParams args = settings.arguments as RatingPageParams;
        return MaterialPageRoute(
            builder: (_) => EvaluateOrderPage(
                  args: args,
                ));

      // personal info
      case EtmamRoutesNames.personalInfoRoute:
        return MaterialPageRoute(builder: (_) => const PersonalInfoPage());

      // help
      case EtmamRoutesNames.helpRoute:
        return MaterialPageRoute(builder: (_) => const HelpPage());

      // Select City Page
      case EtmamRoutesNames.selectCityPage:
        return MaterialPageRoute(builder: (_) => const EtmamSelectCityPage());
    }
    return null;
  }
}
