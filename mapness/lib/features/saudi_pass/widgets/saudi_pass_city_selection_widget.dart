import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SaudiPassCitySelection extends StatelessWidget {
  final String? title;
  final VoidCallback onTap;

  const SaudiPassCitySelection({
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsV3;
    return Padding(
      padding: const EdgeInsets.only(top: Spacing.$3x),
      child: Container(
        padding: const EdgeInsets.all(Spacing.$4x),
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colorsV3.backgroundSurface1,
          borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.saudiPassCitySelectionPageTitle,
              style: context.textStyleV3.bodyLargeSemiBold.copyWith(color: colors.foregroundDefault),
            ),
            Spacing.$3x.heightBox,
            GestureDetector(
              onTap: onTap,
              child: SizedBox(
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.neutralContainerDefault,
                    borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.m)),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: Spacing.$3x, end: Spacing.$2x),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title != null ? title! : context.l10n.saudiPassCitySelectionPageSearchHint,
                          style: context.textStyleV3.bodySmallMedium.copyWith(color: colors.foregroundDefault),
                        ),
                        const Icon(SystemIcons.arrowCornerDownSmall),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
