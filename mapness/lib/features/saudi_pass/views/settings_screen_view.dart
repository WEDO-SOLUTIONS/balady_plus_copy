import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';

abstract class SettingsScreenView implements ResetSaveView, Listenable {
  String get cityTitle;

  void tapCity(BuildContext context);

  Iterable<SelectionView<String>> get typeSelectionViews;

  Iterable<SelectionView<String>> get categorySelectionViews;

  void tapBack(BuildContext context);

  @override
  void tapSave(BuildContext context);

  @override
  void tapReset();
}
