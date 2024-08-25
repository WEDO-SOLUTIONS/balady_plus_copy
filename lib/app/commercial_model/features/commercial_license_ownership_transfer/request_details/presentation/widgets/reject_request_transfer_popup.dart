import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';

class RejectionPopup extends StatelessWidget {
  const RejectionPopup({
    super.key,
  });

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
              "REJECTED".tr(),
              textStyle: AppStyle.cardTitleTextStle,
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.finishButton(
              onPressed: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(CommercialRouteName.requests));
              },
            ),
          ],
        ),
      ),
    );
  }
}
