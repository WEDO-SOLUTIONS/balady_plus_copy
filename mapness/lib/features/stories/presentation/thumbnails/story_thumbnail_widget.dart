import 'package:flutter/material.dart';
import 'package:mapness/core/common/image/loading_image/loading_shimmer_image.dart';
import 'package:mapness/features/stories/data/thumbnail/story_thumbnail_data.dart';

class StoryThumbnailWidget extends StatelessWidget {
  final StoryThumbnailData thumbnail;
  final VoidCallback onPress;

  const StoryThumbnailWidget({super.key, required this.thumbnail, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: AspectRatio(
        aspectRatio: 98 / 112,
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2, color: Color(0xFF1BA135)),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.50, color: const Color(0x4C898989)),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  // TODO: avoid cliprrect
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: LoadingShimmerImage(imageUrl: thumbnail.imageUrl),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                bottom: 12,
                child: Text(
                  thumbnail.title,
                  // TODO: move to theme
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'TheSansArab',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.22,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
