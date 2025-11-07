import 'package:mapness/features/saudi_pass/notifiers/offers_screen_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';

class SortingSelectionDialogViewNotifier extends SelectionDialogViewNotifier<Sorting, Sorting> {
  SortingSelectionDialogViewNotifier(OffersFiltersViewNotifier parent)
      : super(
          all: Sorting.values,
          createSelectionView: SortingSelectionView.new,
          selected: parent.sortingSelected,
          selectionDialogApply: parent.applySorting,
        );
}

class SortingSelectionView extends BaseSelectionView<Sorting, Sorting> {
  SortingSelectionView(super.object, super.selection);

  @override
  Sorting get title => object;

  @override
  final selectionStrategy = toggleSingle;
}
