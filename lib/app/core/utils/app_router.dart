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

class AppRouter {}
