import 'package:mapness/features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';

DateTime saudiTimeNow() => DateTime.now();

extension WorkingHoursStrings on WorkingHours {
  String closedStatus(
    DateTime now,
    AppLocalizations appLocalizations, {
    Duration soonThreshold = kDefaultWorkingHoursSoonThreshold,
  }) {
    final currentStatus = statusType(now, soonThreshold: soonThreshold);

    switch (currentStatus) {
      case WorkingHoursStatusType.hidden:
        return '';
      case WorkingHoursStatusType.open24Hours:
        return appLocalizations.open24Hours;
      case WorkingHoursStatusType.open:
        final closesAt = closeDateTime(now);
        if (closesAt == null) {
          return '';
        }
        return '${appLocalizations.openUntil} ${closesAt.formatHHmm}';
      case WorkingHoursStatusType.openSoon:
        final remaining = closesIn(now);
        if (remaining > const Duration(hours: 1)) {
          return _buildClosesInHoursAndMinutesStatus(remaining, appLocalizations);
        }
        if (remaining.inMinutes > 1) {
          return '${appLocalizations.closesIn}${remaining.inMinutes} ${appLocalizations.minutes}';
        }
        return appLocalizations.closed;
      case WorkingHoursStatusType.closed:
      case WorkingHoursStatusType.closedSoon:
        return _buildClosedUntilStatus(
          now: now,
          appLocalizations: appLocalizations,
        );
    }
  }

  String _buildClosesInHoursAndMinutesStatus(Duration remaining, AppLocalizations appLocalizations) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);

    if (minutes == 0) {
      return '${appLocalizations.closesIn}$hours ${appLocalizations.hoursShort}';
    }

    return '${appLocalizations.closesIn}$hours ${appLocalizations.hoursShort} '
        '$minutes ${appLocalizations.minutesShort}';
  }

  String _buildClosedUntilStatus({
    required DateTime now,
    required AppLocalizations appLocalizations,
  }) {
    final opensAt = nextOpenDateTime(now);
    if (opensAt == null) {
      return appLocalizations.closed;
    }

    final dayPrefix = _dayPrefix(
      now: now,
      value: opensAt,
      appLocalizations: appLocalizations,
    );
    return '${appLocalizations.closedUntil} $dayPrefix${opensAt.formatHHmm}'.trim();
  }

  String _dayPrefix({
    required DateTime now,
    required DateTime value,
    required AppLocalizations appLocalizations,
  }) {
    if (_isSameDate(now, value)) {
      return '';
    }
    if (_isTomorrowDate(now, value)) {
      return '${appLocalizations.tomorrow} ';
    }
    return '${value.weekday.weekDayNameShort(appLocalizations)} ';
  }
}

extension DurationFormatExt on Duration {
  String get formatHHmm {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(inHours)}:${twoDigits(inMinutes.remainder(60))}';
  }
}

extension DateTimeFormatExt on DateTime {
  String get formatHHmm {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(hour)}:${twoDigits(minute)}';
  }
}

bool _isSameDate(DateTime first, DateTime second) =>
    first.year == second.year && first.month == second.month && first.day == second.day;

bool _isTomorrowDate(DateTime now, DateTime other) {
  final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  return tomorrow.year == other.year && tomorrow.month == other.month && tomorrow.day == other.day;
}
