import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hajj_season.g.dart';

/// Returns true when current date is within the Hajj seasonal window.
///
/// Business requirement:
///   Hajj theme should be switched on only May 24 – May 29 (2026).
@riverpod
bool hajjSeason(HajjSeasonRef ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final start = DateTime(2026, 5, 24);
  final end = DateTime(2026, 5, 29);

  final isOnOrAfterStart = !today.isBefore(start);
  final isOnOrBeforeEnd = !today.isAfter(end);

  return isOnOrAfterStart && isOnOrBeforeEnd;
}
