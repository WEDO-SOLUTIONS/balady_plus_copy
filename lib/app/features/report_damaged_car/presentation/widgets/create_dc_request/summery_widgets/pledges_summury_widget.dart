import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';
import '../details_widgets/location_photo_section.dart';

class PledgesSummuryWidget extends StatelessWidget {
  const PledgesSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("vd_pledges").tr(),
          isExpanded: true,
          underline: false,
          leading: SvgPicture.asset(IconPath.vdSummuryPledge),
          children: [
            CustomTextWidget(
              ("consent_body").tr(),
              fontColor: AppColor.blackModern700Light,
              maxLines: 90,
              height: 1.3,
              textAlign: TextAlign.start,
            ),
            CustomVerticalSpace(height: 8),
            Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Color(0x80E6EFEF),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Checkbox(
                      value: state.agreement ?? false,
                      activeColor: AppColor.primary900Light,
                      onChanged: (newVal) {
                        context
                            .read<CreateDCBloc>()
                            .add(ChangeAgreementEvent(isagree: newVal));
                      },
                    ),
                    Flexible(
                      child: CustomTextWidget(
                        ("vd_consent_check").tr(),
                        fontColor: AppColor.primary700Light,
                        fontSize: 12,
                        maxLines: 10,
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                  ],
                ))
          ],
        );
      },
    );
  }
}
