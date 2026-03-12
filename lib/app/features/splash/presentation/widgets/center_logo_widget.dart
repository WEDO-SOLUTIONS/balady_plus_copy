import 'package:balady_plus/app/features/splash/presentation/widgets/splash_screen_animation.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart' show CustomSvgIconWidget, CustomVerticalSpace;

class CenterLogoWidget extends StatelessWidget {
  const CenterLogoWidget({
    super.key,
    required this.animation,
  });

  final SplashScreenAnimation animation;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 250.0,
            height: 100.0,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn,
                  width: animation.centerIconResize.value,
                  child: AlignTransition(
                    alignment: animation.centerToRightIcon,
                    child: FadeTransition(
                      opacity: animation.centerIconOpacity,
                      child: const CustomSvgIconWidget(
                        IconPath.logoSymbolIcon,
                        iconWidth: 100.0,
                        iconHeight: 90.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FadeTransition(
                    opacity: animation.centerTextOpacity,
                    child: const CustomSvgIconWidget(
                      IconPath.logoTextIcon,
                      iconWidth: 100.0,
                      iconHeight: 90.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const CustomVerticalSpace(height: 50),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
                width: 128,
                alignment: Alignment.center,
                child: LinearProgressIndicator(
                  value: animation.controller.value,
                  color: AppColor.white,
                  backgroundColor: const Color(0x3dffffff),
                )),
          )
        ],
      ),
    );
  }
}
