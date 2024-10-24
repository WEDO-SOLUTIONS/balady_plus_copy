import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "packages/smart_advisor/smart_advisor_assets/images/no_data_image.png",
          width: 132,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "لا يوجد بيانات",
          style: AppStyle.calloutBoldStyle,
        ),
      ],
    );
  }
}
