import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_action.dart';
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
                  imageUrl: 'assets/images/route_story_1.png',
                  isWatched: false,
                  isAssetImage: true,
                  duration: 10,
                  action: LocaleKeyFrameAction(
                    deeplinkUrl: 'next',
                    action: StoryAction.next,
                    titleLocaleKey: 'next',
                  ),
                ),
                StoryFrameData(
                  storyId: 'route2',
                  imageUrl: 'assets/images/route_story_2.png',
                  isAssetImage: true,
                  isWatched: false,
                  duration: 10,
                  action: LocaleKeyFrameAction(
                    deeplinkUrl: 'next',
                    action: StoryAction.next,
                    titleLocaleKey: 'next',
                  ),
                ),
                StoryFrameData(
                  storyId: 'route3',
                  imageUrl: 'assets/images/route_story_3.png',
                  isWatched: false,
                  isAssetImage: true,
                  duration: 10,
                  action: LocaleKeyFrameAction(
                    deeplinkUrl: 'route',
                    action: StoryAction.close,
                    titleLocaleKey: 'try_now',
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
          StoryData(
            storyId: 'onboarding0',
            frames: [
              const StoryFrameData(
                storyId: 'onboarding1',
                imageUrl: '',
                isWatched: false,
                isAssetImage: true,
                duration: 10,
              ),
              const StoryFrameData(
                storyId: 'onboarding2',
                imageUrl: '',
                isWatched: false,
                isAssetImage: true,
                duration: 10,
                action: LocaleKeyFrameAction(
                  deeplinkUrl: '/bottomNavBar/route',
                  action: StoryAction.close,
                  titleLocaleKey: 'build_route',
                ),
              ),
              StoryFrameData(
                storyId: 'onboarding3',
                imageUrl: '',
                isWatched: false,
                isAssetImage: true,
                duration: 10,
                additionalContent: (context, onActionPressed) => [
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      onActionPressed?.call(
                        DeeplinkStoryFrameAction(deeplinkUrl: '/bottomNavBar/services/snap_and_send'),
                      );
                    },
                    child: const ColoredBox(
                      color: Colors.grey,
                      child: SizedBox(
                        height: 168,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                action: const LocaleKeyFrameAction(
                  deeplinkUrl: '/bottomNavBar/services',
                  action: StoryAction.next,
                  titleLocaleKey: 'open_services',
                ),
              ),
            ],
          ),
        ]);
}
