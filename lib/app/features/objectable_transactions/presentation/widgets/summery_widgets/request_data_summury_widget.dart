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

class RequestDataSummuryWidget extends StatelessWidget {
  const RequestDataSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateObjectionBloc, CreateObjectionState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("objection_main_request_data").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
          children: [
            FieldData(
              title: ("objection_complain").tr(),
              subTitle: state.getObjectionTypeName,
            ),
            const CustomVerticalSpace(height: 8),
            FieldData(
              title: ("objection_service_group").tr(),
              subTitle: state.getServiceGroupName,
            ),
            const CustomVerticalSpace(height: 8),
            FieldData(
              title: ("objection_service").tr(),
              subTitle: state.getServiceName,
            ),
            const CustomVerticalSpace(height: 8),
            FieldData(
              title: ("objection_municipality").tr(),
              subTitle: state.getMunicipalityName,
            ),
            const CustomVerticalSpace(height: 8),
            FieldData(
              title: ("objection_sub_municipality").tr(),
              subTitle: state.getSubMunicipalityName,
            ),
          ],
        );
      },
    );
  }
}
