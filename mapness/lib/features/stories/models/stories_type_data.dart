import 'package:mapness/features/stories/models/story_data.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';
import 'package:mapness/features/stories/models/story_frame_data.dart';

import 'package:mapness/features/stories/models/story_types.dart';

sealed class StoryTypeData {
  final List<StoryData> stories;
  final StoryTypes type;

  const StoryTypeData({
    required this.stories,
    required this.type,
  });

  factory StoryTypeData.fromFile(String file) {
    final type = StoryTypes.fromFile(file);
    assert(type != null, 'Invalid story type. Must be one of ${StoryTypes.values}');
    return StoryTypeData.fromType(type!);
  }
  factory StoryTypeData.fromType(StoryTypes type) => switch (type) {
        StoryTypes.onboarding => OnboardingStoryData(),
        StoryTypes.route => RouteStoryData(),
      };
}

class RouteStoryData extends StoryTypeData {
  RouteStoryData()
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

class OnboardingStoryData extends StoryTypeData {
  OnboardingStoryData()
      : super(type: StoryTypes.onboarding, stories: [
          const StoryData(
            storyId: 'onboarding0',
            frames: [
              StoryFrameData(
                storyId: 'onboarding1',
                imageUrl: 'assets/images/route_story_1.png',
                action: NavigationFrameAction(
                  location: '/bottomNavBar/routing',
                  localeKey: 'build_route',
                ),
              ),
              StoryFrameData(
                storyId: 'onboarding2',
                imageUrl: 'assets/images/test_oboarding.png',
                action: NavigationFrameAction(
                  location: '/bottomNavBar/routing',
                  localeKey: 'build_route',
                ),
              ),
              StoryFrameData(
                storyId: 'onboarding3',
                imageUrl: 'assets/images/test_oboarding.png',
                action: NavigationFrameAction(
                  location: '/bottomNavBar/services',
                  localeKey: 'open_services',
                ),
              ),
            ],
          ),
        ]);
}
