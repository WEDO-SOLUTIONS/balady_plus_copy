import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

class DashboardTitle extends ConsumerWidget {
  final String title;

  const DashboardTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isMekkahTheme = colors.accentSecondaryDefault.value == 0xFFC56846;
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    final baseStyle = context.textStyles.h3SemiBold;
    final mekkahColor = isDark ? const Color(0xFFEDE3D1) : const Color(0xFF4A3016);
    final textStyle = baseStyle.copyWith(color: isMekkahTheme ? mekkahColor : colors.foregroundDefault);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(title, textAlign: TextAlign.start, style: textStyle),
      ),
    );
  }
}
