import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
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
import '../../../../core/utils/constants/app_style.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';

class SearchMapWidget extends StatelessWidget {
  const SearchMapWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset("assets/icons/svg/profile.svg"),
            SvgPicture.asset("assets/icons/svg/notifications_icon.svg"),
          ],
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
        ValueListenableBuilder(
            valueListenable: mapViewModel.selectedCategory,
            builder: (context, value, _) {
              return mapViewModel.gisSelectedLayer == GISMapLayers.cityPlaces
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SearchCategoryMessage.mousques,
                          SearchCategoryMessage.gasStations,
                          SearchCategoryMessage.cafe,
                          SearchCategoryMessage.restaurants,
                          SearchCategoryMessage.parks,
                        ]
                            .map(
                              (e) => Row(
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: value == e
                                          ? Color(0xFF4B5563)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        mapViewModel.selectCategory(
                                            category: e);
                                        print("Changing ctaegory to: $e");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: SvgPicture.asset(
                                                  e.iconName()),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            CustomTextWidget(
                                              e.displayName(),
                                              textStyle: AppStyle
                                                  .serviceDescriptionStyle
                                                  .copyWith(
                                                color: mapViewModel
                                                            .selectedCategory
                                                            .value ==
                                                        e
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
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : SizedBox();
            }),
      ],
    );
  }
}
