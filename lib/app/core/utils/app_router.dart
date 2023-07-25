import 'package:balady_plus/app/features/daem/daem_exports.dart';
import 'package:balady_plus/app/features/commercial_license/commercial_license_exports.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/create_objection_page_params.dart';
import 'package:balady_plus/app/features/objections/domain/entities/objection_details.dart';
import 'package:balady_plus/app/features/quran/presentation/pages/quran_bookmarks.dart';
import 'package:balady_plus/app/features/quran/quran_exports.dart';
import 'package:balady_plus/app/features/wallet/core/models/wallet_item.dart';
import 'package:flutter/material.dart'
    show AppBar, Center, MaterialPageRoute, Route, RouteSettings, Scaffold;
import 'package:flutter/widgets.dart' show SizedBox;

import '../../core/utils/utils_exports.dart'
    show RouteName, ScaleRotatePage, SliderUpPage;
import '../../features/_shared_feature_/presentation/pages/view_dms_image_screen.dart';
import '../../features/_shared_feature_/shared_feature_exports.dart';
import '../../features/_shared_feature_/data/entities/success_screen_args.dart';
import '../../features/_shared_feature_/presentation/pages/success_screen.dart';
import '../../features/appointments/presentation/core/models/appointment_details_screen_args.dart';
import '../../features/appointments/presentation/pages/appointment_details_screen.dart';
import '../../features/appointments/presentation/pages/appointments_list_screen.dart';
import '../../features/appointments/presentation/pages/previous_appointments_screen.dart';
import '../../features/bottom_navigation/bottom_navigation_exports.dart'
    show BottomNavigationPage;
import '../../features/calculator/presentation/pages/service_calculator_location_screen.dart';
import '../../features/calculator/presentation/pages/service_calculator_screen.dart';
import '../../features/daem/presentation/pages/daem_ticket_page.dart';
import '../../features/entry_point/entry_point_exports.dart' show SsoUserInfo;
import '../../features/health_certificate/presentation/core/models/health_request_details_screen_args.dart';
import '../../features/health_certificate/presentation/pages/health_license_details_screen.dart';
import '../../features/health_certificate/presentation/pages/health_request_details_screen.dart';
import '../../features/health_certificate/presentation/pages/new_health_certificate/new_health_certificate_page.dart';
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
import '../../features/zmzm_points/presentation/pages/zmzm_points_page.dart';
import '../../features/wallet/wallet_exports.dart';

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

      // objections page
      case RouteName.objections:
        return MaterialPageRoute(builder: (_) => const ObjectionsPage());

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

      case RouteName.DCCameraPage:
        CameraParamsPage params = settings.arguments as CameraParamsPage;

        return MaterialPageRoute(
          builder: (_) => DCCameraPage(params: params),
        );

      case RouteName.createDCDetailsPage:
        // CreateVDParamsPage params = settings.arguments as CreateVDParamsPage;
        return MaterialPageRoute(
          builder: (_) => CreateDCDetailsPage(),
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
        VeichlesListPageParams paramas =
            settings.arguments as VeichlesListPageParams;
        return MaterialPageRoute(
          builder: (_) => VeichlesListPage(params: paramas),
        );

      case RouteName.CreateRetriveDetailsPage:
        CreateRetrivePageParams params =
            settings.arguments as CreateRetrivePageParams;
        return MaterialPageRoute(
          builder: (_) => CreateRetriveDetailsPage(params: params),
        );

      case RouteName.DCVeichlePage:
        return MaterialPageRoute(
          builder: (_) => DCVehiclesPage(),
        );

      case RouteName.DCSelectRetreiveTypePage:
        return MaterialPageRoute(
          builder: (_) => DCSelectRetreiveTypePage(),
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
}
