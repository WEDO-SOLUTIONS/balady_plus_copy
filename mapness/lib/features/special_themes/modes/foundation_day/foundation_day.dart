import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foundation_day.g.dart';

/// Returns true when today is Foundation Day.
///
/// Currently hard-coded for February 22, 2026.
@riverpod
bool foundationDay(Ref ref) {
  final now = DateTime.now();
  // Use local date without time component
  final today = DateTime(now.year, now.month, now.day);

  final foundationDayDate = DateTime(now.year, 2, 22);

  return today.isAtSameMomentAs(foundationDayDate);
}
