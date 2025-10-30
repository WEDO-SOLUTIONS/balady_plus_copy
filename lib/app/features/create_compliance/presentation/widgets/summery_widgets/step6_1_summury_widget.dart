import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../bloc/compliance_bloc.dart';
import '../../bloc/compliance_state.dart';
import '../compliance_submission/fifth_submit_step.dart';
import '../compliance_submission/sixth_submit_step.dart';
import 'field_data.dart';

class Step6_1SummeryWidget extends StatelessWidget {
  const Step6_1SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: state.showDetails == true
              ? ("notes_on_the_requests").tr()
              : "notes".tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
          children: [
            if (state.showDetails != true)
              CustomTextWidget(
                state.applicantNotes ?? "",
                fontColor: AppColor.blackModern600Light,
                fontWeight: AppFontWeight.medium,
                fontSize: 12,
              ),
            if (state.showDetails == true)
              Container(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: state.requestDetails?.applicantNotes?.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return NoteItemWidget(
                          item: state.requestDetails!.applicantNotes![index]!);
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
