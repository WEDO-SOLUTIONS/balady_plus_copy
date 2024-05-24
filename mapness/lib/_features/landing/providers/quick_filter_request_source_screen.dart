import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_filter_request_source_screen.g.dart';

@riverpod
class QuickFiltersRequestSourceScreen extends _$QuickFiltersRequestSourceScreen {
  @override
  QuickFilterScreen? build() => null;

  void setSourceScreen([QuickFilterScreen? screen]) {
    state = screen ?? QuickFilterScreen.outside;
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
