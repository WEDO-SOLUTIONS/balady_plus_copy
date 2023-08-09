import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../home_exports.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ChallengeHomeCard extends StatelessWidget {
  const ChallengeHomeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: 'balady_challenge'.tr(),
      topPadding: 12,
      child: Container(
        height: 172,
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          image: DecorationImage(
            image: AssetImage(ImagePath.challengeBaladyBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    'join_challenge'.tr(),
                    fontColor: AppColor.blackModern50Light,
                    fontWeight: AppFontWeight.bold,
                    fontSize: 14,
                  ),
                  const SizedBox(height: 8),
                  CustomTextWidget(
                    'home_card_text'.tr(),
                    fontColor: AppColor.blackModern50Light,
                    fontWeight: AppFontWeight.bold,
                    fontSize: 12,
                    maxLines: null,
                    height: 1.5,
                  ),
                  const SizedBox(height: 12),
                  CustomElevatedButtonWidget(
                    btnColor: AppColor.secondary400Light,
                    textStyle: AppStyle.elevatedButtonStyle.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    btnHeight: 40,
                    btnWidth: 157,
                    text: 'start_challenge'.tr(),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
