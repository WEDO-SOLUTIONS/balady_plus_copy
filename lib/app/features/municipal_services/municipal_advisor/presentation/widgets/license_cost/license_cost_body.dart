import 'package:balady_plus/app/features/municipal_services/municipal_advisor/municipal_advisor_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';

class LicenseCostBody extends StatelessWidget {
  const LicenseCostBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        CustomTextWidget(
          'FillFields'.tr(),
          textStyle: AppStyle.subMessageTextStle,
        ),
        const LicenseYearsSelector(),
        const AreaSelector(partOfLicenseCost: true),
        const CleaningSelector(),
        const BoardSelector(),
        const Divider(
          thickness: 1,
        ),
        BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          builder: (context, state) {
            final licenseFees = state.licenseFees?.permits.firstWhere(
              (element) => element.actionTypeId == 1004,
            );
            return TitleCostWidet(
              title: "LicenseCost".tr(),
              cost: licenseFees?.calculatedFees.totalCost ?? 0,
            );
          },
        ),
      ],
    );
  }
}
