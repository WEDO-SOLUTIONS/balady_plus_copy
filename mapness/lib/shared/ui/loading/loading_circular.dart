import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class LoadingCircular extends StatelessWidget {
  const LoadingCircular({
    this.size,
    this.strokeWidth = 4,
    super.key,
  });
  final double? size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: size ?? 64,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(context.color.strokeAccent),
          strokeCap: StrokeCap.round,
          backgroundColor: context.color.strokePrimary,
        ),
      );
}
