import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/constants/paths/image_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class DownloadForasApp extends StatelessWidget {
  const DownloadForasApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /* LaunchReview.launch(
            writeReview: false,
            androidAppId: "platform.codes.investmentopportunities",
            iOSAppId: "1372788277");*/
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
            const CustomTextWidget(
              "حمل تطبيق فرص الآن",
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
