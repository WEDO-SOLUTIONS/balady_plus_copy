import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';

extension WorkingHoursStrings on WorkingHours {
  // referenced https://urbi-team.youtrack.cloud/issue/BSA-2556
  String closedStatus(DateTime now, AppLocalizations appLocalizations) {
    if (isTemporaryClosed) {
      return appLocalizations.temporarilyClosed;
    }

    if (isClosed(now)) {
      final nextOpen = this.nextOpen(now);
      if (isBreak(now)) {
        return '${appLocalizations.breakUntil} ${nextOpen.hoursAndMinutes.formatHHmm}';
      }

      if (isToday(now, nextOpen) || isTomorrow(now, nextOpen)) {
        return '${appLocalizations.closedUntill} ${nextOpen.hoursAndMinutes.formatHHmm}';
      } else {
        return appLocalizations.closed;
      }
    }

    final closesIn = this.closesIn(now);

    if (closesIn <= const Duration(minutes: 30)) {
      return '${appLocalizations.closesIn}${closesIn.inMinutes} ${appLocalizations.minutes}';
    }

    // Mean Working now, but this function is only for closed status
    return '';
  }
}

extension on Duration {
  String get formatHHmm {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(inHours)}:${twoDigits(inMinutes.remainder(60))}';
  }
}
