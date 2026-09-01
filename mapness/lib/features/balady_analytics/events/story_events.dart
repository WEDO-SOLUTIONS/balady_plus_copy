import 'package:mapness/features/balady_analytics/balady_analytics.dart';

/// Phase-1 stories events of the tracking plan (docs/analytics-tracking-plan.md).
///
/// Event names live here as string literals on purpose — this file is the
/// single source of truth for the stories event schema.
abstract final class StoryEvents {
  /// A story was opened and (possibly) watched. Fired once per story open —
  /// at close/leave time, so [completed] carries its final value.
  ///
  /// [completed] is true when the user watched through to the last frame
  /// (frames story: last frame shown; video story: last video finished or
  /// advanced past).
  static void storyViewed({required String storyId, required bool completed}) {
    BaladyAnalytics.instance.track(
      'story_viewed',
      properties: {
        'story_id': storyId,
        'completed': completed,
      },
    );
  }

  /// The CTA button inside a story frame was tapped. [target] identifies the
  /// service/screen/url the CTA leads to (in-app location path or external
  /// url, as configured in the story frame action).
  static void storyCtaTapped({required String storyId, required String target}) {
    BaladyAnalytics.instance.track(
      'story_cta_tapped',
      properties: {
        'story_id': storyId,
        'target': target,
      },
    );
  }
}
