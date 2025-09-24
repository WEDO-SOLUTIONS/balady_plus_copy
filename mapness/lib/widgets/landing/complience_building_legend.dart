import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

class ComplianceBuildingLegend extends ConsumerWidget {
  ComplianceBuildingLegend({super.key});
  final sizeGroupItems = AutoSizeGroup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layer = ref.watch(layersControlsProvider);
    final language = ref.watch(appLanguageProvider);
    final textStyles = context.textStyle;
    final locale = context.l10n;

    if (layer.selectedType != LayerType.fencing) {
      return const SizedBox.shrink();
    }

    return Directionality(
      textDirection: switch (language) {
        Language.arabic => TextDirection.rtl,
        _ => TextDirection.ltr,
      },
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: SizedBox(
          width: 180,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Column(
              children: [
                AutoSizeText(
                  locale.legendComplienceBuildingTitle,
                  maxLines: 1,
                  style: textStyles.footNoteBold,
                ),
                const SizedBox(height: 8),
                _LegendItem(
                  color: NonThemeColor.color41,
                  borderColor: NonThemeColor.color42,
                  text: locale.legendComplienceBuildingGreen,
                  group: sizeGroupItems,
                ),
                const SizedBox(height: 8),
                _LegendItem(
                  color: context.colors.backgroundSurface1,
                  borderColor: NonThemeColor.color43,
                  text: locale.legendComplienceBuildingGrey,
                  group: sizeGroupItems,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.borderColor,
    required this.text,
    required this.group,
  });
  final Color color;
  final Color borderColor;
  final String text;
  final AutoSizeGroup group;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyle;

    return Row(
      children: [
        Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AutoSizeText(
            text,
            style: textStyles.caption,
            group: group,
            minFontSize: 8,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
