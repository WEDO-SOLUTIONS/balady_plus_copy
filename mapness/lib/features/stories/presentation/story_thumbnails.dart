import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapness/features/common/animated/animated_scroll_view_item.dart';
import 'package:mapness/features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/features/stories/domain/thumbnail/story_thumbnail_data.dart';
import 'package:mapness/features/stories/presentation/thumbnails/story_thumbnail_widget.dart';

class StoryThumbnails extends StatelessWidget {
  final List<StoryThumbnailData> thumbnails;
  final void Function(String storyId) onThumbnailPressed;

  const StoryThumbnails({
    super.key,
    required this.onThumbnailPressed,
    required this.thumbnails,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const StoryThumbnailLabel(title: 'جديدنا'),
            SizedBox(
              width: constraints.maxWidth,
              height: min(constraints.maxHeight, 120),
              child: ScrollConfiguration(
                behavior: NoGlowingScrollBehavior(),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: thumbnails.length,
                  itemBuilder: (context, i) => AnimatedScrollViewItem(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: i == 0 ? 16 : 0,
                          left: i == thumbnails.length - 1 ? 16 : 0),
                      child: StoryThumbnailWidget(
                        thumbnail: thumbnails[i],
                        onPress: () =>
                            onThumbnailPressed(thumbnails[i].storyId),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
