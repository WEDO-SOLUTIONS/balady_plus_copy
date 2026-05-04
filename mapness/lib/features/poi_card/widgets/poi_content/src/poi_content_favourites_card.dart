import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';

class PoiContentFavouritesCard extends StatelessWidget {
  const PoiContentFavouritesCard({required this.data, super.key});

  final PoiContentFavouriteModel data;

  @override
  Widget build(BuildContext context) => ContentWrapper.single(
    color: context.colors.backgroundSurface1,
    child: ContentRow(
      onTap: data.onTap,
      leading: AppIcons(iconData: iconData, color: context.colors.accentDefault),
      text: ContentRowTextOptions(title: data.title),
      trailing: ContentRowTextTrailingOptions(
        icon: SystemIcons.arrowCornerRightSmall,
        iconColor: context.colors.foregroundMuted,
      ),
    ),
  );

  IconData get iconData => switch (data.type) {
    PoiContentFavouriteTypes.favourites => SystemIcons.bookmark,
    PoiContentFavouriteTypes.home => GeneralIcons.home,
    PoiContentFavouriteTypes.work => GeneralIcons.briefcase,
  };
}
