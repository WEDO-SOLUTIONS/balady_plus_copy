import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:balady_plus/app/features/nearby/presentation/mvvm/nearby_view_model.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../../home_page/home_exports.dart';

class NearbyTagList extends StatelessWidget implements PreferredSizeWidget {
  const NearbyTagList({super.key});

  @override
  Widget build(BuildContext context) {
    NearByViewModel nearByViewModel = context.watch<NearByViewModel>();
    const tagsList = [
      SearchCategoryMessage.mousques,
      SearchCategoryMessage.gasStations,
      SearchCategoryMessage.cafe,
      SearchCategoryMessage.restaurants,
      SearchCategoryMessage.parks,
    ];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tagsList.length,
        itemBuilder: (context, index) {
          final SearchCategoryMessage tag = tagsList[index];
          return Container(
            margin: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
            child: InkWell(
              onTap: () {
                nearByViewModel.selectCategory(category: tag);
              },
              child: HomeTag(
                title: tag.name.tr(),
                icon:  tag.iconName(),
                color: Colors.deepPurple,
                selected: nearByViewModel.selectedCategory.value?.index == tag.index,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
