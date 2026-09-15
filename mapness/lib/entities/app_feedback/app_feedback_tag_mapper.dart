import 'package:flutter/widgets.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
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
  Set<Tag> getTags(int rating, {required bool isRtl}) => switch (rating) {
    1 || 2 =>
      isRtl
          ? {
              Tag.badDirections,
              Tag.parkingProblems,
              Tag.poorDesign,
              Tag.poorTraffic,
              Tag.wrongArrivalTime,
              Tag.location,
            }
          : {
              Tag.badDirections,
              Tag.location,
              Tag.poorTraffic,
              Tag.poorDesign,
              Tag.parkingProblems,
              Tag.wrongArrivalTime,
            },
    3 =>
      isRtl
          ? {
              Tag.poorTraffic,
              Tag.wrongArrivalTime,
              Tag.poorDesign,
              Tag.easyToUse,
              Tag.location,
            }
          : {
              Tag.poorTraffic,
              Tag.wrongArrivalTime,
              Tag.poorDesign,
              Tag.badDirections,
              Tag.location,
            },
    4 =>
      isRtl
          ? {
              Tag.easyToUse,
              Tag.helpfulDirections,
              Tag.niceDesign,
              Tag.goodNavigation,
              Tag.traffic,
            }
          : {
              Tag.easyToUse,
              Tag.helpfulDirections,
              Tag.parking,
              Tag.niceDesign,
              Tag.goodNavigation,
            },
    5 =>
      isRtl
          ? {
              Tag.arrivalTime,
              Tag.goodNavigation,
              Tag.greatDesign,
              Tag.easyToUse,
              Tag.parking,
            }
          : {
              Tag.arrivalTime,
              Tag.goodNavigation,
              Tag.parking,
              Tag.easyToUse,
              Tag.greatDesign,
            },
    _ => {},
  };

  static String getIconByTag(Tag tag) => switch (tag) {
    Tag.badDirections || Tag.wrongDirections || Tag.helpfulDirections => Assets.icons.svg.tagDirections.keyName,
    Tag.locationProblems || Tag.location => Assets.icons.svg.tagGps.keyName,
    Tag.poorTraffic || Tag.traffic => Assets.icons.svg.tagTraffic.keyName,
    Tag.wrongArrivalTime || Tag.arrivalTime => Assets.icons.svg.tagArrival.keyName,
    Tag.poorDesign || Tag.design || Tag.niceDesign || Tag.greatDesign => Assets.icons.svg.tagDesign.keyName,
    Tag.easyToUse => Assets.icons.svg.tagEasyToUse.keyName,
    Tag.goodNavigation => Assets.icons.svg.tagNavi.keyName,
    Tag.parkingProblems || Tag.parking => Assets.icons.svg.tagParking.keyName,
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
