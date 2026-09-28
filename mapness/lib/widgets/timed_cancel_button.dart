import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/timed_fill_button.dart';

/// Cancel of the guidance sheets: fills up during [duration], then fires [onTimeout].
class TimedCancelButton extends StatelessWidget {
  const TimedCancelButton({required this.duration, required this.onPressed, required this.onTimeout, super.key});

  final Duration duration;
  final VoidCallback onPressed;
  final VoidCallback onTimeout;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: TimedFillButton(
      duration: duration,
      onCompleted: onTimeout,
      background: _button(context),
      fill: _button(context, filled: true),
    ),
  );

  Widget _button(BuildContext context, {bool filled = false}) => AppButton(
    buttonColorScheme: ButtonColorScheme.accentSecondary,
    buttonType: ButtonType.secondary,
    size: ButtonSize.large,
    color: filled ? context.colors.neutralOnContainer : null,
    textColor: filled ? context.colors.accentSecondaryOnAccentSecondary : null,
    primaryLabel: context.l10n.cancel,
    onTap: onPressed,
  );
}
