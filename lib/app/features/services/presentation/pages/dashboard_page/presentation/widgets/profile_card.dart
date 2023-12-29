import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../core/utils/constants/app_style.dart';
import '../../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, CommonFunctions, IconPath, RouteName;
import '../../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, CustomAutoSizeTextWidget, CustomTextWidget;
import '../../../../../../entry_point/entry_point_exports.dart'
    show SsoUserInfo;
import '../../../../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../../../../../home_page/home_exports.dart' show CircleIcon;
import '../../../../../../profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../../../../profile_features/delegators/delegators_exports.dart'
    show AgentEntity, DelegatorEntity, DelegatorList, DelegatorsCubit;

class ProfileCard extends StatelessWidget {
  final SsoUserInfo? userInfo;
  final DelegatorEntity? delegator;
  final AgentEntity? agent;
  final bool selected;
  final bool isListItem;

  const ProfileCard({
    super.key,
    this.userInfo,
    this.delegator,
    this.agent,
    this.selected = false,
    this.isListItem = true,
  });

  @override
  Widget build(BuildContext context) {
    final selected = !isListItem || this.selected;
    final name = (agent?.grantorName ?? delegator?.entityName) ??
        userInfo?.getFirstAndLastName() ??
        "hi".tr();
    String type = (agent?.agencyNumber ?? delegator?.id) ??
        userInfo?.idNo ??
        "in_balady".tr();

    String? agentType =
        (agent?.agencyTypeName ?? delegator?.roleName) ?? "Indivisual".tr();

    Color? agentBgColor = Color(0xffEAF3EF);
    Color? agentTextColor = Color(0xff2A8663);

    if (agent != null) {
      agentBgColor = Color(0xffE5E8FF);
      agentTextColor = Color(0xff433785);
    }

    if (delegator != null) {
      if (delegator?.roleId == "20") {
        agentBgColor = Color(0xffE5E8FF);
        agentTextColor = Color(0xff433785);
      }
      if (delegator?.roleId == "30") {
        agentBgColor = Color(0xffFAECCA);
        agentTextColor = Color(0xffC07720);
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
          if (delegator != null) {
            context.read<DelegatorsCubit>().selectDelegator(delegator);
            context.read<EntryPointCubit>().selectDelegator(delegator);
          }
          if (agent != null) {
            context.read<DelegatorsCubit>().selectAgent(agent);
            context.read<EntryPointCubit>().selectAgent(agent);
          }
          if (agent == null && delegator == null) {
            context.read<DelegatorsCubit>().selectDelegator(delegator);
            context.read<EntryPointCubit>().selectDelegator(delegator);
            context.read<DelegatorsCubit>().selectAgent(agent);
            context.read<EntryPointCubit>().selectAgent(agent);
          }

          Navigator.of(context).pop();
        } else {
          CommonFunctions.sendUXCamEvent(
              UXCamEvents.DashBoard_Click_Switch_Account_From_Dashboard_Event);

          context.read<DelegatorsCubit>().getDelegators();
          context.read<DelegatorsCubit>().getAgents();
          await BottomSheetDialog.showDraggableSheet(
            context,
            dialogKeyName: DialogName.delegatorsDialog,
            currentRouteName: "MorePage",
            child: DelegatorList(
              delegatorsCubit: context.read<DelegatorsCubit>(),
            ),
          );

          BlocProvider.of<DashboardBloc>(context).add(DashboardEventInitial());
        }
      },
      child: Container(
        margin: isListItem
            ? const EdgeInsets.symmetric(vertical: 8)
            : const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        // height: 80,
        decoration: BoxDecoration(
            color: const Color(0xffFBFBFB),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            border: selected && isListItem
                ? Border.all(color: Color(0xff1191AC))
                : null),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleIcon(
              showShadow: false,
              icon: IconPath.profileIcon,
              backgroundColor: Color(0x33B1B1B1),
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
                      fontColor:
                          selected ? Color(0xff18181B) : Color(0xff18181B),
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
                          fontColor:
                              selected ? Color(0xff737373) : Color(0xff737373),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 28,
                padding: EdgeInsets.only(left: 2, right: 2, bottom: 6, top: 6),
                decoration: BoxDecoration(
                    color: agentBgColor,
                    borderRadius: BorderRadius.circular(6)),
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

            /*
            if (!isListItem && (userInfo != null || delegator != null))
              SvgPicture.asset(
                IconPath.arrowDown,
              )*/
          ],
        ),
      ),
    );
  }
}
