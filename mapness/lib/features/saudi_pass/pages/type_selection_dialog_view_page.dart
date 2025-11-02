import 'package:auto_route/annotations.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/notifiers/recommended_type_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/widgets/selection_dialog_view_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

@RoutePage()
class TypeSelectionDialogViewPage extends StatelessWidget {
  final RecommendedTypeSelectionDialogViewNotifier selectionDialog;

  const TypeSelectionDialogViewPage({required this.selectionDialog, super.key});

  @override
  Widget build(BuildContext context) => SelectionDialogViewWidget(
        selectionDialogView: selectionDialog,
        title: context.l10n.saudiPassOffersPageFilterType,
        layoutBuilder: WrapLayout.new,
      );
}
