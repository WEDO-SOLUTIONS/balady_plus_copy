import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/core/colors/colors_v2/colors_v2.dart';
import 'package:balady_uikit/core/colors/colors_v2/core/base.dart';
import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_data.dart';
import 'package:mapness/features/stories/domain/frame/story_text_style.dart';
import 'package:mapness/features/stories/domain/story_action.dart';
import 'package:mapness/features/stories/domain/story_data.dart';
import 'package:mapness/features/stories/domain/thumbnail/story_thumbnail_data.dart';

class StoriesMap {
  static final stories = {
    'route': [
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
              backgroundColor: NonThemeColor.color29,
              textStyle: StoryTextStyle(
                color: Colors.white,
              ),
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
              backgroundColor: NonThemeColor.color29,
              textStyle: StoryTextStyle(
                color: Colors.white,
              ),
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
              backgroundColor: NonThemeColor.color29,
              textStyle: StoryTextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ],
    'onboarding': [
      StoryData(
        storyId: 'onboarding0',
        thumbnail: StoryThumbnailData(
          title: 'Onboarding',
          imageUrl: '',
          backgroundColor: AppColor.black.withOpacity(0.1),
          animationColor: AppColor.black,
          closeButtonColor: BaseColors.neutral.withOpacity(0.1),
        ),
        frames: [
          StoryFrameData(
            storyId: 'onboarding1',
            title: 'Balady is a map centric app with business services',
            description: 'Places, navigation, traffic situation and governmental services',
            imageUrl: '',
            isWatched: false,
            isAssetImage: true,
            duration: 10,
            titleStyle: StoryTextStyle(
              color: AppColor.black,
              fontSize: 30,
              height: 36 / 30,
            ),
            descriptionStyle: StoryTextStyle(
              color: DefaultColors.neutral990,
              fontSize: 16,
              height: 20 / 16,
            ),
            horizontalPadding: 35,
          ),
          StoryFrameData(
            storyId: 'onboarding2',
            title: 'Navigation for cars and pedestrians ',
            description: 'Find places, build a route, enable voice over instructions and see live traffic',
            imageUrl: '',
            isWatched: false,
            isAssetImage: true,
            duration: 10,
            titleStyle: StoryTextStyle(
              color: AppColor.black,
              fontSize: 24,
              height: 30 / 24,
            ),
            descriptionStyle: StoryTextStyle(
              color: DefaultColors.neutral990,
              fontSize: 16,
              height: 20 / 16,
            ),
            horizontalPadding: 35,
            action: LocaleKeyFrameAction(
              deeplinkUrl: '/bottomNavBar/route',
              action: StoryAction.close,
              titleLocaleKey: 'build_route',
              backgroundColor: BaseColors.accent,
              horizontalPadding: 24,
              textStyle: StoryTextStyle(
                color: Colors.white,
              ),
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
            titleStyle: StoryTextStyle(
              color: AppColor.black,
              fontSize: 24,
              height: 30 / 24,
            ),
            descriptionStyle: StoryTextStyle(
              color: DefaultColors.neutral990,
              fontSize: 16,
              height: 20 / 16,
            ),
            horizontalPadding: 35,
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
            action: LocaleKeyFrameAction(
              deeplinkUrl: '/bottomNavBar/services',
              action: StoryAction.next,
              titleLocaleKey: 'open_services',
              backgroundColor: BaseColors.extra01,
              horizontalPadding: 24,
              textStyle: StoryTextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ],
  };
}
