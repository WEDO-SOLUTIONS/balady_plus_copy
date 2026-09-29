import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheetify/sheetify.dart';

/// BALADY-3960: close paths of the vendored `ToggleSheet` (third_party/sheetify)
/// that used to lose, repeat or never report `onClose`.
void main() {
  const headerKey = Key('header');
  const rowKey = Key('row0');
  // 800x600 test surface: header 56 + 3 rows of 80 = a 296 px sheet when open.
  const openHeight = 296.0;

  late ToggleSheetController controller;
  late int closes;
  late ValueNotifier<double> parentHeight;
  late ValueNotifier<double> touchSlop;

  setUp(() {
    closes = 0;
    controller = ToggleSheetController(onClose: (_) => closes++);
    parentHeight = ValueNotifier(600);
    touchSlop = ValueNotifier(kTouchSlop);
  });

  Future<void> pumpSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder(
            valueListenable: touchSlop,
            builder: (context, slop, _) => MediaQuery(
              // Changing gesture settings makes the sheet's Scrollable recreate
              // its ScrollPosition, which kills a content fling mid-flight.
              data: MediaQuery.of(context).copyWith(gestureSettings: DeviceGestureSettings(touchSlop: slop)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ValueListenableBuilder(
                  valueListenable: parentHeight,
                  builder: (context, height, _) => SizedBox(
                    height: height,
                    child: ToggleSheet(
                      scrollController: controller,
                      startConfig: ToggleSheetStart.closed,
                      dragger: null,
                      useSafeArea: false,
                      resizeToAvoidBottomPadding: false,
                      shouldPop: (_) => false,
                      header: const SizedBox(
                        key: headerKey,
                        height: 56,
                        child: Center(child: Text('header')),
                      ),
                      content: [
                        for (var i = 0; i < 3; i++)
                          SizedBox(
                            key: Key('row$i'),
                            height: 80,
                            child: Center(child: Text('row $i')),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> tearDownSheet(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  }

  Future<void> openAndSettle(WidgetTester tester) async {
    controller.open();
    await tester.pumpAndSettle();
    expect(controller.isClosed, isFalse);
    expect(controller.sheetHeight, closeTo(openHeight, 0.01));
  }

  testWidgets('a header swipe closes the sheet and reports it once', (tester) async {
    await pumpSheet(tester);
    await openAndSettle(tester);

    await tester.fling(find.byKey(headerKey), const Offset(0, 200), 1500);
    await tester.pumpAndSettle();

    expect(controller.isClosed, isTrue);
    expect(controller.sheetHeight, 0);
    expect(controller.isAnimating, isFalse);
    expect(closes, 1);
    await tearDownSheet(tester);
  });

  testWidgets('a header drag during the open push follows the finger and closes', (tester) async {
    await pumpSheet(tester);
    controller.open();
    await tester.pump();
    // Visually open by now, but the easeOutExpo "push" keeps ticking for ~0.9 s.
    await tester.pump(const Duration(milliseconds: 150));
    expect(controller.sheetHeight, closeTo(openHeight, 0.01));
    expect(controller.isAnimating, isTrue);

    final gesture = await tester.startGesture(tester.getCenter(find.byKey(headerKey)));
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(0, 25));
      await tester.pump(const Duration(milliseconds: 16));
    }
    // The push used to pull the offset back to open on every frame.
    expect(controller.sheetHeight, lessThan(openHeight - 150));

    await gesture.up();
    await tester.pumpAndSettle();
    expect(controller.isClosed, isTrue);
    expect(closes, 1);
    await tearDownSheet(tester);
  });

  testWidgets('close() cutting a swipe snap short reports the close once', (tester) async {
    await pumpSheet(tester);
    await openAndSettle(tester);

    await tester.fling(find.byKey(headerKey), const Offset(0, 120), 1500);
    await tester.pump(const Duration(milliseconds: 16));
    expect(controller.isAnimating, isTrue);
    expect(controller.isClosed, isFalse);

    controller.close();
    await tester.pumpAndSettle();
    expect(controller.isClosed, isTrue);
    expect(closes, 1);
    await tearDownSheet(tester);
  });

  testWidgets('open() while a swipe snap is closing the sheet does not interrupt it', (tester) async {
    await pumpSheet(tester);
    await openAndSettle(tester);

    await tester.fling(find.byKey(headerKey), const Offset(0, 120), 1500);
    await tester.pump(const Duration(milliseconds: 16));
    controller.open();
    await tester.pumpAndSettle();

    expect(controller.isClosed, isTrue);
    expect(closes, 1);
    await tearDownSheet(tester);
  });

  testWidgets('a parent resize during a swipe snap still lands closed and reports once', (tester) async {
    await pumpSheet(tester);
    await openAndSettle(tester);

    await tester.fling(find.byKey(headerKey), const Offset(0, 120), 1500);
    await tester.pump(const Duration(milliseconds: 16));
    expect(controller.isAnimating, isTrue);

    parentHeight.value = 560;
    await tester.pumpAndSettle();
    expect(controller.isClosed, isTrue);
    expect(controller.isAnimating, isFalse);
    expect(controller.sheetHeight, 0);
    expect(closes, 1);

    await openAndSettle(tester);
    expect(closes, 1);
    await tearDownSheet(tester);
  });

  testWidgets('a content fling and close() landing together report the close once', (tester) async {
    await pumpSheet(tester);
    await openAndSettle(tester);

    await tester.fling(find.byKey(rowKey), const Offset(0, 120), 1500);
    await tester.pump(const Duration(milliseconds: 16));
    expect(controller.isAnimating, isTrue);

    controller.close();
    await tester.pumpAndSettle();
    expect(controller.isClosed, isTrue);
    expect(closes, 1);
    await tearDownSheet(tester);
  });

  testWidgets('open() brings back a sheet stopped between open and closed', (tester) async {
    await pumpSheet(tester);
    await openAndSettle(tester);

    await tester.fling(find.byKey(rowKey), const Offset(0, 120), 1500);
    await tester.pump(const Duration(milliseconds: 16));
    touchSlop.value = kTouchSlop + 1;
    await tester.pumpAndSettle();

    // The fling died with its ScrollPosition: neither open nor closed, and idle.
    expect(controller.isClosed, isFalse);
    expect(controller.isAnimating, isFalse);
    expect(controller.sheetHeight, allOf(greaterThan(0), lessThan(openHeight - 1)));
    expect(closes, 0);

    controller.open();
    await tester.pumpAndSettle();
    expect(controller.isClosed, isFalse);
    expect(controller.sheetHeight, closeTo(openHeight, 0.01));
    expect(closes, 0);
    await tearDownSheet(tester);
  });
}
