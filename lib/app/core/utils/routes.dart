import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_routes.dart';
import 'package:balady_plus/app/commercial_model/features/posters/presentation/widgets/types_dialog/commercial_permits_dialog.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/pages/balady_calendar_page.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/pages/training_screen.dart';
import 'package:balady_plus/app/features/classification_certificate/core/classification_certificate_routes/classification_certificate_routes.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/pages/create_compliance_location_confirm_page.dart';
import 'package:balady_plus/app/features/athkar/presentation/pages/athkar_entity_content.dart';
import 'package:balady_plus/app/features/boarding/presentation/pages/boarding_main_page.dart';
import 'package:balady_plus/app/features/daem/presentation/dialogs/daem_types_dialog.dart';
import 'package:balady_plus/app/features/force_update/presentation/pages/forceUpdatePage.dart';
import 'package:balady_plus/app/features/jod_services/presentation/tobacco_list/pages/jod_donation_page.dart';
import 'package:balady_plus/app/features/notifications/presentation/pages/notifications_details_screen.dart';
import 'package:balady_plus/app/features/notifications/presentation/pages/notifications_list_screen.dart';
import 'package:balady_plus/app/features/profile_features/incidents/presentation/pages/dc_details.dart';
import 'package:balady_plus/app/features/profile_features/incidents/presentation/pages/incident_details.dart';
import 'package:balady_plus/app/features/profile_features/about_balady/presentation/screens/about_balady_screen.dart';
import 'package:balady_plus/app/features/profile_features/help/presentation/screens/contact_information_screen.dart';
import 'package:balady_plus/app/features/profile_features/rate_us/rate_us.dart';
import 'package:balady_plus/app/features/quran/presentation/pages/quran_bookmarks.dart';
import 'package:balady_plus/app/features/quran/quran_exports.dart';
import 'package:balady_plus/app/features/services/core/home_services_routes/home_services_routes.dart';
import 'package:balady_plus/app/features/services/presentation/pages/municipal_home_services_screen.dart';
import 'package:balady_plus/app/features/splash/presentation/pages/splash_page.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/dialogs/general_inquiries_types_dialog.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/dialogs/new_request_types_dialog.dart';
import 'package:balady_plus/app/features/vd/presentation/dialogs/vd_all_types_dialog.dart';
import 'package:balady_plus/app/features/weather/presentation/pages/weather_main_page.dart';
import 'package:balady_plus/app/features/zmzm_points/zmzm_points_exports.dart';
import 'package:balady_plus/etmam_app/features/home/presentation/pages/city_services_etmam_main_page.dart';
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
import 'package:balady_plus/etmam_app/features/home/presentation/pages/etmam_home_page.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/presentation/pages/etmam_select_city_page.dart';

import '../../../etmam_app/features/my_orders/presentation/pages/request_offers_page.dart';
import '../../../etmam_app/features/my_orders/presentation/pages/requests_page.dart'
    as etmamRequestsPage;
