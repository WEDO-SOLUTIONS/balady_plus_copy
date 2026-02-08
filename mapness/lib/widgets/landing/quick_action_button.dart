import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';

class QuickActionButton extends StatelessWidget {
  final String text;
  final String? mekkahText;
  final IconData icon;
  final VoidCallback onTap;
  final String? assetPath;
  final SpecialThemeMode? themeMode;

  static const buttonSize = 76.0;

  const QuickActionButton({
    required this.text,
    this.mekkahText,
    required this.icon,
    required this.onTap,
    this.assetPath,
    this.themeMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Determine if Makkah theme is active based on explicit theme mode
    final isMekkahTheme = themeMode == SpecialThemeMode.mekkahBase ||
        themeMode == SpecialThemeMode.ramadan;

    final baseTextStyle = context.textStyles.captionSmallMedium.copyWith(
      fontSize: 11,
    );
    final textStyle =
        isMekkahTheme
            ? baseTextStyle.copyWith(color: const Color(0xFF4A3016))
            : baseTextStyle;

    final displayText =
        isMekkahTheme && mekkahText != null ? mekkahText! : text;

    Widget buildIcon() {
      if (isMekkahTheme && assetPath != null) {
        // Image should fill the whole button area
        return SizedBox.expand(
          child: Image.asset(assetPath!, fit: BoxFit.cover, package: 'mapness'),
        );
      }

      // Keep default icon centered inside the button
      return Center(
        child: Icon(
          icon,
          size: Spacing.$6x + Spacing.$1x,
          color: colors.accentDefault,
        ),
      );
    }

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: SizedBox(
            height: buttonSize,
            width: buttonSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusBorder.xl),
                color: colors.backgroundSurface1,
                boxShadow: Shadows.s,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(RadiusBorder.xl),
                child: buildIcon(),
              ),
            ),
          ),
        ),
        SizedBox(
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
      ],
    );
  }
}
