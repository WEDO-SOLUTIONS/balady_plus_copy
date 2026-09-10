import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/pages/landing/landing_page.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

import '../../shared/providers/app_language.dart';

class MapAttributionLabel extends ConsumerWidget {
  const MapAttributionLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(appLanguageProvider) == Language.arabic;
    final splits = context.l10n.baladyMaps.split(' ');
    return IgnorePointer(
      child: Row(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          StrokeText(splits.first, isBold: true),
          StrokeText(splits.last),
        ],
      ),
    );
  }
}

class StrokeText extends ConsumerWidget {
  final String text;
  final bool isBold;

  const StrokeText(this.text, {super.key, this.isBold = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final base = context.textStyles.bodyLargeRegular;
    const fontFamily = 'packages/balady_uikit/Golos';
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    final isArabic = ref.watch(appLanguageProvider) == Language.arabic;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Stack(
        children: [
          Text(
            text,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: base.copyWith(
              fontWeight: isBold && !isArabic ? FontWeight.w600 : FontWeight.w400,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..strokeJoin = StrokeJoin.round
                ..strokeCap = StrokeCap.round
                ..color = context.colors.onMapSurfaceOnMap,
              fontFamily: fontFamily,
            ),
          ),
          Text(
            text,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: base.copyWith(
              color: isDark ? context.colors.accentOnAccent : context.colors.screenOverlayDimming60,
              fontWeight: isBold && !isArabic ? FontWeight.w600 : FontWeight.w400,
              fontFamily: fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
