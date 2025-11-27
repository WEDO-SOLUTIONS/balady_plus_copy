import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/custom_miniApp_switch.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/fav_page_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/get_all_unFav_mini_apps_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AddFavMiniApps extends StatelessWidget {
  const AddFavMiniApps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.screenWidth * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //! Page bar widget ...
              StaggeredAppear(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSubHeadingText(
                            width: context.w(144),
                            height: context.h(28),
                            text: 'my_favorite_apps'.tr(),
                            fontColor: const Color(0XFF242424),
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                          CustomSubHeadingText(
                            width: context.w(235),
                            height: context.h(50),
                            text:
                                'you_can_add_your_favorite_apps_for_easy_access'
                                    .tr(),
                            fontColor: const Color(0XFFA1A1A1),
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: context.w(49),
                            height: context.h(49),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: const Color(0XFFFFFFFF),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: const Color(0xFFEDEDED),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  IconPath.searchSVG,
                                  width: context.w(20),
                                  height: context.h(20),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: context.w(10)),
                          SizedBox(
                            width: context.w(49),
                            height: context.h(49),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: const Color(0XFFFFFFFF),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: const Color(0xFFEDEDED),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              //!
              SizedBox(height: context.screenHeight * 0.02),
              //! Fav apps
              const StaggeredAppear(
                children: [
                  GetAllFavMiniAppsWidget(),
                ],
              ),
              //!
              SizedBox(height: context.screenHeight * 0.02),
              //! All apps
              StaggeredAppear(
                initialDelay: const Duration(milliseconds: 220),
                itemDuration: const Duration(milliseconds: 120),
                itemDelay: const Duration(milliseconds: 100),
                children: [
                  CustomSubHeadingText(
                    width: context.w(144),
                    height: context.h(28),
                    text: 'all_apps'.tr(),
                    fontColor: const Color(0XFF242424),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ],
              ),
              SizedBox(height: context.screenHeight * 0.01),
              const StaggeredAppear(
                initialDelay: Duration(milliseconds: 320),
                itemDuration: Duration(milliseconds: 220),
                itemDelay: Duration(milliseconds: 130),
                children: [
                  GetAllUnFavMiniAppsWidget(),
                ],
              ),
              //!
            ],
          ),
        ),
      ),
    );
  }
}

class GetAllFavMiniAppsWidget extends StatelessWidget {
  const GetAllFavMiniAppsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.40,
      width: context.screenWidth,
      child: BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
        builder: (context, state) {
          if (state.isFavLoading) {
            return const FavPageShimmerLoadingWidget();
          }

          if (state.favError != null) {
            return Center(
              child: Text(
                state.favError!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state.favoriteApps.isEmpty) {
            return Center(
              child: Text('no_favorite_apps'.tr()),
            );
          }

          return ReorderableListView.builder(
            // Changed to ReorderableListView
            padding: EdgeInsets.zero,
            itemCount: state.favoriteApps.length,
            onReorder: (oldIndex, newIndex) {
              context
                  .read<NewMiniAppLogicCubit>()
                  .reorderFavoriteApps(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final favApp = state.favoriteApps[index];
              return Padding(
                key: Key(favApp.id),
                padding:
                    EdgeInsets.symmetric(vertical: context.screenHeight * 0.01),
                child: SizedBox(
                  key: Key(favApp.id), // Important: Add key for reordering
                  width: context.screenWidth,
                  height: context.h(64),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0XFFFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0XFFEFEEEE),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              AppsGroupMiniAppsCardWidgets(
                                width: context.w(48.09228515625),
                                height: context.h(48.09228515625),
                                iconHeight: context.h(37.73630905151367),
                                iconWidth: context.w(37.73630905151367),
                                isTextRemove: true,
                              ),
                              SizedBox(
                                width: context.screenWidth * 0.02,
                              ),
                              CustomSubHeadingText(
                                width: context.w(192),
                                height: context.h(30),
                                text: favApp.name,
                                fontColor: const Color(0XFF1E2A36),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomMiniAppSwitch(
                                isActive: true,
                                onChanged: (_) {
                                  context
                                      .read<NewMiniAppLogicCubit>()
                                      .toggleFavoriteLocal(favApp.id);
                                },
                              ),
                              // Drag handle - make it more prominent
                              const Icon(
                                Icons.drag_indicator_rounded,
                                color: Color(0x99002A46),
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
