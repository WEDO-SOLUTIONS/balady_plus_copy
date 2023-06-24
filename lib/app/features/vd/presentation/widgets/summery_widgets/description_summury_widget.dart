import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../blocs/create_vd_details_bloc/create_vd_bloc.dart';
import '../details_widgets/location_photo_section.dart';
import '../details_widgets/spl_widgets/incident_photo_widget.dart';

class DescriptionSummuryWidget extends StatelessWidget {
  const DescriptionSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("vd_summury_desc").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
          children: [
            CustomTextWidget(
              state.issueDesc ?? "",
              fontColor: AppColor.blackModern700Light,
              maxLines: 90,
              textAlign: TextAlign.start,
            )
          ],
        );
      },
    );
  }
}
