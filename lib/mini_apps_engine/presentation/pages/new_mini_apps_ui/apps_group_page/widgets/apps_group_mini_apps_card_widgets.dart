import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppsGroupMiniAppsCardWidgets extends StatelessWidget {
  final double? width;
  final double? height;

  final double? iconWidth;
  final double? iconHeight;

  final bool? isTextRemove;

  final String? title;
  final String iconPath;

  final double? radius;

  final void Function()? onTap;
  const AppsGroupMiniAppsCardWidgets({
    super.key,
    this.width,
    this.height,
    this.iconHeight,
    this.iconWidth,
    this.isTextRemove = false,
    this.title,
    required this.iconPath,
    this.onTap,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isTextRemove == false
          ? Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.01),
                  child: SizedBox(
                    width: width ?? context.w(87.12268829345703),
                    height: height ?? context.h(87.12268829345703),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5EBED),
                        borderRadius: BorderRadius.circular(radius ?? 22),
                      ),
                      child: Center(
                        child: CustomNetworkImageWidget(
                          iconPath,
                          // sso: true,
                          // ssoAuth: true,
                          isVerifyingKey: true,
                          imageWidth: iconWidth ?? context.w(60),
                          imageHeight: iconHeight ?? context.h(60),
                          placeHolderWidget: SvgPicture.asset(ImagePath.calendarBackground),
                        ),
                        // SvgPicture.asset(
                        //   IconPath.defaultMiniAppIcon,
                        // width: iconWidth ?? context.w(60),
                        // height: iconHeight ?? context.h(60),
                        // ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: context.screenHeight * 0.01),
                SizedBox(
                  height: context.screenHeight * 0.03,
                  width: context.screenWidth * 0.40,
                  child: Text(
                    title ?? "example",
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF1E2A36),
                      fontFamily: GeneralKey.appFontType,
                      height: 1.4,
                    ),
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.01),
              child: SizedBox(
                width: width ?? context.w(87.12268829345703),
                height: height ?? context.h(87.12268829345703),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5EBED),
                    borderRadius: BorderRadius.circular(radius ?? 22),
                  ),
                  child: Center(
                    child: CustomNetworkImageWidget(
                      iconPath,
                      // sso: true,
                      // ssoAuth: true,
                      isVerifyingKey: true,
                      imageWidth: iconWidth ?? context.w(60),
                      imageHeight: iconHeight ?? context.h(60),
                      placeHolderWidget: SvgPicture.asset(ImagePath.calendarBackground),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
