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

class Step2SummeryWidget extends StatelessWidget {
  const Step2SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("user_data_applicant").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
          children: [
            FieldData(
              title: ("vd_full_name").tr(),
              subTitle:  state.requestDetails?.submitterDto?.submitterName,
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
                title: ("user_data_applicant_id").tr(),
                subTitle:
                    state.requestDetails?.submitterDto?.submitterIdNumber),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("user_data_applicant_type").tr(),
              subTitle:
                  state.requestDetails?.submitterDto?.submitterIdentityTypeName,
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("vd_mobile_number").tr(),
              subTitle: state.requestDetails?.submitterDto?.mobile ?? "",
            ),
          ],
        );
      },
    );
  }

  String? get fullName => CommonProperties.userInfo?.getFullName();
  String? get mobileNumber => CommonProperties.userInfo?.getPhone();
}
