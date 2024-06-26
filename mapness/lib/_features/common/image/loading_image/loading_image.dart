import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/features/stories/presentation/story_refresh_button.dart';

class LoadingImage extends ConsumerStatefulWidget {
  const LoadingImage({
    required this.imageUrl,
    required this.loadingWidget,
    super.key,
    this.onImageReady,
    this.fit,
    this.onImageTap,
    this.isAssetImg = false,
  });
  final String imageUrl;
  final Widget loadingWidget;
  final BoxFit? fit;
  final VoidCallback? onImageReady;
  final bool? isAssetImg;
  final Function(String name, {bool? isAsset})? onImageTap;

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
        final becomeAvailable = wasAvailable == false && available != wasAvailable;
        if (becomeAvailable) {
          _reloadWidget(context);
        }
      },
    );

    return widget.isAssetImg == true
        ? Image.asset(
            imageUrl,
            fit: widget.fit,
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            fit: widget.fit,
            errorWidget: (context, _, __) => Container(
              color: context.color.surfaceBasePrimary,
              child: Center(
                child: StoryRefreshButton(
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
                  ),
                ),
              );
            },
          );
  }
}
