import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class LoadingCircular extends StatelessWidget {
  final double? size;

  const LoadingCircular({super.key, this.size});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: size ?? 64,
        width: size ?? 64,
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(context.color.stroke_accent),
          backgroundColor: context.color.stroke_primary,
        ),
      );
}
