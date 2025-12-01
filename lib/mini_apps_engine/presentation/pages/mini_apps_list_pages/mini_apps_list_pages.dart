import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/apps_group_section_shimmer_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_fav_section_shimmer_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_most_used_section_shimmer_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/apps_group_page.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/apps_group_section_widgets/custom_larg_more_apps.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/fav_section_widgets/custom_dashed_add_mini_app_fav.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/fav_section_widgets/custom_mini_apps_card.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_dashed_line_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/mini_apps_search_page/mini_apps_search_page.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class HomeMiniAppsListPages extends StatelessWidget {
  const HomeMiniAppsListPages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewMiniAppLogicCubit>.value(
      value: sl<NewMiniAppLogicCubit>()..loadMiniApps(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
          builder: (context, state) {
            final hasError =
                state.entryPointsError != null || state.favError != null;
            if (hasError) {
              return GeneralErrorWidget(
                error: state.favError ?? state.entryPointsError!,
              );
            }
            return SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.04,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //! Page bar section (Title & Text field widgets) ....
                      StaggeredAppear(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: context.w(170),
                                    height: context.h(30),
                                    child: AutoSizeText(
                                      "quick_apps".tr(),
                                      maxLines: 1,
                                      minFontSize: 25,
                                      maxFontSize: 30,
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(
                                        color: Color(0xFF1CA9A6),
                                        fontWeight: FontWeight.w700,
                                        fontFamily:
                                            "packages/balady_uikit/Frutiger",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: context.w(170),
                                    height: context.h(30),
                                    child: AutoSizeText(
                                      "one_place".tr(),
                                      maxLines: 1,
                                      minFontSize: 25,
                                      maxFontSize: 30,
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(
                                        color: Color(0xFF1CA9A6),
                                        fontWeight: FontWeight.w700,
                                        fontFamily:
                                            "packages/balady_uikit/Frutiger",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              MiniAppsCustomTextField(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MiniAppsSearchPage(),
                                    ),
                                  );
                                },
                                isEnabled: false,
                                isReadOnly: true,
                                width: context.w(150),
                                height: context.h(48),
                                keyboardType: TextInputType.text,
                                suffixString: Text(
                                  "search2".tr(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                suffixIcon:
                                    SvgPicture.asset(IconPath.searchSVG),
                              ),
                            ],
                          ),
                        ],
                      ),
                      //!
                      SizedBox(height: context.screenHeight * 0.04),
                      //! Fav apps section (Fav title & show and add fav apps) ....
                      BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                        builder: (context, state) {
                          if (state.isFavLoading) {
                            return const MiniAppsFavSectionShimmerWidget();
                          }

                          return StaggeredAppear(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomSubHeadingText(
                                    text: "my_favorite_apps".tr(),
                                    width: context.w(170),
                                    height: context.h(33),
                                  ),
                                  SizedBox(height: context.screenHeight * 0.02),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomDashedAddMiniAppFav(),
                                      SizedBox(
                                          width: context.screenWidth * 0.04),
                                      SizedBox(
                                        height: context.screenHeight * 0.13,
                                        width: context.screenWidth * 0.70,
                                        child: ReorderableListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: state.favoriteApps.length,
                                          onReorder: (oldIndex, newIndex) {
                                            context
                                                .read<NewMiniAppLogicCubit>()
                                                .reorderFavoriteApps(
                                                  oldIndex,
                                                  newIndex,
                                                );
                                          },
                                          itemBuilder: (context, index) {
                                            final favMiniApp =
                                                state.favoriteApps[index];
                                            return Padding(
                                              key: Key(favMiniApp.id),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      context.screenWidth *
                                                          0.01),
                                              child: CustomMiniAppsCard(
                                                key: Key(favMiniApp.id),
                                                //key for reordering
                                                onTap: () {
                                                  context
                                                      .read<
                                                          NewMiniAppLogicCubit>()
                                                      .openMiniApp(
                                                        context,
                                                        favMiniApp,
                                                      );
                                                },
                                                text: favMiniApp.name,
                                                titlesHeight:
                                                    context.screenHeight * 0.05,
                                                titlesWidth:
                                                    context.screenWidth * 0.20,
                                                maxLines: 2,
                                                maxFontSize: 20,
                                                minFontSize: 9,

                                                miniAppIcon:
                                                    favMiniApp.iconPath,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      //!
                      SizedBox(height: context.screenHeight * 0.02),
                      const CustomDashedLineWidget(),
                      SizedBox(height: context.screenHeight * 0.02),
                      //! Most common apps section
                      BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                        builder: (context, state) {
                          if (state.isEntryPointsLoading) {
                            return const MiniAppsMostUsedSectionShimmerWidget();
                          }

                          if (state.entryPoints.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return StaggeredAppear(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                            height:
                                                context.screenHeight * 0.02),
                                    itemCount: state.entryPoints.length,
                                    itemBuilder: (context, index) {
                                      final section = state.entryPoints[index];
                                      final apps = section.apps;

                                      if (apps.isEmpty) {
                                        return const SizedBox.shrink();
                                      }

                                      final title = CommonFunctions.isAppAR
                                          ? section.arName
                                          : section.enName;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomSubHeadingText(
                                            text: title,
                                          ),
                                          SizedBox(
                                              height:
                                                  context.screenHeight * 0.01),
                                          SizedBox(
                                            height: context.screenHeight * 0.20,
                                            width: context.screenWidth,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              separatorBuilder: (context, i) =>
                                                  SizedBox(
                                                width:
                                                    context.screenWidth * 0.03,
                                              ),
                                              itemCount: apps.length,
                                              itemBuilder: (context, appIndex) {
                                                final miniApp = apps[appIndex];

                                                return CustomMiniAppsCard(
                                                  width: context.w(104),
                                                  height: context.h(104),
                                                  iconHeight: context.h(48),
                                                  iconWidth: context.w(48),
                                                  titlesHeight: context.h(17),
                                                  titlesWidth: context.w(66),
                                                  withCardEffect: true,
                                                  text: miniApp.name,
                                                  miniAppIcon: miniApp.iconPath,
                                                  onTap: () {
                                                    context
                                                        .read<
                                                            NewMiniAppLogicCubit>()
                                                        .openMiniApp(
                                                          context,
                                                          miniApp,
                                                        );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      //!
                      SizedBox(height: context.screenHeight * 0.02),
                      const CustomDashedLineWidget(),
                      SizedBox(height: context.screenHeight * 0.02),
                      //! Apps group section
                      BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                        builder: (context, state) {
                          if (state.isAppsGroupLoading) {
                            return const AppsGroupSectionShimmerWidget();
                          }
                          return StaggeredAppear(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.appGroups.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing:
                                          context.screenHeight * 0.02,
                                      crossAxisSpacing:
                                          context.screenWidth * 0.04,
                                      childAspectRatio: 0.8,
                                    ),
                                    itemBuilder: (context, index) {
                                      final appGroup = state.appGroups[index];

                                      final groupName = CommonFunctions.isAppAR
                                          ? appGroup.nameAr
                                          : appGroup.nameEn;

                                      return CustomLargMoreApps(
                                        withCardEffect: true,
                                        text: groupName,
                                        apps: appGroup.apps,
                                        totalAppCount: appGroup.appCount,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AppsGroupPage(
                                                appGroup: appGroup,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class GeneralErrorWidget extends StatelessWidget {
  final String error;
  const GeneralErrorWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade700),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  context.read<NewMiniAppLogicCubit>().loadMiniApps();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.accentDefault,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "refresh".tr(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
