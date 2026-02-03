import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:dartz/dartz.dart';

abstract class NewMiniAppsLogicRepository {
  Future<Either<Exception, NewMiniAppsLogicEntity>> getMiniApps(
    final bool isLoggedInLifestyle,
    final bool isLoggedInMunicipality,
    final bool isUserAccountBusiness,
  );
}
