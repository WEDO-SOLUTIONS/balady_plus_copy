import '../../../features/facility_qr/presentation/core/view_models/facility_details_view_model.dart';
import '../../../features/new_appointment/presentation/core/services/repository/appointment_repository.dart';
import '../../../features/new_appointment/presentation/core/services/view_models/new_appointment_view_model.dart';
import '../../remote_services/api_service.dart';
import '../../remote_services/web_service.dart';
import '../dependency_injection_exports.dart' show sl;

class OLDInjection {
  static void init() {
    sl.registerLazySingleton(() => FacilityQRDetailsViewModel());

    sl.registerLazySingleton(() => WebService());
    sl.registerLazySingleton(() => APIService());

    sl.registerLazySingleton(() => AppointmentRepository());
    sl.registerLazySingleton(() => NewAppointmentViewModel());
  }
}
