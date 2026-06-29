import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/custom_miniApp_switch.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/fav_page_shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//!
class GetAllUnFavMiniAppsWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const GetAllUnFavMiniAppsWidget({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
      buildWhen: (previous, current) =>
          previous.unFavoriteApps != current.unFavoriteApps ||
          previous.isUnFavLoading != current.isUnFavLoading ||
          previous.unFavError != current.unFavError,
      builder: (context, state) {
        if (state.isUnFavLoading) {
          return const FavPageShimmerLoadingWidget();
        }

        if (state.unFavError != null) {
          return Center(
            child: Text(state.unFavError!, style: const TextStyle(color: Colors.red)),
          );
        }

        if (state.unFavoriteApps.isEmpty) {
          return const SizedBox();
        }

        return ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: context.screenHeight * 0.01),
          scrollDirection: Axis.vertical,
          itemCount: state.unFavoriteApps.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final unFavApp = state.unFavoriteApps[index];

            return SizedBox(
              key: ValueKey('unfav_${unFavApp.id}'),
              width: context.screenWidth,
              height: context.h(70),
              child: Card(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AppsGroupMiniAppsCardWidgets(
                          isActive: false,
                          width: context.w(48.09228515625),
                          height: context.h(48.09228515625),
                          iconHeight: context.h(37.73630905151367),
                          iconWidth: context.w(37.73630905151367),
                          isTextRemove: true,
                          iconPath: unFavApp.iconPath,
                          radius: 8,
                        ),
                        // SizedBox(width: context.screenWidth * 0.02),
                        CustomSubHeadingText(
                          isTextCenter: false,
                          maxLines: 2,
                          autoSizeMaxFont: 15,
                          autoSizeMinFont: 9,
                          width: context.w(192),
                          height: context.h(30),
                          text: unFavApp.name,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: CustomMiniAppSwitch(
                        isActive: false,
                        onChanged: (_) {
                          context.read<NewMiniAppLogicCubit>().toggleFavoriteLocal(unFavApp.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
