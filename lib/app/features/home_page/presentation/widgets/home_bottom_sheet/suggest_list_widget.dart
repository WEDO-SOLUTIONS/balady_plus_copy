import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/search_bottom_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuggestListWidget extends StatelessWidget {
  const SuggestListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SearchBottomViewModel searchBottomViewModel =
        context.watch<SearchBottomViewModel>();
    MapViewModel mapViewModel = context.watch<MapViewModel>();
    return ValueListenableBuilder(
      valueListenable: searchBottomViewModel.suggestResultMessage,
      builder: (BuildContext context, listSuggest, Widget? child) {
        return listSuggest != null
            ? ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: listSuggest.suggests.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 16),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (listSuggest.suggests[index]!.handler.objectHandler !=
                              null) {
                            mapViewModel.addOneMarkerWithMoveCamera(
                              listSuggest
                                  .suggests[index]!.handler.objectHandler!.item,
                            );
                            searchFocusNode.unfocus();
                            searchBottomViewModel.removeSuggestList();
                            mapViewModel.setBottomSheetSize(.1);
                            searchBottomViewModel.saveItemHistory(listSuggest.suggests[index]!.handler.objectHandler!);
                          } else {
                            mapViewModel.selectedCategory.value = null;
                            searchController.text = listSuggest.suggests[index]!.title.text;
                            mapViewModel.callSearch();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const DrawIconBasedTypeWidget(
                                icon: IconPath.searchSuggestIcon,
                                iconSize: 20,
                                iconColor: AppColor.primary900Light,
                              ),
                              const SizedBox(width: 16),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listSuggest.suggests[index]?.title.text ??
                                        '',
                                    style: AppStyle.textFieldTitleTextStyle,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    listSuggest
                                            .suggests[index]?.subtitle.text ??
                                        '',
                                    style: AppStyle.requestNumberTextStle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color(0xffE6ECEE),
                        height: 16,
                        thickness: 1, //#
                      ),
                    ],
                  );
                },
              )
            : const SizedBox();
      },
    );
  }
}
