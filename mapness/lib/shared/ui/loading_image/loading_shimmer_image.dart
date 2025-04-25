import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/loading_image/loading_image.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmerImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onImageReady;
  final BoxFit? fit;
  final bool? isAssetImg;
  final File? file;
  final void Function(String name, {bool? isAsset})? onImageTap;

  const LoadingShimmerImage({
    required this.imageUrl,
    super.key,
    this.onImageReady,
    this.fit,
    this.onImageTap,
    this.isAssetImg,
    this.file,
  });

  @override
  Widget build(BuildContext context) => LoadingImage(
        onImageTap: onImageTap,
        fit: fit,
        imageUrl: imageUrl,
        isAssetImg: isAssetImg,
        file: file,
        loadingWidget: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(color: Colors.grey),
        ),
        filterQuality: FilterQuality.high,
        onImageReady: onImageReady,
      );
}
