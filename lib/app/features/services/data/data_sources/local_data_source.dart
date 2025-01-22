
import 'package:balady_plus/app/features/services/core/services.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';


abstract class ServicesLocalDataSource {
  Future<HomeServices> getAllServices();
}

class ServicesLocalDataSourceImplementation implements ServicesLocalDataSource {

  @override
  Future<HomeServices> getAllServices() async {
    return HomeServices.fromJson(newServicesConfig);
  }

}
