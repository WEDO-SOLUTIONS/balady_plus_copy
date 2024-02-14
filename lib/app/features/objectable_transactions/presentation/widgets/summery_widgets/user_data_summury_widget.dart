import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/objectable_transactions/presentation/create_objection_bloc/create_objection_bloc.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';

class UserDataSummuryWidget extends StatelessWidget {
  const UserDataSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateObjectionBloc, CreateObjectionState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("user_data_applicant").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
          children: [
            FieldData(
              title: ("user_data_applicant_id").tr(),
              subTitle: CommonProperties.userInfo?.idNo,
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("user_data_applicant_type").tr(),
              subTitle: CommonProperties.userInfo?.getIdTypeName(),
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("user_data_applicant_name").tr(),
              subTitle: CommonProperties.userInfo?.getFullName(),
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("user_data_applicant_role").tr(),
              subTitle: CommonProperties.selectedDelegator != null
                  ? CommonProperties.selectedDelegator?.roleName
                  : "himself".tr(),
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("user_data_applicant_mobile").tr(),
              subTitle: CommonProperties.userInfo?.getPhone(),
            ),
          ],
        );
      },
    );
  }
}
