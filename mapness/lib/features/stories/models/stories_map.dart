import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_action.dart';
import 'package:mapness/features/stories/models/story_data.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';
import 'package:mapness/features/stories/models/story_frame_data.dart';
import 'package:mapness/features/stories/models/story_thumbnail_data.dart';
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
    assert(type == null, 'Invalid story type. Must be one of ${StoryTypes.values}');
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
              thumbnail: StoryThumbnailData(
                title: 'Route',
                imageUrl: '',
              ),
              frames: [
                StoryFrameData(
                  storyId: 'route1',
                  title: 'ماذا يمكن أن يفعل التنقل الذكي ؟',
                  description: 'بعض المزايا والحيل لميزة التنقل الذكي...',
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
                  title: 'أقصر طريق',
                  description:
                      'يقترح التنقل الذكي ما يصل إلى ثلاث طرق بالنظر إلى الوضع الحالي لحركة المرور. سيقترح أيضًا بالطرق البديلة عند تقاطع الطرق ',
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
                  title: 'التركيز على طريقك',
                  description: 'مساعدك الصوتي سيبقيك على اطلاع طوال رحلتك',
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
            thumbnail: const StoryThumbnailData(
              title: 'Onboarding',
            ),
            frames: [
              const StoryFrameData(
                storyId: 'onboarding1',
                title: 'Balady is a map centric app with business services',
                description: 'Places, navigation, traffic situationand governmental services',
                imageUrl: '',
                isWatched: false,
                isAssetImage: true,
                duration: 10,
              ),
              const StoryFrameData(
                storyId: 'onboarding2',
                title: 'Navigation for cars and pedestrians ',
                description: 'Find places, build a route, enable voice over instructions and see live traffic',
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
                title: 'You can access all governmental services',
                description: 'Get business license, send a claim,  find investment opportunities ',
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
