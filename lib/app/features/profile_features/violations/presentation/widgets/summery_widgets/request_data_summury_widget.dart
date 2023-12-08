import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/profile_features/violations/presentation/create_objection_bloc/create_objection_bloc.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/shared_feature_exports.dart';

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
              subTitle: state.details?.objectionTypeName,
            ),
            const CustomVerticalSpace(height: 8),
            // FieldData(
            //   title: ("objection_service_group").tr(),
            //   subTitle: state.details?.serviceGroupName,
            // ),
            // const CustomVerticalSpace(height: 8),
            // FieldData(
            //   title: ("objection_service").tr(),
            //   subTitle: state.details?.serviceName,
            // ),
            const CustomVerticalSpace(height: 8),
            FieldData(
              title: ("objection_municipality").tr(),
              subTitle: state.details?.municipalityName,
            ),
            const CustomVerticalSpace(height: 8),
            FieldData(
              title: ("objection_sub_municipality").tr(),
              subTitle: state.details?.subMunicipalityName,
            ),
          ],
        );
      },
    );
  }
}
