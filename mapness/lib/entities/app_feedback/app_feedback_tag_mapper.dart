import 'package:mapness/l10n/generated/app_localizations.dart';

class AppFeedbackTagMapper {
  Set<String> getTags(int rating) => switch (rating) {
        1 || 2 => {
            'Bad Directions',
            'Location Problems',
            'Poor Traffic',
            'Wrong Arrival Time',
          },
        3 => {
            'Traffic',
            'Wrong Arrival Time',
            'Design',
            'Wrong Directions',
          },
        4 => {
            'Easy to Use',
            'Helpful Directions',
            'Nice Design',
          },
        5 => {
            'Arrival Time',
            'Good Navigation',
            'Easy to Use',
            'Great Design',
          },
        _ => {}
      };

  String getLocalizedText(AppLocalizations l10n, String tag) {
    switch (tag) {
      case 'Bad Directions':
        return l10n.feedbackTagBadDirections;
      case 'Location Problems':
        return l10n.feedbackTagLocationProblems;
      case 'Poor Traffic':
        return l10n.feedbackTagPoorTraffic;
      case 'Wrong Arrival Time':
        return l10n.feedbackTagWrongArrivalTime;
      case 'Traffic':
        return l10n.feedbackTagTraffic;
      case 'Design':
        return l10n.feedbackTagDesign;
      case 'Wrong Directions':
        return l10n.feedbackTagWrongDirections;
      case 'Easy to Use':
        return l10n.feedbackTagEasyToUse;
      case 'Helpful Directions':
        return l10n.feedbackTagHelpfulDirections;
      case 'Nice Design':
        return l10n.feedbackTagNiceDesign;
      case 'Arrival Time':
        return l10n.feedbackTagArrivalTime;
      case 'Good Navigation':
        return l10n.feedbackTagGoodNavigation;
      case 'Great Design':
        return l10n.feedbackTagGreatDesign;
      default:
        return tag;
    }
  }
}
