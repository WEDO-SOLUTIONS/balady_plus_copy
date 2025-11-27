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
        List<MiniApp> allMiniAppsUI = [];

        Map<String, MiniApp> parentMiniApp = {};
        Map<String, CategoryGroup> mapAppCategoryGroup = {};
        Map<String, EntryPoints> mapEntryPoints = {};

        // final appGroups = <CategoryGroup>[];
        // final entryPoints = <EntryPoints>[];

        // final realApps = _realMiniApps(resultData);
        //
        // final miniAppItems = realApps.toList();
        //
        // final appGroups = <CategoryGroup>[];
        // final entryPoints = <EntryPoints>[];
        //
        // for (final category in resultData.categories) {
        //   final appsInCategory = <MiniApp>[];
        //
        //   for (final app in realApps) {
        //     final belongs =
        //         app.categories.any((miniCat) => miniCat.id == category.id);
        //
        //     if (belongs) {
        //       appsInCategory.add(app);
        //     }
        //   }
        //
        //   if (appsInCategory.isNotEmpty && category.isActive == true) {
        //     appGroups.add(
        //       CategoryGroup(
        //         id: category.id,
        //         nameAr: category.arName,
        //         nameEn: category.enName,
        //         apps: appsInCategory,
        //       ),
        //     );
        //   }
        // }
        //
        // for (final ep in resultData.entryPoints) {
        //   final appsForEntryPoint = miniAppItems
        //       .where(
        //         (app) => app.entryPoints.any(
        //           (entry) => entry.entryPointKey == ep.entryPointKey,
        //         ),
        //       )
        //       .toList();
        //
        //   if (appsForEntryPoint.isNotEmpty && ep.isActive == true) {
        //     entryPoints.add(
        //       EntryPoints(
        //         id: ep.id,
        //         entryPointKey: ep.entryPointKey,
        //         arName: ep.arName,
        //         enName: ep.enName,
        //         isActive: ep.isActive,
        //         apps: appsForEntryPoint,
        //       ),
        //     );
        //   }
        // }

        for (final item in resultData.miniApps) {
          if (item.haveChilds) {
            if (item.childServices != null) {
              // this is parent
              parentMiniApp[item.serviceKey] = item;
              if (item.childServices?.isNotEmpty ?? false) {
                for (final child in item.childServices!) {
                  MiniApp typeChild = child.copyWith(
                    parentServiceKey: item.serviceKey,
                  );
                  allMiniAppsUI.add(typeChild);
                  mapOnMiniAppEntryPoint(mapEntryPoints, typeChild);
                  mapOnAppCategoryGroup(mapAppCategoryGroup, typeChild);
                }
              }
            }
          } else {
            allMiniAppsUI.add(item);
            mapOnMiniAppEntryPoint(mapEntryPoints, item);
            mapOnAppCategoryGroup(mapAppCategoryGroup, item);
          }
        }

        return Right(
          NewMiniAppsLogicEntity(
            parentMiniApp: parentMiniApp,
            miniApps: allMiniAppsUI, // Mini Apps With Out Parent Have chiled
            appGroups: mapAppCategoryGroup.values.toList(),
            entryPoints: mapEntryPoints.values.toList(),
          ),
        );
      },
    );
  }

  Map<String, EntryPoints> mapOnMiniAppEntryPoint(
      Map<String, EntryPoints> mapEntryPoints, MiniApp item) {
    for (var entryPoints in item.entryPoints) {
      if (mapEntryPoints[entryPoints.entryPointKey] == null) {
        mapEntryPoints[entryPoints.entryPointKey] = EntryPoints(
          entryPointKey: entryPoints.entryPointKey,
          arName: entryPoints.name,
          enName: entryPoints.name,
          isActive: true,
          apps: [item],
        );
      } else {
        mapEntryPoints[entryPoints.entryPointKey]!.apps.add(item);
      }
    }

    return mapEntryPoints;
  }

  Map<String, CategoryGroup> mapOnAppCategoryGroup(
      Map<String, CategoryGroup> mapAppCategoryGroup, MiniApp item) {
    for (var category in item.categories) {
      if (mapAppCategoryGroup[category.id] == null) {
        mapAppCategoryGroup[category.id] = CategoryGroup(
          id: category.id,
          nameAr: category.name,
          nameEn: category.name,
          apps: [item],
        );
      } else {
        mapAppCategoryGroup[category.id]!.apps.add(item);
      }
    }
    return mapAppCategoryGroup;
  }

// List<MiniApp> _realMiniApps(Data data) {
//   final result = <MiniApp>[];
//
//   for (final item in data.miniApps) {
//     if (!item.haveChilds) {
//       result.add(item);
//     } else {
//       if (item.childServices != null) {
//         for (final child in item.childServices!) {
//           if (!child.haveChilds) {
//             result.add(child);
//           }
//         }
//       }
//     }
//   }
//
//   return result;
// }
}
