import 'package:flutter/widgets.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

enum Tag {
  badDirections,
  locationProblems,
  poorTraffic,
  wrongArrivalTime,
  traffic,
  design,
  wrongDirections,
  easyToUse,
  helpfulDirections,
  niceDesign,
  arrivalTime,
  goodNavigation,
  greatDesign,
  parkingProblems,
  poorDesign,
  location,
  parking,
}

class AppFeedbackTagMapper {
  Set<Tag> getTags(int rating) => switch (rating) {
        1 || 2 => {
            Tag.badDirections,
            Tag.locationProblems,
            Tag.poorTraffic,
            Tag.wrongArrivalTime,
            Tag.poorDesign,
            Tag.parkingProblems,
          },
        3 => {
            Tag.poorTraffic,
            Tag.wrongArrivalTime,
            Tag.poorDesign,
            Tag.badDirections,
            Tag.location,
          },
        4 => {
            Tag.easyToUse,
            Tag.helpfulDirections,
            Tag.niceDesign,
            Tag.goodNavigation,
          },
        5 => {
            Tag.arrivalTime,
            Tag.goodNavigation,
            Tag.parking,
            Tag.easyToUse,
            Tag.greatDesign,
          },
        _ => {},
      };

  /// Because in task requirements, the tags must send to backend localized in English
  static String getSourceTagText(Tag tag) {
    final l10n = lookupAppLocalizations(const Locale('en'));
    return getLocalizedText(l10n, tag);
  }

  static String getLocalizedText(AppLocalizations l10n, Tag tag) {
    switch (tag) {
      case Tag.badDirections:
        return l10n.feedbackTagBadDirections;
      case Tag.locationProblems:
        return l10n.feedbackTagLocationProblems;
      case Tag.poorTraffic:
        return l10n.feedbackTagPoorTraffic;
      case Tag.wrongArrivalTime:
        return l10n.feedbackTagWrongArrivalTime;
      case Tag.traffic:
        return l10n.feedbackTagTraffic;
      case Tag.design:
        return l10n.feedbackTagDesign;
      case Tag.wrongDirections:
        return l10n.feedbackTagWrongDirections;
      case Tag.easyToUse:
        return l10n.feedbackTagEasyToUse;
      case Tag.helpfulDirections:
        return l10n.feedbackTagHelpfulDirections;
      case Tag.niceDesign:
        return l10n.feedbackTagNiceDesign;
      case Tag.arrivalTime:
        return l10n.feedbackTagArrivalTime;
      case Tag.goodNavigation:
        return l10n.feedbackTagGoodNavigation;
      case Tag.greatDesign:
        return l10n.feedbackTagGreatDesign;
      case Tag.parkingProblems:
        return l10n.feedbackTagParkingProblems;
      case Tag.poorDesign:
        return l10n.feedbackTagPoorDesign;
      case Tag.location:
        return l10n.feedbackTagLocation;
      case Tag.parking:
        return l10n.feedbackTagParking;
    }
  }
}
