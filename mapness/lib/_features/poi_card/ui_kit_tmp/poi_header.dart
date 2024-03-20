import 'package:flutter/material.dart';
import 'package:mapness/_features/poi_card/ui_kit_tmp/close_button_poi.dart';
import 'package:mapness/_features/poi_card/ui_kit_tmp/picture_tmp.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PoiHeader extends StatelessWidget {
  final Function()? onTapClose;

  final String text;
  final String subTitle;

  const PoiHeader({
    required this.onTapClose,
    required this.text,
    required this.subTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = context.textStyle.accentL
        .copyWith(color: context.color.text_and_icons_base_primary);

    final subTitleStyle = context.textStyle.textM.copyWith(
        color: context.color.text_and_icons_base_primary.withOpacity(0.5));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Picture.large(
          img: Image.asset('assets/images/profile_bg_placeholder.png'),
        ),
        const SizedBox(width: 12),
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
              Text(
                subTitle,
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
