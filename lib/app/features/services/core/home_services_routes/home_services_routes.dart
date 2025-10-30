import 'package:balady_plus/app/features/services/core/home_services_routes/home_services_route_names.dart';
import 'package:balady_plus/app/features/services/presentation/pages/dynamic_cards_services_screen.dart';
import 'package:balady_plus/app/features/services/presentation/pages/sub_services_screen.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/utils/constants/route_names.dart';

class HomeServicesRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    HomeServicesRouteName.subServicesScreen: (context) => const SubServicesScreen(),
    HomeServicesRouteName.dynamicCardsServicesScreen: (context) => const DynamicCardsServicesScreen(),
  };
}





  // Map<String, Widget Function(BuildContext)> routes = {
  //   RouteName.vDAllTypesScreen: (context) => const VDAllTypesScreen(),
  //   RouteName.createCompliancePage: (context) => const CreateComplianceLocationPage(),
  //   RouteName.objectableTransactions: (context) => const ObjectableTransactionsPage(),
  //   RouteName.NewAppointmentPage: (context) => const NewAppointmentPage(),
  //   RouteName.mSRTypeScreen: (context) => const MSRTypeScreen(),
  //   RouteName.etmamMainPage: (context) => const EtmamMainPage(),
  //   RouteName.cityServicesEtmamMainPage: (context) => const CityServicesEtmamMainPage(),
  //   RouteName.DCCameraPage: (context) => const DCCameraPage(),
  //   RouteName.DCVeichlePage: (context) => const DCVehiclesPage(),
  //   RouteName.newHealthCertificatePage: (context) => const NewHealthCertificatePage(),
  //   RouteName.ekramTransportationListScreen: (context) => const EkramTransportationListPage(),
  //   RouteName.EkramInquiryCemetryDetailsPage: (context) => const InquiryCemetryDetailsPage(),
  //   RouteName.EkramInquiryCemetryResultsPage: (context) => const InquiryCemetryResultsPage(),
  //   RouteName.EkramInquiryOrgnizationsDetailsPage: (context) => const InquiryOrgnizaionDetailsPage(),
  //   RouteName.EkramInquiryPrintDetailsPage: (context) => const InquiryPrintDetailsPage(),
  //   RouteName.ekramBookingListScreen: (context) => const EkramBookingListPage(),
  //   RouteName.driverEkramTransportationListScreen: (context) => const DriverEkramTransportationListPage(),
  //   RouteName.selfRatingMainPage: (context) => const SelfRatingMainPage(),
  //   RouteName.constructionLicenseInquery: (context) => const ConstructionLicenseInqueryScreen(),
  //   RouteName.surveyReportInquery: (context) => const SurveyReportInqueryScreen(),
  //   RouteName.daemTypeScreen: (context) => const DaemTypeScreen(),
  //   RouteName.generalInquiryTypeScreen: (context) => const GeneralInquiryTypeScreen(),
  //   RouteName.commercialPermitsScreen: (context) => const CommercialPermitsScreen(),
  //   RouteName.smartAdvisorAppScreen: (context) => const SmartAdvisorApp()
  //   RouteName.baladyCalendarPage: (context) => const BaladyCalendarPage(),
  //   RouteName.violationGuideMainPage: (context) => const ViolationGuideSelectPage(),
  //   RouteName.calculatorMapRoute: (context) => const ServiceCalculatorLocationScreen(),
  //   RouteName.qrScreenRoute: (context) => const QrScreen(),
  //   RouteName.newTransactionInquiryScreen: (context) => const NewTransactionPage(),
  //   HomeServicesRouteName.subServicesScreen: (context) => const SubServicesScreen(),
  //   ClassificationCertificateRouteName.classificationCertificateVerifyScreen: (context) => const ClassificationCertificateVerifyScreen(),
  //   CommercialRouteName.commercialLicenseQuery: (context) => const CommercialLicenseQueryScreen(),
  //   CommercialRouteName.commercialLicensePage: (context) => const CommercialLicenseScreen(),
  //   CommercialRouteName.tobaccoServicesList: (context) => const TobaccoListPage(),
  // };
