import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FavoriteCard extends StatelessWidget {
  const FavoriteCard({super.key});

  @override
  Widget build(BuildContext context) => CardContent(
      onTap: () => const FavouritesRoute().push(context),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/svg/ic_fav_solid.svg',
            package: PackageConfig.packageName,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              context.color.strokeAccent,
              BlendMode.srcATop,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            context.l10n.favourites,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .text
                .copyWith(color: context.color.textAndIconsBasePrimary),
          ),
          const Spacer(),
          SvgPicture.asset(
            'assets/icons/svg/ic_chevron_left.svg',
            package: PackageConfig.packageName,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              context.color.textAndIconsBasePrimary,
              BlendMode.srcATop,
            ),
          ),
        ],
      ),
    );
}
