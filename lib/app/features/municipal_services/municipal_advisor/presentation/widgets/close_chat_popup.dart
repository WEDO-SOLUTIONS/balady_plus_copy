import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

class CloseChatPopup extends StatelessWidget {
  const CloseChatPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DrawIconBasedTypeWidget(
              icon: IconPath.chat,
              iconColor: AppColor.primary900Light,
              iconSize: 82,
            ),
            const SizedBox(height: 16),
            CustomTextWidget(
              "municipalAdvisorEndChatConfirmation".tr(),
              textStyle: AppStyle.cardTitleTextStle,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextWidget(
                "municipalAdvisorEndChatConfirmationHint".tr(),
                textAlign: TextAlign.center,
                textStyle: AppStyle.serviceListTitleTextStyle.copyWith(
                  height: 1.5,
                ),
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.endChat(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            const SizedBox(height: 8),
            ElevatedButtonWidget.undo(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
