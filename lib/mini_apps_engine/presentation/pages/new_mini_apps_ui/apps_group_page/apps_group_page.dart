import 'dart:ui';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

/*
class AppsGroupPage extends StatelessWidget {
  final CategoryGroup appGroup;
  final String? categoryName;
  const AppsGroupPage({super.key, required this.appGroup, this.categoryName});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return BlocProvider(
      create: (context) => sl<NewMiniAppLogicCubit>(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: const Color(0xD9FFFFFF),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.04,
                  ),
                  child: Column(children: [
                    //! Title section
                    StaggeredAppear(
                      initialDelay: const Duration(milliseconds: 120),
                      itemDuration: const Duration(milliseconds: 320),
                      itemDelay: const Duration(milliseconds: 90),
                      children: [
                        CustomSubHeadingText(
                          isTextCenter: true,
                          width: context.screenWidth,
                          height: context.h(35),
                          text: CommonFunctions.isAppAR
                              ? appGroup.nameAr
                              : appGroup.nameEn,
                          fontColor: const Color(0XFF242424),
                        ),
                      ],
                    ),
                    //!
                    SizedBox(height: context.screenHeight * 0.02),
                    //! Search field & back button
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
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: controller,
                          builder: (context, value, child) {
                            return MiniAppsCustomTextField(
                              height: context.h(48),
                              width: context.screenWidth * 0.75,
                              autoFocus: false,
                              autofocus: false,
                              controller: controller,
                              onTap: () {},
                              keyboardType: TextInputType.text,
                              isReadOnly: false,
                              suffixString: value.text.isEmpty
                                  ? Text(
                                      "search2".tr(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  : const SizedBox(),
                              suffixIcon: value.text.isEmpty
                                  ? SvgPicture.asset(IconPath.searchSVG)
                                  : IconButton(
                                      onPressed: () {
                                        controller.clear();
                                        context
                                            .read<NewMiniAppLogicCubit>()
                                            .close();
                                      },
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: Color(0XFFB2B2B2),
                                      ),
                                    ),
                              onChanged: (query) {
                                // Debounce implementation
                                context.read<NewMiniAppLogicCubit>().searchMiniApp(
                                    query); // Add parentheses and pass the query
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    //!
                    SizedBox(height: context.screenHeight * 0.04),
                    //! GridView apps section - FIXED
                    BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                      builder: (context, state) {
                        if (controller.text.isEmpty &&
                            state.searchResults.isEmpty) {
                          return StaggeredAppear(
                            initialDelay: const Duration(milliseconds: 200),
                            itemDuration: const Duration(milliseconds: 450),
                            itemDelay: const Duration(milliseconds: 130),
                            children: [
                              SizedBox(
                                width: context.screenWidth,
                                height: context.screenHeight * 0.70,
                                child: SingleChildScrollView(
                                  child: GridView.builder(
                                    shrinkWrap: true, // Add this
                                    physics:
                                        const NeverScrollableScrollPhysics(), // Add this
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.8,
                                    ),
                                    itemCount: appGroup.apps.length,
                                    itemBuilder: (context, index) {
                                      final miniApp = appGroup.apps[index];
                                      return AppsGroupMiniAppsCardWidgets(
                                        title: miniApp.name,
                                        iconPath: miniApp.iconPath,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => MockMiniAppsPage(
                                                miniAppTitle: miniApp.name,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (state.isSearching) {
                          return const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1CA9A6),
                              ),
                            ),
                          );
                        } else {
                          final filteredResults = state.searchResults
                              .where((app) => app.category == categoryName)
                              .toList();

                          if (filteredResults.isNotEmpty) {
                            return StaggeredAppear(
                              initialDelay: const Duration(milliseconds: 200),
                              itemDuration: const Duration(milliseconds: 450),
                              itemDelay: const Duration(milliseconds: 130),
                              children: [
                                SizedBox(
                                  width: context.screenWidth,
                                  height: context.screenHeight * 0.70,
                                  child: SingleChildScrollView(
                                    child: GridView.builder(
                                      shrinkWrap: true, // Add this
                                      physics:
                                          const NeverScrollableScrollPhysics(), // Add this
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemCount: filteredResults.length,
                                      //appGroup.apps.length,
                                      itemBuilder: (context, index) {
                                        // final miniApp = appGroup.apps[index];
                                        final miniApp = filteredResults[index];
                                        return AppsGroupMiniAppsCardWidgets(
                                          title: miniApp.name,
                                          iconPath: miniApp.iconPath,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    MockMiniAppsPage(
                                                  miniAppTitle: miniApp.name,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (filteredResults.isEmpty) {
                            return StaggeredAppear(
                              initialDelay: const Duration(milliseconds: 200),
                              itemDuration: const Duration(milliseconds: 450),
                              itemDelay: const Duration(milliseconds: 130),
                              children: [
                                SizedBox(
                                  width: context.screenWidth,
                                  height: context.screenHeight * 0.70,
                                  child: SingleChildScrollView(
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemCount: appGroup.apps.length,
                                      itemBuilder: (context, index) {
                                        final miniApp = appGroup.apps[index];
                                        return AppsGroupMiniAppsCardWidgets(
                                          title: miniApp.name,
                                          iconPath: miniApp.iconPath,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    MockMiniAppsPage(
                                                  miniAppTitle: miniApp.name,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                        return const SizedBox();
                      },
                    )
                    //!
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
class AppsGroupPage extends StatelessWidget {
  final CategoryGroup appGroup;

  const AppsGroupPage({
    super.key,
    required this.appGroup,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: const Color(0xD9FFFFFF),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.04,
                ),
                child: Column(
                  children: [
                    StaggeredAppear(
                      initialDelay: const Duration(milliseconds: 120),
                      itemDuration: const Duration(milliseconds: 320),
                      itemDelay: const Duration(milliseconds: 90),
                      children: [
                        CustomSubHeadingText(
                          isTextCenter: true,
                          width: context.screenWidth,
                          height: context.h(35),
                          text: CommonFunctions.isAppAR
                              ? appGroup.nameAr
                              : appGroup.nameEn,
                          fontColor: const Color(0XFF242424),
                        ),
                      ],
                    ),
                    SizedBox(height: context.screenHeight * 0.02),
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
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: controller,
                          builder: (context, value, child) {
                            return MiniAppsCustomTextField(
                              height: context.h(48),
                              width: context.screenWidth * 0.75,
                              suffixPadding: value.text.isNotEmpty
                                  ? EdgeInsets.symmetric(
                                      horizontal: context.screenWidth * 0.02)
                                  : EdgeInsets.symmetric(
                                      horizontal: context.screenWidth * 0.04),
                              autoFocus: false,
                              autofocus: false,
                              controller: controller,
                              onTap: () {},
                              keyboardType: TextInputType.text,
                              isReadOnly: false,
                              suffixString: value.text.isEmpty
                                  ? Text(
                                      "search2".tr(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                  : const SizedBox(),
                              suffixIcon: value.text.isEmpty
                                  ? SvgPicture.asset(IconPath.searchSVG)
                                  : IconButton(
                                      onPressed: () {
                                        controller.clear();
                                        context
                                            .read<NewMiniAppLogicCubit>()
                                            .searchMiniApp('');
                                      },
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: Color(0XFFB2B2B2),
                                      ),
                                    ),
                              onChanged: (query) {
                                context
                                    .read<NewMiniAppLogicCubit>()
                                    .searchMiniApp(
                                      query,
                                      source: appGroup.apps,
                                    );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: context.screenHeight * 0.04),
                    BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                      builder: (context, state) {
                        if (controller.text.isEmpty &&
                            state.searchResults.isEmpty &&
                            !state.isSearching) {
                          return StaggeredAppear(
                            initialDelay: const Duration(milliseconds: 200),
                            itemDuration: const Duration(milliseconds: 450),
                            itemDelay: const Duration(milliseconds: 130),
                            children: [
                              SizedBox(
                                width: context.screenWidth,
                                // height: context.screenHeight * 0.70,
                                child: SingleChildScrollView(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.8,
                                    ),
                                    itemCount: appGroup.apps.length,
                                    itemBuilder: (context, index) {
                                      final miniApp = appGroup.apps[index];
                                      return AppsGroupMiniAppsCardWidgets(
                                        title: miniApp.name,
                                        iconPath: miniApp.iconPath,
                                        onTap: () {
                                          context
                                              .read<NewMiniAppLogicCubit>()
                                              .openMiniApp(
                                                context,
                                                miniApp,
                                              );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (state.isSearching) {
                          return const MiniAppsShimmerLoadingWidget();
                        } else {
                          final results = state.searchResults;

                          if (results.isEmpty) {
                            return Text(
                              "no_results_found".tr(),
                              style: const TextStyle(
                                color: Color(0xFF242424),
                                fontSize: 25,
                                fontFamily: "packages/balady_uikit/Frutiger",
                              ),
                            );
                          }

                          return StaggeredAppear(
                            initialDelay: const Duration(milliseconds: 200),
                            itemDuration: const Duration(milliseconds: 450),
                            itemDelay: const Duration(milliseconds: 130),
                            children: [
                              SizedBox(
                                width: context.screenWidth,
                                height: context.screenHeight * 0.70,
                                child: SingleChildScrollView(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.8,
                                    ),
                                    itemCount: results.length,
                                    itemBuilder: (context, index) {
                                      final miniApp = results[index];
                                      return AppsGroupMiniAppsCardWidgets(
                                        title: miniApp.name,
                                        iconPath: miniApp.iconPath,
                                        onTap: () {
                                          context
                                              .read<NewMiniAppLogicCubit>()
                                              .openMiniApp(
                                            context,
                                            miniApp,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
