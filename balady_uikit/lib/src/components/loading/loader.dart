import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

enum LoaderSizeV2 {
  l(size: AppSizes.l),
  m(size: AppSizes.m),
  s(size: AppSizes.s),
  xs(size: AppSizes.xs),
  xxs(size: AppSizes.xxs),
  $3xs(size: AppSizes.$3xs),
  $4xs(size: AppSizes.$4xs, strokeWidth: 1.5);

  final double size;
  final double strokeWidth;

  const LoaderSizeV2({required this.size, this.strokeWidth = 2.0});
}

class Loader extends StatelessWidget {
  final LoaderSizeV2 size;
  final LoaderStyle style;
  final double? value;
  const Loader({
    required this.size,
    required this.style,
    super.key,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        height: size.size - size.strokeWidth,
        width: size.size - size.strokeWidth,
        child: CircularProgressIndicator(
          color: style.foregroundColor(context),
          strokeWidth: size.strokeWidth,
          value: value,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
