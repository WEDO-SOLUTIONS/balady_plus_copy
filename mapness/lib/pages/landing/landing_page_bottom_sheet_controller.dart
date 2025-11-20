part of 'landing_page.dart';

// hack: needed to close the dashboard bottom sheet from elsewhere
final landingPageBottomSheetControllerProvider = Provider<MultiStateSheetController<ThreeStateSheet>?>(
    (ref) => ref.watch(_bottomSheetControllerProvider)._controller);

final _bottomSheetControllerProvider =
    Provider<_BottomSheetControllerWrapper>((ref) => _BottomSheetControllerWrapper());

class _BottomSheetControllerWrapper {
  MultiStateSheetController<ThreeStateSheet>? _controller;
}
