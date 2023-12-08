import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../damaged_cars_exports.dart';
import '../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';
import '../details_widgets/location_photo_section.dart';

class LocationSummuryWidget extends StatelessWidget {
  const LocationSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("bd_confirm_location").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryPhoto),
          children: [
            Center(
              child: IncidentPhotoWidget(
                image: state.getImagePath() ?? "",
              ),
            ),
            LocationSection(showOnly: true),
          ],
        );
      },
    );
  }
}
