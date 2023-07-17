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
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '2.${'permits'.tr()}\n\n',
                  style: AppStyle.textFieldTitleTextStyle.copyWith(
                    color: AppColor.primary800Light,
                  ),
                ),
                for (final permit in permits) ...[
                  TextSpan(
                    text: '${permit.actionTypeName}:\n\n',
                    style: AppStyle.costTitleTextStyle,
                  ),
                  for (final costsInfo in permit.calculatedFees.costsInfo) ...[
                    TextSpan(
                      text: '${costsInfo.costItemDescription}:',
                      style: AppStyle.lightTitleTextStyle,
                    ),
                    const WidgetSpan(
                      child: SizedBox(width: 8),
                    ),
                    TextSpan(
                      text:
                          '${costsInfo.costItemValue.toStringAsFixed(2)} ${'sar'.tr()}\n\n',
                      style: AppStyle.lightTextStyle,
                    ),
                  ],
                ],
                TextSpan(
                  text: '${'lbl_total_price'.tr()}\n',
                  style: AppStyle.textFieldTitleTextStyle.copyWith(
                    color: AppColor.primary800Light,
                  ),
                ),
                TextSpan(
                  text:
                      '${state.licenseFees?.permissionTotalFees.toStringAsFixed(2)} ${'sar'.tr()}',
                  style: AppStyle.lightTextStyle,
                ),
              ],
            ),
            textAlign: TextAlign.right,
          ),
        );
      },
    );
  }
}
