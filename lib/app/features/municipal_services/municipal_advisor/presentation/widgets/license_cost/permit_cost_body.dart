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
        return Column(
          children: [
            ListView.builder(
              itemCount: state.licensePermits?.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 8),
              itemBuilder: (context, index) {
                return PermitCheckBox(
                  permit: state.licensePermits![index],
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
            if (state.licenseFees?.permits.isNotEmpty ?? false) ...[
              const Divider(
                thickness: 1,
              ),
              ListView.builder(
                itemCount: state.licenseFees?.permits.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TitleCostWidet(
                      title: state.licenseFees?.permits[index].actionTypeName ??
                          "",
                      cost: state.licenseFees?.permits[index].calculatedFees
                              .totalCost ??
                          0,
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 8),
            ElevatedButtonWidget.finishButton(
              onPressed: () {
                BlocProvider.of<MunicipalAdvisorBloc>(context).add(
                  MunicipalAdvisorEndCalculateLicenseEvent(),
                );
              },
            )
          ],
        );
      },
    );
  }
}
