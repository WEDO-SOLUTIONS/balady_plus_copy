import 'package:balady_plus/app/features/commercial_license_cancel/presentation/apply_cancel/screens/apply_cancel_screen.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/screens/commercial_license_cancel_screen.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/submit_application_successfully_cancel/screens/submit_application_successfully_cancel.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/submit_application_successfully_cancel/screens/submit_rating_cancel_screen.dart';
import 'package:balady_plus/app/features/commercial_license_details/presentation/pages/commercial_license_details_page.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/pages/create_compliance_location_confirm_page.dart';
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
import '../../../etmam_app/features/dynamic_form/presentation/dialogs/bidding_types_dialog.dart';
import '../../../etmam_app/features/dynamic_form/presentation/pages/bidding_form_page.dart';
import '../../../etmam_app/features/dynamic_form/presentation/pages/bidding_type_page.dart';
import '../../../etmam_app/features/dynamic_form/presentation/pages/edit_bidding_form_page.dart';
import '../../../etmam_app/features/my_orders/presentation/pages/requests_page.dart'
    as etmamRequestsPage;
import '../../../etmam_app/features/home/presentation/pages/etmam_main_city_page.dart';
import '../../../etmam_app/features/home/presentation/pages/etmam_main_page.dart';
import '../../../etmam_app/features/my_orders/presentation/pages/delete_orders_page.dart';
import '../../../etmam_app/features/my_orders/presentation/pages/request_details_page.dart';
import '../../../etmam_app/features/my_orders/presentation/pages/request_offers_page.dart';
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
import '../../features/_shared_feature_/presentation/pages/view_apigee_image_screen.dart';
import '../../features/calendar/calendar_exports.dart';
import '../../features/calendar/presentation/pages/calendar_details_page.dart';
import '../../features/create_compliance/presentation/pages/compliance_details_page.dart';
import '../../features/create_compliance/presentation/pages/map_page/complinace_map_page.dart';
import '../../features/create_compliance/presentation/pages/non_compliance_screen.dart';
import '../../features/create_compliance/presentation/pages/submit_compliance_page.dart';
import '../../features/events/presentation/pages/events_main_page.dart';
import '../../features/events/presentation/pages/single_image_page.dart';
import '../../features/map_page/data/model/rental_details_response.dart';
import '../../features/map_page/presentation/pages/resturant_details_page.dart';
import '../../features/qa/presentation/pages/qa_page.dart';
import '../../features/self_ratiing/presentation/pages/self_rating_main_page.dart';
import '../../features/self_ratiing/presentation/pages/self_rating_result_page.dart';
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
  static Map<String, Widget Function(BuildContext)> etmamRoutes() => {};

  static Map<String, Widget Function(BuildContext)> routes() => {
//! Etmam Start
        EtmamRoutesNames.bottomNavigation: (context) =>
            const BottomNavigationPage(),

        // home page
        EtmamRoutesNames.home: (context) => const EtmamHomePage(),

        // search page
        EtmamRoutesNames.searchPage: (context) => const SearchPage(),

//    cubit = ModalRoute.of(context)!.settings.arguments as PrayerTimesCubit;

        // Main Services Page
        EtmamRoutesNames.mainServicesPage: (context) =>
            const EtmamMainServicesPage(),

//    cubit = ModalRoute.of(context)!.settings.arguments as PrayerTimesCubit;

        // Sub Services Page
        /*EtmamRoutesNames.subServicesPage: (context) =>
            const EtmamSubServicesPage(),
*/
        // Providers By Service

        EtmamRoutesNames.providersByService: (context) => const ServicesPage(),

        EtmamRoutesNames.serviceProvidersDetails: (context) =>
            const ServiceDetailsPage(),

        EtmamRoutesNames.faqPage: (context) => const FaqPage(),

        EtmamRoutesNames.officeInfoPage: (context) => const OfficeInfoPage(),

        //    provider = ModalRoute.of(context)!.settings.arguments as Provider;

        EtmamRoutesNames.branchesMapPage: (context) => const BranchesMapPage(),

        EtmamRoutesNames.providersDetails: (context) =>
            const ProviderDetailsPage(),

        // on boarding

        EtmamRoutesNames.onBoardingRoute: (context) =>
            const OnBoardingCitiesPage(),

        // Submit Request

        EtmamRoutesNames.relationsList: (context) =>
            const RelationRequestPage(),

        EtmamRoutesNames.providersListPage: (context) => const ProvidersPage(),

        /* case EtmamRoutesNames.providersListPage:
        //ProviderResponse response = settings.arguments as ProviderResponse;
        return MaterialPageRoute(
            builder: (_) => ProvidersPage(
                //  providerResponse: response,
                ));*/

        EtmamRoutesNames.previousWorksPage: (context) =>
            const PreviousWorksPage(),

        EtmamRoutesNames.previousWorksDetailsPage: (context) =>
            const PreviousWorksDetailsPage(),

        EtmamRoutesNames.serviceTypesList: (context) =>
            const ServiceProvidersRelations(),

        EtmamRoutesNames.orderInfo: (context) => const SubmitRequestPage(),

        EtmamRoutesNames.myOrdersPage: (context) => const OrdersPage(),

        // Success Page

        EtmamRoutesNames.successRoute: (context) =>
            const sharedEtmamFeature.SuccessScreen(),

        // otp page

        EtmamRoutesNames.otpRoute: (context) => const EtmamOtpScreen(),

        // orders details page
        EtmamRoutesNames.orderDetailsRoute: (context) =>
            const OrderDetailsPage(),

        EtmamRoutesNames.requestDetailsRoute: (context) =>
            const RequestDetailsPage(),

        EtmamRoutesNames.myRequestsPage: (context) =>
            const etmamRequestsPage.RequestsPage(),

        EtmamRoutesNames.requestOffersPage: (context) =>
            const RequestOffersPage(),

        // evaluate order
        EtmamRoutesNames.evaluateOrderRoute: (context) =>
            const EvaluateOrderPage(),

        // personal info
        EtmamRoutesNames.personalInfoRoute: (context) =>
            const PersonalInfoPage(),

        // help
        EtmamRoutesNames.helpRoute: (context) => const HelpPage(),

        // Select City Page
        EtmamRoutesNames.selectCityPage: (context) =>
            const EtmamSelectCityPage(),

        // Bidding Type Form

        EtmamRoutesNames.biddingType: (context) => const BiddingTypePage(),

        // Bidding Form

        EtmamRoutesNames.biddingForm: (context) => const BiddingFormPage(),

        EtmamRoutesNames.deleteOrdersPage: (context) =>
            const DeleteOrdersPage(),

        EtmamRoutesNames.editBiddingForm: (context) =>
            const EditBiddingFormPage(),

        EtmamRoutesNames.biddingReleationTypes: (context) =>
            BiddingTypeDialog(),

//! Etmam End

        RouteName.bottomNavigation: (context) => const b.BottomNavigationPage(),
        RouteName.AppointmentsListScreen: (context) =>
            const AppointmentsListScreen(),

        RouteName.splash: (context) => const SplashPage(),
        RouteName.etmamMainPage: (context) => const EtmamMainPage(),
        RouteName.etmamMainPageCitySelector: (context) =>
            const EtmamMainCityPage(),

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
        RouteName.createCompliancePage: (context) =>
            CreateComplianceLocationPage(),

        RouteName.inappWebview: (context) => InAppWebViewPage(),

        RouteName.dmsImageFullScreen: (context) => ViewDMSImageScreen(),
        RouteName.apigeeImageFullScreen: (context) => ViewAPIGEEImageScreen(),

        RouteName.serviceCards: (context) => ServiceCardsPage(),

        //? General Services

        RouteName.prayerTimes: (context) => PrayerTimesPage(),

        RouteName.qiblahCompass: (context) => const QiblahWebViewPage(),

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

        RouteName.violationDetailsPage: (context) => ViolationsDetailsPage(),

        RouteName.createViolationObjectionDetails: (context) =>
            const CreateViolationObjectionPage(),

        RouteName.transactionDetailsPage: (context) =>
            const TransactionsDetailsPage(),

        RouteName.objectionsDetailsPage: (context) =>
            const ObjectionsDetailsPage(),

        RouteName.weatherMainPage: (context) => const WeatherMainPage(),

        RouteName.investmentPage: (context) => const InvestmentPage(),

        RouteName.tempRentalPage: (context) => const TempRentalPage(),

        RouteName.DCCameraPage: (context) => const DCCameraPage(),

        RouteName.createDCDetailsPage: (context) => const CreateDCDetailsPage(),

        RouteName.dcMapRoute: (context) => const DCMapScreen(),

        RouteName.CheckVeichlesPage: (context) => const CheckVeichlesPage(),

        RouteName.VeichlesListPage: (context) => const VeichlesListPage(),

        RouteName.CreateRetriveDetailsPage: (context) =>
            const CreateRetriveDetailsPage(),

        RouteName.DCVeichlePage: (context) => const DCVehiclesPage(),

        RouteName.DCSelectRetreiveTypePage: (context) =>
            const DCSelectRetrieveTypePage(),

        RouteName.NewAppointmentPage: (context) => const NewAppointmentPage(),
        RouteName.newDaemTicket: (context) => const NewDaemPage(),
        RouteName.newTransactionInquiryScreen: (context) =>
            const NewTransactionPage(),

        RouteName.inquiryDetailsScreen: (context) =>
            const InquiryDetailsScreen(),

        RouteName.generalInquiryPage: (context) => const GeneralInquiryPage(),

        RouteName.previousAppointmentsRoute: (context) =>
            const PreviousAppointmentsScreen(),

        RouteName.appointmentDetailsRoute: (context) =>
            const AppointmentDetailsScreen(),

        RouteName.newMSRPage: (context) => const NewMSRPage(),

        RouteName.newMSRMapPage: (context) => const NewRequestLocationScreen(),

        RouteName.calculatorMapRoute: (context) =>
            const ServiceCalculatorLocationScreen(),

        RouteName.calculatorRoute: (context) => const ServiceCalculatorScreen(),

        RouteName.newHealthCertificatePage: (context) =>
            const NewHealthCertificatePage(),

        RouteName.healthLicenseDetailsScreen: (context) =>
            const HealthLicenseDetailsScreen(),

        RouteName.healthRequestDetailsScreen: (context) =>
            const HealthRequestDetailsScreen(),

        RouteName.DiggingMapDetailsPage: (context) =>
            const DiggingMapDetailsPage(),

        RouteName.InvestmentMapDetailsPage: (context) =>
            const InvestmentMapDetailsPage(),
        RouteName.ResturantDetailsPage: (context) =>
            const ResturantDetailsPage(),

        RouteName.DCDetails: (context) => const DCDetailsPage(),

        RouteName.IncidentDetails: (context) => const IncidentDetailsPage(),

        RouteName.InqDetails: (context) => const InqDetailsPage(),

        RouteName.ReqDetails: (context) => const ReqDetailsPage(),
        RouteName.VHRDetails: (context) => const VHRDetailsPage(),
        RouteName.DaemDetails: (context) => const DaemDetailsPage(),
        RouteName.mainAthkarPage: (context) => Athkar(),

        RouteName.boardingPage: (context) => const BoardingMainPage(),
        RouteName.athkarEntitesPage: (context) => const AthkarEntities(),

        RouteName.athkarEntityContentPage: (context) =>
            const AthkarEntityContent(),

        RouteName.complinaceMapView: (context) => ComplinaceMapScreen(),
        RouteName.selfRatingMainPage: (context) => SelfRatingMainPage(),
        RouteName.selfRatingResultPage: (context) => SelfRatingResultPage(),

        RouteName.complianceDetailsPage: (context) => ComplianceDetailsPage(),
        RouteName.nonComplianceScreen: (context) => NonComplianceScreen(),

        RouteName.submitCompliancePage: (context) => SubmitCompliancePage(),

        RouteName.eventsMainPage: (context) => EventsMainPage(),

        RouteName.eventsDetailsPage: (context) => SingleEventDescriptionPage(),
        RouteName.calendarMainPage: (context) => const MainPageCalendar(),
        RouteName.calendarDetailsPage: (context) => const CalendarDetailsPage(),
//    cubit = ModalRoute.of(context)!.settings.arguments as PrayerTimesCubit;
        // -------  Commercial License Cancel ---------
        RouteName.commercialLicenseApplyCancel: (context) =>
            const ApplyCancelScreen(),
        RouteName.commercialLicenseCancel: (context) =>
            const CommercialLicenseCancelScreen(),
        RouteName.submitApplicationSuccessfullyCancel: (context) =>
            const SubmitApplicationSuccessfullyCancel(),
        RouteName.submitRatingCancelScreen: (context) =>
            const SubmitRatingCancelScreen(),

        RouteName.commercialLicenseDetails: (context) =>
            const CommercialLicenseDetailsPage(),
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
    }
    return null;
  }
}
