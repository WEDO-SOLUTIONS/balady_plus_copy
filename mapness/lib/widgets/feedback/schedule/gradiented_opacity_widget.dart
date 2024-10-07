// ignore_for_file: prefer_expression_function_bodies

import 'package:flutter/material.dart';

class GradientedOpacityWidget extends StatelessWidget {
  final Widget child;

  /// Full opaque window in transparent gradient;
  /// Value in pixels representing the size of the opaque area in the middle.
  final double opaqueSize;

  const GradientedOpacityWidget({
    required this.child,
    required this.opaqueSize,
    super.key,
  }) : assert(opaqueSize >= 0.0, 'opaqueSize must be greater than or equal to 0.0');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        final relativeOpaqueSize = (opaqueSize / totalHeight) / 2;
        final transparentSize = 0.5 - relativeOpaqueSize;

        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
                Colors.transparent,
                Colors.white10,
                Colors.white30,
                Colors.white,
                Colors.white,
                Colors.white30,
                Colors.white10,
                Colors.transparent,
              ],
              stops: [
                0,
                transparentSize * 0.3,
                transparentSize * 0.7,
                0.5 - relativeOpaqueSize,
                0.5 + relativeOpaqueSize,
                1 - transparentSize * 0.7,
                1 - transparentSize * 0.3,
                1,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: child,
        );
      },
    );
  }
}
