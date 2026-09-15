import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/splash/presentation/widgets/splash_screen_animation.dart';

import 'package:flutter/material.dart';

import '../../../../core/utils/constants/paths/icon_paths.dart';

class BottomLogoWidget extends StatelessWidget {
  const BottomLogoWidget({super.key, required this.animation});

  final SplashScreenAnimation? animation;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32 * 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* Opacity(
              opacity: 0.24,
              child: CustomTextWidget(
                Helpers.translatingWord('test_launch'),
                fontWeight: AppFontWeight.medium,
              ),
            ),*/
            const CustomVerticalSpace(height: 24),
            SizedBox(
              width: getWidth(size.width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: 0.24,
                    child: Image.asset(
                      IconPath.splashScreenBaladySecondLogoImg,
                      width: getWidth(size.width),
                      height: 40,
                    ),
                  ),
                  const CustomVerticalSpace(height: 24),
                  SizedBox(
                    width: getWidth(size.width),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Image.asset(IconPath.splashScreen2030LogoImg, height: 40)),
                        Expanded(child: Image.asset(IconPath.splashScreenQualityLogoImg, height: 40)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getWidth(double width) {
    return width < 300 ? 200 : 168;
  }
}