import '../../../etmam_app/features/dynamic_form/presentation/dialogs/bidding_types_dialog.dart';
import '../../../etmam_app/features/dynamic_form/presentation/pages/bidding_form_page.dart';
import '../../../etmam_app/features/dynamic_form/presentation/pages/bidding_type_page.dart';
import '../../../etmam_app/features/dynamic_form/presentation/pages/edit_bidding_form_page.dart';
import '../../../etmam_app/features/home/presentation/pages/etmam_main_city_page.dart';
import '../../../etmam_app/features/home/presentation/pages/etmam_main_page.dart';
import '../../../etmam_app/features/my_orders/presentation/pages/delete_orders_page.dart';
import '../../../etmam_app/features/my_orders/presentation/pages/request_details_page.dart';
import '../../core/utils/utils_exports.dart' show EtmamRoutesNames, RouteName;
import '../../features/_shared_feature_/presentation/pages/qiblah_webview_page.dart';
import '../../features/_shared_feature_/presentation/pages/view_apigee_image_screen.dart';
import '../../features/calculator/presentation/pages/service_calculator_result_screen.dart';
import '../../features/calendar/calendar_exports.dart';
import '../../features/calendar/presentation/pages/calendar_details_page.dart';
import '../../features/ceritified_observer/presentation/pages/register_observer_home.dart';
import '../../features/chatbot/presentation/pages/chatbot_screen.dart';
import '../../features/chatbot/presentation/widgets/chat_history_details.dart';
import '../../features/construction_license_inquery/persentation/construction_license_query/construction_license_inquery_screen.dart';
import '../../features/construction_license_inquery/persentation/construction_license_query_Details/construction_license_inquery_details.dart';
import '../../features/create_compliance/presentation/pages/compliance_details_page.dart';
import '../../features/create_compliance/presentation/pages/map_page/complinace_map_page.dart';
import '../../features/create_compliance/presentation/pages/non_compliance_screen.dart';
import '../../features/create_compliance/presentation/pages/otp_page/compliance_otp_screen.dart';
import '../../features/create_compliance/presentation/pages/submit_compliance_page.dart';
import '../../features/ekram/presentation/pages/book_cemetry/ekram_book_cemetry_page.dart';
import '../../features/ekram/presentation/pages/book_cemetry/ekram_book_cemetry_start_service.dart';
import '../../features/ekram/presentation/pages/driver/location_selector.dart';
import '../../features/ekram/presentation/pages/user/ekram_request_transportation_start_service.dart';
import '../../features/ekram/presentation/pages/user/user_ekram_transpotation_details_page.dart';
import '../../features/ekram/presentation/pages/driver/transport_request_list_page.dart';
import '../../features/ekram/presentation/pages/ekram_booking_list_page.dart';
import '../../features/ekram/presentation/pages/ekram_cemetry_details_page.dart';
import '../../features/ekram/presentation/pages/ekram_home_page.dart';
import '../../features/ekram/presentation/pages/ekram_select_type_page.dart';
import '../../features/ekram/presentation/pages/ekram_success_screen.dart';
import '../../features/ekram/presentation/pages/user/ekram_map_page.dart';
import '../../features/ekram/presentation/pages/user/ekram_orders_page.dart';
import '../../features/ekram/presentation/pages/user/ekram_request_transportation_page_new.dart';
import '../../features/ekram/presentation/pages/user/ekram_transportation_list_page.dart';
import '../../features/ekram/presentation/pages/driver/identical_list_page.dart';
import '../../features/ekram_inquiry_service/presentation/pages/inquiry_cemetries/inquiry_cemetry_details.dart';
import '../../features/ekram_inquiry_service/presentation/pages/inquiry_cemetries/inquiry_cemetry_result.dart';
import '../../features/ekram_inquiry_service/presentation/pages/inquiry_graves/inquiry_grave_details.dart';
import '../../features/ekram_inquiry_service/presentation/pages/inquiry_graves/inquiry_grave_result.dart';
import '../../features/ekram_inquiry_service/presentation/pages/inquiry_orgnization/inquiry_orgnization_details.dart';
import '../../features/ekram_inquiry_service/presentation/pages/inquiry_orgnization/inquiry_orgnization_result.dart';
import '../../features/ekram_inquiry_service/presentation/pages/inquiry_orgnization/inquiry_orgnization_result_details.dart';
import '../../features/ekram_inquiry_service/presentation/pages/inquiry_print/inquiry_print_details.dart';
import '../../features/events/presentation/pages/events_main_page.dart';
import '../../features/events/presentation/pages/single_image_page.dart';
import '../../features/map_page/presentation/pages/resturant_details_page.dart';
import '../../features/qa/presentation/pages/qa_page.dart';
import '../../features/self_ratiing/presentation/pages/self_rating_main_page.dart';
import '../../features/self_ratiing/presentation/pages/self_rating_result_page.dart';
import '../../features/self_ratiing/presentation/pages/self_rating_section_page.dart';
import '../../features/services/presentation/pages/dashboard_page/presentation/pages/profile_page.dart';
import '../../features/survey_license_inquery_report/persentation/survey_license_query/survey_report_inquery_screen.dart';
import '../../features/survey_license_inquery_report/persentation/survey_license_query_Details/survey_report_inquery_details.dart';
import '../../features/unknow/pages/direct_page.dart';
import '../../features/unknow/pages/investment_page.dart';
import '../../features/unknow/pages/temp_rental_page.dart';
import '../../features/_shared_feature_/presentation/pages/view_dms_image_screen.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart';
import '../../features/_shared_feature_/presentation/pages/success_screen.dart';
import '../../features/appointments/presentation/pages/appointment_details_screen.dart';
import '../../features/appointments/presentation/pages/appointments_list_screen.dart';
import '../../features/appointments/presentation/pages/previous_appointments_screen.dart';
import '../../features/bottom_navigation/bottom_navigation_exports.dart' as b;
import '../../features/calculator/presentation/pages/service_calculator_location_screen.dart';
import '../../features/calculator/presentation/pages/service_calculator_screen.dart';
import '../../features/daem/presentation/pages/daem_ticket_page.dart';
import '../../features/athkar/athkar_exports.dart' show Athkar, AthkarEntities;

