import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart';

class PermitCostBody extends StatelessWidget {
  const PermitCostBody({super.key});

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
        return Column(
          children: [
            ListView.builder(
              itemCount: state.licensePermits.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 8),
              itemBuilder: (context, index) {
                return PermitCheckBox(
                  permit: state.licensePermits[index],
                );
              },
            ),
            if (state.selectedPermits.isEmpty)
              Row(
                children: [
                  const Icon(
                    Icons.info,
                    color: AppColor.primary700Light,
                  ),
                  CustomTextWidget(
                    "municipalAdvisorNoPermitSelected".tr(),
                    textStyle: AppStyle.textFieldTitleTextStyle,
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            if (permits.isNotEmpty) ...[
              const Divider(
                thickness: 1,
              ),
              ListView.builder(
                itemCount: permits.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TitleCostWidet(
                      title: permits[index].actionTypeName,
                      cost: permits[index].calculatedFees.totalCost,
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 8),
            ElevatedButtonWidget.finishButton(
              onPressed: state.licenseCostFinishEnabled
                  ? () {
                      BlocProvider.of<MunicipalAdvisorBloc>(context).add(
                        MunicipalAdvisorSaveFinancialStudyEvent(),
                      );
                    }
                  : null,
            )
          ],
        );
      },
    );
  }
}
