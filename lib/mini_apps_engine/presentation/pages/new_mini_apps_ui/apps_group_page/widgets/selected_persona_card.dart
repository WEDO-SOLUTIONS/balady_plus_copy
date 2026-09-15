import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/constants/analytics_events.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:balady_plus/app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/agent_entity.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/delegator_entity.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/delegators/presentation/widgets/delegator_list.dart';
import 'package:balady_plus/app/features/delegators/services/account_selection_service.dart';
import 'package:balady_plus/app/features/entry_point/domain/entities/sso_user_info.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/apps_group_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

//!
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
    // final selected = !isListItem || this.selected;
    final name = (agent?.grantorName ?? delegator?.entityName) ?? userInfo?.getFirstAndLastName() ?? "hi".tr();
    // String type = (agent?.agencyNumber ?? delegator?.id) ?? userInfo?.idNo ?? "in_balady".tr();

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
                    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.dashBoardClickSwitchAccountFromDashboardEvent);
                    await BottomSheetDialog.showDraggableSheet(
                      context,
                      dialogKeyName: DialogName.delegatorsDialog,
                      currentRouteName: "MorePage",
                      child: DelegatorList(delegatorsCubit: context.read<DelegatorsCubit>(), groupId: groupId),
                    );
                    if (!context.mounted) {
                      return;
                    }

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
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "switch_account".tr(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: GeneralKey.appFontType,
                          fontWeight: FontWeight.w400,
                          height: 2,
                          letterSpacing: -0.24,
                        ),
                      ),
                      SizedBox(width: context.screenWidth * 0.01),
                      Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20),
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
          debugPrint("DEBUG: Cross-group navigation triggered to group: $targetGroupId");
          // Close the delegator list bottom sheet
          Navigator.of(context).pop();

          // Navigate to target group after a short delay
          Future.delayed(const Duration(milliseconds: 300), () {
            if (context.mounted) {
              debugPrint("DEBUG: Executing cross-group navigation to: $targetGroupId");
              // Close current group and navigate to target group
              // Navigator.of(context).pop(); // Close current AppsGroupPage

              // Navigate to target group
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.transparent,
                  pageBuilder: (_, _, _) => AppsGroupPage(groupId: targetGroupId),
                ),
              );
            } else {
              debugPrint("DEBUG: Context not mounted, skipping navigation");
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

    if (!context.mounted) {
      return;
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
