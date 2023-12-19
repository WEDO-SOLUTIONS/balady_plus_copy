import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/features/providers/presentation/blocs/provider_details_bloc/provider_details_bloc.dart';
import 'package:balady_plus/etmam_app/features/providers/presentation/widgets/provider_details/provider_content.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show InfoCard, InfoWithIcon, PreviousWorks, ServiceFaqSection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_config.dart';
import '../../../../../core/utils/constants/icon_path.dart';
import '../../../../../core/utils/enums/app_font_weight.dart';
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomTextWidget,
        CustomVerticalSpace,
        EtmamRatingEvaluationWidget,
        RatingEvaluationWidget,
        SectionTitleWidget,
        SubTitleAndDescWidget,
        SubTitleAndWidget,
        WorkingDayListWidget;

class ProviderMainInfo extends StatelessWidget {
  const ProviderMainInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderDetailsBloc, ProviderDetailsState>(
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
                  state.args.name ?? "",
                  fontColor: AppColor.blackModern800Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 18,
                  textAlign: TextAlign.start,
                ),
                const CustomVerticalSpace(height: 16),
                RatingEvaluationWidget(
                  rating: state.args.rating,
                  totalEvaluation: state.args.ratingsCount,
                ),
                const CustomVerticalSpace(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InfoWithIcon(
                        icon: IconPath.providerDetailsLocation,
                        info: state.args.mainBranchAddress ?? "",
                        btnPressed: () {
                          CommonFunctions.launchMap(
                              state.args.mainBranchLocation?.getLatLng());
                        },
                      ),
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
}

class EtmamProviderMainInfo extends StatelessWidget {
  const EtmamProviderMainInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderDetailsBloc, ProviderDetailsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            CustomTextWidget(
              'work_details'.tr(),
              fontColor: AppColor.blackModern800Light,
              fontWeight: AppFontWeight.bold,
              fontSize: 16,
              textAlign: TextAlign.start,
            ),
            const CustomVerticalSpace(height: 16),
            WorkingDayListWidget(
              workingHours: state.args.wrokDays,
            ),
            const CustomVerticalSpace(height: 8),
            InfoCard(
              iconPath: IconPath.locationSectionIcon,
              title: trans('main_branch'),
              value: state.args.mainBranchAddress ?? "",
            ),
            // ProviderDetailsContentContainer(
            //   title: 'الفرع الرئيسي',
            //   content: CustomTextWidget(state.args.mainBranchAddress ?? "",
            //       fontSize: 13,
            //       fontWeight: AppFontWeight.bold,
            //       fontColor: AppColor.blackModern500Light),
            //   icon: IconPath.locationSectionIcon,
            // ),
            // ProviderDetailsContentContainer(
            //   title: 'ساعات العمل',
            //   content: WorkingDayListWidget(
            //     workingHours: state.args.wrokDays,
            //   ),
            // ),
            InfoCard(
              onTap: () => CommonFunctions.launch(state.args.website ?? ""),
              iconPath: IconPath.websiteIcon,
              title: trans("website"),
              value: state.args.website ?? "",
            ),
            InfoCard(
              onTap: () => CommonFunctions.launch(state.args.website ?? ""),
              iconPath: IconPath.websiteIcon,
              title: trans("emailFieldLabel"),
              value: state.args.email ?? "",
            ),
            InfoCard(
              onTap: () => CommonFunctions.call(state.args.mainBranchContact),
              iconPath: IconPath.call,
              title: trans('office_mobile'),
              value: state.args.mainBranchContact,
              leading: Row(
                children: [
                  const CustomSvgIconWidget(IconPath.call),
                  const SizedBox(width: 4),
                  CustomTextWidget(
                    trans("call"),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary900Light,
                    ),
                  )
                ],
              ),
            ),
            InfoCard(
              iconPath: IconPath.medalStar,
              title: trans('evaluate_office'),
              value: "${state.args.rating} (${state.args.ratingsCount})",
            ),
          ],
        );
      },
    );
  }
}
