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
                  mapOnAppCategoryGroup(
                    mapAppCategoryGroup,
                    typeChild,
                    typeChild.categories,
                  );
                }
              }
            }
          } else {
            allMiniAppsUI.add(item);
            mapOnMiniAppEntryPoint(mapEntryPoints, item);
            mapOnAppCategoryGroup(
              mapAppCategoryGroup,
              item,
              item.categories,
            );
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
      Map<String, CategoryGroup> mapAppCategoryGroup,
      MiniApp item,
      List<MiniAppCategory> listMiniAppCategory) {
    for (var category in listMiniAppCategory) {
      CategoryGroup? mainCategoryGroup = mapAppCategoryGroup[category.id];
      if (mainCategoryGroup == null) {
        mainCategoryGroup = CategoryGroup(
          id: category.id,
          nameAr: category.name,
          nameEn: category.name,
          apps: [],
        );
        mapAppCategoryGroup[category.id] = mainCategoryGroup;
      }
      if (category.subCategories?.isNotEmpty ?? false) {
        /// Fix It : add  copyWith
        mainCategoryGroup.subCategoryGroup = mapOnAppCategoryGroup(
          mainCategoryGroup.subCategoryGroup ?? {},
          item,
          category.subCategories!,
        );
      } else {
        mapAppCategoryGroup[category.id]!.apps.add(item);
      }
    }
    return mapAppCategoryGroup;
  }
}
