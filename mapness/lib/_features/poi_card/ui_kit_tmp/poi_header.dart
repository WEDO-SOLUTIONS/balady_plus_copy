import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/poi_card/ui_kit_tmp/close_button_poi.dart';

class PoiHeader extends StatelessWidget {
  final Function()? onTapClose;
  final Widget? profileImage;
  final String text;
  final String? subTitle;

  const PoiHeader({
    required this.onTapClose,
    required this.text,
    this.subTitle,
    this.profileImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = context.textStyleV3.h4SemiBold.copyWith(color: context.colorsV2.foregroundDefault);
    final subTitleStyle = context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV2.foregroundSoft);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (profileImage != null) ...[
          profileImage!,
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: titleTextStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
              if (subTitle != null)
                Text(
                  subTitle!,
                  style: subTitleStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        CloseButtonPOI(onTapClose: onTapClose),
      ],
    );
  }
}
