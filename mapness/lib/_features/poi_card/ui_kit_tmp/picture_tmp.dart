//import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Use [Picture] class to display images on the screen. This class has 3 constructors, which have 3 different sizes
/// [Picture.small] = 24dp, [Picture.medium] = 36dp, [Picture.large] = 48dp
/// if the [imgPath] field is not passed, then the default placeholder will be used
/// See also:
/// * [Figma Design] (https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2036-6850&mode=design&t=irJk3D60Qs2500JN-0), design specs

class Picture extends StatelessWidget {
  final Widget? img;
  final double size;

  const Picture.small({
    super.key,
    this.img,
    this.size = 24,
  });

  const Picture.medium({
    super.key,
    this.img,
    this.size = 36,
  });

  const Picture.large({
    super.key,
    this.img,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.color.stroke_primary, width: 0.5),
        ),
        child: ClipOval(
          child: img ??
              Image.asset(
                'assets/images/picture_place_holder.png',
                fit: BoxFit.cover,
              ),
        ),
      );
}
