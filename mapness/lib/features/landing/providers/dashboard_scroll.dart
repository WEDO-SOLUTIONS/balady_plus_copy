import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_scroll.g.dart';

class ScrollPosition {
  final double max;
  final double current;

  ScrollPosition({
    required this.max,
    required this.current,
  });
}

@riverpod
class DashboardScroll extends _$DashboardScroll {
  @override
  ScrollPosition? build() => null;

  void update(ScrollPosition value) => state = value;
}
