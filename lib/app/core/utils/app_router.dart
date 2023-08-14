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
    show AppBar, Center, MaterialPageRoute, Route, RouteSettings, Scaffold;
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
import '../../features/weather/weather_exports.dart';
import '../../features/zmzm_points/presentation/pages/zmzm_points_page.dart';
import '../../features/wallet/wallet_exports.dart';
import 'package:balady_plus/etmam_app/app.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    as sharedEtmamFeature;

import 'etmam_route_exports.dart' hide SplashPage;

class AppRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    Route<dynamic>? route = etmamRoutes(settings);
    if (route != null) return route;
    switch (settings.name) {
      // splash page
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case RouteName.etmamMainPage:
        return MaterialPageRoute(builder: (_) => const EtmamMainPage());

      case RouteName.inappWebview:
        return MaterialPageRoute(
          builder: (_) => InAppWebViewPage(
            args: settings.arguments as ({String title, String url}),
          ),
        );
      // bottom-navigation-bar page
      case RouteName.bottomNavigation:
        // return MaterialPageRoute(builder: (_) => const BottomNavigationPage());
        return SliderUpPage(page: const b.BottomNavigationPage());

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
      case RouteName.qiblahCompass:
        return MaterialPageRoute(
          builder: (_) => QiblahWebViewPage(
            args: (
              title: "",
              url: "https://qiblafinder.withgoogle.com/intl/ar/finder/ar"
            ),
          ),
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
      case RouteName.notificationPage:
        return MaterialPageRoute(builder: (_) => const NotificationPage());
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
      //? About Balady
      case RouteName.aboutBalady:
        return MaterialPageRoute(builder: (_) => const AboutBaladyScreen());
      //? About Balady
      case RouteName.rateUs:
        return MaterialPageRoute(builder: (_) => const RateUs());
      //? Help
      case RouteName.help:
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      //? Contact Info
      case RouteName.contactInfoPage:
        return MaterialPageRoute(
            builder: (_) => const ContactInformationScreen());

      // objections page
      case RouteName.objections:
        return MaterialPageRoute(builder: (_) => const ObjectionsPage());

      case RouteName.incRequestsPage:
        return MaterialPageRoute(builder: (_) => const INCRequestsPage());

      // objectable transactions page
      case RouteName.objectableTransactions:
        return MaterialPageRoute(
            builder: (_) => const ObjectableTransactionsPage());

      case RouteName.createObjectionDetails:
        CreateObjectionPageParams params =
            settings.arguments as CreateObjectionPageParams;
        return MaterialPageRoute(
          builder: (_) => CreateObjectionPage(
            params: params,
          ),
        );

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
          builder: (_) => const CreateVDDetailsPage(),
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

      // ------ Commercial License -----
      case RouteName.commercialLicensePage:
        return MaterialPageRoute(
          builder: (_) => const CommercialLicenseScreen(),
        );

      // ------ Wallet -----
      case RouteName.walletPage:
        return MaterialPageRoute(
          builder: (_) => const WalletScreen(),
        );
      case RouteName.businessLicensePage:
        final WalletItem? item = settings.arguments as WalletItem?;
        return MaterialPageRoute(
          builder: (_) => BusinessLicenseScreen(
            item: item,
          ),
        );

      // ------ Violations -------
      case RouteName.violationsPage:
        return MaterialPageRoute(
          builder: (_) => const ViolationsPage(),
        );
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
        // CreateVDParamsPage params = settings.arguments as CreateVDParamsPage;
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
        //final args = settings.arguments as int;
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
        //final args = settings.arguments as int;
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

      case RouteName.quranScreen:
        final int initialSuraNo = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => QuranPage(
            initialSuraNo: initialSuraNo,
          ),
        );
      case RouteName.menuQuranPage:
        return MaterialPageRoute(
          builder: (_) => MenuQuranPage(),
        );

      case RouteName.quranBookMarkPage:
        return MaterialPageRoute(
          builder: (_) => QuranBookMarkPage(),
        );

      case RouteName.quranDoaaPage:
        return MaterialPageRoute(
          builder: (_) => QuranDoaaPage(),
        );

      case RouteName.quranSearchPage:
        Map<int, Map<int, QuranSuraModel>>? suras =
            settings.arguments as Map<int, Map<int, QuranSuraModel>>;

        return MaterialPageRoute(builder: (_) => QuranSearchPage(suras: suras));

      case RouteName.ZmZmPointsPage:
        return MaterialPageRoute(
          builder: (_) => ZmZmPointsPage(),
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

      case RouteName.forceUpdateRoute:
        return MaterialPageRoute(
          builder: (_) => ForceUpdatePage(),
        );

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
