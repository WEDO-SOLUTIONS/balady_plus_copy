import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppFontWeight, AppStyle;

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextStyle? textStyle;
  final double? fontSize;
  final AppFontWeight? fontWeight;
  final double? height;

  final String fontFamily;
  final Color? fontColor;
  final TextDecoration? textDecoration;
  final double? textDecorationThickness;
  final Color? textDecorationColor;
  final double? textScaleFactor;
  final double? letterSpacing;

  const CustomTextWidget(
    this.text, {
    super.key,
    this.maxLines = 1,
    this.textStyle,
    this.fontSize,
    this.fontWeight,
    this.letterSpacing,
    this.textDecorationColor,
    this.textScaleFactor,
    this.fontFamily = GeneralKey.appFontType,
    this.fontColor = AppColor.white,
    this.height = 1.0,
    this.textAlign,
    this.textOverflow = TextOverflow.visible,
    this.textDecoration = TextDecoration.none,
    this.textDecorationThickness = 1.5,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      overflow: textOverflow ?? TextOverflow.visible,
      textDirection: textDirection,
      maxLines: maxLines,
      style: textStyle ??
          AppStyle.mainTextSecondaryStyle.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight?.fontWeight,
            height: height,
            color: fontColor,
            fontFamily: fontFamily,
            decoration: textDecoration,
            wordSpacing: 1,
            decorationThickness: textDecorationThickness,
            decorationColor: textDecorationColor ?? fontColor,
            letterSpacing: letterSpacing,
          ),
    );
  }
}

class CustomAutoSizeTextWidget extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final TextDirection? textDirection;
  final int maxLines;
  final TextStyle? textStyle;
  final AppFontWeight? fontWeight;
  final double maxFontSize;
  final double minFontSize;
  final double? height;

  final String fontFamily;
  final Color? fontColor;
  final TextDecoration? textDecoration;
  final double? textDecorationThickness;
  final Color? textDecorationColor;
  final double? textScaleFactor;
  final double? letterSpacing;

  const CustomAutoSizeTextWidget(this.text,
      {super.key,
      this.textAlign,
      this.textOverflow,
      this.textDirection,
      this.maxLines = 1,
      this.textStyle,
      this.fontWeight,
      this.maxFontSize = 16.0,
      this.minFontSize = 10.0,
      this.fontFamily = GeneralKey.appFontType,
      this.fontColor = AppColor.white,
      this.height = 1.0,
      this.textDecoration = TextDecoration.none,
      this.textDecorationThickness = 1.5,
      this.letterSpacing,
      this.textDecorationColor,
      this.textScaleFactor});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: textAlign,
      overflow: textOverflow,
      textDirection: textDirection,
      maxFontSize: maxFontSize,
      minFontSize: minFontSize,
      maxLines: maxLines,
      style: textStyle ??
          AppStyle.mainTextSecondaryStyle.copyWith(
            fontSize: maxFontSize,
            fontWeight: fontWeight?.fontWeight,
            height: height,
            color: fontColor,
            fontFamily: fontFamily,
            decoration: textDecoration,
            decorationThickness: textDecorationThickness,
            decorationColor: textDecorationColor ?? fontColor,
            letterSpacing: letterSpacing,
          ),
    );
  }
}
