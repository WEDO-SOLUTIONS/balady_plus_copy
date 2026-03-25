import 'package:mapness/features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';

const Duration kSaudiTimeUtcOffset = Duration(hours: 3);

DateTime saudiTimeNow() => DateTime.now().toUtc().add(kSaudiTimeUtcOffset);

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
        if (remaining.inMinutes > 1) {
          return '${appLocalizations.closesIn}${remaining.inMinutes} ${appLocalizations.minutes}';
        }
        return appLocalizations.closed;
      case WorkingHoursStatusType.closed:
      case WorkingHoursStatusType.closedSoon:
        if (isBreak(now)) {
          final breakEndsAt = nextOpenDateTime(now);
          if (breakEndsAt != null) {
            return '${appLocalizations.breakUntil} ${breakEndsAt.formatHHmm}';
          }
        }
        return _buildClosedUntilStatus(
          now: now,
          appLocalizations: appLocalizations,
        );
    }
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
