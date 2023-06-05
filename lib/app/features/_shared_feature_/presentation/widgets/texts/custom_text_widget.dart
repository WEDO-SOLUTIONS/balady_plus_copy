import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppFontWeight, AppStyle;

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final TextDirection? textDirection;
  final int maxLines;
  final TextStyle? textStyle;
  final double? fontSize;
  final AppFontWeight? fontWeight;
  final double? height;

  const CustomTextWidget(
    this.text, {
    super.key,
    this.textAlign,
    this.textOverflow,
    this.textDirection,
    this.maxLines = 1,
    this.textStyle,
    this.fontSize,
    this.fontWeight,
    this.height,
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

  const CustomAutoSizeTextWidget(
    this.text, {
    super.key,
    this.textAlign,
    this.textOverflow,
    this.textDirection,
    this.maxLines = 1,
    this.textStyle,
    this.fontWeight,
    this.maxFontSize = 16.0,
    this.minFontSize = 10.0,
  });

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
          ),
    );
  }
}
