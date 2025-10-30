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

class Step2_2SummeryWidget extends StatelessWidget {
  const Step2_2SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("owner_data").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
          children: [
            FieldData(
              title: ("owner_name").tr(),
              subTitle: state.requestDetails?.ownerDto?.ownerName,
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
                title: ("owner_national_id").tr(),
                subTitle: state.requestDetails?.ownerDto?.identityNumber),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("owner_national_type").tr(),
              subTitle: state.requestDetails?.ownerDto?.identityTypeDec ?? "",
            ),
          ],
        );
      },
    );
  }

  String? get fullName => CommonProperties.userInfo?.getFullName();
  String? get mobileNumber => CommonProperties.userInfo?.getPhone();
}
