import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/custom_miniApp_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SearchMiniAppsResultsList extends StatelessWidget {
  const SearchMiniAppsResultsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
      builder: (context, state) {
        if (state.isSearching) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.searchError != null) {
          return Center(
            child: Text(
              state.searchError!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final results = state.searchResults;

        if (results.isEmpty) {
          return Center(
            child: Text(
              'no_results_found'.tr(),
              style: const TextStyle(color: Color(0xFF777777)),
            ),
          );
        }

        final favIds = state.favoriteApps.map((app) => app.id).toSet();

        return ListView.builder(
          padding: EdgeInsets.only(top: context.screenHeight * 0.02),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final app = results[index];
            final isFav = favIds.contains(app.id);

            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.screenHeight * 0.005,
              ),
              child: SizedBox(
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
                      horizontal: context.screenWidth * 0.02,
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
                              iconPath: app.iconPath,
                            ),
                            SizedBox(
                              width: context.screenWidth * 0.02,
                            ),
                            CustomSubHeadingText(
                              width: context.w(192),
                              height: context.h(30),
                              text: app.name,
                              fontColor: const Color(0XFF1E2A36),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CustomMiniAppSwitch(
                              isActive: isFav,
                              onChanged: (_) {
                                context
                                    .read<NewMiniAppLogicCubit>()
                                    .toggleFavoriteLocal(app.id);
                              },
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
