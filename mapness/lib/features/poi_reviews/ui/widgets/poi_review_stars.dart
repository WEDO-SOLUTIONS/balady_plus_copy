import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

/// Read-only star row; fractional ratings partially fill a star from the start side.
class PoiReviewStars extends StatelessWidget {
  final double rating;
  final double size;
  final double spacing;

  const PoiReviewStars({required this.rating, this.size = 14, this.spacing = Spacing.$0_5x, super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 0; i < 5; i++) ...[
        if (i > 0) SizedBox(width: spacing),
        _Star(fill: (rating - i).clamp(0.0, 1.0), size: size),
      ],
    ],
  );
}

class _Star extends StatelessWidget {
  final double fill;
  final double size;

  const _Star({required this.fill, required this.size});

  @override
  Widget build(BuildContext context) {
    final active = SvgPicture.asset(Assets.imagesSvg.activeStar.keyName, width: size, height: size);
    if (fill >= 1) {
      return active;
    }
    final inactive = SvgPicture.asset(
      Assets.imagesSvg.inactiveStar.keyName,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(context.colors.foregroundMuted, BlendMode.srcIn),
    );
    if (fill <= 0) {
      return inactive;
    }
    return Stack(
      children: [
        inactive,
        ClipRect(
          child: Align(alignment: AlignmentDirectional.centerStart, widthFactor: fill, child: active),
        ),
      ],
    );
  }
}
