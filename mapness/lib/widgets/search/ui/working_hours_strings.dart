import 'package:mapness/features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';

DateTime saudiTimeNow() => DateTime.now();

extension WorkingHoursStrings on WorkingHours {
  String closedStatus(
    DateTime now,
    AppLocalizations appLocalizations, {
    Duration soonThreshold = kDefaultWorkingHoursSoonThreshold,
  }) => appLocalizations.digits(
    _closedStatus(now, appLocalizations, soonThreshold: soonThreshold),
  );

  String _closedStatus(
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
        final prefix = isBreakUpcoming(now) ? appLocalizations.breakIn : appLocalizations.closesIn;
        if (remaining > const Duration(hours: 1)) {
          return _buildRemainingHoursAndMinutesStatus(prefix, remaining, appLocalizations);
        }
        if (remaining.inMinutes > 1) {
          return '${prefix.trim()} ${remaining.inMinutes} ${appLocalizations.minutesShort}';
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

  String _buildRemainingHoursAndMinutesStatus(
    String prefix,
    Duration remaining,
    AppLocalizations appLocalizations,
  ) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);

    if (minutes == 0) {
      return '${prefix.trim()} $hours ${appLocalizations.hoursShort}';
    }

    return '${prefix.trim()} $hours ${appLocalizations.hoursShort} '
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

    return '$dayPrefix${opensAt.formatHHmm}'.trim();
  }

  String _dayPrefix({
    required DateTime now,
    required DateTime value,
    required AppLocalizations appLocalizations,
  }) {
    if (_isSameDate(now, value)) {
      return '${appLocalizations.closedUntil} ';
    }
    if (_isTomorrowDate(now, value)) {
      return '${appLocalizations.closedUntilOnly} ${appLocalizations.tomorrow} ';
    }
    return '${appLocalizations.closedUntilOnly} ${value.weekday.weekDayNameShort(appLocalizations)} ${appLocalizations.hour} ';
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
