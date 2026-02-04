import 'dart:ui';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/dashboard_card_entity.dart';
import 'package:balady_plus/app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/agent_entity.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/delegator_entity.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/delegators/presentation/widgets/delegator_list.dart';
import 'package:balady_plus/app/features/delegators/services/account_selection_service.dart';
import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:balady_plus/app/features/entry_point/domain/entities/sso_user_info.dart';
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
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                                    onTap: () {},
                                    keyboardType: TextInputType.text,
                                    isReadOnly: false,
                                    suffixString: value.text.isEmpty
                                        ? Text("search2".tr(), style: TextStyle(color: Theme.of(context).disabledColor))
                                        : const SizedBox(),
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
                                _buildNafathLoginWidget,
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
                                _buildNafathLoginWidget,
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
                                                pageBuilder: (_, __, ___) => AppsGroupPage(groupId: categoryGroup.id, dashboard: widget.dashboard,),
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
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.8,
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
                                _buildNafathLoginWidget,
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
                              _buildNafathLoginWidget,
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
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.8,
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
  Widget get _buildNafathLoginWidget {
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
          return SliverToBoxAdapter(child: TempPersonaBannerSection(groupId: widget.groupId, dashboard: widget.dashboard,));
        }
      },
    );
  }
}

class TempPersonaBannerSection extends StatefulWidget {
  final String groupId;
  final MiniApp? dashboard;

  const TempPersonaBannerSection({super.key, required this.groupId, this.dashboard});

  @override
  State<TempPersonaBannerSection> createState() => _TempPersonaBannerSectionState();
}

