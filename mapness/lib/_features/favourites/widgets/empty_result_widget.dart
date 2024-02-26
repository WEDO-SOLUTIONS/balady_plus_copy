import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class EmptyResultWidget extends StatelessWidget {

  const EmptyResultWidget({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset('assets/images_svg/empty_search.svg',
            package: PackageConfig.packageName,
            width: 240,
            height: 140,),
        const SizedBox(height: 10),
        Text(
          text,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: Theme.of(context).extension<ThemeTextStyles>()!.textL.copyWith(
                color: context.color.text_and_icons_base_primary,
              ),
        ),
      ],
    );
  }
}
