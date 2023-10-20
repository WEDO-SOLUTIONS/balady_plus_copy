import 'dart:async';

import 'package:flutter/material.dart';

class LoadingImage extends StatefulWidget {
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
  State<LoadingImage> createState() => _LoadingImageState();
}

class _LoadingImageState extends State<LoadingImage> {
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    unawaited(loadImage(context));
  }

  Future<void> loadImage(BuildContext context) async {
    /// await for image to be ready
    await precacheImage(NetworkImage(widget.imageUrl), context);
    setState(() {
      isLoading = false;
    });
    widget.onImageReady?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return widget.loadingWidget;
    }
    return Image.network(widget.imageUrl, fit: widget.fit);
  }
}
