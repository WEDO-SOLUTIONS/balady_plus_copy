import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show WidgetConversion;
import '../../../shared_feature_exports.dart' show ShimmerEffectWidget;

class TitleSubtitleShimmerComponent extends StatelessWidget {
  final double titleWidth;
  final double titleHeight;
  final double subtitleWidth;
  final double subtitleHeight;
  const TitleSubtitleShimmerComponent({
    super.key,
    this.titleHeight = 50.0,
    this.titleWidth = 150.0,
    this.subtitleHeight = 70.0,
    this.subtitleWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int index = 0; index < length; index++)
          ShimmerEffectWidget(
            height: heights[index],
            width: widths[index],
            borderRadius: 8.0,
          ),
      ].addPadding(bottom: 2.0),
    );
  }

  int get length => heights.length;
  List<double> get heights => [titleHeight, subtitleHeight];
  List<double> get widths => [titleWidth, subtitleWidth];
}
