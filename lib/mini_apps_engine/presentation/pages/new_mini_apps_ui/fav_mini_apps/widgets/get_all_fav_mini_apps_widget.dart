import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/custom_mini_app_switch.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/fav_page_shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//!
class GetAllFavMiniAppsWidget extends StatelessWidget {
  final double? height;

  const GetAllFavMiniAppsWidget({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
      buildWhen: (previous, current) =>
          previous.favoriteApps != current.favoriteApps ||
          previous.isFavLoading != current.isFavLoading ||
          previous.favError != current.favError,
      builder: (context, state) {
        if (state.isFavLoading) {
          return const FavPageShimmerLoadingWidget();
        }

        if (state.favError != null) {
          return Center(
            child: Text(state.favError!, style: const TextStyle(color: Colors.red)),
          );
        }

        if (state.favoriteApps.isEmpty) {
          return const SizedBox();
        }

        final itemHeight = context.h(64) + context.screenHeight * 0.01;
        final listHeight = itemHeight * state.favoriteApps.length;

        return SizedBox(
          height: listHeight,
          child: ReorderableListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.favoriteApps.length,
            proxyDecorator: (Widget child, int index, Animation<double> animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget? child) {
                  return Material(color: Colors.transparent, elevation: 0, child: child);
                },
                child: child,
              );
            },
            onReorder: (oldIndex, newIndex) {
              context.read<NewMiniAppLogicCubit>().reorderFavoriteApps(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final favApp = state.favoriteApps[index];

              return Padding(
                key: ValueKey('fav_${favApp.id}'),
                padding: EdgeInsets.only(bottom: context.screenHeight * 0.00),
                child: SizedBox(
                  width: context.screenWidth,
                  height: context.h(70),
                  child: Card(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            AppsGroupMiniAppsCardWidgets(
                              isActive: true,
                              width: context.w(48.09228515625),
                              height: context.h(48.09228515625),
                              iconHeight: context.h(37.73630905151367),
                              iconWidth: context.w(37.73630905151367),
                              isTextRemove: true,
                              iconPath: favApp.iconPath,
                              radius: 8,
                            ),
                            CustomSubHeadingText(
                              isTextCenter: false,
                              maxLines: 2,
                              autoSizeMaxFont: 15,
                              autoSizeMinFont: 9,

                              width: context.w(192),
                              height: context.h(30),
                              text: favApp.name,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            CustomMiniAppSwitch(
                              isActive: true,
                              onChanged: (_) {
                                context.read<NewMiniAppLogicCubit>().toggleFavoriteLocal(favApp.id);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Icon(Icons.drag_handle_rounded, color: Color(0XFF9DA4AE), size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
