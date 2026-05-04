import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/notifiers/category_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/city_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_screen_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/recommended_type_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';
import 'package:mapness/features/saudi_pass/views/settings_screen_view.dart';

class SettingsScreenViewNotifier extends ChangeNotifier
    implements SettingsScreenView {
  final OffersFiltersViewNotifier parent;

  SettingsScreenViewNotifier(this.parent);

  late City citySelected = parent.citySelected;
  late final recommendedTypesSelected = Set.of(parent.recommendedTypesSelected);
  late final categoriesSelected = Set.of(parent.subCategoriesSelected);

  @override
  late final typeSelectionViews = parent.lookups.recommendedTypes.map(
    (it) => RecommendedTypeSelectionView(it, recommendedTypesSelected),
  );

  @override
  Iterable<SelectionView<String>> get categorySelectionViews =>
      parent.allSubCategories.map(
        (it) => CategorySelectionView(it, categoriesSelected),
      );

  @override
  Iterable<CategoryWithCount> get parentCategoriesWithCounts {
    final categories = parent.lookups.categories;
    final sortedCategories = Category.displayOrder
        .map((id) => categories.where((cat) => cat.id == id).firstOrNull)
        .whereType<Category>();

    final result = sortedCategories.map((category) {
      final subcategoriesForCategory =
          parent.allSubCategories.where((sub) => sub.categoryId == category.id);
      final selectedCount = categoriesSelected
          .where((sub) => sub.categoryId == category.id)
          .length;
      return CategoryWithCount(
        id: category.id,
        name: category.name,
        selectedCount: selectedCount,
        totalCount: subcategoriesForCategory.length,
      );
    }).toList();

    // Sort: selected categories first, then unselected
    return result
      ..sort((a, b) {
        final aSelected = a.selectedCount > 0;
        final bSelected = b.selectedCount > 0;
        if (aSelected && !bSelected) {
          return -1;
        }
        if (!aSelected && bSelected) {
          return 1;
        }
        return 0;
      });
  }

  @override
  void tapCategory(String categoryId) {
    final subcategoriesForCategory = parent.allSubCategories
        .where((sub) => sub.categoryId == categoryId)
        .toSet();
    final selectedForCategory =
        categoriesSelected.where((sub) => sub.categoryId == categoryId).toSet();

    final allSelected =
        selectedForCategory.length == subcategoriesForCategory.length;

    if (allSelected) {
      // Unselect all subcategories of this category
      categoriesSelected.removeAll(subcategoriesForCategory);
    } else {
      // Select all subcategories of this category
      categoriesSelected.addAll(subcategoriesForCategory);
    }
    notifyListeners();
  }

  @override
  void tapBack(BuildContext context) => context.router.pop();

  @override
  String get cityTitle => citySelected.name;

  @override
  Future<void> tapCity(BuildContext context) async {
    final citySelectionDialog =
        CitySelectionDialogViewNotifier(parent.lookups.cities);
    final city = await context.router.push<City>(
      CitySelectionDialogViewRoute(
          citySelectionDialogView: citySelectionDialog),
    );
    if (city != null) {
      citySelected = city;
      notifyListeners();
    }
  }

  @override
  Future<void> tapShowAllCategories(BuildContext context) async {
    final selectionDialog = CategorySelectionDialogViewNotifier(
      (
        parent.lookups.categories,
        parent.allSubCategories,
        categoriesSelected,
        _applyFromDialog,
      ),
    );
    await context.router.push(
      AllCategoriesSelectionDialogViewRoute(
        selectionDialogView: selectionDialog,
      ),
    );
  }

  void _applyFromDialog(Set<SubCategory> updated) {
    categoriesSelected
      ..clear()
      ..addAll(updated);
    notifyListeners();
  }

  @override
  void tapReset() {
    citySelected = parent.defaultCity;
    recommendedTypesSelected.clear();
    categoriesSelected.clear();
    notifyListeners();
  }

  @override
  void tapSave(BuildContext context) {
    parent.applySettings(
        citySelected, recommendedTypesSelected, categoriesSelected);
    context.router.pop();
  }
}
