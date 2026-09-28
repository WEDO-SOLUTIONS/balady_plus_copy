import 'package:dgis_map/library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/map_tap_handler/priority_map_tap_slot.dart';

void main() {
  const objectTap = ObjectTapEvent(
    DgisObjectId(objectId: 70000001, entranceId: 0),
    LatLng(latitude: 24.71, longitude: 46.67),
    null,
  );
  const myLocationTap = MyLocationTapEvent(LatLng(latitude: 24.71, longitude: 46.67));

  late List<TapEvent> handled;
  bool consumeAll(TapEvent event) {
    handled.add(event);
    return true;
  }

  setUp(() => handled = []);

  test('without a handler every tap goes to the default handling', () {
    expect(PriorityMapTapSlot().dispatch(objectTap, makkahMarkerTapPending: false), isFalse);
  });

  test('the handler decides whether it consumed the tap', () {
    final slot = PriorityMapTapSlot()..handler = (event) => event is ObjectTapEvent;

    expect(slot.dispatch(objectTap, makkahMarkerTapPending: false), isTrue);
    expect(slot.dispatch(myLocationTap, makkahMarkerTapPending: false), isFalse);
  });

  test('an object tap right after a Makkah marker tap bypasses the handler', () {
    final slot = PriorityMapTapSlot()..handler = consumeAll;

    expect(slot.dispatch(objectTap, makkahMarkerTapPending: true), isFalse);
    expect(handled, isEmpty);
    expect(slot.dispatch(myLocationTap, makkahMarkerTapPending: true), isTrue);
  });

  test('reset with an owner clears only its own handler', () {
    bool other(TapEvent _) => true;
    final slot = PriorityMapTapSlot()
      ..handler = consumeAll
      ..reset(other);
    expect(slot.dispatch(objectTap, makkahMarkerTapPending: false), isTrue);

    slot.reset(consumeAll);
    expect(slot.dispatch(objectTap, makkahMarkerTapPending: false), isFalse);
  });

  test('a stale owner does not clear the handler of the next screen', () {
    bool previousScreen(TapEvent _) => true;
    final slot = PriorityMapTapSlot()
      ..handler = previousScreen
      ..handler = consumeAll
      ..reset(previousScreen);

    expect(slot.dispatch(objectTap, makkahMarkerTapPending: false), isTrue);
    expect(handled, [objectTap]);
  });
}
