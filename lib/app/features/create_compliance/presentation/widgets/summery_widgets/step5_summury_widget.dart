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

class Step5SummeryWidget extends StatelessWidget {
  const Step5SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("compliance_clauses_title").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: state.requestDetails?.emtithalItems?.length ?? 0,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    FieldData(
                        title: state.requestDetails?.emtithalItems?[index]
                                .itemDesc ??
                            "",
                        subTitle: state.requestDetails?.emtithalItems?[index]
                                    .submitterAnswer ==
                                true
                            ? "compliance".tr()
                            : state.requestDetails?.emtithalItems?[index]
                                        .submitterAnswer ==
                                    false
                                ? "nonـcompliance".tr()
                                : ""),
                    CustomVerticalSpace(height: 8),
                  ],
                );
              },
            )
          ],
        );
      },
    );
  }
}
