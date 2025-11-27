import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/mock_mini_apps_page.dart';
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
      // create: (_) => sl<NewMiniAppLogicCubit>()..loadMiniApps(),
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        resizeToAvoidBottomInset: true,
        body: Container(
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
                  BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                    builder: (context, state) {
                      if (controller.text.isEmpty &&
                          state.searchResults.isEmpty &&
                          !state.isSearching) {
                        return Padding(
                          padding:
                              EdgeInsets.only(top: context.screenHeight * 0.20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "search_for_mini_app".tr(),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                    color: Color(0xFF1CA9A6),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    fontFamily:
                                        "packages/balady_uikit/Frutiger",
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "search_by_name_or_description".tr(),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                    color: Color.fromARGB(161, 0, 0, 0),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    fontFamily:
                                        "packages/balady_uikit/Frutiger",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state.isSearching) {
                        return const Expanded(
                          flex: 10,
                          child: MiniAppsShimmerLoadingWidget(),
                        );
                      } else if (controller.text.isNotEmpty &&
                          state.searchResults.isEmpty &&
                          !state.isSearching) {
                        return Expanded(
                          child: Center(
                            child: AutoSizeText(
                              "no_results_found".tr(),
                              maxLines: 2,
                              minFontSize: 25,
                              maxFontSize: 30,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color.fromARGB(161, 0, 0, 0),
                                fontWeight: FontWeight.w400,
                                fontFamily: "packages/balady_uikit/Frutiger",
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: StaggeredAppear(
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
                                    itemCount: state.searchResults.length,
                                    itemBuilder: (context, index) {
                                      final miniApp =
                                          state.searchResults[index];
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
                          ),
                        );
                      }
                    },
                  ),
                  const Spacer(),
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
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: controller,
                        builder: (context, value, child) {
                          final hasText = value.text.isNotEmpty;

                          return MiniAppsCustomTextField(
                            width: context.screenWidth * 0.75,
                            height: context.h(49),
                            suffixPadding: hasText
                                ? const EdgeInsets.symmetric(
                                    horizontal: 8) // when user typed
                                : const EdgeInsets.symmetric(horizontal: 20),
                            autoFocus: true,
                            autofocus: true,
                            controller: controller,
                            onTap: () {},
                            keyboardType: TextInputType.text,
                            isReadOnly: false,
                            suffixString: value.text.isEmpty
                                ? Text(
                                    "search2".tr(),
                                    style: const TextStyle(color: Colors.black),
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
                                  .searchMiniApp(query);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
