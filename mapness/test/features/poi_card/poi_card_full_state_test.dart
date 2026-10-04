import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/poi_card/domain/poi_card_state_mapper.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:sheetify/sheetify.dart';

const _photoSnapOffset = 200.0;

// Same ladder as `_ContentState.initState` in poi_card_content.dart.
MultiStateSheetController<PoiCardBottomSheetState> _controller({required bool hasPhotoSnap}) =>
    MultiStateSheetController(
      behavior: MultiSnappingBehavior(
        models: [
          FractionSnappingModel({0.0, 1.0}),
          if (hasPhotoSnap) OffsetSnappingModel({_photoSnapOffset}),
          ComponentsSnappingModel(
            componentsDescriptions: [
              SnapComponent.merge(
                a: const SnapComponent.size(component: Components.header),
                b: const SnapComponent.size(component: Components.footer),
                merge: (a, b) => a + b,
              ),
            ],
          ),
        ],
      ),
      stateMapper: const PoiCardStateMapper(),
      initialState: PoiCardBottomSheetState.halfOpen,
    );

Future<void> _pumpSheet(WidgetTester tester, MultiStateSheetController<PoiCardBottomSheetState> controller) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MultiStateSheet(
          scrollController: controller,
          dragger: null,
          header: const SizedBox(height: 80),
          content: const [SizedBox(height: 2000)],
          footer: const SizedBox(height: 60),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final hasPhotoSnap in [false, true]) {
    testWidgets('fullState opens the sheet to its top snap (hasPhotoSnap: $hasPhotoSnap)', (tester) async {
      final controller = _controller(hasPhotoSnap: hasPhotoSnap);
      addTearDown(controller.dispose);
      await _pumpSheet(tester, controller);
      expect(controller.state, PoiCardBottomSheetState.halfOpen);

      final fullState = PoiCardStateMapper.fullState(hasPhotoSnap: hasPhotoSnap);
      controller.setState(fullState);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(controller.state, fullState);
      expect(controller.sheetHeight, greaterThan(controller.viewportHeight - _photoSnapOffset));
    });
  }

  testWidgets('expanded does not exist without the photo snap', (tester) async {
    final controller = _controller(hasPhotoSnap: false);
    addTearDown(controller.dispose);
    await _pumpSheet(tester, controller);

    expect(() => controller.setState(PoiCardBottomSheetState.expanded), throwsAssertionError);
  });
}
