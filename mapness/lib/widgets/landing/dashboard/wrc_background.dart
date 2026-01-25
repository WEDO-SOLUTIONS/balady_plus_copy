import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:sheetify/multi_state_sheet/animated_state_components/sheet_base_components.dart';
import 'package:sheetify/multi_state_sheet/multi_state_sheet.dart';
import 'package:sheetify/multi_state_sheet/state_snapping/sheet_state_mapper.dart';

class WRCBackground extends StatelessWidget {
  final VoidCallback? onTap;
  final MultiStateSheetController<ThreeStateSheet> controller;

  const WRCBackground({
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
              offset: const Offset(0, Spacing.$6x),
              child: const SizedBox(
                height: Spacing.$10x,
                child: _WRCBackground(),
              ),
            ),
          ),
        ),
      ));
}

class _WRCBackground extends StatelessWidget {
  const _WRCBackground();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(RadiusBorder.xl)),
        color: colors.accentSecondaryDefault,
      ),
      child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(
              top: Spacing.$1x,
              right: Spacing.$4x,
              bottom: Spacing.$4x,
            ),
            child: Text(
              l10n.wrcDashboardTitle,
              style: context.textStyles.captionLargeSemiBold.copyWith(
                color: context.colors.successOnSuccess,
              ),
              textAlign: TextAlign.end,
            ),
          )),
    );
  }
}
