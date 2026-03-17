import 'dart:ui';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/apps_group_section_widgets/custom_sub_category.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/filter_buttom_sheet.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/nafath_login_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/persona_banner_section.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AppsGroupPage extends StatefulWidget {
  final String groupId;
  final MiniApp? dashboard;

  const AppsGroupPage({super.key, required this.groupId, this.dashboard});

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
    final cubit = context.watch<NewMiniAppLogicCubit>();

    //! Fetch the app group that matches the ID that the user should pass...
    CategoryGroup? appGroup = cubit.state.appGroups.firstWhereOrNull((g) => g.id == widget.groupId);
    //! HELPER function: Some groups contains sub group (group inside group)
    //! 1 - Loops through current groups
    //! 2 - If current group g matches the id return it
    //! 3 - Otherwise, it gets its children (subs) and searches inside them recursively
    //! 4 - If found in children, returns it
    //! 5 - If nothing found, returns null
    CategoryGroup? findGroupById(List<CategoryGroup> groups, String id) {
      for (final g in groups) {
        if (g.id == id) return g;
        final subs = g.subCategoryGroup?.values.toList() ?? const <CategoryGroup>[];
        final found = findGroupById(subs, id);
        if (found != null) return found;
      }
      return null;
    }

    //! Fall back to recursive search
    appGroup ??= findGroupById(cubit.state.appGroups, widget.groupId);

    // If group not found (e.g., business group filtered out), go back
    if (appGroup == null) {
      if (cubit.state.isAppsGroupLoading) {
        return const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1CA9A6),
            ),
          ),
        );
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1CA9A6),
          ),
        ),
      );
    }

    MiniApp? fetchedDashboard = appGroup.apps.firstWhereOrNull((miniApp) => miniApp.serviceKey == 'Dashboard');

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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(139, 0, 0, 0)
                        : const Color.fromARGB(81, 255, 255, 255),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.04),
                child: Column(
                  children: [
                    // STICKY HEADER (always visible)
                    StaggeredAppear(
                      initialDelay: const Duration(milliseconds: 300),
                      itemDuration: const Duration(milliseconds: 400),
                      itemDelay: const Duration(milliseconds: 200),
                      children: [
                        CustomSubHeadingText(
                          isTextCenter: true,
                          width: context.screenWidth,
                          height: context.h(35),
                          text: CommonFunctions.isAppAR ? appGroup.nameAr : appGroup.nameEn,
                          fontColor: Theme.of(context).colorScheme.onSurface,
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
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Theme.of(context).cardColor, width: 1),
                                ),
                                child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
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
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Theme.of(context).cardColor, width: 1),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    final cubit = context.read<NewMiniAppLogicCubit>();
                                    final result = await FilterButtomSheet.show(
                                      context,
                                      initialSelectedType: cubit.state.selectedSortType,
                                    );
                                    if (result != null && mounted) {
                                      cubit.setSortType(result);
                                    }
                                  },
                                  icon: Image.asset(
                                    color: Theme.of(context).colorScheme.onSurface,
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
                                        ? EdgeInsets.symmetric(horizontal: context.screenWidth * 0.02)
                                        : EdgeInsets.symmetric(horizontal: context.screenWidth * 0.04),
                                    autoFocus: false,
                                    autofocus: false,
                                    controller: controller,
                                    onTap: null,
                                    keyboardType: TextInputType.text,
                                    isReadOnly: false,
                                    suffixString: value.text.isEmpty
                                        ? Text("search2".tr(), style: TextStyle(color: Theme.of(context).disabledColor))
                                        : null,
                                    suffixIcon: value.text.isEmpty
                                        ? SvgPicture.asset(
                                      Theme.of(context).brightness == Brightness.dark
                                          ? IconPath.searchSVG2
                                          : IconPath.searchSVG,
                                    )
                                        : IconButton(
                                      onPressed: () {
                                        controller.clear();
                                        context.read<NewMiniAppLogicCubit>().searchMiniApp(
                                          '',
                                          source: appGroup!.apps,
                                        );
                                      },
                                      icon: const Icon(Icons.close_rounded, color: Color(0XFFB2B2B2)),
                                    ),
                                    onChanged: (query) {
                                      context.read<NewMiniAppLogicCubit>().searchMiniApp(query, source: appGroup!.apps);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: context.screenHeight * 0.02),
                    Expanded(
                      child: BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                        builder: (context, state) {
                          // Make NafathLoginWidget and the apps grid scroll together
                          if (state.isSearching) {
                            // when searching, fill remaining area with shimmer
                            return CustomScrollView(
                              physics: const BouncingScrollPhysics(),
                              slivers: [
                                SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.02)),
                                _buildNafathLoginWidget(fetchedDashboard),
                                SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.02)),
                                const SliverFillRemaining(hasScrollBody: true, child: MiniAppsShimmerLoadingWidget()),
                              ],
                            );
                          }

                          final isInitial =
                              controller.text.isEmpty && state.searchResults.isEmpty && !state.isSearching;

                          final cubit = context.read<NewMiniAppLogicCubit>();

                          if (isInitial) {
                            final sortedApps = cubit.sortApps(appGroup!.apps, state.selectedSortType);

                            final subCount = appGroup.subCategoryGroup?.length ?? 0;
                            final totalCount = subCount + sortedApps.length;

                            return CustomScrollView(
                              physics: const BouncingScrollPhysics(),
                              slivers: [
                                SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.02)),
                                _buildNafathLoginWidget(fetchedDashboard),
                                SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.02)),
                                SliverGrid(
                                  delegate: SliverChildBuilderDelegate((context, index) {
                                    if (appGroup!.subCategoryGroup != null && index < subCount) {
                                      CategoryGroup categoryGroup = appGroup.subCategoryGroup!.values.toList()[index];
                                      final groupName = CommonFunctions.isAppAR
                                          ? categoryGroup.nameAr
                                          : categoryGroup.nameEn;
                                      return StaggeredAppear(
                                        initialDelay: const Duration(milliseconds: 150),
                                        itemDuration: const Duration(milliseconds: 150),
                                        itemDelay: const Duration(milliseconds: 200),
                                        children: [
                                          CustomSubCategory(
                                            text: groupName,
                                            apps: categoryGroup.apps,
                                            totalAppCount: categoryGroup.appCount,
                                            onTap: () => Navigator.of(context).push(
                                              PageRouteBuilder(
                                                opaque: false,
                                                barrierColor: Colors.transparent,
                                                pageBuilder: (_, __, ___) => AppsGroupPage(groupId: categoryGroup.id, dashboard: widget.dashboard ?? fetchedDashboard,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    final newIndex = index - subCount;
                                    final miniApp = sortedApps[newIndex];
                                    return StaggeredAppear(
                                      initialDelay: const Duration(milliseconds: 150),
                                      itemDuration: const Duration(milliseconds: 150),
                                      itemDelay: const Duration(milliseconds: 200),
                                      children: [
                                        AppsGroupMiniAppsCardWidgets(
                                          title: miniApp.name,
                                          iconPath: miniApp.iconPath,
                                          onTap: () => context.read<NewMiniAppLogicCubit>().openMiniApp(miniApp),
                                        ),
                                      ],
                                    );
                                  }, childCount: totalCount),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16 * MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5),
                                    childAspectRatio: (0.72 / MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5)).clamp(0.52, 0.78),
                                  ),
                                ),
                                // Add bottom spacing so the gradient overlay doesn't hide last items
                                SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.08)),
                              ],
                            );
                          }

                          // Not initial => we have searchResults to show
                          final results = state.searchResults;
                          final sortedResults = cubit.sortApps(results, state.selectedSortType);

                          if (sortedResults.isEmpty) {
                            return CustomScrollView(
                              physics: const BouncingScrollPhysics(),
                              slivers: [
                                _buildNafathLoginWidget(fetchedDashboard),
                                SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.02)),
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(
                                    child: Text(
                                      "no_results_found".tr(),
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontSize: 25,
                                        fontFamily: GeneralKey.appFontType,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          return CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              _buildNafathLoginWidget(fetchedDashboard),
                              SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.02)),
                              SliverGrid(
                                delegate: SliverChildBuilderDelegate((context, index) {
                                  final miniApp = sortedResults[index];
                                  return AppsGroupMiniAppsCardWidgets(
                                    title: miniApp.name,
                                    iconPath: miniApp.iconPath,
                                    onTap: () => context.read<NewMiniAppLogicCubit>().openMiniApp(miniApp),
                                  );
                                }, childCount: sortedResults.length),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16 * MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5),
                                  childAspectRatio: (0.72 / MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5)).clamp(0.52, 0.78),
                                ),
                              ),
                              SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.08)),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: context.screenHeight * 0.08,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? [
                      // replaced with Color.fromRGBO to avoid withOpacity deprecation
                      const Color.fromRGBO(0, 0, 0, 0.0),
                      const Color.fromRGBO(0, 0, 0, 0.6),
                      const Color.fromRGBO(0, 0, 0, 1.0),
                    ]
                        : [
                      const Color.fromRGBO(255, 255, 255, 0.0),
                      const Color.fromRGBO(255, 255, 255, 0.6),
                      const Color.fromRGBO(255, 255, 255, 1.0),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 124a4dd1-7a7b-47f1-09eb-08de2cce6088 => Personal Municipality Group ID
  // 6f736c81-c998-4c3e-09ea-08de2cce6088 => Business Municipality Group ID
  Widget _buildNafathLoginWidget(MiniApp? fetchedDashboard) {
    // Only show login/dashboard for specific municipality groups
    if (widget.groupId != '124a4dd1-7a7b-47f1-09eb-08de2cce6088' &&
        widget.groupId != '6f736c81-c998-4c3e-09ea-08de2cce6088') {
      return SliverToBoxAdapter(child: const SizedBox());
    }

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        final isLoggedIn = authState is AuthenticatedMunicipalityState;

        if (!isLoggedIn) {
          return SliverToBoxAdapter(child: NafathLoginWidget());
        } else {
          return SliverToBoxAdapter(child: PersonaBannerSection(groupId: widget.groupId, dashboard: widget.dashboard ?? fetchedDashboard,));
        }
      },
    );
  }
}

