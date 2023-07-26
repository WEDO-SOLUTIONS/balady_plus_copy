import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../municipal_advisor_exports.dart';

class AttachmentRequired extends StatelessWidget {
  final AttachmentEntity attachment;

  const AttachmentRequired({
    super.key,
    required this.attachment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextWidget(
                "${'municipalAdvisorAttachmentsRequired'.tr()}:",
                textStyle: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary800Light,
                ),
              ),
            ),
            CustomTextWidget(
              attachment.name,
              textStyle: AppStyle.textFieldTitleTextStyle,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CustomTextWidget(
                "${'municipalAdvisorAttachmentsStatus'.tr()}:",
                textStyle: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: AppColor.primary800Light,
                ),
              ),
            ),
            CustomTextWidget(
              attachment.mandatory ? 'Required'.tr() : 'Optional'.tr(),
              textStyle: AppStyle.textFieldTitleTextStyle,
            ),
          ],
        ),
      ],
    );
  }
}
