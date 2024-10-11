import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstpageOnbording extends StatelessWidget {
  const FirstpageOnbording({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image.asset("packages/smart_advisor/smart_advisor_assets/images/CardStack.png"),

        const SizedBox(
          height: 40,
        ),
        //try later the svg extention..
        Image.asset(
          "packages/smart_advisor/smart_advisor_assets/images/Mockup.png",
        ),
        const SizedBox(
          height: 40,
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ("comprehensive_interactive_guide").tr(),
              style: AppStyle.accentBoldStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 45, left: 45),
              child: Text(
                "مكتبة موحدة توفر المعلومات والاشتراطات التي تحتاجها لتلبية متطلباتك البلدية",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppStyle.textRegularStyle
                    .copyWith(color: AppColor.textSecondaryColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
