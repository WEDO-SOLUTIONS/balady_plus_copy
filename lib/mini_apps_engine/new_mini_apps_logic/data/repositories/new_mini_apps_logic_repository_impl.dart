import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/data_sources/new_mini_apps_logic_data_source.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/repositories/new_mini_apps_logic_repository.dart';
import 'package:dartz/dartz.dart';

class NewMiniAppsLogicRepositoryImpl implements NewMiniAppsLogicRepository {
  final NewMiniAppsLogicDataSource dataSource;

  NewMiniAppsLogicRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Exception, NewMiniAppsLogicEntity>> getMiniApps(
    bool isLoggedInLifestyle,
    bool isLoggedInMunicipality,
    bool isUserAccountBusiness,
  ) async {
    final result = await dataSource.getMiniApps();

    return result.fold((e) => Left(e), (success) {
      //! Get mini apps
      final resultData = success.data.result;
      List<MiniApp> allMiniAppsUI = [];

      Map<String, MiniApp> parentMiniApp = {};
      Map<String, CategoryGroup> mapAppCategoryGroup = {};
      Map<String, EntryPoints> mapEntryPoints = {};

      // First, collect all mini apps
      for (final item in resultData.miniApps) {
        if (item.haveChilds) {
          if (item.childServices != null) {
            // this is parent
            parentMiniApp[item.serviceKey] = item;
            if (item.childServices?.isNotEmpty ?? false) {
              for (final child in item.childServices!) {
                MiniApp typeChild = child.copyWith(parentServiceKey: item.serviceKey);
                allMiniAppsUI.add(typeChild);
              }
            }
          }
        } else {
          allMiniAppsUI.add(item);
        }
      }

      // Removed app filtering from repository - this should be handled in the state layer
      // Return all apps and let the cubit handle business logic filtering

      // Now create groups and entry points from ALL apps
      for (final item in allMiniAppsUI) {
        _mapOnMiniAppEntryPoint(mapEntryPoints, item);
        _mapOnAppCategoryGroup(mapAppCategoryGroup, item, item.categories);
      }

      // Process groups to combine groups with < 2 apps
      final processedGroups = _processAppGroups(
        mapAppCategoryGroup.values.toList(),
        isLoggedInMunicipality,
        isUserAccountBusiness,
      );

      return Right(
        NewMiniAppsLogicEntity(
          parentMiniApp: parentMiniApp,
          miniApps: allMiniAppsUI,
          appGroups: processedGroups,
          entryPoints: mapEntryPoints.values.toList(),
        ),
      );
    });
  }

  Map<String, EntryPoints> _mapOnMiniAppEntryPoint(Map<String, EntryPoints> mapEntryPoints, MiniApp item) {
    for (var entryPoint in item.entryPoints) {
      if (mapEntryPoints[entryPoint.entryPointKey] == null) {
        mapEntryPoints[entryPoint.entryPointKey] = EntryPoints(
          entryPointKey: entryPoint.entryPointKey,
          arName: entryPoint.name,
          enName: entryPoint.name,
          isActive: true,
          apps: [item],
        );
      } else {
        mapEntryPoints[entryPoint.entryPointKey]!.apps.add(item);
      }
    }

    return mapEntryPoints;
  }

  Map<String, CategoryGroup> _mapOnAppCategoryGroup(
    Map<String, CategoryGroup> mapAppCategoryGroup,
    MiniApp item,
    List<MiniAppCategory> listMiniAppCategory,
  ) {
    for (var category in listMiniAppCategory) {
      CategoryGroup? mainCategoryGroup = mapAppCategoryGroup[category.id];
      if (mainCategoryGroup == null) {
        mainCategoryGroup = CategoryGroup(id: category.id, nameAr: category.name, nameEn: category.name, apps: []);
        mapAppCategoryGroup[category.id] = mainCategoryGroup;
      }
      if (category.subCategories?.isNotEmpty ?? false) {
        mainCategoryGroup.subCategoryGroup = _mapOnAppCategoryGroup(
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

  List<CategoryGroup> _processAppGroups(
    List<CategoryGroup> groups,
    bool isLoggedInMunicipality,
    bool isUserAccountBusiness,
  ) {
    final List<CategoryGroup> processedGroups = [];
    final List<MiniApp> otherServicesApps = [];

    for (final group in groups) {
      // Removed hardcoded business category filtering - this should be handled in the state layer

      // Regular processing - count apps recursively including subcategories
      final totalAppCount = _getTotalAppCount(group);
      if (totalAppCount >= 2) {
        processedGroups.add(group);
      } else if (totalAppCount == 1) {
        // Collect all apps from this group and its subcategories
        _collectAllApps(group, otherServicesApps);
      }
      // Groups with 0 apps are silently dropped
    }

    if (otherServicesApps.isNotEmpty) {
      processedGroups.add(
        CategoryGroup(
          id: 'other_services_group',
          nameAr: 'خدمات أخرى',
          nameEn: 'Other Services',
          apps: otherServicesApps,
        ),
      );
    }

    return processedGroups;
  }

  /// Recursively counts all apps in a group and its subcategories
  int _getTotalAppCount(CategoryGroup group) {
    int count = group.apps.length;

    if (group.subCategoryGroup != null) {
      for (final subGroup in group.subCategoryGroup!.values) {
        count += _getTotalAppCount(subGroup);
      }
    }

    return count;
  }

  /// Recursively collects all apps from a group and its subcategories
  void _collectAllApps(CategoryGroup group, List<MiniApp> collector) {
    collector.addAll(group.apps);

    if (group.subCategoryGroup != null) {
      for (final subGroup in group.subCategoryGroup!.values) {
        _collectAllApps(subGroup, collector);
      }
    }
  }
}
