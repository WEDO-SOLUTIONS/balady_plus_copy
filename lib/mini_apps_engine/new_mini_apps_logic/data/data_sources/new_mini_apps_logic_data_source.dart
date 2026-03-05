import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class NewMiniAppsLogicDataSource {
  Future<Either<Exception, NewMiniAppLogicResponseModel>> getMiniApps();
}

class NewMiniAppsLogicDataSourceImpl implements NewMiniAppsLogicDataSource {
  final WebService webServices;

  NewMiniAppsLogicDataSourceImpl({
    required this.webServices,
  });

  @override
  Future<Either<Exception, NewMiniAppLogicResponseModel>> getMiniApps() async {
    try {
      final response = await webServices.dio.get(
        "/v2/balady-mini-apps/services",
      );

      if (response.data == null) {
        return Left(Exception('Response data is null'));
      }

      final Map<String, dynamic> responseData = response.data as Map<String, dynamic>;

      final model = NewMiniAppLogicResponseModel.fromJson(responseData);
      return Right(model);
    } catch (e) {
      return Left(Exception('Failed to load mini apps: $e'));
    }
  }
}
