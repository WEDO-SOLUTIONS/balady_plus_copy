import 'package:balady_plus/app/features/appointments/presentation/core/services/view_models/my_appointments_view_model.dart';
import 'package:balady_plus/app/features/calculator/core/calculator_location_view_model.dart';
import 'package:balady_plus/app/features/health_certificate/license_management_exports.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/services/customer_voice_repository.dart';

import '../../../features/appointments/presentation/core/services/view_models/appontment_details_view_model.dart';
import '../../../features/facility_qr/presentation/core/view_models/facility_details_view_model.dart';
import '../../../features/health_certificate/presentation/core/services/view_models/main_health_license_view_model.dart';
import '../../../features/health_certificate/presentation/core/services/view_models/new_details_health_license_view_model.dart';
import '../../../features/health_certificate/presentation/core/services/view_models/new_health_license_view_model.dart';
import '../../../features/health_certificate/presentation/core/services/view_models/new_terms_health_license_view_model.dart';
import '../../../features/new_appointment/presentation/core/services/repository/appointment_repository.dart';
import '../../../features/new_appointment/presentation/core/services/view_models/new_appointment_view_model.dart';
import '../../../features/transaction_inquiry/presentation/core/view_models/inquiry/inquiry_view_model.dart';
import '../../../features/transaction_inquiry/presentation/core/view_models/msr/new_msr_details_view_model.dart';
import '../../../features/transaction_inquiry/presentation/core/view_models/msr/new_msr_map_view_model.dart';
import '../../../features/transaction_inquiry/presentation/core/view_models/msr/new_msr_view_model.dart';
import '../../remote_services/api_service.dart';
import '../../remote_services/pega_web_service.dart';
import '../dependency_injection_exports.dart' show sl;

class OLDInjection {
  static void init() {
    sl.registerLazySingleton(() => FacilityQRDetailsViewModel());

    sl.registerLazySingleton(() => PegaWebService());
    sl.registerLazySingleton(() => APIService());

    sl.registerLazySingleton(() => AppointmentRepository());
    sl.registerLazySingleton(() => NewAppointmentViewModel());
    sl.registerLazySingleton(() => InquiryViewModel());

    sl.registerLazySingleton(() => NewMSRViewModel());
    sl.registerLazySingleton(() => NewMSRMapViewModel());
    sl.registerLazySingleton(() => CustomerVoiceRepository());

    sl.registerLazySingleton(() => NewMSRDetailsViewModel());
    sl.registerLazySingleton(() => CalculatorLocationViewModel());

    sl.registerLazySingleton(() => AppointmentDetailsViewModel());

    sl.registerLazySingleton(() => MyAppointmentsViewModel());

    sl.registerLazySingleton(() => NewDetailsHealthLicenseViewModel());
    sl.registerLazySingleton(() => HealthLicenseViewModel());
    sl.registerLazySingleton(() => NewTermsHealthLicenseViewModel());
    sl.registerLazySingleton(() => MainHealthLicenseViewModel());
    sl.registerLazySingleton(() => HealthLicenseRepository());
  }
}
