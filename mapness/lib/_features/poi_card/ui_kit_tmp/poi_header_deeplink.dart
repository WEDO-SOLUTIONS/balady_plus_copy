import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/poi_card/ui_kit_tmp/close_button_poi.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PoiHeaderDeeplink extends StatelessWidget {
  final Function()? onTapClose;

  final String text;

  const PoiHeaderDeeplink({
    required this.onTapClose,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = context.textStyle.accentL
        .copyWith(color: context.color.text_and_icons_base_primary);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          'assets/icons/svg/ic_nav_profile.svg',
          height: 48,
          width: 48,
          package: PackageConfig.packageName,
          colorFilter: ColorFilter.mode(
            context.color.stroke_accent,
            BlendMode.srcIn,
          ),
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
            ],
          ),
        ),
        const SizedBox(width: 12),
        CloseButtonPOI(onTapClose: onTapClose),
      ],
    );
  }
}
