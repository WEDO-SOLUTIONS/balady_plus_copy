import 'package:sheetify/sheetify.dart';

final class RouteDetailsStateMapper implements SheetStateMapper<ThreeStateSheet> {
  const RouteDetailsStateMapper();

  @override
  ThreeStateSheet state(int state) => switch (state) {
    0 => ThreeStateSheet.hidden,
    1 => ThreeStateSheet.open,
    _ => ThreeStateSheet.expanded,
  };

  @override
  int index(ThreeStateSheet state) => state.index.clamp(0, 2);

  @override
  bool shouldPopOn(MultiStateSheetController<ThreeStateSheet> controller) {
    switch (controller.closestState) {
      case ThreeStateSheet.hidden:
        return true;

      case ThreeStateSheet.open:
        controller.setState(ThreeStateSheet.hidden);
        return false;

      case ThreeStateSheet.expanded:
        controller.setState(ThreeStateSheet.open);
        return false;
    }
  }
}

enum TwoStateSheet { hidden, expanded }

final class RouteDetailsStateMapperV2 implements SheetStateMapper<TwoStateSheet> {
  const RouteDetailsStateMapperV2();

  @override
  TwoStateSheet state(int state) => switch (state) {
    0 => TwoStateSheet.hidden,
    _ => TwoStateSheet.expanded,
  };

  @override
  int index(TwoStateSheet state) => state.index.clamp(0, 2);

  @override
  bool shouldPopOn(MultiStateSheetController<TwoStateSheet> controller) {
    switch (controller.closestState) {
      case TwoStateSheet.hidden:
        return true;

      case TwoStateSheet.expanded:
        controller.setState(TwoStateSheet.hidden);
        return false;
    }
  }
}
