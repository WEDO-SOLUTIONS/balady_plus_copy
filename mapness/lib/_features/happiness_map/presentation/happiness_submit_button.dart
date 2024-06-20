import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class HappinessSubmitButton extends ConsumerWidget {
  const HappinessSubmitButton({required this.onPress, super.key});
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = context.color.strokeAccent;

    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          child: Text(
            context.l10n.sendFeedback,
            style: Theme.of(context).extension<ThemeTextStyles>()!.callout.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
