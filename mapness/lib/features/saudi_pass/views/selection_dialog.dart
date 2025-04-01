import 'package:flutter/foundation.dart';

abstract class SelectionDialog<T> implements ResetSaveView, Listenable {
  Iterable<SelectionView<T>> get selectionViews;

  void tapCross();

  @override
  void tapSave();

  @override
  void tapReset();
}

abstract class ResetSaveView {
  void tapSave();

  void tapReset();
}

abstract class SelectionView<T> implements Listenable {
  bool get isHighlighted;

  T get title;

  void onTap();
}

enum Sorting { byRecency, byRating }
