import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_memory_image_provider.dart';

const tagPicture = 'tagPicture';

/// Use [Picture] class to display images on the screen. This class has 3 constructors, which have 3 different sizes
/// [Picture.small] = 24dp, [Picture.medium] = 36dp, [Picture.large] = 48dp
/// if the [imgPath] or [imgBytes] field is not passed, then the default placeholder will be used
/// See also:
/// * [Figma Design] (https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2036-6850&mode=design&t=irJk3D60Qs2500JN-0), design specs
@Deprecated('Use [Avatar] widget from balady_uikit instead')
class Picture extends StatelessWidget {
  final String? imgPath;
  final double size;
  final Uint8List? imgBytes;

  const Picture.small({
    super.key,
    this.imgPath,
    this.size = 24,
    this.imgBytes,
  });

  const Picture.medium({
    super.key,
    this.imgPath,
    this.size = 36,
    this.imgBytes,
  });

  const Picture.large({
    super.key,
    this.imgPath,
    this.size = 48,
    this.imgBytes,
  });

  @override
  Widget build(BuildContext context) {
    const _fit = BoxFit.cover;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.borderSoft.withOpacity(.8), width: 0.5),
      ),
      child: ClipOval(
        child: imgBytes != null
            ? Image(image: CacheMemoryImageProvider(imgBytes!.lengthInBytes.toString(), imgBytes!), fit: _fit)
            : imgPath != null
                ? CachedNetworkImage(
                    imageUrl: imgPath!,
                    fit: _fit,
                  )
                : Image.asset(
                    'assets/images/picture_place_holder.png',
                    fit: _fit,
                    package: packageName,
                  ),
      ),
    );
  }
}
