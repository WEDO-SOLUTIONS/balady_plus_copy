import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';

class CustomCircularLoadingWidget extends StatelessWidget {
  final Color backgroundCircularColor;
  final Color loadingColor;
  final double circularWidth;
  final double circularHeight;
  const CustomCircularLoadingWidget({
    super.key,
    this.backgroundCircularColor = /*AppColor.primary900Light*/
        const Color(0xff389492),
    this.loadingColor = AppColor.white,
    this.circularWidth = 60.0,
    this.circularHeight = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    // put in center to avoid start of Column
    return Center(
      child: Container(
        width: circularWidth,
        height: circularHeight,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(GeneralKey.smallPadding),
        // decoration: BoxDecoration(
        //   shape: BoxShape.circle,
        //   color: backgroundCircularColor,
        // ),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(backgroundCircularColor),
        ),
      ),
    );
  }
}
