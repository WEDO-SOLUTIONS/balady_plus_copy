import 'package:flutter/foundation.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';

abstract class SettingsScreenView implements ResetSaveView, Listenable {
  String get cityTitle;

  void tapCity();

  Iterable<SelectionView<String>> get typeSelectionViews;

  Iterable<SelectionView<String>> get categorySelectionViews;

  void tapBack();

  @override
  void tapSave();

  @override
  void tapReset();
}
