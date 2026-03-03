import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ramadan_season.g.dart';

/// Returns true when current date is within the Ramadan seasonal window.
///
/// Business requirement:
///   Ramadan theme should be switched on only Feb 17 – March 20 (2026).
@riverpod
bool ramadanSeason(Ref ref) {
  return false;

  // final now = DateTime.now();
  // final today = DateTime(now.year, now.month, now.day);
  //
  // final start = DateTime(2026, 2, 17);
  // final end = DateTime(2026, 3, 20);
  //
  // final isOnOrAfterStart = !today.isBefore(start);
  // final isOnOrBeforeEnd = !today.isAfter(end);
  //
  // return isOnOrAfterStart && isOnOrBeforeEnd;
}
