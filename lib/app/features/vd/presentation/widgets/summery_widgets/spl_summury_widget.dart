import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../blocs/create_vd_details_bloc/create_vd_bloc.dart';
import 'field_data.dart';

class SPLSummuryWidget extends StatelessWidget {
  const SPLSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("vd_summery_spl").tr(),
          leading: SvgPicture.asset(IconPath.vdSummurySPL),
          children: [
            FieldData(
              title: state.splItems?[state.selectedSPLIndex ?? 0].name ?? "",
            ),
          ],
        );
      },
    );
  }
}
