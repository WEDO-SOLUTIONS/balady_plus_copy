import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mapness/shared/lib/weekday_entity.dart';

extension ISetWeekDayExt on ISet<WeekDay> {
  List<WeekDay> sortedByIndex() => toList()..sort((a, b) => a.index.compareTo(b.index));
}
