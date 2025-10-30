import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../../vd/presentation/blocs/create_vd_details_bloc/create_vd_bloc.dart';
import '../../../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';

class CarSummuryWidget extends StatelessWidget {
  const CarSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("dc_vc_details").tr(),
          leading: SvgPicture.asset(IconPath.vdSummurySPL),
          children: [
            FieldData(
              title: ("dc_report_type").tr(),
              subTitle: state.reportType?.name,
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("dc_vc_type").tr(),
              subTitle: state.selectedCarType?.brandName,
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("dc_vc_model").tr(),
              subTitle: state.selectedCarModel?.carName,
            ),
          ],
        );
      },
    );
  }
}
