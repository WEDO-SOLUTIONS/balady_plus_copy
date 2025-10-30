import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../municipal_advisor_exports.dart';

class TradeLicenseCost extends StatelessWidget {
  const TradeLicenseCost({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        final licenseFees = state.licenseFees?.permits.firstWhere(
          (element) => element.actionTypeId == 1004,
        );
        if (licenseFees == null) return Container();

        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '1.${'issue_trade_license'.tr()}\n\n',
                style: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary800Light,
                ),
              ),
              for (final costsInfo in licenseFees.calculatedFees.costsInfo) ...[
                TextSpan(
                  text: '${costsInfo.costItemDescription}:\n',
                  style: AppStyle.lightTitleTextStyle,
                ),
                TextSpan(
                  text:
                      '${costsInfo.costItemValue.toStringAsFixed(2)} ${'sar'.tr()}\n\n',
                  style: AppStyle.lightTextStyle,
                ),
              ],
              TextSpan(
                text: '${'lbl_total_price'.tr()}\n',
                style: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary800Light,
                ),
              ),
              TextSpan(
                text:
                    '${licenseFees.calculatedFees.totalCost.toStringAsFixed(2)} ${'sar'.tr()}',
                style: AppStyle.lightTextStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}
