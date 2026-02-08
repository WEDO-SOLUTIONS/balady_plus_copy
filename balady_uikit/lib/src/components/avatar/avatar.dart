import 'package:balady_uikit/components.dart';
import 'package:balady_uikit/core/colorsV2/values/values.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/utils/constants.dart';
import 'package:balady_uikit/src/components/avatar/custom_memory_image_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Avatar extends StatelessWidget {
  final AvatarSize size;
  final AvatarData data;

  const Avatar({
    required this.size,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.size,
      height: size.size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: getGradient(context),
          color: getBackgroundColor(context),
        ),
        child: ClipOval(
          child: switch (data) {
            AvatarDataEmpty() => _DataEmpty(
                data: data as AvatarDataEmpty,
                size: size,
              ),
            AvatarUrl() => _Url(
                data: data as AvatarUrl,
                size: size,
              ),
            AvatarBytes() => _Bytes(
                data: data as AvatarBytes,
                size: size,
              ),
            AvatarLoading() => _Loader(
                data: data as AvatarLoading,
                size: size,
              ),
          },
        ),
      ),
    );
  }

  Color? getBackgroundColor(BuildContext context) {
    if (data is AvatarLoading) {
      return context.colors.neutralContainerActive;
    }
    return null;
  }

  LinearGradient? getGradient(BuildContext context) {
    if (data is! AvatarDataEmpty) {
      return null;
    }
    final isGrayScale = data.isGrayScale;
    if (isGrayScale) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          NeutralColors.$400,
          NeutralColors.$600,
        ],
      );
    }
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: switch ((data as AvatarDataEmpty).style) {
        AvatarEmptyStyle.accentSecondary => [
            AccentSecondaryColors.$400,
            AccentSecondaryColors.$600,
          ],
        AvatarEmptyStyle.extra01 => [
            Extra01Colors.$400,
            Extra01Colors.$600,
          ],
        AvatarEmptyStyle.accent => [
            AccentColors.$400,
            AccentColors.$600,
          ],
      },
    );
  }
}

class _DataEmpty extends StatelessWidget {
  final AvatarSize size;
  final AvatarDataEmpty data;
  const _DataEmpty({
    required this.size,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.value == null || data.value!.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(size.size / 5),
        child: SvgPicture.asset(
          'assets/icons/ic_profile.svg',
          package: packageName,
          height: 36,
          width: 36,
          colorFilter: ColorFilter.mode(
            context.colors.backgroundSurface1,
            BlendMode.srcIn,
          ),
        ),
      );
    }
    return Center(
      child: Text(
        data.value!,
        style: mapAvatarSizeToTextStyle(context).copyWith(
          color: context.colors.backgroundSurface1,
        ),
      ),
    );
  }

  TextStyle mapAvatarSizeToTextStyle(BuildContext context) {
    return switch (size) {
      AvatarSize.$16 => TextStyle(
          letterSpacing: 0,
          fontSize: 6,
          fontWeight: FontWeight.w700,
          height: 8 / 6,
          fontFamily: context.textStyles.h4SemiBold.fontFamily,
          package: packageName,
        ),
      AvatarSize.$24 => TextStyle(
          letterSpacing: 0,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          height: 13 / 10,
          fontFamily: context.textStyles.h4SemiBold.fontFamily,
          package: packageName,
        ),
      AvatarSize.$32 => context.textStyles.captionLargeSemiBold,
      AvatarSize.$48 => context.textStyles.h4SemiBold,
      AvatarSize.$64 => context.textStyles.h2SemiBold,
      AvatarSize.$80 => context.textStyles.h1SemiBold,
      AvatarSize.$96 => context.textStyles.h1SemiBold,
    };
  }
}

class _Url extends StatelessWidget {
  final AvatarUrl data;
  final AvatarSize size;

  const _Url({
    required this.data,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final imgPath = data.url;

    return _GrayScaleImage(
      isGrayScale: data.isGrayScale,
      child: CachedNetworkImage(
        imageUrl: imgPath,
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) {
          return Image(
            image: imageProvider,
            fit: BoxFit.cover,
          );
        },
        progressIndicatorBuilder: (context, url, progress) {
          return _Loader(data: const AvatarLoading(), size: size);
        },
        errorWidget: (context, url, error) {
          return _DataEmpty(
            data: AvatarDataEmpty(value: data.value),
            size: size,
          );
        },
      ),
    );
  }
}

class _Bytes extends StatelessWidget {
  final AvatarBytes data;
  final AvatarSize size;

  const _Bytes({
    required this.data,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final imgBytes = data.bytes;
    return _GrayScaleImage(
      isGrayScale: data.isGrayScale,
      child: Image(
        image: CacheMemoryImageProvider(imgBytes.lengthInBytes.toString(), imgBytes),
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null || loadingProgress.cumulativeBytesLoaded == loadingProgress.expectedTotalBytes) {
            return child;
          }
          return _Loader(
            data: const AvatarLoading(),
            size: size,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _DataEmpty(
            data: AvatarDataEmpty(value: data.value),
            size: size,
          );
        },
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  final AvatarLoading data;
  final AvatarSize size;
  const _Loader({
    required this.data,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final size = mapAvatarSizeToLoading();
    if (size == null) {
      return const SizedBox();
    }
    return _GrayScaleImage(
      isGrayScale: data.isGrayScale,
      child: Loader(
        style: data.style,
        size: size,
      ),
    );
  }

  LoaderSizeV2? mapAvatarSizeToLoading() {
    return switch (size) {
      AvatarSize.$16 => null,
      AvatarSize.$24 => LoaderSizeV2.$4xs,
      AvatarSize.$32 => LoaderSizeV2.$4xs,
      AvatarSize.$48 => LoaderSizeV2.xxs,
      AvatarSize.$64 => LoaderSizeV2.s,
      AvatarSize.$80 => LoaderSizeV2.m,
      AvatarSize.$96 => LoaderSizeV2.l,
    };
  }
}

class _GrayScaleImage extends StatelessWidget {
  final Widget child;
  final bool isGrayScale;
  const _GrayScaleImage({
    required this.child,
    required this.isGrayScale,
  });

  @override
  Widget build(BuildContext context) {
    if (isGrayScale) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0, // Red channel
          0.2126, 0.7152, 0.0722, 0, 0, // Green channel
          0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
          0, 0, 0, 1, 0, // Alpha channel
        ]),
        child: child,
      );
    }
    return child;
  }
}
