import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../municipal_advisor_exports.dart';

class PermitsCost extends StatelessWidget {
  const PermitsCost({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        final permits = state.licenseFees?.permits
                .where(
                  (element) => element.actionTypeId != 1004,
                )
                .toList() ??
            [];

        return SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                '2.${'permits'.tr()}',
                textStyle: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary800Light,
                ),
              ),
              const SizedBox(height: 8),
              for (final permit in permits)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      '${permit.actionTypeName}:',
                      textStyle: AppStyle.costTitleTextStyle,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          '${'municipalAdvisorPermitFees'.tr()}:',
                          textStyle: AppStyle.lightTitleTextStyle,
                        ),
                        CustomTextWidget(
                          '${state.permitHours(permit)} ${'sar'.tr()}',
                          textStyle: AppStyle.lightTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          '${'municipalAdvisorTotalPermitFees'.tr()}:',
                          textStyle: AppStyle.lightTitleTextStyle,
                        ),
                        CustomTextWidget(
                          '${permit.calculatedFees.totalCost} ${'sar'.tr()}',
                          textStyle: AppStyle.lightTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final costsInfo
                        in permit.calculatedFees.costsInfo) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            '${costsInfo.costItemDescription}:',
                            textStyle: AppStyle.lightTitleTextStyle,
                          ),
                          CustomTextWidget(
                            '${costsInfo.costItemValue.toStringAsFixed(2)} ${'sar'.tr()}',
                            textStyle: AppStyle.lightTextStyle,
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              const SizedBox(height: 8),
              CustomTextWidget(
                'lbl_total_price'.tr(),
                textStyle: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary800Light,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextWidget(
                '${state.licenseFees?.permissionTotalFees.toStringAsFixed(2)} ${'sar'.tr()}',
                textStyle: AppStyle.lightTextStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}
