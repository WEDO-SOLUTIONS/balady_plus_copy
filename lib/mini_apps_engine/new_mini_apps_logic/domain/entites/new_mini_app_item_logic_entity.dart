//! Mini apps that has list of categories and entrypoints ...
//! Assign each mini app to matched categoryId and matched entryPointKey ...
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';

// class MiniAppItem {
//   final String id;
//   final String name;
//   final String description;
//   final String iconPath;
//   final List<String> categoryIds;
//   final List<String> entryPointsKey;

//   MiniAppItem({
//     required this.id,
//     required this.name,
//     required this.iconPath,
//     required this.categoryIds,
//     required this.entryPointsKey,
//     required this.description,
//   });
// }

//! Get the category parent and add list of miniAppItem to it ...
class CategoryGroup {
  final String id;
  final String nameAr;
  final String nameEn;
  final List<MiniApp> apps;

  /// Fix It  add  copyWith
  Map<String, CategoryGroup>? subCategoryGroup;

  CategoryGroup({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.apps,
    this.subCategoryGroup,
  });

  int get appCount => apps.length;
}

//! Get the entry point parent and add list of miniAppItem to it ...
class EntryPoints {
  // final String id;
  final String entryPointKey;
  final String arName;
  final String enName;
  final bool isActive;
  final List<MiniApp> apps;
  const EntryPoints({
    // required this.id,
    required this.entryPointKey,
    required this.arName,
    required this.enName,
    required this.isActive,
    required this.apps,
  });
}

class NewMiniAppsLogicEntity {
  final List<MiniApp> miniApps;
  final Map<String, MiniApp> parentMiniApp;
  final List<CategoryGroup> appGroups;
  final List<EntryPoints> entryPoints;

  NewMiniAppsLogicEntity({
    required this.miniApps,
    required this.parentMiniApp,
    required this.appGroups,
    required this.entryPoints,
  });
}
