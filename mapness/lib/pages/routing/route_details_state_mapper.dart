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

final class RouteDetailsStateMapperV2 implements sheetify.SheetStateMapper<sheetify.ThreeStateSheet> {
  const RouteDetailsStateMapperV2();

  @override
  sheetify.ThreeStateSheet state(int state) => switch (state) {
        0 => sheetify.ThreeStateSheet.hidden,
        1 => sheetify.ThreeStateSheet.open,
        _ => sheetify.ThreeStateSheet.expanded,
      };

  @override
  int index(sheetify.ThreeStateSheet state) => state.index.clamp(0, 2);

  @override
  bool shouldPopOn(sheetify.MultiStateSheetController<sheetify.ThreeStateSheet> controller) {
    switch (controller.closestState) {
      case sheetify.ThreeStateSheet.hidden:
        return true;

      case sheetify.ThreeStateSheet.open:
        controller.setState(sheetify.ThreeStateSheet.hidden);
        return false;

      case sheetify.ThreeStateSheet.expanded:
        controller.setState(sheetify.ThreeStateSheet.open);
        return false;
    }
  }
}
