import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

const Duration kDefaultWorkingHoursSoonThreshold = Duration(hours: 2);

enum WorkingHoursStatusType {
  hidden,
  open,
  openSoon,
  closed,
  closedSoon,
  open24Hours,
}

/// Represents working week from Monday to Sunday
///
/// Keeps map of entries where Key is point in time of start and Value is working duration
///
/// Example
///        monday  10:00-14:00, 15:00-18:00
///        tuesday 11:00-18:00
///
/// Pseudo code
///        monday  10:00+4:00
///        monday  15:00+3:00
///        tuesday 11:00+7:00
///
/// Real code
/// Map.of({
///       Duration(days: DateTime.monday, hours: 10): Duration(hours: 4),
///       Duration(days: DateTime.monday, hours: 15): Duration(hours: 3),
///       Duration(days: DateTime.tuesday, hours: 11): Duration(hours: 7),
///     });
///
/// SplayTreeMap sorts points in time (because Duration is Comparable)
class WorkingHours {
  final SplayTreeMap<Duration, Duration> map;

  WorkingHours(Map<Duration, Duration> map) : map = SplayTreeMap.of(map);

  bool get isTemporaryClosed => map.isEmpty;

  /// Returns current display status for working hours.
  WorkingHoursStatusType statusType(
    DateTime dateTime, {
    Duration soonThreshold = kDefaultWorkingHoursSoonThreshold,
  }) {
    if (isTemporaryClosed) {
      return WorkingHoursStatusType.hidden;
    }

    if (isOpen24x7) {
      return WorkingHoursStatusType.open24Hours;
    }

    if (isOpen(dateTime)) {
      final untilClose = closesIn(dateTime);
      return untilClose <= soonThreshold ? WorkingHoursStatusType.openSoon : WorkingHoursStatusType.open;
    }

    final nextOpenAt = nextOpenDateTime(dateTime);
    if (nextOpenAt == null) {
      return WorkingHoursStatusType.hidden;
    }

    final untilOpen = nextOpenAt.difference(dateTime);
    return untilOpen <= soonThreshold ? WorkingHoursStatusType.closedSoon : WorkingHoursStatusType.closed;
  }

  DateTime? nextOpenDateTime(DateTime dateTime) {
    final next = _nextInterval(dateTime);
    return next?.start;
  }

  DateTime? closeDateTime(DateTime dateTime) {
    final current = _currentInterval(dateTime);
    return current?.end;
  }

  /// Only inside working hours
  bool isOpen(DateTime dateTime) => _currentInterval(dateTime) != null;

  bool isClosed(DateTime dateTime) => !isOpen(dateTime);

  /// When closed between day intervals
  bool isBreak(DateTime dateTime) {
    if (isOpen(dateTime)) {
      return false;
    }

    final previous = _previousInterval(dateTime);
    final next = _nextInterval(dateTime);
    if (previous == null || next == null) {
      return false;
    }

    return _sameDate(previous.end, dateTime) && _sameDate(next.start, dateTime);
  }

  /// Shows same day close time HH:mm
  /// Defined only when working this day, otherwise Duration.zero
  Duration closesIn(DateTime dateTime) {
    final interval = _currentInterval(dateTime);
    if (interval == null) {
      return Duration.zero;
    }

    final until = interval.end.difference(dateTime);
    return until.isNegative ? Duration.zero : until;
  }

  /// Shows next working hours start
  /// Loops over weekend - if is sunday will show monday
  Duration nextOpen(DateTime dateTime) {
    final next = _nextInterval(dateTime);
    if (next == null) {
      return Duration.zero;
    }

    return next.start.durationFromWeekStart;
  }

  bool isTomorrow(DateTime dateTime, Duration point) {
    final nowDay = dateTime.weekday;
    final openingDay = point.inDays;
    final diff = openingDay - nowDay;
    return diff == 1 || diff == -6;
  }

  bool isToday(DateTime dateTime, Duration point) => dateTime.weekday == point.inDays;

