import 'package:flutter/material.dart';
import 'package:mapness/_features/common/image/loading_image/loading_shimmer_image.dart';

class IwishPhotosRow extends StatelessWidget {
  final List<String> photos;

  const IwishPhotosRow({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == photos.length - 1 ? 12 : 0,
              right: index == 0 ? 12 : 0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                key: ValueKey(photos[index]),
                aspectRatio: 1,
                child: LoadingShimmerImage(
                  imageUrl: photos[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: photos.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
      ),
    );
  }
}
