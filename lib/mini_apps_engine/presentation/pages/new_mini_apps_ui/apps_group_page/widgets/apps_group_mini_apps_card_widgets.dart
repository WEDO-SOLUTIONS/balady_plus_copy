import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
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
  final String? iconPath;

  final void Function()? onTap;
  const AppsGroupMiniAppsCardWidgets({
    super.key,
    this.width,
    this.height,
    this.iconHeight,
    this.iconWidth,
    this.isTextRemove = false,
    this.title,
    this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: isTextRemove == false
            ? Column(
                children: [
                  SizedBox(
                    width: width ?? context.w(87.12268829345703),
                    height: height ?? context.h(87.12268829345703),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5EBED),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          IconPath.defaultMiniAppIcon,
                          width: iconWidth ?? context.w(60),
                          height: iconHeight ?? context.h(60),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.screenHeight * 0.01),
                  SizedBox(
                    height: context.screenHeight * 0.03,
                    width: context.screenWidth * 0.40,
                    child: AutoSizeText(
                      title ?? "example",
                      maxFontSize: 13,
                      minFontSize: 10,
                      maxLines: 3,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0XFF1E2A36),
                      ),
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            : SizedBox(
                width: width ?? context.w(87.12268829345703),
                height: height ?? context.h(87.12268829345703),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5EBED),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath ?? '',
                      width: context.w(60),
                      height: context.h(60),
                    ),
                  ),
                ),
              ));
  }
}
