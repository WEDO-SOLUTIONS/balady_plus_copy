import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MiniAppsSearchPage extends StatelessWidget {
  const MiniAppsSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return BlocProvider<NewMiniAppLogicCubit>.value(
      value: sl<NewMiniAppLogicCubit>(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Positioned.fill(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      height: 10,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(139, 0, 0, 0)
                          : const Color.fromARGB(81, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              PopScope(
                onPopInvokedWithResult: (_, __) {
                  context.read<NewMiniAppLogicCubit>().clearSearch();
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 30,
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.04,
                      vertical: context.screenHeight * 0.02,
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          //! Main content - takes available space and scrolls
                          Expanded(
                            child: BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                              builder: (context, state) {
                                if (controller.text.isEmpty &&
                                    state.searchResults.isEmpty &&
                                    !state.isSearching) {
                                  //! Intro section
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 80,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "search_for_mini_app".tr(),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(
                                              color: Color(0xff155E75),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25,
                                              fontFamily:
                                                  GeneralKey.appFontType,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "search_by_name_or_description"
                                                .tr(),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              color: Color(0xff155E75),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                              fontFamily:
                                                  GeneralKey.appFontType,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (state.isSearching) {
                                  //! Loading section
                                  return const MiniAppsShimmerLoadingWidget();
                                } else if (controller.text.isNotEmpty &&
                                    state.searchResults.isEmpty &&
                                    !state.isSearching) {
                                  //! No results section
                                  return Center(
                                    child: AutoSizeText(
                                      "no_results_found".tr(),
                                      maxLines: 2,
                                      minFontSize: 8,
                                      maxFontSize: 30,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: GeneralKey.appFontType,
                                      ),
                                    ),
                                  );
                                } else {
                                  //! Results section - FIXED SCROLLING ISSUE
                                  return SingleChildScrollView(
                                    padding: const EdgeInsets.only(bottom: 120),
                                    child: StaggeredAppear(
                                      initialDelay: const Duration(
                                        milliseconds: 200,
                                      ),
                                      itemDuration: const Duration(
                                        milliseconds: 450,
                                      ),
                                      itemDelay: const Duration(
                                        milliseconds: 130,
                                      ),
                                      children: [
                                        GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                               SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 16,
                                                mainAxisSpacing: 16* MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5),
                                                childAspectRatio: (0.72 / MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5)).clamp(0.52, 0.78),
                                              ),
                                          itemCount: state.searchResults.length,
                                          itemBuilder: (context, index) {
                                            final miniApp =
                                                state.searchResults[index];
                                            return AppsGroupMiniAppsCardWidgets(
                                              title: miniApp.name,
                                              iconPath: miniApp.iconPath,
                                              onTap: () {
                                                context
                                                    .read<
                                                      NewMiniAppLogicCubit
                                                    >()
                                                    .openMiniApp(miniApp);
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),

                          //! Search field - fixed at bottom
                          AnimatedPadding(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            padding: EdgeInsets.only(
                              bottom:
                                  (MediaQuery.viewInsetsOf(context).bottom - 50)
                                      .clamp(0, double.infinity),
                            ),
                            child: SizedBox(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: context.w(49),
                                    height: context.h(49),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: Border.all(
                                          color: Theme.of(context).cardColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: IconButton(
                                        tooltip: 'back',
                                        onPressed: () {
                                          context.read<NewMiniAppLogicCubit>().clearSearch();

                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha(400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ValueListenableBuilder<TextEditingValue>(
                                    valueListenable: controller,
                                    builder: (context, value, child) {
                                      final hasText = value.text.isNotEmpty;

                                      return MiniAppsCustomTextField(
                                        width: context.screenWidth * 0.77,
                                        height: context.screenHeight * 0.06,
                                        // height: context.h(100),
                                        suffixPadding: hasText
                                            ? const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              )
                                            : const EdgeInsets.symmetric(
                                                horizontal: 20,
                                              ),
                                        autoFocus: true,
                                        autofocus: true,
                                        controller: controller,
                                        onTap: () {},
                                        keyboardType: TextInputType.text,
                                        isReadOnly: false,
                                        hintText: "search2".tr(),

                                        suffixIcon: value.text.isEmpty
                                            ? SvgPicture.asset(
                                                colorFilter: ColorFilter.mode(
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                                  BlendMode.srcIn,
                                                ),
                                                IconPath.searchSVG,
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  controller.clear();
                                                  context
                                                      .read<
                                                        NewMiniAppLogicCubit
                                                      >()
                                                      .searchMiniApp('');
                                                },
                                                icon: Icon(
                                                  Icons.close_rounded,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                                ),
                                              ),
                                        onChanged: (query) {
                                          context
                                              .read<NewMiniAppLogicCubit>()
                                              .searchMiniApp(query);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
