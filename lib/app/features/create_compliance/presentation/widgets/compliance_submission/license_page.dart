import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/license_item_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/radio_custom.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class ComplianceLicensePage extends StatelessWidget {
  const ComplianceLicensePage({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ComplianceSubmitTitle(
              title: 'submission_document'.tr(),
              subtitle: 'submission_document_subtitle'.tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextWidget(
              'choose_document'.tr(),
              textStyle: AppStyle.complianceDocumentTitleStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: 321,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColor.primary100Light,
              ),
              child: CustomTextWidget(
                'document_message'.tr(),
                maxLines: 3,
                textAlign: TextAlign.right,
                textStyle: AppStyle.comlianceDocumentMessageStyle,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            CustomTextWidget(
              'document_dropdown_title'.tr(),
              textStyle: AppStyle.complianceDocumentTitleStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButtonWidget.next(
              onPressed: onPressed,
            )
          ],
        ),
      ),
    );
  }
}
