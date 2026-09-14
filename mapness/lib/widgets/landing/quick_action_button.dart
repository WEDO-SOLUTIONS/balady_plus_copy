import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/makkah_poi_constants.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

class QuickActionButton extends ConsumerWidget {
  final String text;
  final String? mekkahText;
  final IconData icon;
  final Widget? child;
  final VoidCallback onTap;
  final String? assetPath;
  final SpecialThemeMode? themeMode;

  static const buttonSize = 60.0;

  const QuickActionButton({
    required this.text,
    required this.icon,
    required this.onTap,
    this.mekkahText,
    this.assetPath,
    this.themeMode,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    // Determine if Makkah theme is active based on explicit theme mode
    final isMekkahTheme = themeMode == SpecialThemeMode.mekkahBase || themeMode == SpecialThemeMode.ramadan;
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    final isDGADark = context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA;

    final baseTextStyle = context.textStyles.captionSmallMedium.copyWith(
      fontSize: 11,
      color: context.colors.foregroundDefault,
    );
    // Mekkah light: dark brown on cream. Mekkah dark: warm cream on near-black.
    final mekkahColor = isDark ? const Color(0xFFEDE3D1) : const Color(0xFF4A3016);
    final textStyle = isMekkahTheme ? baseTextStyle.copyWith(color: mekkahColor) : baseTextStyle;

    final displayText = isMekkahTheme && mekkahText != null ? mekkahText! : text;

    Widget buildIcon() {
      if (isMekkahTheme && assetPath != null) {
        // Image should fill the whole button area
        return SizedBox.expand(
          child: Image.asset(assetPath!, fit: BoxFit.cover, package: 'mapness'),
        );
      }

      // Keep default icon centered inside the button
      return Center(
        child:
            child ??
            Icon(
              icon,
              size: Spacing.$6x,
              color: colors.accentDefault,
            ),
      );
    }

    final tileColor = isMekkahTheme && isDark
        ? MakkahPoiConstants.darkSheet
        : isDGADark
        ? colors.accentSecondarySoft
        : colors.backgroundSurface1;

    return Semantics(
      button: true,
      label: displayText,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: buttonSize,
              width: buttonSize,
              child: ExcludeSemantics(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusBorder.xl),
                    color: tileColor,
                    boxShadow: isMekkahTheme && isDark ? const [] : Shadows.s,
                    border: Border.all(
                      color: colors.borderSoft,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(RadiusBorder.xl),
                    child: buildIcon(),
                  ),
                ),
              ),
            ),
            ExcludeSemantics(
              child: SizedBox(
                width: buttonSize,
                child: Padding(
                  padding: const EdgeInsets.only(top: Spacing.$1x + Spacing.$0_5x),
                  child: Text(
                    displayText,
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
