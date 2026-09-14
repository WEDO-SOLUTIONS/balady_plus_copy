import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/apps_group_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatelessWidget {
  final SsoUserInfo? userInfo;
  final DelegatorEntity? delegator;
  final AgentEntity? agent;
  final bool selected;
  final bool isListItem;
  final String? groupId;
  final bool isIndividual;

  const ProfileCard({
    super.key,
    this.userInfo,
    this.delegator,
    this.agent,
    this.selected = false,
    this.isListItem = true,
    this.groupId,
    required this.isIndividual,
  });

  @override
  Widget build(BuildContext context) {
    final selected = !isListItem || this.selected;
    final name = (agent?.grantorName ?? delegator?.entityName) ?? userInfo?.getFirstAndLastName() ?? "hi".tr();
    String type = (agent?.agencyNumber ?? delegator?.id) ?? userInfo?.idNo ?? "in_balady".tr();

    String? agentType = (agent?.agencyTypeName ?? delegator?.roleName) ?? "Indivisual".tr();

    bool isIndivisual = agentType == "Indivisual".tr();

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
      type = userInfo?.idNo ?? "";
    }

    return Consumer<BaladyThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return InkWell(
          onTap: () async {
            if (userInfo == null && delegator == null && agent == null) {
              return;
            }

            if (isListItem) {
              // Handle account selection with cross-group navigation
              await _handleAccountSelection(context, newDelegator: delegator, newAgent: agent);
            } else {
              CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.DashBoard_Click_Switch_Account_From_Dashboard_Event);
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
                BlocProvider.of<DashboardBloc>(context).add(DashboardEventInitial(delegatorsCubit: delegatorsCubit));
              } catch (e) {
                // Fallback if DelegatorsCubit is not available
                BlocProvider.of<DashboardBloc>(context).add(DashboardEventInitial());
              }
            }
          },
          child: SizedBox(
            // width: context.w(461),
            // height: context.h(130),
            //! Individual card ....
            child: isIndividual
                ? Card(
                    elevation: 0,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      // width: double.infinity,
                                      child: AutoSizeText(
                                        maxFontSize: 16,
                                        minFontSize: 12,
                                        isIndivisual ? 'indivisual_account'.tr() : name,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontFamily: GeneralKey.appFontType,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          wordSpacing: 0,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 22, // Match the design height
                                      width: 22,
                                      alignment: Alignment.center, // Centers the inner circle
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent, // Background of the radio
                                        border: Border.all(
                                          color: selected
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context).colorScheme.onSurface,
                                          width: 1, // Thinner border as per design
                                        ),
                                      ),
                                      child: selected
                                          ? Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 9.0),
                                  child: SizedBox(
                                    width: context.screenWidth,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              name,
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSurface,
                                                fontSize: 16,
                                                fontFamily: GeneralKey.appFontType,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              type,
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSurface.withAlpha(90),
                                                fontSize: 14,
                                                fontFamily: GeneralKey.appFontType,
                                                fontWeight: FontWeight.w400,
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
                        ],
                      ),
                    ),
                  )
                //! Business card ....
                : Card(
                    color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                    elevation: 0,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: AutoSizeText(
                                    maxFontSize: 16,
                                    minFontSize: 12,
                                    isIndivisual ? 'indivisual_account'.tr() : name,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontFamily: GeneralKey.appFontType,
                                      fontWeight: FontWeight.w400,
                                      wordSpacing: 0,
                                      height: 0,
                                    ),
                                  ),
                                ),

                                Text(
                                  type,
                                  style: TextStyle(
                                    color: themeNotifier.isDarkMode
                                        ? Colors.white.withValues(alpha: 0.6)
                                        : const Color(0x993C3C43),
                                    fontSize: 12,
                                    fontFamily: GeneralKey.appFontType,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: context.screenHeight * 0.01),
                                Container(
                                  // width: context.w(90), // 1. Removed this fixed width to allow auto-expansion
                                  decoration: BoxDecoration(
                                    color: agentBgColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 4.0,
                                    ), // 2. Changed to symmetric horizontal and vertical padding for uniform looks
                                    child: Row(
                                      mainAxisSize: MainAxisSize
                                          .min, // 3. CRITICAL: Tells the Row to only take up as much space as its children need
                                      children: [
                                        SizedBox(
                                          width: context.w(10),
                                          height: context.h(10),
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(color: agentTextColor, shape: BoxShape.circle),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ), // 4. Replaced spaceEvenly with a fixed spacer for stable layout
                                        Text(
                                          agentType,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: agentTextColor,
                                            fontSize: 14,
                                            fontFamily: GeneralKey.appFontType,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 22, // Match the design height
                              width: 22,
                              alignment: Alignment.center, // Centers the inner circle
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent, // Background of the radio
                                border: Border.all(
                                  color: selected
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).colorScheme.onSurface,
                                  width: 1, // Thinner border as per design
                                ),
                              ),
                              child: selected
                                  ? Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
    if (kDebugMode) {
      print(
        "DEBUG: _handleAccountSelection called - Delegator: ${newDelegator?.entityName}, Agent: ${newAgent?.grantorName}, GroupId: $groupId",
      );
    }
    final cubit = context.read<DelegatorsCubit>();

    if (groupId != null) {
      if (kDebugMode) {
        print("DEBUG: GroupId is not null, calling AccountSelectionService.handleAccountSwitch");
      }
      // Use AccountSelectionService to handle cross-group navigation
      await AccountSelectionService.handleAccountSwitch(
        currentGroupId: groupId!,
        newDelegator: newDelegator,
        newAgent: newAgent,
        cubit: cubit,
        onNavigateToGroup: (targetGroupId) {
          if (kDebugMode) {
            print("DEBUG: Cross-group navigation triggered to group: $targetGroupId");
          }

          // Close the delegator list bottom sheet immediately
          Navigator.of(context).pop();
          if (kDebugMode) {
            print("DEBUG: Closed delegator list bottom sheet");
          }

          // Navigate back to main screen context, then navigate to new group
          // This mimics exactly how normal group navigation works from the main screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              if (kDebugMode) {
                print("DEBUG: Post-frame callback executing group switch to: $targetGroupId");
              }

              // First, pop back to the main screen context
              // Navigator.of(context).pop();
              if (kDebugMode) {
                print("DEBUG: Popped Personal group, back to main screen context");
              }

              // Then navigate to the Business group using the same pattern as main screen navigation
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.transparent,
                  pageBuilder: (_, __, ___) {
                    if (kDebugMode) {
                      print(
                        "DEBUG: Building Business group overlay from main screen context with groupId: $targetGroupId",
                      );
                    }
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
              if (kDebugMode) {
                print("DEBUG: Business group overlay pushed from main screen context successfully: $targetGroupId");
              }
            } else {
              if (kDebugMode) {
                print("DEBUG: Context not mounted, navigation failed");
              }
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
