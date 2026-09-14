import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, ImagePath;
import '../../../../_shared_feature_/shared_feature_exports.dart' show CustomTextWidget, ElevatedButtonWidget;
import '../../../home_exports.dart' show HomeSection;

class GameChallenge extends StatelessWidget {
  const GameChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: "beTheBestInspectorIn".tr(),
      child: Container(
        width: double.infinity,
        height: 160,
        margin: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [BoxShadow(color: AppColor.darkSlateBlue6, offset: Offset(0, 16), blurRadius: 32)],
          color: AppColor.primary800Light,
        ),
        child: Stack(
          children: [
            Image.asset(ImagePath.gameChallenge, width: double.infinity, height: double.infinity, fit: BoxFit.fill),
            Container(
              padding: const EdgeInsets.all(16),
              width: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  CustomTextWidget(
                    "gameChallenge".tr(),
                    textStyle: AppStyle.mainTextStyle.copyWith(color: AppColor.blackModern50Light),
                  ),
                  const SizedBox(height: 8),
                  CustomTextWidget(
                    "gameChallengeHint".tr(),
                    textStyle: AppStyle.serviceDescriptionStyle.copyWith(
                      color: AppColor.blackModern50Light.withValues(alpha: 0.6),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButtonWidget.startGame(onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
