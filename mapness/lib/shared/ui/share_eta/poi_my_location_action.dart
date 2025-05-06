import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/poi_card/widgets/footer/footer_style.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class MyLocationPoiActions extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onCopy;
  final VoidCallback? onParkingAdd;

  const MyLocationPoiActions({
    super.key,
    this.onShare,
    this.onCopy,
    this.onParkingAdd,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyle.footNoteBold;
    final accent = context.colorsV2.accentDefault;
    final secondary = context.staticColor.surfaceStatusContrastAccent;
    final primary = context.color.textAndIconsBaseInversePrimary;
    final secondaryText = context.color.textAndIconsStatusAccent;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.surfaceBasePrimary,
        boxShadow: Shadows.s,
      ),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$3x),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FooterIconButton(
                desc: Text(
                  context.l10n.share_location_btn,
                  style: textStyle.copyWith(color: primary),
                ),
                assetName: Assets.icons.svg.icShare.keyName,
                colorIcon: primary,
                colorButton: accent,
                onTap: onShare,
              ),
              FooterIconButton(
                desc: Text(
                  context.l10n.copy,
                  style: textStyle.copyWith(color: secondaryText),
                ),
                assetName: Assets.icons.svg.icCopy.keyName,
                colorIcon: secondaryText,
                colorButton: secondary,
                onTap: onCopy,
              ),
              if (onParkingAdd != null)
                ItemActionBar(
                  icon: SystemIcons.parkingAdd,
                  buttonType: BaladyButtonType.secondary,
                  onPressed: () {
                    onParkingAdd?.call();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
