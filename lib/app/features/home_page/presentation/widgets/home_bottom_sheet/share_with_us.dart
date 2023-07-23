import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, ImagePath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetTitle,
        BottomSheetWithActions,
        CustomTextWidget,
        ElevatedButtonWidget;
import '../../../home_exports.dart' show HomeSection;

class ShareWithUs extends StatelessWidget {
  const ShareWithUs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: "shareWithUs".tr(),
      child: Container(
        width: double.infinity,
        height: 220,
        margin: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppColor.darkSlateBlue6,
              offset: Offset(0, 16),
              blurRadius: 32,
            )
          ],
          color: AppColor.white,
        ),
        child: Stack(
          children: [
            Image.asset(
              ImagePath.sendImage,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(ImagePath.camera),
                  const SizedBox(height: 8),
                  CustomTextWidget(
                    "shareWithUs".tr(),
                    textStyle: AppStyle.mainTextStyle.copyWith(
                      color: AppColor.blackModern900Light,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CustomTextWidget(
                    "sendImageHint".tr(),
                    textStyle: AppStyle.serviceDescriptionStyle,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButtonWidget.sendImage(
                    onPressed: () async {},
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
