import 'package:balady_plus/app/core/utils/debouncer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scroll_to_selected_filter.g.dart';

@riverpod
class ScrollToSelectedQuickFilter extends _$ScrollToSelectedQuickFilter {
  final _debouncer = Debouncer(milliseconds: 200);
  @override
  QuickFilterScreen? build() => null;

  void scrollToSelected([QuickFilterScreen? screen]) {
    _debouncer.run(() {
      state = screen ?? QuickFilterScreen.outside;
    });
  }

  void reset() {
    state = null;
  }
}

enum QuickFilterScreen {
  controls,
  dashboard,
  lifestyle,
  iwish,
  routing,
  outside,
}
