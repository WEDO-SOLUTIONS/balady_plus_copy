import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:sheetify/multi_state_sheet/animated_state_components/sheet_base_components.dart';
import 'package:sheetify/multi_state_sheet/multi_state_sheet.dart';
import 'package:sheetify/multi_state_sheet/state_snapping/sheet_state_mapper.dart';

class CityscapeBackground extends StatelessWidget {
  final VoidCallback? onTap;
  final MultiStateSheetController<ThreeStateSheet> controller;

  const CityscapeBackground({
    required this.controller,
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(),
      child: MultiStateSheetBuilder(
        defaultState: ThreeStateSheet.hidden,
        builder: (context, state, interpolation, child) => Padding(
          padding: EdgeInsets.only(top: state == ThreeStateSheet.hidden ? Spacing.$1x * (1 - interpolation) : 0),
          child: SizedBox(
            height: (Spacing.$12x) * (state == ThreeStateSheet.hidden ? clampDouble(interpolation * 3, 0, 1) : 1.0),
            width: double.infinity,
            child: Transform.translate(
              // transform y to move it down, the parent widget has cut off the top
              offset: const Offset(0, Spacing.$2x + Spacing.$0_5x),
              child: SizedBox(
                height: Spacing.$10x,
                child: _CityescapeBackground(
                  formattedDate: formatDateRange(
                    DateTime(2025, 11, 17),
                    DateTime(2025, 11, 20),
                    context.l10n.localeName,
                  ),
                ),
              ),
            ),
          ),
        ),
      ));
}

class _CityescapeBackground extends StatelessWidget {
  final String formattedDate;
  const _CityescapeBackground({required this.formattedDate});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusBorder.xl)),
          color: Color(0xFF6B57E0),
        ),
        child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: Spacing.$4x,
                bottom: Spacing.$4x,
                top: Spacing.$1_5x,
              ),
              child: Text(
                '${context.l10n.visualCityScape} · $formattedDate',
                style: context.textStyles.captionLargeSemiBold.copyWith(
                  color: context.colors.successOnSuccess,
                ),
                textAlign: TextAlign.end,
              ),
            )),
      );
}
