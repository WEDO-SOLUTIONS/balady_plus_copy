import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

class SecpageOnb extends StatelessWidget {
  const SecpageOnb({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Image.asset("packages/smart_advisor/smart_advisor_assets/images/CardStack.png"),

        const SizedBox(
          height: 40,
        ),
        //try later the svg extention..
        Image.asset(
            "packages/smart_advisor/smart_advisor_assets/images/mockuptow.png"),
        const SizedBox(
          height: 40,
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              " دليل تفاعلي ",
              style: AppStyle.accentBoldStyle.copyWith(color: AppColor.black),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "  تعرف على كافة الاشتراطات والمعلومات المتعلقة بالمنشأة والمخالفات  ",
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppStyle.textRegularRomanStyle
                  .copyWith(color: AppColor.textSecondaryColor),
            ),
          ],
        ),
      ],
    );
  }
}
