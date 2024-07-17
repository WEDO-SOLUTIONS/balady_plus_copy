import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stories/models/stories_map.dart';
import 'package:mapness/features/stories/models/story_theme_data.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/ui/stories_fullscreen.dart';

class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({
    required this.type,
    super.key,
  });

  final StoryTypes type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyData = StoryTypeData.fromType(type);
    return Material(
      color: Colors.white,
      child: StoryTheme(
        themeData: StoryThemeData.typedFromTheme(
          type,
          colorTheme: context.colorsV2,
          textTheme: context.textStyleV3,
        ),
        child: type == StoryTypes.onboarding
            ? StoriesFullscreen.onboadring(
                initialStoryId: storyData.stories.first.storyId,
                // TODO: implement onClose
                onClose: () => Navigator.of(context).pop(),
                // TODO: implement handleDeeplink
                handleDeeplink: (storyId) {},
                localStoryType: type,
              )
            : StoriesFullscreen.story(
                initialStoryId: storyData.stories.first.storyId,
                onClose: () => Navigator.of(context).pop(),
                // TODO: implement handleDeeplink
                handleDeeplink: (storyId) {},
              ),
      ),
    );
  }
}

class StoryTheme extends InheritedWidget {
  const StoryTheme({
    required super.child,
    required this.themeData,
    super.key,
  });

  final StoryThemeData themeData;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static StoryThemeData of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<StoryTheme>()!.themeData;
}
