import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/notifiers/category_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/widgets/all_categories_selection_dialog_view_widget.dart';

@RoutePage()
class AllCategoriesSelectionDialogViewPage extends StatelessWidget {
  final CategorySelectionDialogViewNotifier selectionDialogView;

  const AllCategoriesSelectionDialogViewPage({
    required this.selectionDialogView,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AllCategoriesSelectionDialogViewWidget(
        selectionDialogView,
      );
}
