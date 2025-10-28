import 'dart:collection';

import 'package:collection/collection.dart';

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

  /// Only inside working hours
  bool isOpen(DateTime dateTime) {
    if (map.isNotEmpty) {
      final now = dateTime.durationFromWeekStart;
      final before = map.lastKeyBefore(now);
      final beforeDuration = map[before];
      final after = map.firstKeyAfterIncluding(now);
      final afterDuration = map[after];

      if (before != null && beforeDuration != null) {
        return before <= now && now <= before + beforeDuration;
      }

      if (after != null && afterDuration != null) {
        return after <= now && now <= after + afterDuration;
      }
    }

    return false;
  }

  bool isClosed(DateTime dateTime) => !isOpen(dateTime);

  /// When closed between day intervals
  bool isBreak(DateTime dateTime) {
    if (isClosed(dateTime)) {
      final now = dateTime.durationFromWeekStart;
      final prevOpen = map.lastKeyBefore(now);
      final nextOpen = map.firstKeyAfterIncluding(now);

      if (prevOpen != null && nextOpen != null) {
        return prevOpen.inDays == now.inDays && nextOpen.inDays == now.inDays;
      }
    }

    return false;
  }

  /// Shows same day close time HH:mm
  /// Defined only when working this day, otherwise Duration.zero
  Duration closesIn(DateTime dateTime) {
    final now = dateTime.durationFromWeekStart;
    final dayEnd = Duration(days: now.inDays) + const Duration(hours: 24);

    final last = map.lastKeyBefore(dayEnd);
    final lastDuration = map[last];

    if (last != null && lastDuration != null && last.inDays == now.inDays) {
      final until = last + lastDuration - now;
      return until.isNegative ? Duration.zero : until;
    }

    return Duration.zero;
  }

  /// Shows next working hours start
  /// Loops over weekend - if is sunday will show monday
  Duration nextOpen(DateTime dateTime) {
    final now = dateTime.durationFromWeekStart;
    final next = map.firstKeyAfter(now) ?? map.firstKey();

    if (next != null) {
      return next;
    }

    return Duration.zero;
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
}

extension on DateTime {
  Duration get durationFromWeekStart => Duration(days: weekday, hours: hour, minutes: minute);
}

extension SplayTreeMapExt<K, V> on SplayTreeMap<K, V> {
  K? firstKeyAfterIncluding(K key) => containsKey(key) ? key : firstKeyAfter(key);
}

extension DurationExt on Duration {
  Duration get hoursAndMinutes => this - Duration(days: inDays);
}

typedef Hours = ({Duration from, Duration till});
