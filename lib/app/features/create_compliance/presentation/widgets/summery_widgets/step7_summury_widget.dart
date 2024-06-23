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
import '../compliance_submission/fifth_submit_step.dart';
import 'field_data.dart';

class Step7SummeryWidget extends StatelessWidget {
  const Step7SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return state.requestDetails?.requestNote != null &&
                state.requestDetails?.statusId == 12
            ? CustomExpansionPanelWidget(
                title: ("notes").tr(),
                leading: SvgPicture.asset(IconPath.vdSummuryPhoto),
                children: [
                  FieldData(
                    title: state.requestDetails?.statusId == 12
                        ? "rejection_reason".tr()
                        : "",
                    subTitle: state.requestDetails?.requestNote,
                  )
                ],
              )
            : const SizedBox();
      },
    );
  }
}
