import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/notifiers/selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';

typedef CategorySelectionViewParams = (
  Iterable<Category> categories,
  Iterable<SubCategory> all,
  Set<SubCategory> selected,
  ValueChanged<Set<SubCategory>> onApply,
);

class CategorySelectionDialogViewNotifier
    extends SelectionDialogViewNotifier<SubCategory, String> {
  CategorySelectionDialogViewNotifier(this._params)
      : super(
          all: _params.$2,
          selected: _params.$3,
          selectionDialogApply: (subs) => _params.$4.call(subs),
          createSelectionView: CategorySelectionView.new,
        ) {
    _searchViews = selectionViews;

    _groupByCategory();
  }

  final CategorySelectionViewParams _params;

  Iterable<Category> get categories => _params.$1;

  Iterable<SubCategory> get subcategories => all;

  String search = '';

  bool nothingFound = false;

  late Iterable<SelectionView<String>> _searchViews = selectionViews;

  late final Map<Category, List<SelectionView<String>>> _groupedViews = {};

  Map<Category, List<SelectionView<String>>> get groupedViews => _groupedViews;

  /// Call this whenever search input changes.
  void onSearchInput(String input) {
    search = input;
    _filterCategories();
    notifyListeners();
  }

  void _filterCategories() {
    if (search.isEmpty) {
      _searchViews = selectionViews;
      nothingFound = false;
    } else {
      final lowerSearch = search.toLowerCase();

      final matchedCategories = categories.where(
        (category) => category.name.toLowerCase().contains(lowerSearch),
      );

      if (matchedCategories.isNotEmpty) {
        final matchedCatIds = matchedCategories.map((c) => c.id).toSet();

        final matchedSubs = subcategories.where(
          (sub) => matchedCatIds.contains(sub.categoryId),
        );

        final matchedSubNames = matchedSubs.map((s) => s.name).toSet();

        _searchViews = selectionViews.where(
          (view) => matchedSubNames.contains(view.title),
        );
      } else {
        _searchViews = selectionViews.where(
          (view) => view.title.toLowerCase().contains(lowerSearch),
        );
      }

      if (_searchViews.isEmpty) {
        _searchViews = selectionViews;
        nothingFound = true;
      }
    }

    _groupByCategory();
  }

  void toggleCategory({
    required String categoryId,
    required BuildContext context,
  }) {
    // 1. find all subcategories of this category
    final subs = subcategories.where((sub) => sub.categoryId == categoryId);

    if (subs.isEmpty) {
      return;
    }

    // 2. find related selectionViews
    final categoryViews = _searchViews.where(
      (view) => subs.any((sub) => sub.name == view.title),
    );

    if (categoryViews.isEmpty) {
      return;
    }

    // 3. determine if all are selected
    final bool allSelected = categoryViews.every((view) => view.isHighlighted);

    // 4. toggle each view
    for (final view in categoryViews) {
      final shouldToggle =
          allSelected ? view.isHighlighted : !view.isHighlighted;

      if (shouldToggle) {
        view.onTap(context);
      }
    }

    _filterCategories();

    notifyListeners();
  }

  void _groupByCategory() {
    _groupedViews.clear();

    final sortedCategories = Category.displayOrder
        .map((id) => categories.where((cat) => cat.id == id).firstOrNull)
        .whereType<Category>();

    for (final cat in sortedCategories) {
      // find real subcategories of this category
      final subs = subcategories.where((sub) => sub.categoryId == cat.id);

      // match search views against subcategory names
      final views = _searchViews.where(
        (view) => subs.any((sub) => sub.name == view.title),
      );

      _groupedViews[cat] = views.toList();
    }
    notifyListeners();
  }
}

class CategorySelectionView extends BaseSelectionView<SubCategory, String> {
  CategorySelectionView(super.object, super.selection);

  @override
  String get title => object.name;

  @override
  final selectionStrategy = toggleMultiple;

  @override
  String toString() =>
      'CategorySelectionView(title: $title, isHighlighted: $isHighlighted)';
}
