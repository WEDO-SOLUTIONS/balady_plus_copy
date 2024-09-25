import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';

class PledgesSummuryWidget extends StatelessWidget {
  const PledgesSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("vd_pledges").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryPledge),
          isExpanded: true,
          children: [
            CustomTextWidget(
              ("agreement_text_akram").tr().replaceAll(
                  "{}", CommonProperties.userInfo?.getFullName() ?? ""),
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
                            .read<EkramBookCemetryBloc>()
                            .add(ChangeAgreementEvent(isagree: newVal));
                      },
                    ),
                    CustomTextWidget(
                      ("vd_consent_check").tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 12,
                      fontWeight: AppFontWeight.semiBold,
                      height: 1.3,
                    ),
                  ],
                ))
          ],
        );
      },
    );
  }
}
