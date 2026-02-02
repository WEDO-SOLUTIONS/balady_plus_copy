import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/data_sources/new_mini_apps_logic_data_source.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/repositories/new_mini_apps_logic_repository.dart';
import 'package:dartz/dartz.dart';

class NewMiniAppsLogicRepositoryImpl implements NewMiniAppsLogicRepository {
  final NewMiniAppsLogicDataSource dataSource;

  NewMiniAppsLogicRepositoryImpl({required this.dataSource});

  bool _isBusinessOnlyApp(MiniApp app) {
    final categories = app.categories;
    final isBusiness = categories.any(
      (c) =>
          c.id == '6f736c81-c998-4c3e-09ea-08de2cce6088' ||
          c.name == 'تطبيقات بلدية للأعمال' ||
          c.name == 'Business Municipal Apps',
    );
    final isIndividual = categories.any(
      (c) =>
          c.id == '124a4dd1-7a7b-47f1-09eb-08de2cce6088' ||
          c.name == 'تطبيقات بلدية للأفراد' ||
          c.name == 'Individual Municipal Apps',
    );
    return isBusiness && !isIndividual;
  }

  List<MiniApp> _filterMiniApps({
    required List<MiniApp> allApps,
    required bool isLoggedInLifestyle,
    required bool isLoggedInMunicipality,
    required bool isUserAccountBusiness,
  }) {
    //! Not logged in = show all
    if (!isLoggedInLifestyle && !isLoggedInMunicipality) {
      return allApps;
    }

    //! Lifestyle login = show all
    if (isLoggedInLifestyle && !isLoggedInMunicipality) {
      return allApps;
    }

    //! Municipality login
    if (isLoggedInMunicipality && !isLoggedInLifestyle ||
        isLoggedInMunicipality && isLoggedInLifestyle) {
      //! Business account = show all
      if (isLoggedInMunicipality == true && isUserAccountBusiness == true) {
        return allApps;
      }
      //! Individual account = hide business-only apps
      if (isLoggedInMunicipality == true && isUserAccountBusiness == false) {
        return allApps.where((app) => !_isBusinessOnlyApp(app)).toList();
      }
    }

    return allApps;
  }

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
                MiniApp typeChild = child.copyWith(
                  parentServiceKey: item.serviceKey,
                );
                allMiniAppsUI.add(typeChild);
              }
            }
          }
        } else {
          allMiniAppsUI.add(item);
        }
      }

      // Apply filtering based on user status
      final filteredMiniApps = _filterMiniApps(
        allApps: allMiniAppsUI,
        isLoggedInLifestyle: isLoggedInLifestyle,
        isLoggedInMunicipality: isLoggedInMunicipality,
        isUserAccountBusiness: isUserAccountBusiness,
      );

      // Now create groups and entry points from FILTERED apps
      for (final item in filteredMiniApps) {
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
          miniApps: filteredMiniApps,
          appGroups: processedGroups,
          entryPoints: mapEntryPoints.values.toList(),
        ),
      );
    });
  }

  Map<String, EntryPoints> _mapOnMiniAppEntryPoint(
    Map<String, EntryPoints> mapEntryPoints,
    MiniApp item,
  ) {
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
        mainCategoryGroup = CategoryGroup(
          id: category.id,
          nameAr: category.name,
          nameEn: category.name,
          apps: [],
        );
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
      // Check if this is the business category
      final isBusinessCategory =
          group.id == '6f736c81-c998-4c3e-09ea-08de2cce6088' ||
          group.nameAr == 'تطبيقات بلدية للأعمال' ||
          group.nameEn == 'Business Municipal Apps';

      // ALWAYS skip/hide the business category
      if (isBusinessCategory &&
          isLoggedInMunicipality == true &&
          isUserAccountBusiness == false) {
        continue; // Don't add it at all
      }

      // Regular processing for non-business categories
      if (group.apps.length >= 2) {
        processedGroups.add(group);
      } else if (group.apps.length == 1) {
        otherServicesApps.addAll(group.apps);
      }
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
}
