import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppFontWeight, WidgetConversion;
import '../../../shared_feature_exports.dart' show CustomTextWidget;

class TitleSubtitleComponent extends StatelessWidget {
  final String title;
  final TextStyle? titleTextStyle;
  final String subtitle;
  final TextStyle? subtitleTextStyle;
  const TitleSubtitleComponent({
    super.key,
    required this.title,
    this.titleTextStyle,
    required this.subtitle,
    this.subtitleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Subtitle
        for (int index = 0; index < length; index++)
          CustomTextWidget(
            texts[index],
            textStyle: textStyles[index],
            fontWeight: index == 1 ? AppFontWeight.regular : null,
          ),
      ].addPadding(bottom: 6.0),
    );
  }

  int get length => texts.length;
  List<String> get texts => [title, subtitle];
  List<TextStyle?> get textStyles => [titleTextStyle, subtitleTextStyle];
}
