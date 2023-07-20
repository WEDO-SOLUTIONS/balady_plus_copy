import '../../remote_services/api_service.dart';
import '../../remote_services/web_service.dart';
import '../dependency_injection_exports.dart' show sl;

class OLDInjection {
  static void init() {
    sl.registerLazySingleton(() => WebService());
    sl.registerLazySingleton(() => APIService());
  }
}