import '../../features/health_certificate/presentation/pages/health_license_details_screen.dart';
import '../../features/health_certificate/presentation/pages/health_request_details_screen.dart';
import '../../features/health_certificate/presentation/pages/new_health_certificate/new_health_certificate_page.dart';

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
    show LocationPage, MunicipalAdvisorPage;

import '../../features/objections/presentation/pages/objections_page.dart';
import '../../features/profile_features/dashboard/dashboard_exports.dart'
    show DashBoardPage, NotificationPage;
import '../../features/profile_features/incidents/presentation/pages/daem_details.dart';
import '../../features/profile_features/incidents/presentation/pages/inq_details.dart';
import '../../features/profile_features/incidents/presentation/pages/req_details.dart';
import '../../features/profile_features/incidents/presentation/pages/requests_page.dart';
import '../../features/profile_features/incidents/presentation/pages/vhr_details.dart';
import '../../features/profile_features/help/presentation/screens/help_screen.dart';
import '../../features/profile_features/invoices/invoices_exports.dart'
    show InvoiceDetailsPage, InvoicesPage;
import '../../features/profile_features/licenses/licenses_exports.dart'
    show LicensesPage;
import '../../features/profile_features/personal_information/personal_information_exports.dart'
    show PersonalInformationPage;
import '../../features/profile_features/requests/requests_exports.dart'
    show RequestsPage;
import '../../features/objections/objections_exports.dart' show ObjectionsPage;
import '../../features/profile_features/violations/violations_exports.dart';
import '../../features/public_services_features/prayer_times/prayer_times_exports.dart'
    show PrayerTimesPage;
import '../../features/quran/presentation/pages/menu_quran_page.dart';
import '../../features/quran/presentation/pages/quran_doaa.dart';
import '../../features/quran/presentation/pages/quran_search_page.dart';
import '../../features/report_damaged_car/damaged_cars_exports.dart'
    show DCCameraPage, CreateDCDetailsPage, DCMapScreen;

import '../../features/retrive_car/presentation/pages/check_veichles_page/check_veichles_page.dart';
import '../../features/retrive_car/presentation/pages/check_veichles_page/veichles_list_page.dart';
import '../../features/retrive_car/presentation/pages/create_retrive_page.dart';
import '../../features/retrive_car/presentation/pages/dc_select_retrive_request_type.dart';
import '../../features/retrive_car/presentation/pages/dc_vehicles_page.dart';

import '../../features/public_services_features/prayer_times/presentation/pages/prayer_times_page.dart';

