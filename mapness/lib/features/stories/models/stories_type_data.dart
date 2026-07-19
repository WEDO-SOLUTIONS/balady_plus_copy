import 'package:flutter/rendering.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stories/models/story_data.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';
import 'package:mapness/features/stories/models/story_frame_data.dart';
import 'package:mapness/features/stories/models/story_frame_theme_data.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/models/story_video_data.dart';

/// Represents the base class for different types of story data.
sealed class StoryTypedData {
  final List<StoryData> stories;
  final StoryTypes type;

  const StoryTypedData({
    required this.stories,
    required this.type,
  });

  /// Creates a [StoryTypedData] instance based on the given file.

  factory StoryTypedData.fromFile(String file) {
    final type = StoryTypes.fromFile(file);
    assert(type != null, 'Invalid story type. Must be one of ${StoryTypes.values}');
    return StoryTypedData.fromType(type!);
  }

  /// Creates a [StoryTypedData] instance based on the given type.
  factory StoryTypedData.fromType(StoryTypes type) => switch (type) {
    StoryTypes.onboarding => OnboardingStoryData(),
    StoryTypes.route => RouteStoryData(),
    StoryTypes.network => const NetworkStoryData(),
    StoryTypes.saudiDay => SaudiDayStoryData(),
    StoryTypes.mekkahBase => MekkahBaseStoryData(),
  };
}

/// Represents the story data for the [StoryTypes.route] type.
class RouteStoryData extends StoryTypedData {
  RouteStoryData()
    : super(
        type: StoryTypes.route,
        stories: [
          StoryData(
            storyId: 'route0',
            frames: [
              StoryFrameData(
                storyId: 'route1',
                imageUrl: 'assets/images/route_story_1.webp',
                isAssetImage: true,
                action: const NextStoryAction(),
              ),
              StoryFrameData(
                storyId: 'route2',
                imageUrl: 'assets/images/route_story_2.webp',
                isAssetImage: true,
                action: const NextStoryAction(),
              ),
              StoryFrameData(
                storyId: 'route3',
                imageUrl: 'assets/images/route_story_3.webp',
                isAssetImage: true,
                action: const NavigationFrameAction(
                  location: '/routing',
                  localeKey: 'try_now',
                ),
              ),
            ],
          ),
        ],
      );
}

/// Represents the story data for the [StoryTypes.onboarding] type.
class OnboardingStoryData extends StoryTypedData {
  static const theme = NetworkStoryThemeData(
    titleColor: Color(0xFF0C0C0D),
    descriptionColor: Color(0xFF0C0C0D),
  );

  OnboardingStoryData()
    : super(
        type: StoryTypes.onboarding,
        stories: [
          StoryData(
            storyId: 'onboarding0',
            frames: [
              StoryFrameData(
                storyId: 'onboarding1',
                imageUrl: 'assets/images/onboarding_story_1.webp',
                arabicImageUrl: 'assets/images/onboarding_story_1.webp',
                isAssetImage: true,
                networkTheme: theme,
              ),
              StoryFrameData(
                storyId: 'onboarding2',
                imageUrl: 'assets/images/onboarding_story_2.webp',
                arabicImageUrl: 'assets/images/onboarding_story_2.webp',
                isAssetImage: true,
                networkTheme: theme,
              ),
              StoryFrameData(
                storyId: 'onboarding3',
                imageUrl: 'assets/images/onboarding_story_3.webp',
                arabicImageUrl: 'assets/images/onboarding_story_3.webp',
                isAssetImage: true,
                networkTheme: theme,
                action: const NextStoryAction(localeKey: 'onboarding3Action'),
              ),
            ],
          ),
        ],
      );
}

class SaudiDayStoryData extends StoryTypedData {
  SaudiDayStoryData()
    : super(
        type: StoryTypes.saudiDay,
        stories: [
          StoryData(
            storyId: 'saudiDayId',
            frames: [
              StoryFrameData(
                storyId: 'saudiDay',
                imageUrl: Assets.images.saudiDaySplash.keyName,
                isAssetImage: true,
                action: const NextStoryAction(localeKey: 'saudiDayAction'),
              ),
            ],
          ),
        ],
      );
}

/// Represents the story data for the [StoryTypes.mekkahBase] type.
///
/// Uses a fullscreen video splash screen for the Makkah theme onboarding.
/// The video plays automatically and advances to the next story on completion.
class MekkahBaseStoryData extends StoryTypedData {
  /// Asset path for the Makkah splash video.
  ///
  /// Located in the root balady_plus assets folder.
  static const _splashVideoAsset = 'assets/balady-splashscreen.mp4';

  MekkahBaseStoryData()
    : super(
        type: StoryTypes.mekkahBase,
        stories: const [
          StoryData(
            storyId: 'mekkahBaseId',
            videos: [
              StoryVideoData.asset(_splashVideoAsset),
            ],
          ),
        ],
      );
}

/// Represents the story data for the [StoryTypes.network] type.
class NetworkStoryData extends StoryTypedData {
  const NetworkStoryData()
    : super(
        type: StoryTypes.network,
        stories: const [],
      );
}
