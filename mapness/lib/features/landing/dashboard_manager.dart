import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'dashboard_manager.g.dart';

enum BottomSheetState {
  expanded,
  collapsed;
}

@riverpod
class DashboardManager extends _$DashboardManager {
  @override
  BottomSheetState build() => BottomSheetState.collapsed;

  void onDrag(BottomSheetState bottomSheet) => state = bottomSheet;
}
