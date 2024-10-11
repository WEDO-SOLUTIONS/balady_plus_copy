import 'package:smart_advisor/app/core/utils/constants/language.dart';

import '../../../core/services/local/navigation_services.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HappyNewsDialog extends StatelessWidget {
  const HappyNewsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, right: 25, left: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: AppColor.surfaceMidContrast,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'اخبار سعيده',
                  style: AppStyle.heading2BoldStyle,
                ),
                GestureDetector(
                  onTap: () {
                    NavigationService.navigatorKey.currentState!.pop();
                  },
                  child: SvgPicture.asset(
                      "packages/smart_advisor/smart_advisor_assets/icons/svg/Button.svg"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'packages/smart_advisor/smart_advisor_assets/images/skech.png',
              height: 116,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  ' لا يوجد اي اشتراطات بلديه للعمل عبر الانترنت',
                  style: AppStyle.textRegularRomanStyle,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                btnHeight: 40,
                //btnWidth: 361,
                btnColor: AppColor.statusAccentColor,
                onPress: () {
                  NavigationService.navigatorKey.currentState!.pop();
                  NavigationService.navigatorKey.currentState!.pop();
                },
                text: 'back_main'.tr())
          ],
        ),
      ),
    );
  }
}
