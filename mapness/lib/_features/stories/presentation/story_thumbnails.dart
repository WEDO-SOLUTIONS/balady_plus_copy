import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapness/_features/common/animated/animated_scroll_view_item.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/_features/stories/domain/story_data.dart';
import 'package:mapness/_features/stories/presentation/thumbnails/story_thumbnail_widget.dart';

class StoryThumbnails extends StatelessWidget {
  final List<StoryData> stories;
  final void Function(String storyId) onThumbnailPressed;

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
            // const StoryThumbnailLabel(title: 'جديدنا'),
            SizedBox(
              width: constraints.maxWidth,
              height: min(constraints.maxHeight, 120),
              child: ScrollConfiguration(
                behavior: NoGlowingScrollBehavior(),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount: stories.length,
                  itemBuilder: (context, i) {
                    final story = stories[i];
                    return AnimatedScrollViewItem(
                      key: ValueKey(story.storyId),
                      child: StoryThumbnailWidget(
                        // thumbnail: story,
                        onPress: () => onThumbnailPressed(story.storyId),
                        imageUrl: story.thumbnail.imageUrl,
                        isWatched: story.isViewed,
                        title: story.thumbnail.title,
                      ),
                    );
                  },
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
