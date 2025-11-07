import 'package:flutter/widgets.dart';

abstract class SelectionDialogView<T> implements ResetSaveView, Listenable {
  Iterable<SelectionView<T>> get selectionViews;

  void tapCross(BuildContext context);

  @override
  void tapSave(BuildContext context);

  @override
  void tapReset();
}

abstract class ResetSaveView {
  void tapSave(BuildContext context);

  void tapReset();
}

abstract class SelectionView<T> implements Listenable {
  bool get isHighlighted;

  T get title;

  void onTap(BuildContext context);
}

enum Sorting { byRecency, byRating }
