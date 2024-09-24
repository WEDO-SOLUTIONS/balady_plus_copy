import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart' show Spacing, Stories;
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/features/stories/models/story_data.dart';

/// A row of stories displayed in a horizontal scrollable list.
class StoriesRow extends StatelessWidget {
  final List<StoryData> stories;
  final void Function(String storyId) onThumbnailPressed;

  /// Constructs a [StoriesRow] widget.
  ///
  /// The [onThumbnailPressed] callback is called when a story thumbnail is pressed.
  /// The [stories] list contains the data for each story.
  const StoriesRow({
    required this.onThumbnailPressed,
    required this.stories,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              width: constraints.maxWidth,
              height: min(constraints.maxHeight, 120),
              child: ScrollConfiguration(
                behavior: NoGlowingScrollBehavior(),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.$4x,
                  ),
                  itemCount: stories.length,
                  itemBuilder: (_, i) {
                    final story = stories[i];
                    return Stories(
                      key: ValueKey(story.storyId),
                      title: story.thumbnail?.title,
                      networkImage: story.thumbnail?.imageUrl,
                      onTap: () => onThumbnailPressed(story.storyId),
                      isWatched: story.isWatched,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: Spacing.$2x),
                ),
              ),
            ),
          ),
        ],
      );
}