  /// Return working hours for weekday 1-7 as [DateTime.monday]
  /// Ex. [11:00-14:00, 15:00-18:00]
  Iterable<Hours> todayHours(int weekday) => map.entries.where((it) => it.key.inDays == weekday).map((it) {
    Duration close = it.key + it.value;
    close = close - Duration(days: close.inDays);
    return (from: it.key - Duration(days: it.key.inDays), till: close);
  });

  /// Return break hours for weekday 1-7 as [DateTime.monday]
  /// Ex. if hours [11:00-14:00, 15:00-18:00] then breaks [14:00-15:00]
  Iterable<Hours> todayBreaks(int weekday) {
    final hours = todayHours(weekday);
    final breaks = <Hours>[];

    if (hours.length > 1) {
      for (int i = 0; i < hours.length - 1; i += 1) {
        breaks.add((from: hours.elementAt(i).till, till: hours.elementAt(i + 1).from));
      }
    }

    return breaks;
  }

  /// All week days has same working hours
  bool get isSameEveryDay {
    // surely can be random in 1-7 range
    final anyDayHours = todayHours(DateTime.monday);

    for (int weekday = DateTime.monday; weekday <= DateTime.saturday; weekday++) {
      final hours = todayHours(weekday);
      if (!const DeepCollectionEquality().equals(hours, anyDayHours)) {
        return false;
      }
    }

    return true;
  }

  /// All week days has same working hours from 00:00 till 24:00
  bool get isOpen24x7 {
    for (int day = DateTime.monday; day <= DateTime.sunday; day++) {
      final opening = Duration(days: day);
      final isOpenAllDay = map.containsKey(opening) && map[opening] == const Duration(hours: 24);
      if (!isOpenAllDay) {
        return false;
      }
    }
    return true;
  }

  _ResolvedInterval? _currentInterval(DateTime dateTime) {
    _ResolvedInterval? result;

    for (final interval in _intervalsAround(dateTime)) {
      if (!dateTime.isBefore(interval.start) && dateTime.isBefore(interval.end)) {
        if (result == null || interval.end.isBefore(result.end)) {
          result = interval;
        }
      }
    }

    return result;
  }

  _ResolvedInterval? _nextInterval(DateTime dateTime) {
    _ResolvedInterval? result;

    for (final interval in _intervalsAround(dateTime)) {
      if (interval.start.isAfter(dateTime)) {
        if (result == null || interval.start.isBefore(result.start)) {
          result = interval;
        }
      }
    }

    return result;
  }

  _ResolvedInterval? _previousInterval(DateTime dateTime) {
    _ResolvedInterval? result;

    for (final interval in _intervalsAround(dateTime)) {
      if (!interval.end.isAfter(dateTime)) {
        if (result == null || interval.end.isAfter(result.end)) {
          result = interval;
        }
      }
    }

    return result;
  }

  Iterable<_ResolvedInterval> _intervalsAround(DateTime dateTime) sync* {
    if (map.isEmpty) {
      return;
    }

    final weekStart = _weekStart(dateTime);

    for (final entry in map.entries) {
      final startThisWeek = _startPointForWeek(weekStart, entry.key);
      for (final weekShift in const [-1, 0, 1]) {
        final shiftedStart = startThisWeek.add(Duration(days: 7 * weekShift));
        yield _ResolvedInterval(
          start: shiftedStart,
          end: shiftedStart.add(entry.value),
        );
      }
    }
  }

  DateTime _weekStart(DateTime dateTime) {
    final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return dateOnly.subtract(Duration(days: dateTime.weekday - DateTime.monday));
  }

  DateTime _startPointForWeek(DateTime weekStart, Duration point) {
    final dayOffsetFromMonday = point.inDays - DateTime.monday;
    final timeOfDay = point.hoursAndMinutes;
    return weekStart.add(Duration(days: dayOffsetFromMonday)).add(timeOfDay);
  }
}

extension on DateTime {
  Duration get durationFromWeekStart => Duration(days: weekday, hours: hour, minutes: minute);
}

extension DurationExt on Duration {
  Duration get hoursAndMinutes => this - Duration(days: inDays);
}

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year && first.month == second.month && first.day == second.day;

class _ResolvedInterval {
  final DateTime start;
  final DateTime end;

  const _ResolvedInterval({required this.start, required this.end});
}

typedef Hours = ({Duration from, Duration till});