import '../../features/transaction_inquiry/presentation/pages/inquiry/general_inquiry/general_inquiry_page.dart';
import '../../features/transaction_inquiry/presentation/pages/inquiry/transactions_inquiry/inquiry_details_screen.dart';
import '../../features/transaction_inquiry/presentation/pages/inquiry/transactions_inquiry/transaction_inquiry_page.dart';
import '../../features/transaction_inquiry/presentation/pages/request_service/new_request_service/new_request_service_location_screen.dart';
import '../../features/transaction_inquiry/presentation/pages/request_service/new_request_service/new_request_service_page.dart';
import '../../features/vd/vd_exports.dart';
import '../../features/violation_guide/presentation/pages/approved_violation_page.dart';
import '../../features/violation_guide/presentation/pages/violation_create_page.dart';
import '../../features/violation_guide/presentation/pages/violation_guide_select_page.dart';
import '../../features/violation_guide/presentation/pages/violation_results_page.dart';
import '../../features/visual_distortion/visual_distoration_exports.dart';
import '../../features/weather/weather_exports.dart';
import '../../features/wallet/wallet_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    as sharedEtmamFeature;

import 'etmam_route_exports.dart' hide SplashPage;

import 'package:balady_authorization/src/shared/authentication_routes/authentication_routes.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> etmamRoutes = {
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

    EtmamRoutesNames.providersDetails: (context) => const ProviderDetailsPage(),

    // on boarding

    EtmamRoutesNames.onBoardingRoute: (context) => const OnBoardingCitiesPage(),

    // Submit Request

    EtmamRoutesNames.relationsList: (context) => const RelationRequestPage(),

    EtmamRoutesNames.providersListPage: (context) => const ProvidersPage(),

    /* case EtmamRoutesNames.providersListPage:
        //ProviderResponse response = settings.arguments as ProviderResponse;
        return MaterialPageRoute(
            builder: (_) => ProvidersPage(
                //  providerResponse: response,
                ));*/

    EtmamRoutesNames.previousWorksPage: (context) => const PreviousWorksPage(),

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
    EtmamRoutesNames.orderDetailsRoute: (context) => const OrderDetailsPage(),

    EtmamRoutesNames.requestDetailsRoute: (context) =>
        const RequestDetailsPage(),

    EtmamRoutesNames.myRequestsPage: (context) =>
        const etmamRequestsPage.RequestsPage(),

    EtmamRoutesNames.requestOffersPage: (context) => const RequestOffersPage(),

    // evaluate order
    EtmamRoutesNames.evaluateOrderRoute: (context) => const EvaluateOrderPage(),

    // personal info
    EtmamRoutesNames.personalInfoRoute: (context) => const PersonalInfoPage(),

    // help
    EtmamRoutesNames.helpRoute: (context) => const HelpPage(),

    // Select City Page
    EtmamRoutesNames.selectCityPage: (context) => const EtmamSelectCityPage(),

    // Bidding Type Form

    EtmamRoutesNames.biddingType: (context) => const BiddingTypePage(),

    // Bidding Form

    EtmamRoutesNames.biddingForm: (context) => const BiddingFormPage(),

    EtmamRoutesNames.deleteOrdersPage: (context) => const DeleteOrdersPage(),

    EtmamRoutesNames.editBiddingForm: (context) => const EditBiddingFormPage(),

    EtmamRoutesNames.biddingReleationTypes: (context) => BiddingTypeDialog(),




