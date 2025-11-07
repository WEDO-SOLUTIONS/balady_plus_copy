import 'package:mapness/features/saudi_pass/notifiers/offers_screen_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';

class CategorySelectionDialogViewNotifier extends SelectionDialogViewNotifier<Category, String> {
  CategorySelectionDialogViewNotifier(OffersFiltersViewNotifier parent)
      : super(
          all: parent.lookups.categories,
          selected: parent.categoriesSelected,
          selectionDialogApply: parent.applyCategories,
          createSelectionView: CategorySelectionView.new,
        );
}

class CategorySelectionView extends BaseSelectionView<Category, String> {
  CategorySelectionView(super.object, super.selection);

  @override
  String get title => object.name;

  @override
  final selectionStrategy = toggleMultiple;
}
