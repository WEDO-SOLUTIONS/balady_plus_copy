import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/delegators/services/account_selection_service.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/domain/entites/new_mini_app_item_logic_entity.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/apps_group_section_widgets/custom_sub_category.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/shimmer_loading_widgets/mini_apps_shimmer_loading_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/_shared/widgets/custom_mini_app_icon_button_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/apps_group_mini_apps_card_widgets.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/filter_buttom_sheet.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/nafath_login_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/persona_banner_section.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class AppsGroupPage extends StatefulWidget {
  final String groupId;

  const AppsGroupPage({super.key, required this.groupId});

  @override
  State<AppsGroupPage> createState() => _AppsGroupPageState();
}

class _AppsGroupPageState extends State<AppsGroupPage> {
  late final TextEditingController controller;

  final FocusNode _searchFocusNode = FocusNode();

  //! Build can re-enter the "group not found" branch on every cubit emit while
  //! the exit transition is still playing (context.mounted stays true), so an
  //! unguarded pop per rebuild empties the nested services navigator (only
  //! home + group live there) and the next pop throws "Bad state: No element".
  //! One-shot flag + route/stack checks keep it to a single safe pop.
  bool _autoPopScheduled = false;

  void _autoPopIfGroupMissing() {
    if (_autoPopScheduled) return;
    _autoPopScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      if (route == null || !route.isCurrent) {
        // Already popped (or covered) - nothing to pop for this page.
        _autoPopScheduled = false;
        return;
      }
      final navigator = Navigator.maybeOf(context);
      if (navigator == null || !navigator.canPop()) {
        _autoPopScheduled = false;
        return;
      }
      navigator.pop();
    });
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
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
          body: Center(child: CircularProgressIndicator(color: Color(0xFF1CA9A6))),
        );
      }

      _autoPopIfGroupMissing();
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator(color: Color(0xFF1CA9A6))),
      );
    }

    MiniApp? fetchedDashboard = appGroup.apps.firstWhereOrNull((miniApp) => miniApp.serviceKey == 'Dashboard');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomSubHeadingText(
          text: CommonFunctions.isAppAR ? appGroup.nameAr : appGroup.nameEn,
          isTextCenter: true,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        leading: Padding(
          padding: context.isRTL
              ? EdgeInsets.only(right: context.screenWidth * 0.02, bottom: 10)
              : EdgeInsets.only(left: context.screenWidth * 0.02, bottom: 10),
          child: const CustomMiniAppsIconButton(),
        ),
      ),
      body: PopScope(
        onPopInvokedWithResult: (_, _) {
          context.read<NewMiniAppLogicCubit>().clearSearch();
        },

        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.04),
            child: Column(
              children: [
                SizedBox(height: context.screenHeight * 0.02),

                StaggeredAppear(
                  initialDelay: const Duration(milliseconds: 120),
                  itemDuration: const Duration(milliseconds: 100),
                  itemDelay: const Duration(milliseconds: 90),
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 6,
                            child: ValueListenableBuilder<TextEditingValue>(
                              valueListenable: controller,
                              builder: (context, value, child) {
                                return MiniAppsCustomTextField(
                                  width: double.infinity,
                                  focusNode: _searchFocusNode,
                                  suffixPadding: value.text.isNotEmpty
                                      ? EdgeInsets.symmetric(horizontal: context.screenWidth * 0.02)
                                      : EdgeInsets.symmetric(horizontal: context.screenWidth * 0.04),
                                  autofocus: false,
                                  controller: controller,
                                  onTap: null,
                                  keyboardType: TextInputType.text,
                                  isReadOnly: false,
                                  suffixString: value.text.isEmpty
                                      ? Text("search2".tr(), style: TextStyle(color: Theme.of(context).disabledColor))
                                      : null,
                                  suffixIcon: value.text.isEmpty
                                      ? null
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
                          SizedBox(width: context.w(1)),
                          Expanded(
                            flex: 1,
                            child: CustomMiniAppsIconButton(
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              borderColor: Theme.of(context).dividerColor,
                              icon: Icons.tune,
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
                            ),
                          ),
                          /*
                          */
                        ],
                      ),
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
                            // SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.02)),
                            if (!_searchFocusNode.hasFocus) _buildNafathLoginWidget(fetchedDashboard),
                            SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.01)),
                            const SliverFillRemaining(hasScrollBody: true, child: MiniAppsShimmerLoadingWidget()),
                          ],
                        );
                      }

                      final isInitial = controller.text.isEmpty && state.searchResults.isEmpty && !state.isSearching;

                      final cubit = context.read<NewMiniAppLogicCubit>();

                      if (isInitial) {
                        final sortedApps = cubit.sortApps(appGroup!.apps, state.selectedSortType);

                        final subCount = appGroup.subCategoryGroup?.length ?? 0;
                        final totalCount = subCount + sortedApps.length;

                        return CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.02)),
                            if (!_searchFocusNode.hasFocus) _buildNafathLoginWidget(fetchedDashboard),
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
                                            pageBuilder: (_, _, _) => AppsGroupPage(groupId: categoryGroup.id),
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
                                    GestureDetector(
                                      onTap: () => context.read<NewMiniAppLogicCubit>().openMiniApp(miniApp),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: context.w(100),
                                            height: context.h(100),
                                            child: Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              color: Theme.of(context).brightness == Brightness.light
                                                  ? Theme.of(context).colorScheme.onSurface.withAlpha(13)
                                                  : Theme.of(context).primaryColorLight,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: CustomNetworkImageWidget(
                                                  miniApp.iconPath,
                                                  isVerifyingKey: true,
                                                  imageFit: BoxFit.contain,
                                                  imageWidth: context.w(51),
                                                  imageHeight: context.h(51),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: context.screenWidth * 0.25,
                                            height: context.screenHeight * 0.05,
                                            child: AutoSizeText(
                                              maxLines: 2,
                                              maxFontSize: 14,
                                              minFontSize: 12,
                                              miniApp.name,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center, // Good practice for grid items
                                              style: const TextStyle(
                                                fontFamily: GeneralKey.appFontType,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /*
                                    AppsGroupMiniAppsCardWidgets(
                                      isActive: false,
                                      title: miniApp.name,
                                      iconPath: miniApp.iconPath,
                                      onTap: () => context.read<NewMiniAppLogicCubit>().openMiniApp(miniApp),
                                    ),
                                    */
                                  ],
                                );
                              }, childCount: totalCount),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16 * MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5),
                                childAspectRatio: (0.72 / MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5))
                                    .clamp(0.52, 0.78),
                              ),
                            ),
                            // Add bottom spacing so the gradient overlay doesn't hide last items
                            // SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.08)),
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
                            if (!_searchFocusNode.hasFocus) _buildNafathLoginWidget(fetchedDashboard),
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
                          if (!_searchFocusNode.hasFocus) _buildNafathLoginWidget(fetchedDashboard),
                          SliverToBoxAdapter(child: SizedBox(height: context.screenHeight * 0.02)),
                          SliverGrid(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              final miniApp = sortedResults[index];
                              return AppsGroupMiniAppsCardWidgets(
                                isActive: false,
                                title: miniApp.name,
                                iconPath: miniApp.iconPath,
                                onTap: () => context.read<NewMiniAppLogicCubit>().openMiniApp(miniApp),
                              );
                            }, childCount: sortedResults.length),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16 * MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5),
                              childAspectRatio: (0.72 / MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5))
                                  .clamp(0.52, 0.78),
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
          AccountSelectionService.applyAccountSelectionForGroup(widget.groupId);
          return SliverToBoxAdapter(child: PersonaBannerSection(groupId: widget.groupId));
        }
      },
    );
  }
}
