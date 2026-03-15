import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:balady_plus/app/features/dashboard/presentation/widgets/profile_card.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/delegators/services/account_selection_service.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/apps_group_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/utils_exports.dart'
    show AppFontWeight, BlocRequestStatus, CommonFunctions, CommonProperties;
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetWithActions, CustomTextWidget, CustomVerticalSpace, ShimmerEffectWidget;
import '../../delegators_exports.dart' show DelegatorsCubit, DelegatorsState;
import 'no_accounts_widget.dart';

class DelegatorList extends StatefulWidget {
  final DelegatorsCubit _delegatorsCubit;
  final bool fromService;
  final String? groupId;

  const DelegatorList({super.key, required DelegatorsCubit delegatorsCubit, this.fromService = false, this.groupId})
    : _delegatorsCubit = delegatorsCubit;

  @override
  State<DelegatorList> createState() => _DelegatorListState();
}

class _DelegatorListState extends State<DelegatorList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.openDelegators);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget._delegatorsCubit,
      child: Consumer<BaladyThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return BottomSheetWithActions(
            withoutClose: true,
            backgroundColor: themeNotifier.isDarkMode ? Color(0xFF002D40) : Colors.white,
            title: "switch_account".tr(),
            body: BlocBuilder<DelegatorsCubit, DelegatorsState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Check if this is a business group with no access
                    if (_shouldShowNoAccessMessage(state)) ...[
                      _buildNoAccessWidget(context, themeNotifier.isDarkMode),
                    ] else if (widget.fromService && state.delegators.isEmpty && state.agents.isEmpty) ...[
                      const NoAccountsWidget(),
                    ] else ...[
                      // Only show personal account option for personal groups or when no group specified
                      if (!_isBusinessGroup()) ...[
                        ProfileCard(
                          userInfo: CommonProperties.userInfo,
                          selected: state.selectedDelegate == null && state.selectedAgent == null,
                          isListItem: true,
                          groupId: widget.groupId,
                        ),
                      ],
                      // Only show tabs if there are delegators or agents
                      if (state.delegators.isNotEmpty || state.agents.isNotEmpty) ...[
                        // const ProfileHeader(),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: const Color(0xFFE7E7E7)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: state.tab == 0
                              ? DelegatorsBody(delegatorsCubit: widget._delegatorsCubit, groupId: widget.groupId)
                              : AgentsBody(delegatorsCubit: widget._delegatorsCubit, groupId: widget.groupId),
                        ),
                      ],
                    ],
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  bool _shouldShowNoAccessMessage(DelegatorsState state) {
    // Show no access message if:
    // 1. This is a business group
    // 2. User has no delegators or agents
    // 3. Not currently loading
    return widget.groupId != null &&
        AccountSelectionService.isBusinessGroup(widget.groupId!) &&
        state.delegators.isEmpty &&
        state.agents.isEmpty &&
        state.status != BlocRequestStatus.submissionGetLoading &&
        state.agentStatus != BlocRequestStatus.submissionGetLoading;
  }

  bool _isBusinessGroup() {
    return widget.groupId != null && AccountSelectionService.isBusinessGroup(widget.groupId!);
  }

  Widget _buildNoAccessWidget(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.business_center_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "no_business_access_title".tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[400] : Color(0xFF27272A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "no_business_access_message".tr(),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _switchToPersonalGroup(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003449),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("switch_to_personal".tr()),
            ),
          ),
        ],
      ),
    );
  }

  void _switchToPersonalGroup(BuildContext context) {
    // Clear business account selection from DelegatorsCubit
    final delegatorsCubit = context.read<DelegatorsCubit>();
    delegatorsCubit.clearSelection(); // This will trigger the mini apps list listener

    // Close the bottom sheet
    Navigator.of(context).pop();

    // Navigate to personal group after a short delay
    // Future.delayed(const Duration(milliseconds: 500), () {
    if (context.mounted) {
      // Close current group and navigate to personal group
      Navigator.of(context).pop(); // Close current AppsGroupPage

      // Navigate to personal group (business group will auto-disappear from list due to listener)
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.transparent,
          pageBuilder: (_, __, ___) => const AppsGroupPage(groupId: AccountSelectionService.personalGroupId),
        ),
      );
    }
    // });
  }
}

class DelegatorsBody extends StatelessWidget {
  final DelegatorsCubit delegatorsCubit;
  final String? groupId;

  const DelegatorsBody({super.key, required this.delegatorsCubit, this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DelegatorsCubit, DelegatorsState>(
      builder: (context, state) {
        return Column(
          children: [
            ...List.generate(
              state.delegators.length,
              (index) => ProfileCard(
                delegator: state.delegators[index],
                selected: state.delegators[index] == state.selectedDelegate,
                isListItem: true,
                groupId: groupId,
              ),
            ),
            if (state.status == BlocRequestStatus.submissionGetLoading)
              ...List.generate(
                5,
                (_) =>
                    Container(height: 80, margin: const EdgeInsets.only(top: 16), child: const ShimmerEffectWidget()),
              ),
            if (state.status == BlocRequestStatus.submissionGetFailure)
              ReloadWidget(
                onTab: () {
                  delegatorsCubit.getDelegators();
                },
              ),
          ],
        );
      },
    );
  }
}

class AgentsBody extends StatelessWidget {
  final DelegatorsCubit delegatorsCubit;
  final String? groupId;

  const AgentsBody({super.key, required this.delegatorsCubit, this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DelegatorsCubit, DelegatorsState>(
      builder: (context, state) {
        return Column(
          children: [
            ...List.generate(
              state.agents.length,
              (index) => ProfileCard(
                agent: state.agents[index],
                selected: state.agents[index] == state.selectedAgent,
                isListItem: true,
                groupId: groupId,
              ),
            ),
            if (state.agentStatus == BlocRequestStatus.submissionGetLoading)
              ...List.generate(
                5,
                (_) =>
                    Container(height: 80, margin: const EdgeInsets.only(top: 16), child: const ShimmerEffectWidget()),
              ),
            if (state.agentStatus == BlocRequestStatus.submissionGetFailure)
              ReloadWidget(
                onTab: () {
                  delegatorsCubit.getAgents();
                },
              ),
          ],
        );
      },
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomVerticalSpace(height: 16),
        CustomTextWidget(
          "profile_switch_entity".tr(),
          fontSize: 16,
          maxLines: 2,
          fontWeight: AppFontWeight.bold,
          textAlign: TextAlign.start,
          fontColor: const Color(0xFF27272A),
        ),
        const CustomVerticalSpace(height: 16),
        Container(
          height: 60,
          decoration: ShapeDecoration(
            color: const Color(0xFFFBFBFB),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TabWidget(name: "profile_switch_delegator".tr(), index: 0),
              TabWidget(name: "profile_switch_agent".tr(), index: 1),
            ],
          ),
        ),
      ],
    );
  }
}

class TabWidget extends StatelessWidget {
  final String name;
  final int index;

  const TabWidget({super.key, required this.name, required this.index});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<DelegatorsCubit, DelegatorsState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              context.read<DelegatorsCubit>().changeTab(index);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: state.tab == index ? AppColor.primary900Light : AppColor.warmGrey3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                shadows: const [
                  BoxShadow(color: Color(0x3F9EA5B7), blurRadius: 20, offset: Offset(0, 4), spreadRadius: 0),
                ],
              ),
              alignment: Alignment.center,
              child: CustomTextWidget(
                name,
                fontColor: state.tab == index ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: AppFontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
