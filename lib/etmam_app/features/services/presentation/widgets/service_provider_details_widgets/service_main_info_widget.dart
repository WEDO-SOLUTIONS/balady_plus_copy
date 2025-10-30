import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/features/services/presentation/blocs/service_details_bloc/service_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import '../../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppFontWeight,
        CommonFunctions,
        IconPath,
        PrimaryIcons,
        RouteName,
        trans;
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomIconButtonWidget,
        CustomSvgIconWidget,
        CustomTextButtonWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        EtmamRatingEvaluationWidget,
        SectionTitleWidget,
        SubTitleAndDescWidget,
        SubTitleAndWidget;

/*class ServiceProviderMainInfo extends StatelessWidget {
  const ServiceProviderMainInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                  color: Color(0x14d1d5db),
                  offset: Offset(-2, 4),
                  blurRadius: 8,
                  spreadRadius: 0)
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  state.response.provider?.name ?? "",
                  fontColor: AppColor.hunterGreen,
                  fontWeight: AppFontWeight.w600,
                  fontSize: 18,
                  textAlign: TextAlign.start,
                ),
                const CustomVerticalSpace(height: 16),
                RatingEvaluationWidget(
                  rating: state.response.provider?.rating ?? 0,
                  totalEvaluation: state.response.provider?.ratingsCount ?? 0.0,
                ),
                const CustomVerticalSpace(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InfoWithIcon(
                        icon: IconPath.providerDetailsLocation,
                        info: state.response.provider?.mainBranchAddress ?? "",
                        btnPressed: () {
                          CommonFunctions.launchMap(state
                              .response.provider?.mainBranchLocation
                              ?.getLatLng());
                        },
                      ),
                    ),
                    if (state.response.provider?.branches != null &&
                        (state.response.provider?.branches?.length ?? 0) > 0)
                      CustomTextButtonWidget(
                        btnText: trans('view_branches'),
                        btnPressed: () {
                          NavigationService.pushNamed(
                              routeName: EtmamRoutesNames.branchesMapPage,
                              args: state.response.provider?.branches);
                        },
                        alignment: AlignmentDirectional.centerEnd,
                      ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InfoWithIcon(
                        icon: IconPath.providerDetailsPhone,
                        info: state.response.provider?.mainBranchContact ?? "",
                        btnPressed: () {
                          String? mobile =
                              state.response.provider?.mainBranchContact ?? "";
                          CommonFunctions.call(mobile);
                        },
                      ),
                    ),
                    CustomTextButtonWidget(
                      btnText: trans('view_info'),
                      btnPressed: () {
                        if (state.response.provider != null) {
                          NavigationService.pushNamed(
                              routeName: EtmamRoutesNames.officeInfoPage,
                              args: state.response.provider!);
                          // showDialogWidget(context,
                          //     headerText: trans('office_info'),
                          //     isFullHeight: true,
                          //     dialogBody: ShowOfficeInfoDialog(
                          //       provider: state.response.provider!,
                          //     ));
                        }
                      },
                      alignment: AlignmentDirectional.centerEnd,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}*/
class ServiceProviderMainInfo extends StatelessWidget {
  const ServiceProviderMainInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SubTitleAndDescWidget(
                        subTitle: trans('main_branch'),
                        desc: state.response.provider?.mainBranchAddress,
                        descPressedAction: () {
                          CommonFunctions.launchMap(state
                              .response.provider?.mainBranchLocation
                              ?.getLatLng());
                        }),
                  ),
                  if (state.response.provider?.branches != null &&
                      (state.response.provider?.branches?.length ?? 0) > 0)
                    CustomTextButtonWidget(
                        btnText: trans('view_branches'),
                        btnPressed: () {
                          NavigationService.pushNamed(
                              routeName: EtmamRoutesNames.branchesMapPage,
                              args: state.response.provider?.branches);
                        },
                        alignment: AlignmentDirectional.centerEnd,
                        haveUnderline: true,
                        btnTextSize: 13,
                        btnTextColor: AppColor.baladyDarkGreen2,
                        btnTextWeight: AppFontWeight.bold),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: SubTitleAndDescWidget(
                      subTitle: trans('lbl_more_contactInfo'),
                      subTitleIcon: IconPath.phoneIcon,
                      desc: state.response.provider?.mainBranchContact,
                      descPressedAction: () {
                        String? mobile =
                            state.response.provider?.mainBranchContact ?? "";
                        CommonFunctions.call(mobile);
                      },
                    ),
                  ),
                  CustomTextButtonWidget(
                      btnText: trans('view_info'),
                      btnPressed: () {
                        if (state.response.provider != null) {
                          NavigationService.pushNamed(
                              routeName: EtmamRoutesNames.officeInfoPage,
                              args: state.response.provider!);
                        }
                      },
                      alignment: AlignmentDirectional.centerEnd,
                      haveUnderline: true,
                      btnTextSize: 13,
                      btnTextColor: AppColor.baladyDarkGreen2,
                      btnTextWeight: AppFontWeight.bold),
                ],
              ),
              SubTitleAndWidget(
                  subTitle: trans('evaluate_office'),
                  verticalSpace: 10,
                  subTitleIcon: IconPath.subTitleStarIcon,
                  widget: EtmamRatingEvaluationWidget(
                    rating: state.response.service?.rating ?? 0,
                    totalEvaluation: state.response.service?.ratingsCount,
                    withIcon: false,
                  )),
            ],
          ),
        );
      },
    );
  }
}

class InfoWithIcon extends StatelessWidget {
  final String icon;
  final String info;
  final VoidCallback? btnPressed;

  const InfoWithIcon(
      {Key? key,
      required this.icon,
      required this.info,
      required this.btnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomIconButtonWidget(
        padding: EdgeInsets.zero,
        btnPressed: btnPressed,
        icon: Row(
          children: [
            CustomSvgIconWidget(icon),
            Flexible(
              child: CustomTextWidget(
                info,
                fontColor: AppColor.hunterGreen,
                fontWeight: AppFontWeight.w600,
                fontSize: 14,
                textAlign: TextAlign.start,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon == IconPath.providerDetailsLocation) ...[
              const CustomHorizontalSpace(width: 4),
              CustomTextWidget(
                trans('main_branch'),
                fontColor: AppColor.bottomNavigationShadow,
                fontWeight: AppFontWeight.regular,
                fontSize: 14,
                textAlign: TextAlign.start,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ));
  }
}
