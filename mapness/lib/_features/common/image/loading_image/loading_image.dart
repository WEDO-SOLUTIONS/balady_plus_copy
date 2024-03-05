import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/_features/stories/presentation/story_refresh_button.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

enum ImageState { loading, loaded, error }

class LoadingImage extends ConsumerStatefulWidget {

  const LoadingImage({
    required this.imageUrl, required this.loadingWidget, super.key,
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
  final Function(String name, bool? isAsset)? onImageTap;

  @override
  ConsumerState<LoadingImage> createState() => _LoadingImageState();
}

class _LoadingImageState extends ConsumerState<LoadingImage> {
  ImageState state = ImageState.loading;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (imageUrl != widget.imageUrl || state == ImageState.loading) {
      imageUrl = widget.imageUrl;
      unawaited(loadImage(context));
    }
  }

  Future<void> loadImage(BuildContext context) async {
    /// await for image to be ready
    var failed = false;
    if (widget.isAssetImg == false) {
      await precacheImage(
        NetworkImage(widget.imageUrl),
        context,
        onError: (_, __) {
          failed = true;
          setState(() {
            state = ImageState.error;
          });
        },
      );
    }

    if (context.mounted && !failed) {
      setState(() {
        state = ImageState.loaded;
      });
      widget.onImageReady?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      networkStatusProvider,
      (previous, next) {
        if (previous == ConnectivityResult.none && next != previous) {
          unawaited(loadImage(context));
        }
      },
    );

    return switch (state) {
      ImageState.error => Container(
          color: context.color.surface_base_primary,
          child: Center(
            child: StoryRefreshButton(
              onPressed: () {
                loadImage(context);
              },
            ),
          ),
        ),
      ImageState.loaded => GestureDetector(
          onTap: () {
            widget.onImageTap?.call(widget.imageUrl, widget.isAssetImg);
          },
          child: widget.isAssetImg == true
              ? Image.asset(
                  widget.imageUrl,
                  fit: widget.fit,
                )
              : Image.network(
                  widget.imageUrl,
                  fit: widget.fit,
                ),
        ),
      ImageState.loading => widget.loadingWidget,
    };
  }
}
