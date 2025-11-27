import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/data_sources/new_mini_apps_logic_data_source.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/repositories/new_mini_apps_logic_repository.dart';
import 'package:dartz/dartz.dart';

class NewMiniAppsLogicRepositoryImpl implements NewMiniAppsLogicRepository {
  final NewMiniAppsLogicDataSource dataSource;

  NewMiniAppsLogicRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Exception, NewMiniAppsLogicEntity>> getMiniApps() async {
    final result = await dataSource.getMiniApps();

    return result.fold(
      (e) => Left(e),
      (success) {
        //! Get mini apps
        final resultData = success.data.result;
        final realApps = _realMiniApps(resultData);

        final miniAppItems = realApps.toList();

        final appGroups = <CategoryGroup>[];
        final entryPoints = <EntryPoints>[];

        for (final category in resultData.categories) {
          final appsInCategory = <MiniApp>[];

          for (final app in realApps) {
            final belongs =
                app.categories.any((miniCat) => miniCat.id == category.id);

            if (belongs) {
              appsInCategory.add(app);
            }
          }

          if (appsInCategory.isNotEmpty && category.isActive == true) {
            appGroups.add(
              CategoryGroup(
                id: category.id,
                nameAr: category.arName,
                nameEn: category.enName,
                apps: appsInCategory,
              ),
            );
          }
        }

        for (final ep in resultData.entryPoints) {
          final appsForEntryPoint = miniAppItems
              .where(
                (app) => app.entryPoints.any(
                  (entry) => entry.entryPointKey == ep.entryPointKey,
                ),
              )
              .toList();

          if (appsForEntryPoint.isNotEmpty && ep.isActive == true) {
            entryPoints.add(
              EntryPoints(
                id: ep.id,
                entryPointKey: ep.entryPointKey,
                arName: ep.arName,
                enName: ep.enName,
                isActive: ep.isActive,
                apps: appsForEntryPoint,
              ),
            );
          }
        }

        return Right(
          NewMiniAppsLogicEntity(
            miniApps: miniAppItems,
            appGroups: appGroups,
            entryPoints: entryPoints,
          ),
        );
      },
    );
  }

  List<MiniApp> _realMiniApps(Data data) {
    final result = <MiniApp>[];

    for (final item in data.miniApps) {
      if (!item.haveChilds) {
        result.add(item);
      } else {
        if (item.childServices != null) {
          for (final child in item.childServices!) {
            if (!child.haveChilds) {
              result.add(child);
            }
          }
        }
      }
    }

    return result;
  }
}
