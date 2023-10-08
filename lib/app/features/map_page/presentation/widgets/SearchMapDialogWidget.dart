import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/map_page/data/enums/map_enums.dart';
import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/search_bottom_view_model.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../data/enums/custom_search_category.dart';

class SearchMapDialogWidget extends StatelessWidget {
  const SearchMapDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel>();
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: ValueListenableBuilder(
          valueListenable: mapViewModel.selectedCategory,
          builder: (context, value, _) {
            return mapViewModel.gisSelectedLayer == GISMapLayers.cityPlaces
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SearchCategoryMessage.mousques,
                        SearchCategoryMessage.gasStations,
                        // SearchCategoryMessage.cafe,
                        SearchCategoryMessage.restaurants,
                        SearchCategoryMessage.parks,
                        SearchCategoryMessage.hospitals,
                        SearchCategoryMessage.schools,
                        CustomSearchCategory.events
                      ].map(
                        (e) {
                          SearchCategoryMessage? category;
                          CustomSearchCategory? custom;

                          late String displayName;
                          late String iconName;

                          if (e is CustomSearchCategory) {
                            iconName = e.iconName();
                            displayName = e.displayName();
                            custom = e;
                          } else if (e is SearchCategoryMessage) {
                            iconName = e.iconName();
                            displayName = e.displayName();
                            category = e;
                          }

                          return Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                width: 59,
                                height: 77,
                                decoration: BoxDecoration(
                                  color: mapViewModel.selectedCategory.value ==
                                          category
                                      ? Color(0xFF4B5563)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    mapViewModel.selectCategory(
                                        category: category, custom: custom);
                                    searchFocusNode.unfocus();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: SvgPicture.asset(iconName),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        CustomTextWidget(
                                          displayName,
                                          textStyle: AppStyle
                                              .serviceDescriptionStyle
                                              .copyWith(
                                            color: mapViewModel.selectedCategory
                                                        .value ==
                                                    category
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  )
                : SizedBox();
          }),
    );
  }
}
