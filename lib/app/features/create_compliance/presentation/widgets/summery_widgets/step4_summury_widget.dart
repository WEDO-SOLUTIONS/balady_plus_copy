import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../bloc/compliance_bloc.dart';
import '../../bloc/compliance_state.dart';
import 'field_data.dart';

class Step4SummeryWidget extends StatelessWidget {
  const Step4SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("compliance_usages").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
          children: [
            FieldData(
                title: ("compliance_main_usage").tr(),
                subTitle: state.selectedMainUsage?.name),
            CustomVerticalSpace(height: 8),
            FieldData(
                title: ("compliance_sub_usage").tr(),
                subTitle: state.selectedSubUsage?.name),
          ],
        );
      },
    );
  }
}
