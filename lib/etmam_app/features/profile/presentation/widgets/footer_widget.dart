import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              ImagePath.vision2030Logo,
              height: 64,
            ),
            Image.asset(
              ImagePath.lifeQualityLogo,
              height: 64,
            ),
          ],
        ),
        const CustomVerticalSpace(height: 32),
        FutureBuilder<String>(
            future: getCurrentVersion(),
            builder: (context, snapShot) {
              return snapShot.data != null
                  ? CustomTextWidget(snapShot.data!,
                      fontColor: AppColor.bottomNavigationShadow,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 13)
                  : Container();
            })
      ],
    );
  }

  Future<String> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersionNumber = packageInfo.version;
    return "v " + currentVersionNumber;
  }
}
