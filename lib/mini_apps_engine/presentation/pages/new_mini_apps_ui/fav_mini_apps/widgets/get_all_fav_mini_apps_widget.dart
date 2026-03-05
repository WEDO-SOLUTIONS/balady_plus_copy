import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/custom_miniApp_switch.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/fav_page_shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAllFavMiniAppsWidget extends StatelessWidget {
  final double? height;

  const GetAllFavMiniAppsWidget({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
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

        return ReorderableListView.builder(
          // Changed to ReorderableListView
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.favoriteApps.length,
          onReorder: (oldIndex, newIndex) {
            context.read<NewMiniAppLogicCubit>().reorderFavoriteApps(oldIndex, newIndex);
          },
          itemBuilder: (context, index) {
            final favApp = state.favoriteApps[index];
            return Padding(
              key: Key(favApp.id),
              padding: EdgeInsets.only(bottom: context.screenHeight * 0.01),
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
                              iconPath: favApp.iconPath,
                              radius: 12.7,
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
                                context.read<NewMiniAppLogicCubit>().toggleFavoriteLocal(favApp.id);
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
    );
  }
}
