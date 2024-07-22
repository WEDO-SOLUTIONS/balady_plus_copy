import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/stories/models/stories_type_data.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/providers/story_service.dart';
import 'package:mapness/features/stories/ui/stories_fullscreen.dart';
import 'package:mapness/features/stories/ui/story_args_provider.dart';

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
    final storyData = StoryTypedData.fromType(type);
    void _onClose() {
      onClose?.call();
      ref.read(storyServiceProvider.notifier).resumeUpdate();
      context.pop();
    }

    return StoryArgsProvider(
      type: type,
      onClose: _onClose,
      child: Material(
        child: Directionality(
          textDirection: Directionality.of(context),
          child: StoriesFullscreen(
            initialStoryId: initialStoryId ?? storyData.stories.first.storyId,
          ),
        ),
      ),
    );
  }
}
