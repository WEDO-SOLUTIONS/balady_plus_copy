import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../core/utils/utils_exports.dart';
import '../../_shared_feature_/shared_feature_exports.dart';

class DownloadForasApp extends StatelessWidget {
  const DownloadForasApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        LaunchReview.launch(
            writeReview: false,
            androidAppId: "platform.codes.investmentopportunities",
            iOSAppId: "1372788277");
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColor.white,
        ),
        child: Row(
          children: [
            Image.asset(ImagePath.forasLogo, width: 58, height: 58),
            const SizedBox(width: 12),
            CustomTextWidget(
              "download_furas_now".tr(),
              fontSize: 16,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.blackModern600Light,
            ),
            Spacer(),
            const CustomSvgIconWidget(IconPath.download2, iconSize: 32),
          ],
        ),
      ),
    );
  }
}
