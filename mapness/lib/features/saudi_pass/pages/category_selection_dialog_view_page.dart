import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/notifiers/category_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/widgets/selection_dialog_view_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

@RoutePage()
class CategorySelectionDialogViewPage extends StatelessWidget {
  final CategorySelectionDialogViewNotifier selectionDialogView;

  const CategorySelectionDialogViewPage({required this.selectionDialogView, super.key});

  @override
  Widget build(BuildContext context) => SelectionDialogViewWidget(
        selectionDialogView: selectionDialogView,
        title: context.l10n.saudiPassOffersPageFilterCategory,
        layoutBuilder: WrapLayout.new,
      );
}
