import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/stories/data/story_service.dart';
import 'package:mapness/_features/stories/presentation/story_refresh_button.dart';
import 'package:mapness/_features/stories/presentation/story_thumbnails.dart';
import 'package:mapness/_features/stories/stories.dart';

import '../common/providers/network_status.dart';

class StoriesWidget extends ConsumerStatefulWidget {
  const StoriesWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends ConsumerState<StoriesWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheFirstFrame();
  }

  void _precacheFirstFrame() {
    final storiesAsync = ref.read(storyServiceProvider);
    storiesAsync.whenData((data) {
      for (final story in data) {
        final firstFrame = story.frames.first;
        precacheImage(NetworkImage(firstFrame.imageUrl), context);
      }
    });
  }

  openStory(BuildContext context, String id) {
    Stories.showStoryById(context, id);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(networkStatusProvider, (previous, next) {
      if (previous == ConnectivityResult.none && next != previous) {
        ref.read(storyServiceProvider.notifier).refresh();
      }
    });

    final thumbnails = ref.watch(storyServiceProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: thumbnails.when(
        data: (data) => StoryThumbnails(
          onThumbnailPressed: (id) => openStory(context, id),

          /// arabic => reversed
          stories: data.reversed.toList(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => StoryRefreshButton(
          onPressed: () {
            ref.read(storyServiceProvider.notifier).refresh();
          },
        ),
      ),
    );
  }
}
