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
  };
}
