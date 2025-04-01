import 'package:mapness/features/saudi_pass/notifiers/offers_screen_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/selection_dialog_notifier.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';

class RecommendedTypeSelectionDialogNotifier extends SelectionDialogNotifier<RecommendedType, String> {
  RecommendedTypeSelectionDialogNotifier(OffersFiltersViewNotifier parent)
      : super(
          createSelectionView: RecommendedTypeSelectionView.new,
          selected: parent.recommendedTypesSelected,
          all: parent.lookups.recommendedTypes,
          stackRouter: parent.stackRouter,
          selectionDialogApply: parent.applyRecommendedTypes,
        );
}

class RecommendedTypeSelectionView extends BaseSelectionView<RecommendedType, String> {
  RecommendedTypeSelectionView(super.object, super.selected);

  @override
  String get title => object.name;

  @override
  final selectionStrategy = toggleMultiple;
}
