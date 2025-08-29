import 'package:balady_uikit/balady_uikit.dart';
import 'package:sheetify/sheetify.dart' as sheetify;

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

enum TwoStateSheet {
  hidden,
  expanded,
}

final class RouteDetailsStateMapperV2 implements sheetify.SheetStateMapper<TwoStateSheet> {
  const RouteDetailsStateMapperV2();

  @override
  TwoStateSheet state(int state) => switch (state) {
        0 => TwoStateSheet.hidden,
        _ => TwoStateSheet.expanded,
      };

  @override
  int index(TwoStateSheet state) => state.index.clamp(0, 2);

  @override
  bool shouldPopOn(sheetify.MultiStateSheetController<TwoStateSheet> controller) {
    switch (controller.closestState) {
      case TwoStateSheet.hidden:
        return true;

      case TwoStateSheet.expanded:
        controller.setState(TwoStateSheet.hidden);
        return false;
    }
  }
}
