import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:balady_plus/app/features/nearby/presentation/mvvm/nearby_view_model.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_text_widget.dart';
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
      //SearchCategoryMessage.cafe,
      // SearchCategoryMessage.restaurants,
      SearchCategoryMessage.parks,
    ];
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tagsList.length,
        itemBuilder: (context, index) {
          final SearchCategoryMessage tag = tagsList[index];
          return Container(
            margin: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
            child: Row(
              children: [
                const SizedBox(width: 8),
                ValueListenableBuilder<SearchCategoryMessage?>(
                  valueListenable: nearByViewModel.selectedCategory,
                  builder: (_, selectedCategory, __) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: selectedCategory == tag
                            ? const Color(0xFF4B5563)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (tag != selectedCategory) {
                            nearByViewModel.selectCategory(category: tag);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: SvgPicture.asset(tag.iconName()),
                              ),
                              const SizedBox(width: 4),
                              CustomTextWidget(
                                tag.displayName(),
                                textStyle:
                                    AppStyle.serviceDescriptionStyle.copyWith(
                                  color: selectedCategory == tag
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
