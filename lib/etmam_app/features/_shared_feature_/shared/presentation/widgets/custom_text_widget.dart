import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppFontWeight, AppStyle;

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextStyle? textStyle;
  final double? fontSize;
  final Color? fontColor;
  final TextDecoration textDecoration;
  final double textDecorationThickness;
  final Color? textDecorationColor;
  final AppFontWeight? fontWeight;
  final double? height;
  final double? letterSpacing;
  const CustomTextWidget(this.text,
      {Key? key,
      this.textAlign,
      this.textOverflow,
      this.textDirection,
      this.maxLines,
      this.textStyle,
      this.fontSize,
      this.fontColor,
      this.fontWeight,
      this.height,
      this.textDecoration = TextDecoration.none,
      this.textDecorationColor,
      this.textDecorationThickness = 1.5,
      this.letterSpacing})
      : super(key: key);

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
              color: fontColor,
              height: height,
              decoration: textDecoration,
              decorationThickness: textDecorationThickness,
              decorationColor: textDecorationColor ?? fontColor,
              letterSpacing: letterSpacing),
      textScaleFactor: 1,
    );
  }
}

class CustomAutoSizeTextWidget extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextStyle? textStyle;
  final AppFontWeight? fontWeight;
  final double maxFontSize;
  final double minFontSize;
  final Color? fontColor;

  const CustomAutoSizeTextWidget(this.text,
      {Key? key,
      this.textAlign,
      this.textOverflow,
      this.textDirection,
      this.maxLines,
      this.textStyle,
      this.fontWeight,
      this.maxFontSize = 16.0,
      this.minFontSize = 10.0,
      this.fontColor})
      : super(key: key);

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
              color: fontColor),
    );
  }
}
