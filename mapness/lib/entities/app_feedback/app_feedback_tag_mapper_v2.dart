import 'package:flutter/widgets.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

enum TagV2 {
  // Negative feedback tags (1-3 stars) - App errors for improvement

  incorrectAddress,
  missingAddress,
  missingLane,
  generalMapError,

  missingSpeedBump,
  wrongSpeedLimit,
  wrongDrivingDirections,
  wrongEta,

  appCrash,

  // Positive feedback tags (4-5 stars) - App features for positioning

  threeDExperience,
  localKnowledge,
  discoveringPlaces,

  indoorNavigation,
  fastRoadUpdates,
  accuracy,
  speedAlerts,

  userFriendly,
  generalSatisfaction,
}

enum TagGroupType {
  errorsOnMap,
  roadErrors,
  commonMistake,
  mapAndContent,
  navigationAndRoutes,
  overallImpression,
}

class TagGroup {
  final List<TagV2> tags;
  final TagGroupType type;

  TagGroup({
    required this.tags,
    required this.type,
  });
}

class AppFeedbackTagMapperV2 {
  AppFeedbackTagMapperV2._();

  static List<TagGroup> getTags(int rating) => switch (rating) {
        1 || 2 || 3 => [
            // Negative feedback for app improvement
            TagGroup(type: TagGroupType.errorsOnMap, tags: [
              TagV2.incorrectAddress,
              TagV2.missingAddress,
              TagV2.missingLane,
              TagV2.generalMapError,
            ]),
            TagGroup(type: TagGroupType.roadErrors, tags: [
              TagV2.missingSpeedBump,
              TagV2.wrongSpeedLimit,
              TagV2.wrongDrivingDirections,
              TagV2.wrongEta,
            ]),
            TagGroup(type: TagGroupType.commonMistake, tags: [
              TagV2.appCrash,
            ]),
          ],
        4 || 5 => [
            // Positive feedback for app positioning
            TagGroup(type: TagGroupType.mapAndContent, tags: [
              TagV2.threeDExperience,
              TagV2.localKnowledge,
              TagV2.discoveringPlaces,
            ]),
            TagGroup(type: TagGroupType.navigationAndRoutes, tags: [
              TagV2.indoorNavigation,
              TagV2.fastRoadUpdates,
              TagV2.accuracy,
              TagV2.speedAlerts,
            ]),
            TagGroup(type: TagGroupType.overallImpression, tags: [
              TagV2.userFriendly,
              TagV2.generalSatisfaction,
            ]),
          ],
        _ => [],
      };

  /// Because in task requirements, the tags must send to backend localized in English
  static String getSourceTagText(TagV2 tag) {
    final l10n = lookupAppLocalizations(const Locale('en'));
    return getLocalizedText(l10n, tag);
  }

  static String getLocalizedTitle(AppLocalizations l10n, TagGroupType type) {
    switch (type) {
      case TagGroupType.errorsOnMap:
        return l10n.feedbackTagV2ErrorsOnMap;
      case TagGroupType.roadErrors:
        return l10n.feedbackTagV2RoadErrors;
      case TagGroupType.commonMistake:
        return l10n.feedbackTagV2CommonMistake;
      case TagGroupType.mapAndContent:
        return l10n.feedbackTagV2MapsAndContent;
      case TagGroupType.navigationAndRoutes:
        return l10n.feedbackTagV2NavigationAndRoutes;
      case TagGroupType.overallImpression:
        return l10n.feedbackTagV2OverallImpression;
    }
  }

  static String getLocalizedText(AppLocalizations l10n, TagV2 tag) {
    switch (tag) {
      // Negative feedback tags
      case TagV2.incorrectAddress:
        return l10n.feedbackTagV2IncorrectAddress;
      case TagV2.missingAddress:
        return l10n.feedbackTagV2MissingAddress;
      case TagV2.missingLane:
        return l10n.feedbackTagV2MissingLane;
      case TagV2.generalMapError:
        return l10n.feedbackTagV2GeneralMapError;

      case TagV2.missingSpeedBump:
        return l10n.feedbackTagV2MissingSpeedBump;
      case TagV2.wrongSpeedLimit:
        return l10n.feedbackTagV2WrongSpeedLimit;
      case TagV2.wrongDrivingDirections:
        return l10n.feedbackTagV2WrongDrivingDirections;
      case TagV2.wrongEta:
        return l10n.feedbackTagV2WrongEta;

      case TagV2.appCrash:
        return l10n.feedbackTagV2AppCrash;

      // Positive feedback tags

      case TagV2.threeDExperience:
        return l10n.feedbackTagV2ThreeDExperience;
      case TagV2.localKnowledge:
        return l10n.feedbackTagV2LocalKnowledge;
      case TagV2.discoveringPlaces:
        return l10n.feedbackTagV2DiscoveringPlaces;

      case TagV2.indoorNavigation:
        return l10n.feedbackTagV2IndoorNavigation;
      case TagV2.fastRoadUpdates:
        return l10n.feedbackTagV2FastRoadUpdates;
      case TagV2.accuracy:
        return l10n.feedbackTagV2Accuracy;
      case TagV2.speedAlerts:
        return l10n.feedbackTagV2SpeedAlerts;

      case TagV2.userFriendly:
        return l10n.feedbackTagV2UserFriendly;
      case TagV2.generalSatisfaction:
        return l10n.feedbackTagV2GeneralSatisfaction;
    }
  }
}
