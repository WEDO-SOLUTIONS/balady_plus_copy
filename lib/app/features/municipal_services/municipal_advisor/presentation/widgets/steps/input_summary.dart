import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../municipal_advisor_exports.dart'
    show MunicipalAdvisorBloc, MunicipalAdvisorState;

class InputSummary extends StatelessWidget {
  const InputSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "${"location".tr()}: ",
                style: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary900Light,
                ),
              ),
              TextSpan(
                text:
                    ' ${state.activityLocation?.gisResponse.getFullAddress()} \n\n',
                style: AppStyle.textFieldTitleTextStyle,
              ),
              TextSpan(
                text: "${'isicActivity'.tr()}: ",
                style: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary900Light,
                ),
              ),
              TextSpan(
                text: '${state.selectedIsicActivity?.name} \n\n',
                style: AppStyle.textFieldTitleTextStyle,
              ),
              TextSpan(
                text: "${'subActivity'.tr()}: ",
                style: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary900Light,
                ),
              ),
              TextSpan(
                text: ' ${state.selectedIsicSubActivity?.name}\n\n',
                style: AppStyle.textFieldTitleTextStyle,
              ),
              TextSpan(
                text: "${'facilityType'.tr()}: ",
                style: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary900Light,
                ),
              ),
              TextSpan(
                text: ' ${state.activityDetails!.facilityName}\n\n',
                style: AppStyle.textFieldTitleTextStyle,
              ),
              TextSpan(
                text: "${'facilityArea'.tr()}: ",
                style: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary900Light,
                ),
              ),
              TextSpan(
                text:
                    ' ${state.selectedArea?.toStringAsFixed(0)} ${'m2'.tr()}\n',
                style: AppStyle.textFieldTitleTextStyle,
              ),
            ],
          ),
          textAlign: TextAlign.right,
        );
      },
    );
  }
}
