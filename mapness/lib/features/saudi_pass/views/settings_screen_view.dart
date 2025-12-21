import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';

abstract class SettingsScreenView implements ResetSaveView, Listenable {
  String get cityTitle;

  void tapCity(BuildContext context);

  Iterable<SelectionView<String>> get typeSelectionViews;

  Iterable<SelectionView<String>> get categorySelectionViews;

  /// Returns parent categories with count of selected subcategories
  Iterable<CategoryWithCount> get parentCategoriesWithCounts;

  void tapBack(BuildContext context);

  void tapShowAllCategories(BuildContext context);

  void tapCategory(String categoryId);

  @override
  void tapSave(BuildContext context);

  @override
  void tapReset();
}

class CategoryWithCount {
  final String id;
  final String name;
  final int selectedCount;
  final int totalCount;

  const CategoryWithCount({
    required this.id,
    required this.name,
    required this.selectedCount,
    required this.totalCount,
  });

  bool get allSelected => selectedCount == totalCount && totalCount > 0;
}
