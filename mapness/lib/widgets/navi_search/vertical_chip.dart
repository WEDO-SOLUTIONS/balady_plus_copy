import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerticalChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  const VerticalChip({required this.title, required this.icon, this.onTap,this.width,this.height, super.key});


  @override
  Widget build(BuildContext context) {
    final isDGADark = context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA;

    return  GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 94,
        height: height ?? 70,
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.$2x, vertical: Spacing.$3x),
        decoration: BoxDecoration(
          color: isDGADark?const Color(0xFF104631) :context.colors.accentDefault.withOpacity(.09),
          borderRadius: BorderRadius.circular(RadiusBorder.m),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color:isDGADark? context.colors.accentSoft:context.colors.accentDefault),
            const SizedBox(height: Spacing.$1x),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.textStyles.bodySmallMedium.copyWith(
                  color:isDGADark?context.colors.staticWhite: context.colors.accentSecondaryDefault),
            ),
          ],
        ),
      ),
    );
  }
}
