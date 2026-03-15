
import '../../remote_services/pega_web_service.dart';
import '../dependency_injection_exports.dart' show sl;

class OLDInjection {
  static void init() {

    sl.registerLazySingleton(() => PegaWebService());


  }
}
