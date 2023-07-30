import 'package:flutter/material.dart';

import '../../shared_feature_exports.dart' show CustomBoxWidget;

class CustomIndicatorWidget extends StatelessWidget {
  final int length;
  final int currentIndex;
  const CustomIndicatorWidget({
    Key? key,
    required this.currentIndex,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => CustomBoxWidget(
          isActive: index == currentIndex,
          horizontalMargin: 2,
        ),
      ),
    );
  }
}
