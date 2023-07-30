import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/features/providers/presentation/blocs/provider_details_bloc/provider_details_bloc.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show InfoWithIcon;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath, PrimaryIcons, trans;
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomTextWidget,
        CustomVerticalSpace,
        EtmamRatingEvaluationWidget,
        RatingEvaluationWidget,
        SectionTitleWidget,
        SubTitleAndDescWidget,
        SubTitleAndWidget;

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
                  fontColor: AppColor.hunterGreen,
                  fontWeight: AppFontWeight.w600,
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
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitleWidget(
                title: trans('office_info'),
                primaryIcon: PrimaryIcons.providerOfficeIcon,
              ),
              const CustomVerticalSpace(height: 16),
              SubTitleAndDescWidget(
                  subTitle: trans('main_branch'),
                  desc: state.args.mainBranchAddress ?? "",
                  descPressedAction: () {
                    CommonFunctions.launchMap(
                        state.args.mainBranchLocation?.getLatLng());
                  }),

              SubTitleAndWidget(
                  subTitle: trans('evaluate_office'),
                  verticalSpace: 10,
                  subTitleIcon: IconPath.subTitleStarIcon,
                  widget: EtmamRatingEvaluationWidget(
                    rating: state.args.rating,
                    totalEvaluation: state.args.ratingsCount,
                    withIcon: false,
                  )),
              // const CustomVerticalSpace(height: 16),
            ],
          ),
        );
      },
    );
  }
}
