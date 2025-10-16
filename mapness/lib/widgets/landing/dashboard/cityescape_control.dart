import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class CityscapeGlobal extends StatelessWidget {
  final VoidCallback? onTap;

  const CityscapeGlobal({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onTap?.call(),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Transform.translate(
              // transform y to move it down, the parent widget has cut off the top
              offset: const Offset(0, Spacing.$2x + Spacing.$0_5x),
              child: _CityescapeBackground(
                formattedDate: formatDateRange(
                  DateTime(2025, 11, 17),
                  DateTime(2025, 11, 20),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: Spacing.$6x, bottom: Spacing.$1_5x),
                child: Transform.translate(
                  // transform y to move it down, cut off the bottom by design
                  offset: const Offset(0, 25),
                  child: Assets.images.cityscapeGlobal.image(width: 76),
                ),
              ),
            ),
          ],
        ),
      );
}

class _CityescapeBackground extends StatelessWidget {
  final String formattedDate;
  const _CityescapeBackground({required this.formattedDate});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(RadiusBorder.xl)),
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
