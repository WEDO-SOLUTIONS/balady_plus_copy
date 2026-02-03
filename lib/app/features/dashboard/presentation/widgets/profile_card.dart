import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/widgets/shared/circle_icon.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/agent_entity.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/delegator_entity.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/delegators/presentation/widgets/delegator_list.dart';
import 'package:balady_plus/app/features/delegators/services/account_selection_service.dart';
import 'package:balady_plus/app/features/entry_point/domain/entities/sso_user_info.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/apps_group_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ProfileCard extends StatelessWidget {
  final SsoUserInfo? userInfo;
  final DelegatorEntity? delegator;
  final AgentEntity? agent;
  final bool selected;
  final bool isListItem;
  final String? groupId;

  const ProfileCard({
    super.key,
    this.userInfo,
    this.delegator,
    this.agent,
    this.selected = false,
    this.isListItem = true,
    this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    final selected = !isListItem || this.selected;
    final name = (agent?.grantorName ?? delegator?.entityName) ?? userInfo?.getFirstAndLastName() ?? "hi".tr();
    String type = (agent?.agencyNumber ?? delegator?.id) ?? userInfo?.idNo ?? "in_balady".tr();

    String? agentType = (agent?.agencyTypeName ?? delegator?.roleName) ?? "Indivisual".tr();

    Color? agentBgColor = const Color(0xffEAF3EF);
    Color? agentTextColor = const Color(0xff2A8663);

    if (agent != null) {
      agentBgColor = const Color(0xffE5E8FF);
      agentTextColor = const Color(0xff433785);
    }

    if (delegator != null) {
      if (delegator?.roleId == "20") {
        agentBgColor = const Color(0xffE5E8FF);
        agentTextColor = const Color(0xff433785);
      }
      if (delegator?.roleId == "30") {
        agentBgColor = const Color(0xffFAECCA);
        agentTextColor = const Color(0xffC07720);
      }
    }

    if (!isListItem && delegator == null && agent == null && userInfo != null) {
      // type = "individual_account".tr();
      type = userInfo?.idNo ?? "";
    }

    return InkWell(
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
            BlocProvider.of<DashboardBloc>(context).add(DashboardEventInitial(delegatorsCubit: delegatorsCubit));
          } catch (e) {
            // Fallback if DelegatorsCubit is not available
            BlocProvider.of<DashboardBloc>(context).add(DashboardEventInitial());
          }
        }
      },
      child: Container(
        margin: isListItem ? const EdgeInsets.symmetric(vertical: 8) : const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        // height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: selected && isListItem ? Border.all(color: const Color(0xff1191AC)) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleIcon(
              showShadow: false,
              icon: IconPath.profileIcon,
              backgroundColor: Theme.of(context).colorScheme.surface,
              iconColor: agentTextColor,
              // backgroundColor: AppColor.primary50Light,
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: CustomTextWidget(
                      name,
                      // fontColor: selected ? const Color(0xff18181B) : const Color(0xff18181B),
                      maxLines: 2,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          type,
                          fontWeight: AppFontWeight.medium,
                          fontSize: 12,
                          //      fontColor: selected ? const Color(0xff737373) : const Color(0xff737373),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 28,
                padding: const EdgeInsets.only(left: 2, right: 2, bottom: 6, top: 6),
                decoration: BoxDecoration(color: agentBgColor, borderRadius: BorderRadius.circular(6)),
                alignment: Alignment.center,
                child: CustomTextWidget(
                  agentType,
                  maxLines: 4,
                  fontSize: 12,
                  fontWeight: AppFontWeight.medium,
                  fontColor: agentTextColor,
                ),
              ),
            ),

            if (!isListItem && (userInfo != null || delegator != null))
              SvgPicture.asset(
                IconPath.arrowDown,
                width: 16,
                height: 16,
                placeholderBuilder: (context) =>
                    Icon(Icons.keyboard_arrow_down, size: 16, color: Theme.of(context).colorScheme.onSurface),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAccountSelection(
    BuildContext context, {
    DelegatorEntity? newDelegator,
    AgentEntity? newAgent,
  }) async {
    print(
      "DEBUG: _handleAccountSelection called - Delegator: ${newDelegator?.entityName}, Agent: ${newAgent?.grantorName}, GroupId: $groupId",
    );
    final cubit = context.read<DelegatorsCubit>();

    if (groupId != null) {
      print("DEBUG: GroupId is not null, calling AccountSelectionService.handleAccountSwitch");
      // Use AccountSelectionService to handle cross-group navigation
      await AccountSelectionService.handleAccountSwitch(
        currentGroupId: groupId!,
        newDelegator: newDelegator,
        newAgent: newAgent,
        cubit: cubit,
        onNavigateToGroup: (targetGroupId) {
          print("DEBUG: Cross-group navigation triggered to group: $targetGroupId");

          // Close the delegator list bottom sheet immediately
          Navigator.of(context).pop();
          print("DEBUG: Closed delegator list bottom sheet");

          // Navigate back to main screen context, then navigate to new group
          // This mimics exactly how normal group navigation works from the main screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              print("DEBUG: Post-frame callback executing group switch to: $targetGroupId");

              // First, pop back to the main screen context
              // Navigator.of(context).pop();
              print("DEBUG: Popped Personal group, back to main screen context");

              // Then navigate to the Business group using the same pattern as main screen navigation
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.transparent,
                  pageBuilder: (_, __, ___) {
                    print(
                      "DEBUG: Building Business group overlay from main screen context with groupId: $targetGroupId",
                    );
                    return AppsGroupPage(groupId: targetGroupId);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    // Slide transition from right to left
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                      child: child,
                    );
                  },
                ),
              );
              print("DEBUG: Business group overlay pushed from main screen context successfully: $targetGroupId");
            } else {
              print("DEBUG: Context not mounted, navigation failed");
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
