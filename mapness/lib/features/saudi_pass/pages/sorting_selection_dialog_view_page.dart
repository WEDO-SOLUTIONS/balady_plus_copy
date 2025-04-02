import 'package:auto_route/annotations.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/notifiers/sorting_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/widgets/selection_dialog_view_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

@RoutePage()
class SortingSelectionDialogPage extends StatelessWidget {
  final SortingSelectionDialogViewNotifier selectionDialog;

  const SortingSelectionDialogPage({required this.selectionDialog, super.key});

  @override
  Widget build(BuildContext context) => SelectionDialogViewWidget(
        backgroundColor: context.colorsV3.backgroundSurface4,
        selectionDialogView: selectionDialog,
        title: context.l10n.saudiPassOffersPageFilterCategory,
        layoutBuilder: ContentRowLayout.new,
      );
}
