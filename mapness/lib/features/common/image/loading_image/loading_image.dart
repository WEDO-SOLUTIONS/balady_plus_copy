import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/common/providers/network_status.dart';
import 'package:mapness/features/stories/presentation/story_refresh_button.dart';

enum ImageState { loading, loaded, error }

class LoadingImage extends ConsumerStatefulWidget {
  final String imageUrl;
  final Widget loadingWidget;
  final BoxFit? fit;
  final VoidCallback? onImageReady;

  const LoadingImage({
    Key? key,
    required this.imageUrl,
    this.onImageReady,
    required this.loadingWidget,
    this.fit,
  }) : super(key: key);

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
    bool failed = false;
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

    if (context.mounted && !failed) {
      setState(() {
        state = ImageState.loaded;
      });
      widget.onImageReady?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(networkStatusProvider, (previous, next) {
      if (previous == ConnectivityResult.none && next != previous) {
        unawaited(loadImage(context));
      }
    });

    return switch (state) {
      ImageState.error => Container(
          color: const Color(0xFFE9E9E9),
          child: Center(
            child: StoryRefreshButton(
              onPressed: () {
                loadImage(context);
              },
            ),
          ),
        ),
      ImageState.loaded => Image.network(
          widget.imageUrl,
          fit: widget.fit,
        ),
      ImageState.loading => widget.loadingWidget,
    };
  }
}
