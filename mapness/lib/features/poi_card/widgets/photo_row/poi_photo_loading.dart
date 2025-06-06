import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PoiPhotoRowLoading extends StatelessWidget {
  final BorderRadius borderRadius;
  const PoiPhotoRowLoading({
    required this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.grey,
          ),
        ),
      );
}
