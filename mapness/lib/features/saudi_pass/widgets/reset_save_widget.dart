import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ResetSaveWidget extends StatelessWidget {
  final ResetSaveView resetSaveView;

  const ResetSaveWidget(this.resetSaveView, {super.key});

  @override
  Widget build(BuildContext context) {
    final resetButton = AppButton(
      primaryLabel: context.l10n.saudiPassDialogReset,
      onTap: resetSaveView.tapReset,
      size: ButtonSize.large,
      buttonColorScheme: ButtonColorScheme.accentSecondary,
      buttonType: ButtonType.secondary,
    );

    final saveButton = AppButton(
      primaryLabel: context.l10n.saudiPassDialogSave,
      onTap: () => resetSaveView.tapSave(context),
      size: ButtonSize.large,
      buttonColorScheme: ButtonColorScheme.accentSecondary,
    );

    return Row(
      children: [
        Expanded(child: resetButton),
        const SizedBox(width: Spacing.$2x),
        Expanded(child: saveButton),
      ],
    );
  }
}
