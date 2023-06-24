import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../blocs/create_vd_details_bloc/create_vd_bloc.dart';

class UserDataSummuryWidget extends StatelessWidget {
  const UserDataSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("vd_user_info").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryUserInfo),
          children: [
            FieldData(
              title: ("vd_full_name").tr(),
              subTitle: fullName ?? "${state.firstName} ${state.lastName}",
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("vd_mobile_number").tr(),
              subTitle: mobileNumber ?? state.mobileNumber ?? "",
            ),
          ],
        );
      },
    );
  }

  String? get fullName => CommonProperties.userInfo?.getFirstAndLastName();
  String? get mobileNumber => CommonProperties.userInfo?.getPhone();
}
