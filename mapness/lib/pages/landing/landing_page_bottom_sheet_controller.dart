part of 'landing_page.dart';

final bottomSheetControllerProvider = StateProvider<_BottomSheetControllerWrapper>(
  (ref) => _BottomSheetControllerWrapper(),
);

class _BottomSheetControllerWrapper {
  MultiStateSheetController<ThreeStateSheet>? controller;
  _BottomSheetControllerWrapper();
}
