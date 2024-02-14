import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/previous_next_buttons.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/features/otp/domain/entities/otp_page_params.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../mobile_number_field.dart';

class SecondSubmissonCompliance extends StatelessWidget {
  const SecondSubmissonCompliance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ComplianceSubmitTitle(
              title: 'user_info_details_title'.tr(),
              subtitle: "",
            ),
            const SizedBox(
              height: 7,
            ),
            CustomTextFieldWidget(
              fillColor: AppColor.scaffoldBackground,
              label: 'user_name_label'.tr(),
              labelStyle: AppStyle.complianceLabelStyle,
              hintText: CommonProperties.userInfo?.getFullName() ?? "",
              hintStyle: AppStyle.complianceSubtitleStyle,
              borderRadius: 6,
              borderColor: const Color(0xffD4D4D8),
            ),
            const SizedBox(
              height: 24,
            ),
            MobileNumberField(),
            SizedBox(
              height: 32,
            ),
            PreviousNextButtons()
          ],
        ),
      ),
    );
  }
}
