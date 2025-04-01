import 'package:mapness/features/saudi_pass/notifiers/offers_screen_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/selection_dialog_notifier.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog.dart';

class SortingSelectionDialogNotifier extends SelectionDialogNotifier<Sorting, Sorting> {
  SortingSelectionDialogNotifier(OffersFiltersViewNotifier parent)
      : super(
          all: Sorting.values,
          createSelectionView: SortingSelectionView.new,
          selected: parent.sortingSelected,
          stackRouter: parent.stackRouter,
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
