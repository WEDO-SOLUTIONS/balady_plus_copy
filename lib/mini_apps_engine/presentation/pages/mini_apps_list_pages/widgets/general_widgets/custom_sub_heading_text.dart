import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';

class CustomSubHeadingText extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final Color? fontColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool? isTextCenter;
  const CustomSubHeadingText(
      {super.key,
      required this.text,
      this.width,
      this.height,
      this.fontColor,
      this.fontSize,
      this.isTextCenter,
      this.fontWeight});

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
                  color: fontColor ?? Colors.black,
                  fontWeight: fontWeight ?? FontWeight.w700,
                  fontSize: fontSize ?? 18,
                  fontFamily: "packages/balady_uikit/Frutiger",
                ),
                textAlign: TextAlign.start,
              ),
            )
          : AutoSizeText(
              text,
              maxFontSize: 18,
              minFontSize: 15,
              overflow: TextOverflow.visible,
              maxLines: 1,
              style: TextStyle(
                color: fontColor ?? Colors.black,
                fontWeight: fontWeight ?? FontWeight.w700,
                // fontSize: fontSize ?? 18,

                fontFamily: "packages/balady_uikit/Frutiger",
              ),
              textAlign: TextAlign.start,
            ),
    );
  }
}
