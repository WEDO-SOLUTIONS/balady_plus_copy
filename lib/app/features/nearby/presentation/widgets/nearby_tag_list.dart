import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../../home_page/home_exports.dart';

class NearbyTagList extends StatelessWidget implements PreferredSizeWidget {
  const NearbyTagList({super.key});

  @override
  Widget build(BuildContext context) {
    const tagsList = NearByTypes.values;
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tagsList.length,
        itemBuilder: (context, index) {
          final tag = tagsList[index];
          return Container(
            margin: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
            child: HomeTag(
              title: tag.title.tr(),
              icon: tag.icon == null ? null : IconPath.nearbyIcon(tag.icon!),
              color: tag.color,
              selected: index == 0,
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
