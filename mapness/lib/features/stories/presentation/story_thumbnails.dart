import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapness/features/stories/data/thumbnail/story_thumbnail_data.dart';
import 'package:mapness/features/stories/presentation/thumbnails/story_thumbnail_label.dart';
import 'package:mapness/features/stories/presentation/thumbnails/story_thumbnail_widget.dart';

class StoryThumbnails extends StatelessWidget {
  final List<StoryThumbnailData> stories;
  final void Function(int index) onThumbnailPressed;

  const StoryThumbnails({
    super.key,
    required this.onThumbnailPressed,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const StoryThumbnailLabel(title: 'جديدنا'),
            SizedBox(
              width: constraints.maxWidth,
              height: min(constraints.maxHeight, 120),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: stories.length,
                itemBuilder: (context, i) => Padding(
                  padding: EdgeInsets.only(right: i == 0 ? 16 : 0, left: i == stories.length - 1 ? 16 : 0),
                  child: StoryThumbnailWidget(
                    thumbnail: stories[i],
                    onPress: () => onThumbnailPressed(i),
                  ),
                ),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
              ),
            ),
          ],
        );
      },
    );
  }
}
