
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';


abstract class MiniAppsLocalDataSource {
  Future<List<MiniAppModel>> getAllServices();
}

class MiniAppsDataSourceImplementation implements MiniAppsLocalDataSource {

  final WebService webServices;

  MiniAppsDataSourceImplementation({required this.webServices});

  @override
  Future<List<MiniAppModel>> getAllServices() async {
    var response;
    // try {
      response = await webServices.dio.get("/v1/balady-mini-apps/services");
      var data = response.data["data"]["result"];

      List<MiniAppModel> list = data.map((e) => MiniAppModel.fromJson(e)).toList();

      return list;
    // } catch (_) {
    //   return HomeServices.fromJson(newServicesConfig[sl<EnvType>().name]["locale".tr()]);
    // }
  }



}
