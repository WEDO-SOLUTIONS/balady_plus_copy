import 'dart:io';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/ui/buttons/refresh_button.dart';

class LoadingImage extends ConsumerStatefulWidget {
  final String imageUrl;
  final File? file;
  final Widget loadingWidget;
  final BoxFit? fit;
  final VoidCallback? onImageReady;
  final bool? isAssetImg;
  final Function(String name, {bool? isAsset})? onImageTap;
  final FilterQuality? filterQuality;

  const LoadingImage({
    required this.imageUrl,
    required this.loadingWidget,
    super.key,
    this.onImageReady,
    this.fit,
    this.onImageTap,
    this.isAssetImg = false,
    this.filterQuality,
    this.file,
  });

  @override
  ConsumerState<LoadingImage> createState() => _LoadingImageState();
}

class _LoadingImageState extends ConsumerState<LoadingImage> {
  late String imageUrl;
  bool _isLoaded = false;

  static const _animationDuration = Duration(milliseconds: 50);

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
  }

  void _reloadWidget(BuildContext context) {
    if (context.mounted) {
      _isLoaded = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      networkStatusProvider,
      (wasAvailable, available) {
        // [wasAvailable] is nullable value. So we have to handle this value
        // If the network was available we use this value. Else we set default value `true`
        // By default we think that the user has network connection
        final _wasAvailable = wasAvailable ?? true;

        // If the network was not available bit now it is available => [becomeAvailable] = true
        final becomeAvailable = !_wasAvailable && available;
        if (becomeAvailable) {
          _reloadWidget(context);
        }
      },
    );

    if (widget.file != null) {
      return Image.file(
        widget.file!,
        fit: widget.fit,
        width: double.infinity,
        semanticLabel: AppLocalizations.of(context).a11yImage,
        errorBuilder: (context, __, ___) => ColoredBox(
          color: context.colors.backgroundSurface1,
          child: const SizedBox.shrink(),
        ),
        filterQuality: widget.filterQuality ?? FilterQuality.low,
      );
    }

    return widget.isAssetImg == true
        ? Image.asset(
            imageUrl,
            fit: widget.fit,
            semanticLabel: AppLocalizations.of(context).a11yImage,
            errorBuilder: (context, __, ___) => ColoredBox(
              color: context.colors.backgroundSurface1,
              child: const SizedBox.shrink(),
            ),
            filterQuality: widget.filterQuality ?? FilterQuality.low,
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            fit: widget.fit,
            errorWidget: (context, _, __) => Container(
              color: context.colors.backgroundSurface1,
              child: Center(
                child: RefreshButton(
                  onPressed: () {
                    _reloadWidget(context);
                  },
                ),
              ),
            ),
            fadeInDuration: _animationDuration,
            fadeOutDuration: _animationDuration,
            placeholder: (context, _) => widget.loadingWidget,
            imageBuilder: (context, imageProvider) {
              if (!_isLoaded) {
                _isLoaded = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onImageReady?.call();
                });
              }
              return ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: GestureDetector(
                  onTap: () => widget.onImageTap?.call(
                    widget.imageUrl,
                    isAsset: widget.isAssetImg,
                  ),
                  child: Image(
                    image: imageProvider,
                    fit: widget.fit,
                    semanticLabel: AppLocalizations.of(context).a11yImage,
                  ),
                ),
              );
            },
          );
  }
}
