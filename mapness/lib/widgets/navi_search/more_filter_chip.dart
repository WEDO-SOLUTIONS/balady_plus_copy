import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreFilterChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const MoreFilterChip({
    required this.title,
    required this.icon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDGADark = context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isDGADark ? const Color(0xFF104631) : context.colors.accentSecondaryContainerSoft.withOpacity(.05),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: context.colors.accentSecondaryDefault),
            const SizedBox(height: Spacing.$2x),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.textStyles.bodySmallRegular.copyWith(
                color: context.colors.foregroundDefault,
                fontSize: 12,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
