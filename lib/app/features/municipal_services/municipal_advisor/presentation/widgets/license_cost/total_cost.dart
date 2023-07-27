import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart';

class TotalCost extends StatelessWidget {
  const TotalCost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          'municipalAdvisorTotalFees'.tr(),
          textStyle: AppStyle.textFieldTitleTextStyle,
        ),
        const SizedBox(height: 10),
        BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          builder: (context, state) {
            return CustomTextWidget(
              '${state.licenseFees?.totalFees.toStringAsFixed(2)} ${'sar'.tr()}',
              textStyle: AppStyle.lightTextStyle,
            );
          },
        ),
      ],
    );
  }
}
