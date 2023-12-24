import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

class ComplienceBuildingLegend extends ConsumerWidget {
  final sizeGroupItems = AutoSizeGroup();

  ComplienceBuildingLegend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layer = ref.watch(layersControlsProvider);
    final language = ref.watch(appLanguageProvider);
    final textStyles = context.textStyle;
    final locale = context.l10n;

    if (layer.selectedType != LayerType.buildings) {
      return const SizedBox.shrink();
    }

    return Directionality(
      textDirection: switch (language) {
        Language.arabic => TextDirection.rtl,
        _ => TextDirection.ltr,
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            AutoSizeText(
              locale.legendComplienceBuildingTitle,
              maxLines: 1,
              style: textStyles.accentS,
            ),
            const SizedBox(height: 8),
            _LegendItem(
              color: const Color(0xffD8F7E7),
              borderColor: const Color(0xffA9C5B7),
              text: locale.legendComplienceBuildingGreen,
              group: sizeGroupItems,
            ),
            const SizedBox(height: 8),
            _LegendItem(
              color: const Color(0xffD9D9D9),
              borderColor: const Color(0xff888888),
              text: locale.legendComplienceBuildingGrey,
              group: sizeGroupItems,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final String text;
  final AutoSizeGroup group;

  const _LegendItem({
    required this.color,
    required this.borderColor,
    required this.text,
    required this.group,
  });

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
            style: textStyles.textXS,
            group: group,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
