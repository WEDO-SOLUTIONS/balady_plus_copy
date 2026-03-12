import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../home_exports.dart';

class ChallengeHomeCard extends StatelessWidget {
  const ChallengeHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: 'تحدي بلدي',
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
                  const CustomTextWidget(
                    "شاركنا التحدي",
                    fontColor: AppColor.blackModern50Light,
                    fontWeight: AppFontWeight.bold,
                    fontSize: 14,
                  ),
                  const SizedBox(height: 8),
                  const CustomTextWidget(
                    "وساهم في التصدي لمظاهر التلوث البصري في مدينتك",
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
                    text: "ابدا التحدي",
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