//! Etmam End
  };
  static Map<String, Widget Function(BuildContext)> routesApp = {
    RouteName.bottomNavigation: (context) => const b.BottomNavigationPage(),
    RouteName.splashScreen: (context) => const SplashPage(),
    RouteName.AppointmentsListScreen: (context) =>
        const AppointmentsListScreen(),

    RouteName.baladyCalendarPage: (context) => const BaladyCalendarPage(),
    RouteName.etmamMainPage: (context) => const EtmamMainPage(),
    RouteName.cityServicesEtmamMainPage: (context) =>
        const CityServicesEtmamMainPage(),
    RouteName.etmamMainPageCitySelector: (context) => const EtmamMainCityPage(),

    //! Services

    RouteName.visualDistortionPage: (context) => const VisualDistortionScreen(),

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
    RouteName.contactInfoPage: (context) => const ContactInformationScreen(),

    //? objections page
    RouteName.objections: (context) => const ObjectionsPage(),

    //? incRequests page
    RouteName.incRequestsPage: (context) => const INCRequestsPage(),

//? objectable transactions page
    RouteName.objectableTransactions: (context) =>
        const ObjectableTransactionsPage(),

//? QR

    RouteName.qrFacilityRatingRoute: (context) => FacilityRatingScreen(),

    RouteName.qrFacilityScreenRoute: (context) => const FacilityScreen(),

    RouteName.qrScreenRoute: (context) => const QrScreen(),

    RouteName.qrPhotosRoute: (context) => const FacilityPhotosScreen(),

    RouteName.forceUpdateRoute: (context) => ForceUpdatePage(),

    RouteName.QAPage: (context) => const QAPage(),

//? Quran
    RouteName.quranScreen: (context) => const QuranPage(),
    RouteName.menuQuranPage: (context) => const MenuQuranPage(),
    RouteName.quranBookMarkPage: (context) => const QuranBookMarkPage(),

    RouteName.quranDoaaPage: (context) => const QuranDoaaPage(),

    RouteName.quranSearchPage: (context) => const QuranSearchPage(),

    RouteName.ZmZmPointsPage: (context) => const ZmZmPointsPage(),
    RouteName.createCompliancePage: (context) =>
        const CreateComplianceLocationPage(),

    RouteName.inappWebview: (context) => const InAppWebViewPage(),

    RouteName.dmsImageFullScreen: (context) => const ViewDMSImageScreen(),
    RouteName.apigeeImageFullScreen: (context) =>  ViewAPIGEEImageScreen(),

    // RouteName.serviceCards: (context) => const ServiceCardsPage(),

    //? General Services

    RouteName.prayerTimes: (context) => const PrayerTimesPage(),

    RouteName.qiblahCompass: (context) => const QiblahWebViewPage(),

    RouteName.visualDistortionDetailsPage: (context) =>
        VisualDistortionDetailsScreen(),
    //! Setting
    //? personalInformation page

    RouteName.personalInformation: (context) => const PersonalInformationPage(),

    RouteName.invoiceDetails: (context) => InvoiceDetailsPage(),

    RouteName.createObjectionDetails: (context) => const CreateObjectionPage(),

    // -------  VD ---------

    RouteName.vdCameraPage: (context) => VDCameraPage(),

    RouteName.vdCreateVDDetailsPage: (context) => const CreateVDDetailsPage(),

    RouteName.vdMapRoute: (context) => VDMapScreen(),

    RouteName.vdGuestOtpScreen: (context) => VDGuestOtpScreen(),

    RouteName.successRoute: (context) => const SuccessScreen(),
    // ------ Commercial License -----

    // ------ Wallet -----

    RouteName.walletPage: (context) => const WalletScreen(),

    RouteName.businessLicensePage: (context) => BusinessLicenseScreen(),

    // ------ Violations -------
    RouteName.violationsPage: (context) => const ViolationsPage(),

    RouteName.violationDetailsPage: (context) => const ViolationsDetailsPage(),

    RouteName.transactionDetailsPage: (context) =>
        const TransactionsDetailsPage(),

    RouteName.objectionsDetailsPage: (context) => const ObjectionsDetailsPage(),

    RouteName.weatherMainPage: (context) => const WeatherMainPage(),

    RouteName.investmentPage: (context) => const InvestmentPage(),
    RouteName.DirectRentalPage: (context) => const DirectRentalPage(),

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

    RouteName.inquiryDetailsScreen: (context) => const InquiryDetailsScreen(),

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

    RouteName.calculatorResultsScreen: (context) =>
        ServiceCalculatorResultScreen(),
    RouteName.newHealthCertificatePage: (context) =>
        const NewHealthCertificatePage(),

    RouteName.healthLicenseDetailsScreen: (context) =>
        const HealthLicenseDetailsScreen(),

    RouteName.healthRequestDetailsScreen: (context) =>
        const HealthRequestDetailsScreen(),

    RouteName.DiggingMapDetailsPage: (context) => const DiggingMapDetailsPage(),

    RouteName.InvestmentMapDetailsPage: (context) =>
        const InvestmentMapDetailsPage(),
    RouteName.ResturantDetailsPage: (context) => const ResturantDetailsPage(),

    RouteName.DCDetails: (context) => const DCDetailsPage(),

    RouteName.IncidentDetails: (context) => const IncidentDetailsPage(),

    RouteName.InqDetails: (context) => const InqDetailsPage(),

    RouteName.ReqDetails: (context) => const ReqDetailsPage(),
    RouteName.VHRDetails: (context) => const VHRDetailsPage(),
    RouteName.DaemDetails: (context) => const DaemDetailsPage(),
    RouteName.mainAthkarPage: (context) => Athkar(),

    RouteName.boardingPage: (context) => const BoardingMainPage(),
    RouteName.athkarEntitesPage: (context) => const AthkarEntities(),

    RouteName.athkarEntityContentPage: (context) => const AthkarEntityContent(),

    RouteName.complinaceMapView: (context) => ComplinaceMapScreen(),
    RouteName.selfRatingMainPage: (context) => const SelfRatingMainPage(),
    RouteName.SelfRatingSectionPage: (context) => const SelfRatingSectionPage(),
    RouteName.selfRatingResultPage: (context) => const SelfRatingResultPage(),

    RouteName.complianceDetailsPage: (context) => const ComplianceDetailsPage(),
    RouteName.nonComplianceScreen: (context) => const NonComplianceScreen(),

    RouteName.submitCompliancePage: (context) => const SubmitCompliancePage(),
    RouteName.submitComplianceOTPPage: (context) => ComplianceOtpScreen(),

    RouteName.eventsMainPage: (context) => const EventsMainPage(),

    RouteName.eventsDetailsPage: (context) =>
        const SingleEventDescriptionPage(),
    RouteName.calendarMainPage: (context) => const MainPageCalendar(),
    RouteName.calendarDetailsPage: (context) => const CalendarDetailsPage(),

    RouteName.violationGuideMainPage: (context) =>
        const ViolationGuideSelectPage(),

    RouteName.violationCreatePage: (context) => const ViolationCreatePage(),

    RouteName.violationResultsPage: (context) => const ViolationResultsPage(),

    RouteName.violationRegulationDetailsPage: (context) =>
        const ApprovedViolationPage(),
//    cubit = ModalRoute.of(context)!.settings.arguments as PrayerTimesCubit;

    // Ekram

    RouteName.ekramOrdersScreen: (context) => const EkramOrdersPage(),

    RouteName.ekramHomeScreen: (context) => const EkramHomePage(),

    RouteName.ekramTransportationListScreen: (context) =>
        const EkramTransportationListPage(),

    RouteName.driverEkramTransportationListScreen: (context) =>
        const TransportRequestListPage(),

    RouteName.ekramBookingListScreen: (context) => const EkramBookingListPage(),

    RouteName.ekramSelectRequestTypeScreen: (context) =>
        const EkramSelectRequestTypePage(),

    RouteName.ekramRequestTransportationScreen: (context) =>
        const EkramRequestTransportationPage(),



    RouteName.ekramSuccessScreen: (context) => const EkramSuccessPage(),

    RouteName.IdenticalListPage: (context) =>
        const IdenticalListPage(),

    RouteName.driverEkramTransportationDetailsScreen: (context) =>
        const UsersEkramTransportationDetailsPage(),

    RouteName.EkramMapPage: (context) => EkramMapPage(),

    RouteName.ekramCemetryRequestScreen: (context) =>
        const EkramBookCemetryPage(),

    RouteName.EkramCemetryDetailsPage: (context) =>
        const EkramCemetryDetailsPage(),

    RouteName.EkramInquiryCemetryDetailsPage: (context) =>
        const InquiryCemetryDetailsPage(),

    RouteName.EkramInquiryCemetryResultsPage: (context) =>
        const InquiryCemetryResultsPage(),

    RouteName.EkramInquiryOrgnizationsDetailsPage: (context) =>
        const InquiryOrgnizaionDetailsPage(),

    RouteName.EkramInquiryOrgnizationsResultsPage: (context) =>
        const InquiryOrgnizationResultsPage(),

    RouteName.EkramInquiryOrgnizationsResultsDetailsPage: (context) =>
        const InquiryOrgnizationResultsDetailsPage(),

    RouteName.EkramInquiryGravesDetailsPage: (context) =>
        const InquiryGraveDetailsPage(),

    RouteName.EkramInquiryGravesResultsPage: (context) =>
        const InquiryGraveResultsPage(),

    RouteName.EkramBookCemetryStartService: (context) =>
        const EkramBookCemetryStartService(),

    RouteName.EkramInquiryPrintDetailsPage: (context) =>
        const InquiryPrintDetailsPage(),
    RouteName.EkramRequestTransportationStartService: (context) =>
        const EkramRequestTransportationStartService(),
    RouteName.DashbordDataPage: (context) => const DashbordDataPage(),
    // RouteName.SpecificServicePage: (context) => const AllServicesPage(),
    RouteName.jodDonationPage: (context) => const JodDonationPage(),
    RouteName.chatbot: (context) => const ChatBotScreen(),
    RouteName.chatHistoryDetailsRoute: (context) => const ChatHistoryDetails(),




    RouteName.surveyReportInqueryOverView: (context) =>
        const SurveyReportOverviewScreen(),
    RouteName.surveyReportInquery: (context) =>
        const SurveyReportInqueryScreen(),
    RouteName.surveyReportInqueryDetails: (context) =>
        const SurveyReportInqueryDetails(),
    RouteName.constructionLicenseInquery: (context) =>
        const ConstructionLicenseInqueryScreen(),
    RouteName.constructionLicenseInqueryDetails: (context) =>
        const ConstructionLicenseInqueryDetails(),
    RouteName.notificationsListScreen: (context) =>
        const NotificationsListScreen(),
    RouteName.notificationsDetailsScreen: (context) =>
        const NotificationsDetailsScreen(),

    RouteName.vDAllTypesScreen: (context) => const VDAllTypesScreen(),
    RouteName.daemTypeScreen: (context) => const DaemTypeScreen(),
    RouteName.generalInquiryTypeScreen: (context) =>
        const GeneralInquiryTypeScreen(),
    RouteName.mSRTypeScreen: (context) => const MSRTypeScreen(),
    RouteName.commercialPermitsScreen: (context) =>
        const CommercialPermitsScreen(),

    RouteName.Observer_Choose_Municipality: (context) =>
        const RegisterObserverHome(),
    RouteName.trainingScreen: (context) => const TrainingScreen(),

    RouteName.municipalServicesScreen: (context) => const MunicipalHomeServicesScreen()


  };

  static Map<String, Widget Function(BuildContext)> routes() {
    Map<String, Widget Function(BuildContext)> all = {};
    all.addAll(routesApp);
    all.addAll(etmamRoutes);
    all.addAll(CommercialRoutes.routes);
    all.addAll(AuthenticationRoutes.routes);
    all.addAll(ClassificationCertificateRoutes.routes);
    all.addAll(HomeServicesRoutes.routes);
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
