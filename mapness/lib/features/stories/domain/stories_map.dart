import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/core/colors/colors_v2/colors_v2.dart';
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
            imageUrl: ({required isArabic}) => 'assets/images/route_story_1.png',
            isWatched: false,
            isAssetImage: true,
            duration: 10,
            action: const LocaleKeyFrameAction(
              deeplinkUrl: 'next',
              action: StoryAction.next,
              titleLocaleKey: 'next',
              backgroundColor: NonThemeColor.color29,
              textStyle: StoryTextStyle(
                color: Colors.white,
              ),
            ),
            storyGradient: const LinearGradient(
              stops: [0, 0.8, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(0, 0, 0, 0.4),
                Color.fromRGBO(0, 0, 0, 0.06),
                Color.fromRGBO(0, 0, 0, 0),
              ],
            ),
          ),
          StoryFrameData(
            storyId: 'route2',
            title: 'أقصر طريق',
            description:
                'يقترح التنقل الذكي ما يصل إلى ثلاث طرق بالنظر إلى الوضع الحالي لحركة المرور. سيقترح أيضًا بالطرق البديلة عند تقاطع الطرق ',
            imageUrl: ({required isArabic}) => 'assets/images/route_story_2.png',
            isAssetImage: true,
            isWatched: false,
            duration: 10,
            action: const LocaleKeyFrameAction(
              deeplinkUrl: 'next',
              action: StoryAction.next,
              titleLocaleKey: 'next',
              backgroundColor: NonThemeColor.color29,
              textStyle: StoryTextStyle(
                color: Colors.white,
              ),
            ),
            storyGradient: const LinearGradient(
              stops: [0, 0.8, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(0, 0, 0, 0.4),
                Color.fromRGBO(0, 0, 0, 0.06),
                Color.fromRGBO(0, 0, 0, 0),
              ],
            ),
          ),
          StoryFrameData(
            storyId: 'route3',
            title: 'التركيز على طريقك',
            description: 'مساعدك الصوتي سيبقيك على اطلاع طوال رحلتك',
            imageUrl: ({required isArabic}) => 'assets/images/route_story_3.png',
            isWatched: false,
            isAssetImage: true,
            duration: 10,
            action: const LocaleKeyFrameAction(
              deeplinkUrl: 'route',
              action: StoryAction.close,
              titleLocaleKey: 'try_now',
              backgroundColor: NonThemeColor.color29,
              textStyle: StoryTextStyle(
                color: Colors.white,
              ),
            ),
            storyGradient: const LinearGradient(
              stops: [0, 0.8, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(0, 0, 0, 0.4),
                Color.fromRGBO(0, 0, 0, 0.06),
                Color.fromRGBO(0, 0, 0, 0),
              ],
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
          linearTrackColor: AppColor.white.withOpacity(0.1),
          animationColor: AppColor.white,
          closeButtonColor: AppColor.white.withOpacity(0.06),
          iconColor: AppColor.white,
        ),
        frames: [
          StoryFrameData(
            storyId: 'onboarding1',
            title: 'Balady is more than maps and services',
            description:
                'All the usual services, but also location search, company information, navigation and real-time traffic',
            imageUrl: ({required isArabic}) =>
                isArabic ? 'assets/images/onboarding_story_1_ar.png' : 'assets/images/onboarding_story_1_en.png',
            isWatched: false,
            isAssetImage: true,
            duration: 30,
            titleStyle: const StoryTextStyle(
              color: AppColor.white,
              fontSize: 30,
              height: 36 / 30,
            ),
            descriptionStyle: const StoryTextStyle(
              color: AppColor.white,
              fontSize: 16,
              height: 20 / 16,
            ),
            horizontalPadding: 35,
            action: const LocaleKeyFrameAction(
              deeplinkUrl: 'next',
              action: StoryAction.close,
              titleLocaleKey: 'about_routes',
              backgroundColor: AppColor.white,
              horizontalPadding: 24,
              verticalPadding: 24,
              textStyle: StoryTextStyle(
                color: DefaultColors.neutral990,
              ),
            ),
          ),
          StoryFrameData(
            storyId: 'onboarding2',
            title: 'Smart navigation for cars and pedestrians',
            description:
                'Search for places by address or name,\nplan routes and set off with voice guidance and traffic information',
            imageUrl: ({required isArabic}) =>
                isArabic ? 'assets/images/onboarding_story_2_ar.png' : 'assets/images/onboarding_story_2_en.png',
            isWatched: false,
            isAssetImage: true,
            duration: 30,
            titleStyle: const StoryTextStyle(
              color: AppColor.white,
              fontSize: 24,
              height: 30 / 24,
            ),
            descriptionStyle: const StoryTextStyle(
              color: AppColor.white,
              fontSize: 16,
              height: 20 / 16,
            ),
            horizontalPadding: 35,
            action: const LocaleKeyFrameAction(
              deeplinkUrl: 'next',
              action: StoryAction.close,
              titleLocaleKey: 'balady_features',
              backgroundColor: AppColor.white,
              horizontalPadding: 24,
              verticalPadding: 24,
              textStyle: StoryTextStyle(
                color: DefaultColors.neutral990,
              ),
            ),
          ),
          StoryFrameData(
            storyId: 'onboarding3',
            title: 'Take full advantage\nof Balady\'s capabilities',
            description: 'Get business license, send a claim\nand find investment opportunities',
            imageUrl: ({required isArabic}) =>
                isArabic ? 'assets/images/onboarding_story_3_ar.png' : 'assets/images/onboarding_story_3_en.png',
            isWatched: false,
            isAssetImage: true,
            duration: 30,
            titleStyle: const StoryTextStyle(
              color: AppColor.white,
              fontSize: 24,
              height: 30 / 24,
            ),
            descriptionStyle: const StoryTextStyle(
              color: AppColor.white,
              fontSize: 16,
              height: 20 / 16,
            ),
            horizontalPadding: 35,
            action: const LocaleKeyFrameAction(
              deeplinkUrl: '/bottomNavigation/services',
              action: StoryAction.next,
              titleLocaleKey: 'get_started',
              backgroundColor: AppColor.white,
              horizontalPadding: 24,
              verticalPadding: 24,
              textStyle: StoryTextStyle(
                color: DefaultColors.neutral990,
              ),
            ),
          ),
        ],
      ),
    ],
  };
}
