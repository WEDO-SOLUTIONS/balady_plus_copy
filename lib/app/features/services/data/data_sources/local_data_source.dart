
import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';
import 'package:balady_plus/app/features/services/core/endpoints.dart';
import 'package:balady_plus/app/features/services/core/services.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


abstract class ServicesLocalDataSource {
  Future<HomeServices> getAllServices();
}

class ServicesLocalDataSourceImplementation implements ServicesLocalDataSource {

  final WebService webServices;

  ServicesLocalDataSourceImplementation({required this.webServices});

  @override
  Future<HomeServices> getAllServices() async {
    var response;
    try {
      response = await webServices.dio.get(HomeServicesEndpoints.getHomeServices);
      var data = response.data["data"]["result"];
      return HomeServices.fromJson(data);
    } catch (_) {
      return HomeServices.fromJson(newServicesConfig[sl<EnvType>().name]["locale".tr()]);
    }
  }


}
