import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controls.g.dart';

enum DashboardControlsState {
  idle,
  searching,
  suggests,
  results;
}

@riverpod
class DashboardControls extends _$DashboardControls {
  @override
  DashboardControlsState build() => DashboardControlsState.idle;

  void update(DashboardControlsState value) => state = value;
}
