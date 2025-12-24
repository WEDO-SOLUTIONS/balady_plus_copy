import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/repositories/new_mini_apps_logic_repository.dart';
import 'package:dartz/dartz.dart';

class GetNewMiniAppsLogicUseCase {
  final NewMiniAppsLogicRepository repository;

  GetNewMiniAppsLogicUseCase(this.repository);

  Future<Either<Exception, NewMiniAppsLogicEntity>> call() {
    return repository.getMiniApps();
  }
}
