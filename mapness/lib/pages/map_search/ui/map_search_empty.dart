import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/shared/extensions/build_context_ext.dart';

import 'package:mapness/shared/config/package_config.dart';

class MapSearchEmpty extends StatelessWidget {
  const MapSearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images_svg/empty_search.svg',
            package: PackageConfig.packageName,
            width: 240,
            height: 140,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 279,
            child: Text(
              context.l10n.weCouldntFindAnythingTryChangingYourRequest,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: Theme.of(context).extension<ThemeTextStyles>()!.textL.copyWith(color: context.color.text_and_icons_base_primary),
            ),
          ),
        ],
      ),
    );
  }
}
