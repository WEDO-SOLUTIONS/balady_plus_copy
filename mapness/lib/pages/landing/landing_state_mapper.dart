import 'package:sheetify/sheetify.dart';

final class LandingStateMapper implements SheetStateMapper<ThreeStateSheet> {
  const LandingStateMapper();

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