class _TempPersonaBannerSectionState extends State<TempPersonaBannerSection> {
  @override
  Widget build(BuildContext context) {
    bool isLoggedin = CommonProperties.isLoggedInMunicipality;
    return Consumer<BaladyThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return BlocProvider<DelegatorsCubit>(
          create: (context) {
            final cubit = GetIt.instance<DelegatorsCubit>();
            // Apply account selection logic based on group type
            if (isLoggedin) {
              _applyAccountSelection(cubit);
            }
            return cubit;
          },
          child: Builder(
            builder: (context) {
              // Now we can access the DelegatorsCubit and pass it to DashboardBloc
              final delegatorsCubit = context.read<DelegatorsCubit>();
              return BlocProvider<DashboardBloc>(
                create: (context) => GetIt.instance<DashboardBloc>(),
                child: BlocListener<DelegatorsCubit, DelegatorsState>(
                  listenWhen: (previous, current) {
                    // Only listen when the actual selection changes, not on loading states or other changes
                    final previousSelection = '${previous.selectedDelegate?.id}_${previous.selectedAgent?.id}';
                    final currentSelection = '${current.selectedDelegate?.id}_${current.selectedAgent?.id}';
                    final selectionChanged = previousSelection != currentSelection;

                    if (selectionChanged) {
                      print("DEBUG: Selection actually changed from '$previousSelection' to '$currentSelection'");
                    }

                    return selectionChanged;
                  },
                  listener: (context, state) {
                    // Refresh dashboard when delegator/agent selection changes
                    print(
                      "DEBUG: Delegator selection changed - Delegator: ${state.selectedDelegate?.entityName}, Agent: ${state.selectedAgent?.grantorName}",
                    );
                    final dashboardBloc = context.read<DashboardBloc>();
                    dashboardBloc.add(DashboardEventInitial(delegatorsCubit: delegatorsCubit));
                  },
                  child: BlocListener<DelegatorsCubit, DelegatorsState>(
                    listenWhen: (previous, current) {
                      // Only trigger when transitioning from loading to no-data state for business groups
                      final isBusinessGroup = AccountSelectionService.isBusinessGroup(widget.groupId);
                      if (!isBusinessGroup || !isLoggedin) return false;

                      final wasLoading = previous.status == BlocRequestStatus.submissionGetLoading ||
                                        previous.agentStatus == BlocRequestStatus.submissionGetLoading ||
                                        previous.status == BlocRequestStatus.initial ||
                                        previous.agentStatus == BlocRequestStatus.initial;
                      final isNotLoading = current.status != BlocRequestStatus.submissionGetLoading &&
                                          current.agentStatus != BlocRequestStatus.submissionGetLoading &&
                                          current.status != BlocRequestStatus.initial &&
                                          current.agentStatus != BlocRequestStatus.initial;
                      final hasNoData = current.delegators.isEmpty && current.agents.isEmpty;

                      return wasLoading && isNotLoading && hasNoData;
                    },
                    listener: (context, state) {
                      _showDelegatorSelectionBottomSheet(context, state);
                    },
                  child: Container(
                    decoration: ShapeDecoration(
                      color: themeNotifier.isDarkMode ? Color(0xFF002D40) : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      shadows: [
                        BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1), spreadRadius: 0),
                        BoxShadow(color: Color(0x0A000000), blurRadius: 0, offset: Offset(0, 0), spreadRadius: 0.50),
                      ],
                    ),
                    child: Column(
                      children: [
                        BlocBuilder<DelegatorsCubit, DelegatorsState>(
                          builder: (context, state) {
                            final isBusinessGroup = AccountSelectionService.isBusinessGroup(widget.groupId);

                            // For business groups, show loading while determining account selection
                            if (isBusinessGroup && isLoggedin) {
                              final isDataLoading =
                                  state.status == BlocRequestStatus.submissionGetLoading ||
                                  state.agentStatus == BlocRequestStatus.submissionGetLoading ||
                                  state.status == BlocRequestStatus.initial ||
                                  state.agentStatus == BlocRequestStatus.initial;

                              final hasNoData = state.delegators.isEmpty && state.agents.isEmpty;
                              final hasDataButNoSelection =
                                  (state.delegators.isNotEmpty || state.agents.isNotEmpty) &&
                                  state.selectedDelegate == null &&
                                  state.selectedAgent == null;

                              // Show loading while data is being fetched or selection is being determined
                              if (isDataLoading && hasNoData) {
                                return _buildLoadingProfileCard();
                              }

                              // If no delegators/agents available, the BlocListener above will handle showing the bottom sheet

                              // If data loaded but no selection made yet, show loading briefly while selection is applied
                              if (hasDataButNoSelection && !isDataLoading) {
                                return _buildLoadingProfileCard();
                              }
                            }
                            // return ;

                            return SelectedPersonaCard(
                              isListItem: false,
                              agent: isLoggedin ? state.selectedAgent : null,
                              delegator: isLoggedin ? state.selectedDelegate : null,
                              userInfo: isLoggedin ? CommonProperties.userInfo : null,
                              groupId: widget.groupId,
                              dashboard: widget.dashboard,
                            );
                          },
                        ),

                        // Dashboard
                        if (CommonProperties.isLoggedInMunicipality) ...[
                          BlocBuilder<DelegatorsCubit, DelegatorsState>(
                            builder: (context, delegatorsState) {
                              // Check if account selection is ready based on group type
                              final isBusinessGroup = AccountSelectionService.isBusinessGroup(widget.groupId);
                              final isAccountSelectionReady = isBusinessGroup
                                  ? (delegatorsState.selectedDelegate != null ||
                                        delegatorsState.selectedAgent != null ||
                                        (delegatorsState.delegators.isEmpty &&
                                            delegatorsState.agents.isEmpty &&
                                            delegatorsState.status == BlocRequestStatus.submissionGetSuccess))
                                  : true; // Personal group is always ready

                              // Initialize dashboard when account selection is ready
                              if (isAccountSelectionReady) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  final dashboardBloc = context.read<DashboardBloc>();
                                  if (dashboardBloc.state.status == BlocRequestStatus.initial) {
                                    print("DEBUG: Initializing dashboard with selected account");
                                    dashboardBloc.add(DashboardEventInitial(delegatorsCubit: delegatorsCubit));
                                  }
                                });
                              }

                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: BlocBuilder<DashboardBloc, DashboardState>(
                                  builder: (context, dashboardState) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: IntrinsicHeight(
                                        child: Row(
                                          spacing: 8,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            // Always show 3 dashboard cards (empty or with data)
                                            ...List.generate(3, (index) {
                                              final hasCard = index < dashboardState.cards.length;
                                              final card = hasCard ? dashboardState.cards[index] : null;
                                              final hasData = hasCard && dashboardState.cardsStates[card] != null;

                                              return Container(
                                                height: 72,
                                                width: 72,
                                                padding: const EdgeInsets.symmetric(vertical: 2),
                                                decoration: ShapeDecoration(
                                                  color: themeNotifier.isDarkMode ? Color(0xFF002D40) : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      width: 1,
                                                      color: themeNotifier.isDarkMode
                                                          ? Color(0xFFFFFFFF).withValues(alpha: 0.6)
                                                          : Colors.black.withValues(alpha: 0.08),
                                                    ),
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                ),
                                                child: hasCard
                                                    ? Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        spacing: 6,
                                                        children: [
                                                          Text(
                                                            card!.name,
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: themeNotifier.isDarkMode
                                                                  ? Color(0xFFFFFFFF).withValues(alpha: 0.6)
                                                                  : const Color(0xFF8E8E93),
                                                              fontSize: 12,
                                                              fontFamily: GeneralKey.appFontType,
                                                              fontWeight: FontWeight.w400,
                                                              height: 1.67,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          Text(
                                                            hasData
                                                                ? dashboardState.cardsStates[card]!.totalCount
                                                                      .toString()
                                                                : '0',
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              color: hasData
                                                                  ? themeNotifier.isDarkMode
                                                                        ? Color(0xFFFFFFFF)
                                                                        : Colors.black
                                                                  : const Color(0xFF8E8E93),
                                                              fontSize: 20,
                                                              fontFamily: GeneralKey.appFontType,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        spacing: 6,
                                                        children: [
                                                          Container(
                                                            height: 12,
                                                            width: 40,
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFF8E8E93).withValues(alpha: 0.3),
                                                              borderRadius: BorderRadius.circular(6),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 20,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFF8E8E93).withValues(alpha: 0.3),
                                                              borderRadius: BorderRadius.circular(6),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              );
                                            }),
                                            // Always show "View More" button
                                            if (widget.dashboard != null)
                                              GestureDetector(
                                                onTap: () {
                                                  context.read<NewMiniAppLogicCubit>().openMiniApp(widget.dashboard!);
                                                },
                                                child: Container(
                                                  height: 72,
                                                  width: 72,
                                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                                  decoration: ShapeDecoration(
                                                    color: themeNotifier.isDarkMode ? Color(0xFF002D40) : Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        width: 1,
                                                        color: themeNotifier.isDarkMode
                                                            ? Color(0xFFFFFFFF).withValues(alpha: 0.6)
                                                            : Colors.black.withValues(alpha: 0.08),
                                                      ),
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "show_more".tr().replaceAll(' ', '\n'),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: const Color(0xFF29B2A9),
                                                        fontSize: 14,
                                                        fontFamily: GeneralKey.appFontType,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.33,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ));
            },
          ),
        );
      },
    );
  }

  void _applyAccountSelection(DelegatorsCubit cubit) {
    // Apply account selection logic immediately
    print("DEBUG: Applying account selection for group: ${widget.groupId}");
    AccountSelectionService.applyAccountSelectionForGroup(widget.groupId, cubit);
  }

  Widget _buildLoadingProfileCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  void _showDelegatorSelectionBottomSheet(BuildContext context, DelegatorsState state) {
    final delegatorsCubit = context.read<DelegatorsCubit>();

    BottomSheetDialog.showDraggableSheet(
      context,
      dialogKeyName: DialogName.delegatorsDialog,
      currentRouteName: "BusinessGroupPage",
      isDismissible: false, // Non-dismissible
      enableDrag: false, // Disable drag to close
      child: DelegatorList(delegatorsCubit: delegatorsCubit, groupId: widget.groupId),
    );
  }
}

class DashboardCardWidget extends StatelessWidget {
  final DashboardCardEntity card;
  final int totalCount;

  const DashboardCardWidget({super.key, required this.card, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    Color? textColor;

    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).cardColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: CustomTextWidget(
              totalCount.toString(),
              fontSize: 21,
              fontWeight: AppFontWeight.bold,
              fontColor: textColor ?? Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            flex: 2,
            child: CustomTextWidget(
              card.name,
              fontSize: 14,
              maxLines: 4,
              height: 1.3,
              fontColor: textColor ?? Theme.of(context).primaryColor,
              textAlign: TextAlign.center,
              fontWeight: AppFontWeight.regular,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedPersonaCard extends StatelessWidget {
  const SelectedPersonaCard({
    super.key,
    this.userInfo,
    this.delegator,
    this.agent,
    this.selected = false,
    this.isListItem = true,
    this.groupId,
    this.dashboard,
  });

  final SsoUserInfo? userInfo;
  final DelegatorEntity? delegator;
  final AgentEntity? agent;
  final bool selected;
  final bool isListItem;
  final String? groupId;
  final MiniApp? dashboard;

  @override
  Widget build(BuildContext context) {
    final selected = !isListItem || this.selected;
    final name = (agent?.grantorName ?? delegator?.entityName) ?? userInfo?.getFirstAndLastName() ?? "hi".tr();
    String type = (agent?.agencyNumber ?? delegator?.id) ?? userInfo?.idNo ?? "in_balady".tr();

    return Consumer<BaladyThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 6,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontFamily: GeneralKey.appFontType,
                    fontWeight: FontWeight.w400,
                    height: 1.75,
                    letterSpacing: -0.24,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () async {
                  if (userInfo == null && delegator == null && agent == null) {
                    return;
                  }

                  if (isListItem) {
                    // Handle account selection with cross-group navigation
                    await _handleAccountSelection(context, newDelegator: delegator, newAgent: agent);
                  } else {
                    CommonFunctions.sendUXCamEvent(UXCamEvents.DashBoard_Click_Switch_Account_From_Dashboard_Event);

                    context.read<DelegatorsCubit>().getDelegators();
                    context.read<DelegatorsCubit>().getAgents();
                    await BottomSheetDialog.showDraggableSheet(
                      context,
                      dialogKeyName: DialogName.delegatorsDialog,
                      currentRouteName: "MorePage",
                      child: DelegatorList(delegatorsCubit: context.read<DelegatorsCubit>(), groupId: groupId),
                    );

                    try {
                      final delegatorsCubit = context.read<DelegatorsCubit>();
                      BlocProvider.of<DashboardBloc>(
                        context,
                      ).add(DashboardEventInitial(delegatorsCubit: delegatorsCubit));
                    } catch (e) {
                      // Fallback if DelegatorsCubit is not available
                      BlocProvider.of<DashboardBloc>(context).add(DashboardEventInitial());
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: ShapeDecoration(
                    color: const Color(0x2629B2A9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "switch_account".tr(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontFamily: GeneralKey.appFontType,
                          fontWeight: FontWeight.w400,
                          height: 2,
                          letterSpacing: -0.24,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleAccountSelection(
    BuildContext context, {
    DelegatorEntity? newDelegator,
    AgentEntity? newAgent,
  }) async {
    final cubit = context.read<DelegatorsCubit>();

    if (groupId != null) {
      // Use AccountSelectionService to handle cross-group navigation
      await AccountSelectionService.handleAccountSwitch(
        currentGroupId: groupId!,
        newDelegator: newDelegator,
        newAgent: newAgent,
        cubit: cubit,
        onNavigateToGroup: (targetGroupId) {
          print("DEBUG: Cross-group navigation triggered to group: $targetGroupId");
          // Close the delegator list bottom sheet
          Navigator.of(context).pop();

          // Navigate to target group after a short delay
          Future.delayed(const Duration(milliseconds: 300), () {
            if (context.mounted) {
              print("DEBUG: Executing cross-group navigation to: $targetGroupId");
              // Close current group and navigate to target group
              // Navigator.of(context).pop(); // Close current AppsGroupPage

              // Navigate to target group
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.transparent,
                  pageBuilder: (_, _, _) => AppsGroupPage(groupId: targetGroupId, dashboard: dashboard),
                ),
              );
            } else {
              print("DEBUG: Context not mounted, skipping navigation");
            }
          });
        },
      );
    } else {
      // Fallback to original logic if groupId is not provided
      if (newDelegator != null) {
        cubit.selectDelegator(newDelegator);
      } else if (newAgent != null) {
        cubit.selectAgent(newAgent);
      } else {
        cubit.selectDelegator(null);
        cubit.selectAgent(null);
      }
    }

    // Close the bottom sheet if still open
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // Refresh dashboard after selection change
    try {
      final delegatorsCubit = context.read<DelegatorsCubit>();
      BlocProvider.of<DashboardBloc>(context).add(DashboardEventInitial(delegatorsCubit: delegatorsCubit));
    } catch (e) {
      // Dashboard bloc or DelegatorsCubit might not be available in all contexts
      try {
        BlocProvider.of<DashboardBloc>(context).add(DashboardEventInitial());
      } catch (e2) {
        // Dashboard bloc might not be available in all contexts
      }
    }
  }
}
