import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';

class OfferViewDecorationWidget extends StatelessWidget {
  final Widget? child;

  const OfferViewDecorationWidget({this.child, super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorsV3.backgroundSurface1,
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$3x).copyWith(left: Spacing.$4x),
          child: child,
        ),
      );
}
