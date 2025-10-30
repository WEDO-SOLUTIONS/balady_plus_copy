import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/utils_exports.dart'
    show AppColor, IconPath, RouteName;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, CustomAutoSizeTextWidget, CustomTextWidget;
import '../../../entry_point/entry_point_exports.dart' show SsoUserInfo;
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../../home_page/home_exports.dart' show CircleIcon;
import '../../../profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../profile_features/delegators/delegators_exports.dart'
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
    if (!isListItem && delegator == null && agent == null && userInfo != null) {
      // type = "individual_account".tr();
      type = userInfo?.idNo ?? "";
    }

    String? agentType = agent?.agencyTypeName;

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
          color: selected
              ? AppColor.primary900Light
              : AppColor.blackModern100Light,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleIcon(
              icon: IconPath.profileIcon,
              iconColor: AppColor.primary700Light,
              // backgroundColor: AppColor.primary50Light,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: CustomAutoSizeTextWidget(
                    name,
                    textStyle: AppStyle.profileNameTextStyle.copyWith(
                      color: selected
                          ? AppColor.blackModern50Light
                          : AppColor.blackModern600Light,
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width - 155,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        type,
                        textStyle: AppStyle.profileTypeTextStyle.copyWith(
                          color: selected
                              ? AppColor.blackModern50Light.withOpacity(0.6)
                              : AppColor.blackModern600Light.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      if (agentType != null)
                        Flexible(
                          child: CustomTextWidget(
                            agentType,
                            maxLines: 2,
                            textStyle: AppStyle.profileTypeTextStyle.copyWith(
                              color: selected
                                  ? AppColor.blackModern50Light.withOpacity(0.6)
                                  : AppColor.blackModern600Light
                                      .withOpacity(0.6),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
            const Spacer(),
            if (!isListItem && (userInfo != null || delegator != null))
              SvgPicture.asset(
                IconPath.arrowDown,
              )
          ],
        ),
      ),
    );
  }
}
