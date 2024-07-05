import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class LoadingCircular extends StatelessWidget {
  const LoadingCircular({super.key, this.size});
  final double? size;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: size ?? 64,
        width: size ?? 64,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(context.color.strokeAccent),
          strokeCap: StrokeCap.round,
          backgroundColor: context.color.strokePrimary,
        ),
      );
}
