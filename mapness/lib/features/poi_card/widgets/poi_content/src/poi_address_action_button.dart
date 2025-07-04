import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final int? count;
  final void Function()? onTap;

  const ActionButton({
    required this.title,
    super.key,
    this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => BaladyAppButton(
        padding: EdgeInsets.zero,
        innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$5x),
        primaryLabel: title,
        trailing: Counter(
          count: count,
          color: context.colorsV3.accentDefault,
        ),
        buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
        buttonType: BaladyButtonType.secondary,
        onTap: onTap,
      );
}
