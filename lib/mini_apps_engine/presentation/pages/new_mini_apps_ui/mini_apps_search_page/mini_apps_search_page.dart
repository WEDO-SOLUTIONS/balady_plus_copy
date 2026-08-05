import 'dart:async';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/_shared/widgets/custom_mini_app_icon_button_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

//!
class MiniAppsSearchPage extends StatefulWidget {
  const MiniAppsSearchPage({super.key});

  @override
  State<MiniAppsSearchPage> createState() => _MiniAppsSearchPageState();
}

class _MiniAppsSearchPageState extends State<MiniAppsSearchPage> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query, BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<NewMiniAppLogicCubit>().searchMiniApp(query);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onPopInvokedWithResult: (_, _) {
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
                          //! Main content
                          Expanded(
                            child: BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                              builder: (context, state) {
                                if (_controller.text.isEmpty && state.searchResults.isEmpty && !state.isSearching) {
                                  //! Intro section
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 80),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "search_for_mini_app".tr(),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Color(0xff155E75),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25,
                                              fontFamily: GeneralKey.appFontType,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "search_by_name_or_description".tr(),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Color(0xff155E75),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                              fontFamily: GeneralKey.appFontType,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (state.isSearching) {
                                  //! Loading section
                                  return const MiniAppsShimmerLoadingWidget();
                                } else if (_controller.text.isNotEmpty &&
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
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: GeneralKey.appFontType,
                                      ),
                                    ),
                                  );
                                } else {
                                  return GridView.builder(
                                    padding: const EdgeInsets.only(bottom: 120),
                                    physics: const BouncingScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing:
                                          16 * MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5),
                                      childAspectRatio:
                                          (0.72 / MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5)).clamp(
                                            0.52,
                                            0.78,
                                          ),
                                    ),
                                    itemCount: state.searchResults.length,
                                    itemBuilder: (context, index) {
                                      final miniApp = state.searchResults[index];
                                      return AppsGroupMiniAppsCardWidgets(
                                        isActive: false,
                                        title: miniApp.name,
                                        iconPath: miniApp.iconPath,
                                        onTap: () {
                                          context.read<NewMiniAppLogicCubit>().openMiniApp(miniApp);
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),

                          //! Search field
                          AnimatedPadding(
                            duration: const Duration(milliseconds: 50),
                            curve: Curves.easeOut,
                            padding: EdgeInsets.only(
                              bottom: (MediaQuery.viewInsetsOf(context).bottom > 0)
                                  ? (MediaQuery.viewInsetsOf(context).bottom -
                                            MediaQuery.paddingOf(context).bottom -
                                            (context.screenHeight * 0.08))
                                        .clamp(0.0, double.infinity)
                                  : 0.0,
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CustomMiniAppsIconButton(
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                    borderColor: Theme.of(context).dividerColor,
                                    width: context.screenWidth * 0.13,
                                  ),
                                  ValueListenableBuilder<TextEditingValue>(
                                    valueListenable: _controller,
                                    builder: (context, value, child) {
                                      return MiniAppsCustomTextField(
                                        width: context.screenWidth * 0.79,
                                        autofocus: true,
                                        controller: _controller,
                                        onTap: () {},
                                        keyboardType: TextInputType.text,
                                        isReadOnly: false,
                                        suffixIcon: value.text.isEmpty
                                            ? null
                                            : IconButton(
                                                onPressed: () {
                                                  _controller.clear();
                                                  context.read<NewMiniAppLogicCubit>().searchMiniApp('');
                                                },
                                                icon: const Icon(Icons.close_rounded, color: Color(0XFFB2B2B2)),
                                              ),
                                        onChanged: (query) => _onSearchChanged(query, context),
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
