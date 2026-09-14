import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:balady_plus/app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/delegators/presentation/widgets/delegator_list.dart';
import 'package:balady_plus/app/features/delegators/services/account_selection_service.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/widgets/selected_persona_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class PersonaBannerSection extends StatefulWidget {
  final String groupId;
  final MiniApp? dashboard;

  const PersonaBannerSection({super.key, required this.groupId, this.dashboard});

  @override
  State<PersonaBannerSection> createState() => _PersonaBannerSectionState();
}

class _PersonaBannerSectionState extends State<PersonaBannerSection> {
  @override
  Widget build(BuildContext context) {
    bool isLoggedin = CommonProperties.isLoggedInMunicipality;
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    return Consumer<BaladyThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return BlocProvider<DelegatorsCubit>.value(
          value: GetIt.instance<DelegatorsCubit>(),
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
                      debugPrint("DEBUG: Selection actually changed from '$previousSelection' to '$currentSelection'");
                    }

                    return selectionChanged;
                  },
                  listener: (context, state) {
                    // Refresh dashboard when delegator/agent selection changes
                    debugPrint(
                      (
                        "DEBUG: Delegator selection changed - Delegator: ${state.selectedDelegate?.entityName}, Agent: ${state.selectedAgent?.grantorName}",
                      ).toString(),
                    );
                    final dashboardBloc = context.read<DashboardBloc>();
                    dashboardBloc.add(DashboardEventInitial(delegatorsCubit: delegatorsCubit));
                  },
                  child: BlocListener<DelegatorsCubit, DelegatorsState>(
                    listenWhen: (previous, current) {
                      final isBusinessGroup = AccountSelectionService.isBusinessGroup(widget.groupId);
                      if (!isBusinessGroup || !isLoggedin) return false;

                      final wasLoading =
                          previous.accountStatus == DelegatorsAccountStatus.loading ||
                          previous.accountStatus == DelegatorsAccountStatus.initial;
                      final isNotLoading =
                          current.accountStatus != DelegatorsAccountStatus.loading &&
                          current.accountStatus != DelegatorsAccountStatus.initial;
                      final hasNoData = current.delegators.isEmpty && current.agents.isEmpty;

                      return wasLoading && isNotLoading && hasNoData;
                    },
                    listener: (context, state) {
                      _showDelegatorSelectionBottomSheet(context, state);
                    },
                    child: Card(
                      child: Column(
                        children: [
                          BlocBuilder<DelegatorsCubit, DelegatorsState>(
                            builder: (context, state) {
                              final isBusinessGroup = AccountSelectionService.isBusinessGroup(widget.groupId);

                              // For business groups, show loading while determining account selection
                              if (isBusinessGroup && isLoggedin) {
                                final isDataLoading =
                                    state.accountStatus == DelegatorsAccountStatus.loading ||
                                    state.accountStatus == DelegatorsAccountStatus.initial;

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
                                          delegatorsState.accountStatus == DelegatorsAccountStatus.normalAccount)
                                    : true; // Personal group is always ready

                                // Initialize dashboard when account selection is ready
                                if (isAccountSelectionReady) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    final dashboardBloc = context.read<DashboardBloc>();
                                    if (dashboardBloc.state.status == BlocRequestStatus.initial) {
                                      debugPrint("DEBUG: Initializing dashboard with selected account");
                                      dashboardBloc.add(DashboardEventInitial(delegatorsCubit: delegatorsCubit));
                                    }
                                  });
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: BlocBuilder<DashboardBloc, DashboardState>(
                                    builder: (context, dashboardState) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: IntrinsicHeight(
                                          child: Row(
                                            spacing: 8,
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              // Always show 4 dashboard cards (empty or with data)
                                              ...List.generate(4, (index) {
                                                final hasCard = index < dashboardState.cards.length;
                                                final card = hasCard ? dashboardState.cards[index] : null;
                                                final hasData = hasCard && dashboardState.cardsStates[card] != null;

                                                return Container(
                                                  height: context.h(74) * textScale,
                                                  width: context.w(63) * textScale,
                                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                                  decoration: ShapeDecoration(
                                                    color: themeNotifier.isDarkMode
                                                        ? const Color(0xFF002D40)
                                                        : Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        width: 1,
                                                        color: themeNotifier.isDarkMode
                                                            ? const Color(0xFFFFFFFF).withValues(alpha: 0.6)
                                                            : Colors.black.withValues(alpha: 0.08),
                                                      ),
                                                      borderRadius: BorderRadius.circular(8),
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
                                                                    ? const Color(0xFFFFFFFF).withValues(alpha: 0.6)
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
                                                                          ? const Color(0xFFFFFFFF)
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
                                                    height: context.h(74) * textScale,
                                                    width: context.w(45) * textScale,
                                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                                    decoration: ShapeDecoration(
                                                      color: Theme.of(context).hintColor.withAlpha(20),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "show_more".tr(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onPrimary,
                                                          fontSize: 12,
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
                ),
              );
            },
          ),
        );
      },
    );
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
