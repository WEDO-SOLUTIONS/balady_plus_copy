
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/features/services/core/endpoints.dart';
import 'package:balady_plus/app/features/services/core/services.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';


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
      return HomeServices.fromJson(newServicesConfig);
    }
  }


}
