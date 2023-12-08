import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/bottom_navigation/presentation/cubits/bottom_nav_bar_cubit.dart';
import 'package:balady_plus/app/features/map_page/data/enums/map_enums.dart';
import 'package:balady_plus/app/features/map_page/data/model/layers.dart';
import 'package:balady_plus/app/features/map_page/extensions/search_category_ext.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/layers_gis_view_model.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../data/enums/custom_search_category.dart';
import '../mvvm/search_bottom_view_model.dart';

class SearchMapWidget extends StatelessWidget {
  const SearchMapWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top > 20
                  ? MediaQuery.of(context).padding.top - 20
                  : 0,
              left: 10,
              bottom: 10,
              right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    sl<BottomNavBarCubit>().onChangeBottomNavBar(2);
                  },
                  child: CircleIcon(
                    icon: "assets/icons/svg/user.svg",
                  )),
              GestureDetector(
                  onTap: () {
                    NavigationService.navigatorKey.currentState!
                        .pushNamed(RouteName.notificationPage);
                  },
                  child: CircleIcon(
                    icon: "assets/icons/svg/notification_active.svg",
                    iconSize: 40,
                  )),
            ],
          ),
        )

        /* TextFormField(
          controller: mapViewModel.searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'search'.tr(),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
          ),
          onFieldSubmitted: (text) {
            if (text.isNotEmpty) {
              mapViewModel.performSearch(queryText: text);
            }
          },
          // onChanged: (text) => searchItem(text: text),
        ),*/
        // Container(color: Colors.black, height: 10, width: 20,),
        ,
        Padding(
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
                            CustomSearchCategory.events,
                            SearchCategoryMessage.pharmacies,
                            SearchCategoryMessage.dentalCenters,
                          ].map((e) {
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

                            final bool isActive = ((mapViewModel
                                            .selectedCategory.value ==
                                        category) &&
                                    mapViewModel.selectedCategory.value !=
                                        null) ||
                                ((mapViewModel.selectedCustomCategory.value ==
                                        custom) &&
                                    mapViewModel.selectedCustomCategory.value !=
                                        null);
                            return Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: isActive
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
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: SvgPicture.asset(iconName),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          CustomTextWidget(
                                            displayName,
                                            textStyle: AppStyle
                                                .serviceDescriptionStyle
                                                .copyWith(
                                              color: isActive
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
                          }).toList(),
                        ),
                      )
                    : SizedBox();
              }),
        ),
      ],
    );
  }
}
