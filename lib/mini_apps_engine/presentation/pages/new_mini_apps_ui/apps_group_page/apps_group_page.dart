import 'dart:ui';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/filter_buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:flutter_svg/flutter_svg.dart';

class AppsGroupPage extends StatefulWidget {
  final CategoryGroup appGroup;

  const AppsGroupPage({
    super.key,
    required this.appGroup,
  });

  @override
  State<AppsGroupPage> createState() => _AppsGroupPageState();
}

class _AppsGroupPageState extends State<AppsGroupPage> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appGroup = widget.appGroup;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PopScope(
        onPopInvokedWithResult: (_, __) {
          context.read<NewMiniAppLogicCubit>().clearSearch();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color: const Color.fromARGB(81, 255, 255, 255),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.04,
                ),
                child: Column(
                  children: [
                    // STICKY HEADER (always visible)
                    StaggeredAppear(
                      initialDelay: const Duration(milliseconds: 320),
                      itemDuration: const Duration(milliseconds: 420),
                      itemDelay: const Duration(milliseconds: 290),
                      children: [
                        CustomSubHeadingText(
                          isTextCenter: true,
                          width: context.screenWidth,
                          height: context.h(35),
                          text: CommonFunctions.isAppAR
                              ? appGroup.nameAr
                              : appGroup.nameEn,
                          fontColor: const Color(0XFF242424),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ],
                    ),
                    SizedBox(height: context.screenHeight * 0.02),

                    StaggeredAppear(
                      initialDelay: const Duration(milliseconds: 120),
                      itemDuration: const Duration(milliseconds: 100),
                      itemDelay: const Duration(milliseconds: 90),
                      children: [
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
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            ),

                            // spacing between close & search
                            SizedBox(width: context.w(4)),
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
                                  onPressed: () async {
                                    final cubit =
                                        context.read<NewMiniAppLogicCubit>();
                                    final result = await FilterButtomSheet.show(
                                      context,
                                      initialSelectedType:
                                          cubit.state.selectedSortType,
                                    );
                                    if (result != null && mounted) {
                                      cubit.setSortType(result);
                                    }
                                  },
                                  icon: Image.asset(
                                    ImagePath.sortDescending,
                                    width: context.w(24),
                                    height: context.h(24),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: context.w(4)),
                            Expanded(
                              child: ValueListenableBuilder<TextEditingValue>(
                                valueListenable: controller,
                                builder: (context, value, child) {
                                  return MiniAppsCustomTextField(
                                    height: context.h(48),
                                    width: double.infinity,
                                    suffixPadding: value.text.isNotEmpty
                                        ? EdgeInsets.symmetric(
                                            horizontal:
                                                context.screenWidth * 0.02,
                                          )
                                        : EdgeInsets.symmetric(
                                            horizontal:
                                                context.screenWidth * 0.04,
                                          ),
                                    autoFocus: false,
                                    autofocus: false,
                                    controller: controller,
                                    onTap: () {},
                                    keyboardType: TextInputType.text,
                                    isReadOnly: false,
                                    suffixString: value.text.isEmpty
                                        ? Text(
                                            "search2".tr(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          )
                                        : const SizedBox(),
                                    suffixIcon: value.text.isEmpty
                                        ? SvgPicture.asset(IconPath.searchSVG)
                                        : IconButton(
                                            onPressed: () {
                                              controller.clear();
                                              context
                                                  .read<NewMiniAppLogicCubit>()
                                                  .searchMiniApp(
                                                    '',
                                                    source: appGroup.apps,
                                                  );
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
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: context.screenHeight * 0.04),

                    Expanded(
                      child: BlocBuilder<NewMiniAppLogicCubit,
                          NewMiniAppLogicState>(
                        builder: (context, state) {
                          final isInitial = controller.text.isEmpty &&
                              state.searchResults.isEmpty &&
                              !state.isSearching;

                          if (isInitial) {
                            final cubit = context.read<NewMiniAppLogicCubit>();
                            final sortedApps = cubit.sortApps(
                              appGroup.apps,
                              state.selectedSortType,
                            );
                            return GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: sortedApps.length,
                              itemBuilder: (context, index) {
                                final miniApp = sortedApps[index];
                                return StaggeredAppear(
                                  initialDelay:
                                      const Duration(milliseconds: 150),
                                  itemDuration:
                                      const Duration(milliseconds: 150),
                                  itemDelay: const Duration(milliseconds: 200),
                                  children: [
                                    AppsGroupMiniAppsCardWidgets(
                                      title: miniApp.name,
                                      iconPath: miniApp.iconPath,
                                      onTap: () {
                                        context
                                            .read<NewMiniAppLogicCubit>()
                                            .openMiniApp(miniApp);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          if (state.isSearching) {
                            return const MiniAppsShimmerLoadingWidget();
                          }

                          final results = state.searchResults;
                          final cubit = context.read<NewMiniAppLogicCubit>();
                          final sortedResults = cubit.sortApps(
                            results,
                            state.selectedSortType,
                          );

                          if (sortedResults.isEmpty) {
                            return Center(
                              child: Text(
                                "no_results_found".tr(),
                                style: const TextStyle(
                                  color: Color(0xFF242424),
                                  fontSize: 25,
                                  fontFamily: GeneralKey.appFontType,
                                ),
                              ),
                            );
                          }

                          return GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: sortedResults.length,
                            itemBuilder: (context, index) {
                              final miniApp = sortedResults[index];
                              return AppsGroupMiniAppsCardWidgets(
                                title: miniApp.name,
                                iconPath: miniApp.iconPath,
                                onTap: () {
                                  context
                                      .read<NewMiniAppLogicCubit>()
                                      .openMiniApp(miniApp);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
