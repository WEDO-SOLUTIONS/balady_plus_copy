import 'package:balady_uikit/balady_uikit.dart';

final class RouteDetailsStateMapper implements BottomSheetStateMapper<ThreeStateBottomSheet> {
  const RouteDetailsStateMapper();

  @override
  ThreeStateBottomSheet state(int state) => switch (state) {
        0 => ThreeStateBottomSheet.hidden,
        1 => ThreeStateBottomSheet.open,
        _ => ThreeStateBottomSheet.expanded,
      };

  @override
  int index(ThreeStateBottomSheet state) => state.index.clamp(0, 2);

  @override
  bool shouldPopOn(StatefulBottomSheetController<ThreeStateBottomSheet> controller) {
    switch (controller.closestState) {
      case ThreeStateBottomSheet.hidden:
        return true;

      case ThreeStateBottomSheet.open:
        controller.setState(ThreeStateBottomSheet.hidden);
        return false;

      case ThreeStateBottomSheet.expanded:
        controller.setState(ThreeStateBottomSheet.open);
        return false;
    }
  }
}
