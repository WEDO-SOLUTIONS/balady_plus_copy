import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/features/providers/presentation/blocs/provider_details_bloc/provider_details_bloc.dart';
import 'package:balady_plus/etmam_app/features/providers/presentation/widgets/provider_details/provider_content.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show InfoWithIcon;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../app/core/utils/constants/app_colors.dart';
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
            const SizedBox(height: 28),
            CustomTextWidget(
              'work_details'.tr(),
              fontColor: AppColor.blackModern800Light,
              fontWeight: AppFontWeight.w600,
              fontSize: 16,
              textAlign: TextAlign.start,
            ),
            const CustomVerticalSpace(height: 16),
            ProviderDetailsContentContainer(
              title: 'main_branch'.tr(),
              content: CustomTextWidget(state.args.mainBranchAddress ?? "",
                  fontSize: 13,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.blackModern500Light),
              icon: IconPath.locationSectionIcon,
            ),
            // ProviderDetailsContentContainer(
            //   title: 'ساعات العمل',
            //   content: WorkingDayListWidget(
            //     workingHours: state.args.wrokDays,
            //   ),
            // ),
            WorkingDayListWidget(
              workingHours: state.args.wrokDays,
            ),
            ProviderDetailsContentContainer(
              title: 'office_website'.tr(),
              content: CustomTextWidget(state.args.website ?? "",
                  fontSize: 13,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.blackModern500Light),
              icon: IconPath.websiteIcon,
            ),
            ProviderDetailsContentContainer(
              title: 'office_mobile'.tr(),
              content: Row(
                children: [
                  Expanded(
                    child: CustomTextWidget(state.args.mainBranchContact ?? "",
                        fontSize: 13,
                        fontWeight: AppFontWeight.bold,
                        fontColor: AppColor.blackModern500Light),
                  ),
                  Row(
                    children: [
                      const CustomSvgIconWidget(IconPath.phoneIcon),
                      const SizedBox(width: 2),
                      GestureDetector(
                        onTap: () {
                          launch("tel://${state.args.mainBranchContact}");
                        },
                        child: const CustomTextWidget(
                          "اتصال",
                          fontSize: 12,
                          textStyle: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary900Light),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              icon: IconPath.phoneIcon,
            ),
          ],
        );
      },
    );
  }
}
