import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppFontWeight, BlocRequestStatus, CommonFunctions, CommonProperties;
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetWithActions,
        CustomTextWidget,
        CustomVerticalSpace,
        ShimmerEffectWidget;
import '../../../../services/presentation/pages/dashboard_page/presentation/widgets/profile_card.dart';
import '../../delegators_exports.dart' show DelegatorsCubit, DelegatorsState;
import 'no_accounts_widget.dart';

class DelegatorList extends StatefulWidget {
  final DelegatorsCubit _delegatorsCubit;
  final bool fromService;
  const DelegatorList({
    super.key,
    required DelegatorsCubit delegatorsCubit,
    this.fromService = false,
  }) : _delegatorsCubit = delegatorsCubit;

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
      child: Builder(builder: (context) {
        return BottomSheetWithActions(
          title: "profile_switch_account".tr(),
          body: BlocBuilder<DelegatorsCubit, DelegatorsState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.fromService &&
                      state.delegators.length == 0 &&
                      state.agents.length == 0) ...[
                    NoAccountsWidget()
                  ] else ...[
                    ProfileCard(
                      userInfo: CommonProperties.userInfo,
                      selected: state.selectedDelegate == null &&
                          state.selectedAgent == null,
                    ),
                    ProfileHeader(),
                    CustomVerticalSpace(
                      height: 16,
                    ),
                    if (state.tab == 0)
                      DelegatorsBody(
                        delegatorsCubit: widget._delegatorsCubit,
                      ),
                    if (state.tab == 1)
                      AgentsBody(delegatorsCubit: widget._delegatorsCubit)
                  ]
                ],
              );
            },
          ),
        );
      }),
    );
  }
}

class DelegatorsBody extends StatelessWidget {
  final DelegatorsCubit delegatorsCubit;
  const DelegatorsBody({super.key, required this.delegatorsCubit});

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
              ),
            ),
            if (state.status == BlocRequestStatus.submissionGetLoading)
              ...List.generate(
                5,
                (_) => Container(
                  height: 80,
                  margin: const EdgeInsets.only(top: 16),
                  child: const ShimmerEffectWidget(),
                ),
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
  const AgentsBody({super.key, required this.delegatorsCubit});

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
              ),
            ),
            if (state.agentStatus == BlocRequestStatus.submissionGetLoading)
              ...List.generate(
                5,
                (_) => Container(
                  height: 80,
                  margin: const EdgeInsets.only(top: 16),
                  child: const ShimmerEffectWidget(),
                ),
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
        CustomVerticalSpace(height: 16),
        CustomTextWidget(
          "profile_switch_entity".tr(),
          fontSize: 16,
          maxLines: 2,
          fontWeight: AppFontWeight.bold,
          textAlign: TextAlign.start,
          fontColor: Color(0xFF27272A),
        ),
        CustomVerticalSpace(height: 16),
        Container(
          height: 60,
          decoration: ShapeDecoration(
            color: Color(0xFFFBFBFB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TabWidget(
                name: "profile_switch_delegator".tr(),
                index: 0,
              ),
              TabWidget(
                name: "profile_switch_agent".tr(),
                index: 1,
              )
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
              margin: EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color:
                    state.tab == index ? Color(0xFFECECEC) : Color(0xffFFFFFF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F9EA5B7),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              alignment: Alignment.center,
              child: CustomTextWidget(
                name,
                fontColor:
                    state.tab == index ? Color(0xff18181B) : Color(0xFF737373),
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
