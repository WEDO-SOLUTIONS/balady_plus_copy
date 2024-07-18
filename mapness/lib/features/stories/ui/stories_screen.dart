import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/stories/models/stories_type_data.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/ui/stories_fullscreen.dart';
import 'package:mapness/features/stories/ui/story_type_provider.dart';

class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({
    required this.type,
    this.onClose,
    this.initialStoryId,
    super.key,
  });

  final StoryTypes type;
  final VoidCallback? onClose;
  final String? initialStoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyData = StoryTypeData.fromType(type);
    return StoryTypeProvider(
      type: type,
      child: Material(
        color: Colors.white,
        child: type == StoryTypes.onboarding
            ? StoriesFullscreen.onboadring(
                initialStoryId: initialStoryId ?? storyData.stories.first.storyId,
                onClose: () {
                  onClose?.call();
                  context.pop();
                },
                // TODO: implement handleDeeplink
                handleDeeplink: (storyId) {},
                localStoryType: type,
              )
            : StoriesFullscreen.story(
                initialStoryId: storyData.stories.first.storyId,
                onClose: () {
                  onClose?.call();
                  context.pop();
                },
                // TODO: implement handleDeeplink
                handleDeeplink: (storyId) {},
              ),
      ),
    );
  }
}
