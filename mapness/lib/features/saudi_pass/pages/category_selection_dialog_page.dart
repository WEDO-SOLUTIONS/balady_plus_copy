import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/notifiers/category_selection_dialog_notifier.dart';
import 'package:mapness/features/saudi_pass/widgets/selection_dialog_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

@RoutePage()
class CategorySelectionDialogPage extends StatelessWidget {
  final CategorySelectionDialogNotifier selectionDialog;

  const CategorySelectionDialogPage({required this.selectionDialog, super.key});

  @override
  Widget build(BuildContext context) => SelectionDialogWidget(
        selectionDialog: selectionDialog,
        title: context.l10n.saudiPassOffersPageFilterCategory,
        layoutBuilder: WrapLayout.new,
      );
}
