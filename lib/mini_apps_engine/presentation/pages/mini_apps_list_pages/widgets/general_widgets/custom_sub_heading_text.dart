import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';

//!
class CustomSubHeadingText extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final Color? fontColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool? isTextCenter;
  final int? maxLines;

  final double? autoSizeMaxFont;
  final double? autoSizeMinFont;
  const CustomSubHeadingText({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.fontColor,
    this.fontSize,
    this.isTextCenter,
    this.fontWeight,
    this.maxLines,
    this.autoSizeMaxFont,
    this.autoSizeMinFont,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.w(195),
      height: height ?? context.h(35),
      child: isTextCenter == true
          ? Center(
              child: Text(
                text,
                style: TextStyle(
                  height: 1.2,
                  // color: fontColor ?? Colors.black,
                  fontWeight: fontWeight ?? FontWeight.w300,
                  fontSize: fontSize ?? 18,
                  fontFamily: GeneralKey.appFontType,
                ),
                textAlign: TextAlign.start,
              ),
            )
          : AutoSizeText(
              text,
              maxFontSize: autoSizeMaxFont ?? 18,
              minFontSize: autoSizeMinFont ?? 14,
              overflow: TextOverflow.visible,
              maxLines: maxLines ?? 1,
              style: TextStyle(
                //    color: fontColor ?? Colors.black,
                fontWeight: fontWeight ?? FontWeight.w700,
                // fontSize: fontSize ?? 18,
                height: 1.4,
                fontFamily: GeneralKey.appFontType,
              ),
              textAlign: TextAlign.start,
            ),
    );
  }
}
