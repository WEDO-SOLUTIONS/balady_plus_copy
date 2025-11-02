import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';

abstract class SelectionDialogViewNotifier<T, S> extends ChangeNotifier implements SelectionDialogView<S> {
  SelectionDialogViewNotifier({
    required this.all,
    required Set<T> selected,
    required this.createSelectionView,
    required this.selectionDialogApply,
  }) : selected = Set.of(selected);

  final Iterable<T> all;
  final Set<T> selected;

  final void Function(Set<T> updates) selectionDialogApply;

  @override
  late final Iterable<SelectionView<S>> selectionViews = all.map((it) => createSelectionView(it, selected)).toList();

  final SelectionView<S> Function(T object, Set<T> selected) createSelectionView;

  @override
  void tapReset() {
    selected.clear();
    notifyListeners();
  }

  @override
  void tapSave(BuildContext context) {
    selectionDialogApply(selected);
    context.router.popForced();
  }

  @override
  void tapCross(BuildContext context) => context.router.popForced();
}

abstract class BaseSelectionView<T, S> extends ChangeNotifier implements SelectionView<S> {
  final Set<T> selected;
  final T object;

  BaseSelectionView(this.object, this.selected);

  SelectionStrategy get selectionStrategy;

  @override
  bool get isHighlighted => selected.contains(object);

  @override
  void onTap(BuildContext context) {
    selectionStrategy(selected, object);
    notifyListeners();
  }
}

typedef SelectionStrategy<T> = void Function(Set<T>, T object);

void toggleSingle<T>(Set<T> set, T object) {
  toggleMultiple(set, object);
  set.retainAll({object});
}

void toggleMultiple<T>(Set<T> set, T object) {
  if (!set.add(object)) {
    set.remove(object);
  }
}
