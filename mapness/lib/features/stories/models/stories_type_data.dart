import 'package:mapness/features/stories/models/story_data.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';
import 'package:mapness/features/stories/models/story_frame_data.dart';

import 'package:mapness/features/stories/models/story_types.dart';

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
        StoryTypes.onboarding => const OnboardingStoryData(),
        StoryTypes.route => const RouteStoryData(),
        StoryTypes.network => const NetworkStoryData(),
      };
}

/// Represents the story data for the [StoryTypes.route] type.
class RouteStoryData extends StoryTypedData {
  const RouteStoryData()
      : super(
          type: StoryTypes.route,
          stories: const [
            StoryData(
              storyId: 'route0',
              frames: [
                StoryFrameData(
                  storyId: 'route1',
                  action: NextStoryAction(),
                ),
                StoryFrameData(
                  storyId: 'route2',
                  action: NextStoryAction(),
                ),
                StoryFrameData(
                  storyId: 'route3',
                  action: NavigationFrameAction(
                    location: 'route',
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
  const OnboardingStoryData()
      : super(type: StoryTypes.onboarding, stories: const [
          StoryData(
            storyId: 'onboarding0',
            frames: [
              StoryFrameData(
                storyId: 'onboarding1',
                imageUrl: 'assets/images/route_story_1.png',
                isAssetImage: true,
                action: NavigationFrameAction(
                  location: '/bottomNavBar/routing',
                  localeKey: 'build_route',
                ),
              ),
              StoryFrameData(
                storyId: 'onboarding2',
                imageUrl: 'assets/images/test_oboarding.png',
                fullscreenImage: false,
                isAssetImage: true,
                action: NavigationFrameAction(
                  location: '/bottomNavBar/routing',
                  localeKey: 'build_route',
                ),
              ),
              StoryFrameData(
                storyId: 'onboarding3',
                imageUrl: 'assets/images/test_oboarding.png',
                fullscreenImage: false,
                isAssetImage: true,
                action: NavigationFrameAction(
                  location: '/bottomNavBar/services',
                  localeKey: 'open_services',
                ),
              ),
            ],
          ),
        ]);
}

/// Represents the story data for the [StoryTypes.network] type.
class NetworkStoryData extends StoryTypedData {
  const NetworkStoryData()
      : super(
          type: StoryTypes.network,
          stories: const [],
        );
}
