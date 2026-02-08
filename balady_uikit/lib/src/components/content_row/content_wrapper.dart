import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';

///[ContentWrapper] component. In this case, the content is one
///or a list of [ContentRow]. The wrapper gives the content a background,
///fillets, and vertical padding of 4 pixels.
///
/// See also:
/// * [Figma Design](https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2732-21815&mode=design&t=SDHK3kmgGjetLldc-4)

class ContentWrapper extends StatelessWidget {
  final List<Widget> children;
  final Color? color;
  final CrossAxisAlignment crossAxisAlignment;

  const ContentWrapper({
    required this.children,
    this.color,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: smoothBorder(RadiusBorder.xl),
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      ),
    );
  }

  static Widget single({required Widget child, Color? color}) {
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: smoothBorder(RadiusBorder.xl),
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.$0_5x),
        child: child,
      ),
    );
  }
}
