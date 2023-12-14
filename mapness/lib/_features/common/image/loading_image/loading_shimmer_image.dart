import 'package:flutter/material.dart';
import 'package:mapness/_features/common/image/loading_image/loading_image.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmerImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onImageReady;
  final BoxFit? fit;

  const LoadingShimmerImage({
    super.key,
    required this.imageUrl,
    this.onImageReady,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingImage(
      fit: fit,
      imageUrl: imageUrl,
      loadingWidget: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(color: Colors.grey),
      ),
      onImageReady: onImageReady,
    );
  }
}
