import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class DashboardTitle extends StatelessWidget {
  final String title;

  const DashboardTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isMekkahTheme = colors.accentSecondaryDefault.value == 0xFFC56846;
    final baseStyle = context.textStyles.h3SemiBold;
    final textStyle = baseStyle.copyWith(color: isMekkahTheme ? const Color(0xFF4A3016) : colors.foregroundDefault);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(title, textAlign: TextAlign.start, style: textStyle),
      ),
    );
  }
}
