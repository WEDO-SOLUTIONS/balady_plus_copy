import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/features/providers/presentation/blocs/provider_details_bloc/provider_details_bloc.dart';
import 'package:balady_plus/etmam_app/features/providers/presentation/widgets/provider_details/provider_content.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show InfoWithIcon;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            const CustomTextWidget(
              'تفاصيل العمل والتواصل',
              fontColor: AppColor.blackModern800Light,
              fontWeight: AppFontWeight.w600,
              fontSize: 16,
              textAlign: TextAlign.start,
            ),
            const CustomVerticalSpace(height: 16),
            ProviderDetailsContentContainer(
              title: 'الفرع الرئيسي',
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
              title: 'الموقع الإلكتروني',
              content: CustomTextWidget(state.args.website ?? "",
                  fontSize: 13,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.blackModern500Light),
              icon: IconPath.websiteIcon,
            ),
            ProviderDetailsContentContainer(
              title: 'رقم التواصل',
              content: CustomTextWidget(state.args.mainBranchContact ?? "",
                  fontSize: 13,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.blackModern500Light),
              icon: IconPath.phoneIcon,
            ),
          ],
        );
      },
    );
  }
}
