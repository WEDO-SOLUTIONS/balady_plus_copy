import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/custom_miniApp_switch.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/fav_search_section_shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

//!
class SearchMiniAppsResultsList extends StatelessWidget {
  final bool isSearching;
  const SearchMiniAppsResultsList({super.key, required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
      builder: (context, state) {
        if (state.isSearching) {
          return const FavSearchSectionShimmerLoadingWidget();
        }

        if (state.searchError != null) {
          return Center(
            child: Text(state.searchError!, style: const TextStyle(color: Colors.red)),
          );
        }

        final results = state.searchResults;

        if (results.isEmpty) {
          return Center(
            child: Text(
              'no_results_found'.tr(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: GeneralKey.appFontType,
                fontSize: 30,
              ),
            ),
          );
        }

        final favIds = state.favoriteApps.map((app) => app.id).toSet();

        return ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: context.screenHeight * 0.01),
          padding: EdgeInsets.only(top: context.screenHeight * 0.02),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final app = results[index];
            final isFav = favIds.contains(app.id);

            return SizedBox(
              key: ValueKey('search_${app.id}'),
              width: context.screenWidth,
              height: context.h(70),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.00),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          AppsGroupMiniAppsCardWidgets(
                            isActive: isFav,
                            width: context.w(48.09228515625),
                            height: context.h(48.09228515625),
                            iconHeight: context.h(37.73630905151367),
                            iconWidth: context.w(37.73630905151367),
                            isTextRemove: true,
                            iconPath: app.iconPath,
                            radius: 8,
                          ),
                          CustomSubHeadingText(
                            isTextCenter: false,
                            maxLines: 2,
                            autoSizeMaxFont: 15,
                            autoSizeMinFont: 9,

                            width: context.w(192),
                            height: context.h(30),
                            text: app.name,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: CustomMiniAppSwitch(
                              isActive: isFav,
                              onChanged: (_) {
                                context.read<NewMiniAppLogicCubit>().toggleFavoriteLocal(app.id);
                              },
                            ),
                          ),
                          if (isFav && !isSearching)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.01),
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
        );
      },
    );
  }
}
