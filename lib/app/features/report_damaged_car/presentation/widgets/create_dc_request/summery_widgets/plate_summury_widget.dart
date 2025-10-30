import 'package:balady_plus/app/core/utils/utils_exports.dart';
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

class PlateSummuryWidget extends StatelessWidget {
  const PlateSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("dc_vc_plate_details").tr(),
          leading: SvgPicture.asset(IconPath.vdSummurySPL),
          children: [
            FieldData(
              title: ("dc_vc_plate_letters").tr(),
              subTitle:
                  CommonFunctions.isAppAR ? state.arLetters : state.enLetters,
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("dc_vc_plate_number").tr(),
              subTitle: state.plateDigit ?? "",
            ),
            CustomVerticalSpace(height: 8),
            FieldData(
              title: ("dc_vc_chassie").tr(),
              subTitle: state.chassisNumber ?? "",
            ),
          ],
        );
      },
    );
  }
}
