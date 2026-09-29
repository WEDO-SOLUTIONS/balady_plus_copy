import 'dart:async';

import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/navigation_cursor/navigation_cursor.dart';
import 'package:mapness/features/navigation_cursor/navigation_cursor_controller.dart';
import 'package:mapness/pages/navigator_settings/pages/cursors_page/cursors_page_content.dart';
import 'package:mapness/pages/navigator_settings/pages/cursors_page/cursors_sheet.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/cursors_sheet_visibility_provider.dart';
import 'package:mapness/shared/test_utils/test_material_app.dart';
import 'package:provider/provider.dart' as provider;
import 'package:sheetify/sheetify.dart';

class _FakeCursorController extends NavigationCursorController {
  @override
  NavigationCursorState build() =>
      NavigationCursorState(active: NavigationCursor.classic, downloadedIds: {NavigationCursor.classic.id});
}

/// A page as PathNav/FreeRoam mount it: the sheet sits in the page Stack.
class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Stack(children: [SizedBox.expand(), CursorsSheet()]),
  );
}

/// BALADY-3960: the cursors sheet must never latch "open" once it is gone.
void main() {
  late ProviderContainer container;
  late ValueNotifier<double> touchSlop;

  setUp(() {
    container = ProviderContainer(
      overrides: [navigationCursorControllerProvider.overrideWith(_FakeCursorController.new)],
    );
    touchSlop = ValueNotifier(kTouchSlop);
  });

  tearDown(() => container.dispose());

  bool flag() => container.read(cursorsSheetVisibilityProvider);
  // What MapTapHandler does on a MyLocationTapEvent in PathNav/FreeRoam.
  void tapCursor() => container.read(cursorsSheetVisibilityProvider.notifier).requestOpen();
  ToggleSheetController sheetAt(WidgetTester tester, int index) =>
      tester.widgetList<ToggleSheet>(find.byType(ToggleSheet)).elementAt(index).scrollController;
  final header = find.text('Your cursors');

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: provider.ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: TestMaterialApp(
            language: Language.english,
            child: ValueListenableBuilder(
              valueListenable: touchSlop,
              builder: (context, slop, child) => MediaQuery(
                // A gesture-settings change recreates the sheet's ScrollPosition.
                data: MediaQuery.of(context).copyWith(gestureSettings: DeviceGestureSettings(touchSlop: slop)),
                child: child!,
              ),
              child: const _Page(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> tearDownApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  }

  void pushOver(WidgetTester tester, Widget page) {
    final navigator = Navigator.of(tester.element(find.byType(CursorsSheet).first));
    // Non-opaque, so the page below keeps ticking and stays hit-testable.
    unawaited(navigator.push(PageRouteBuilder<void>(opaque: false, pageBuilder: (_, _, _) => page)));
  }

  testWidgets('a header swipe resets the flag and the next cursor tap opens the sheet again', (tester) async {
    await pumpApp(tester);
    tapCursor();
    await tester.pumpAndSettle();
    final sheet = sheetAt(tester, 0);
    expect(sheet.isClosed, isFalse);
    expect(find.byType(CursorsPageContent), findsOneWidget);

    await tester.fling(header, const Offset(0, 300), 1500);
    await tester.pumpAndSettle();
    expect(sheet.isClosed, isTrue);
    expect(flag(), isFalse);

    tapCursor();
    await tester.pumpAndSettle();
    expect(sheet.isClosed, isFalse);
    expect(flag(), isTrue);
    await tearDownApp(tester);
  });

  testWidgets('repeated cursor taps while the sheet opens or is open neither restart nor close it', (tester) async {
    await pumpApp(tester);
    tapCursor();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final sheet = sheetAt(tester, 0);
    final heightMidOpen = sheet.sheetHeight;
    expect(heightMidOpen, greaterThan(0));

    // Long-press + tap-on-release: the second native event lands mid-animation.
    tapCursor();
    await tester.pump(const Duration(milliseconds: 16));
    expect(sheet.sheetHeight, greaterThanOrEqualTo(heightMidOpen));
    await tester.pumpAndSettle();
    final openHeight = sheet.sheetHeight;

    tapCursor();
    await tester.pump();
    expect(sheet.isAnimating, isFalse);
    await tester.pumpAndSettle();
    expect(sheet.sheetHeight, openHeight);
    expect(flag(), isTrue);
    await tearDownApp(tester);
  });

  testWidgets('system back closes the sheet and resets the flag', (tester) async {
    await pumpApp(tester);
    tapCursor();
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(sheetAt(tester, 0).isClosed, isTrue);
    expect(flag(), isFalse);
    expect(find.byType(CursorsSheet), findsOneWidget);
    await tearDownApp(tester);
  });

  testWidgets('a page mounted while another page shows the sheet resets the flag; only the top page opens', (
    tester,
  ) async {
    await pumpApp(tester);
    tapCursor();
    await tester.pumpAndSettle();
    final below = sheetAt(tester, 0);
    expect(below.isClosed, isFalse);

    // FreeRoam -> PathNav with the sheet still up.
    pushOver(tester, const _Page());
    await tester.pumpAndSettle();
    final top = sheetAt(tester, 1);
    expect(flag(), isFalse);
    expect(top.isClosed, isTrue);
    expect(below.isClosed, isTrue);

    tapCursor();
    await tester.pumpAndSettle();
    expect(top.isClosed, isFalse);
    expect(below.isClosed, isTrue);
    expect(below.isAnimating, isFalse);

    // Leaving the top page while its sheet is up must not leave the flag set.
    Navigator.of(tester.element(find.byType(CursorsSheet).last)).pop();
    await tester.pumpAndSettle();
    expect(find.byType(CursorsSheet), findsOneWidget);
    expect(flag(), isFalse);
    expect(below.isClosed, isTrue);
    await tearDownApp(tester);
  });

  testWidgets('a sheet under another route stays closed and drops the flag once its page is back on top', (
    tester,
  ) async {
    await pumpApp(tester);
    pushOver(tester, const Scaffold(backgroundColor: Colors.transparent, body: SizedBox.expand()));
    await tester.pumpAndSettle();

    tapCursor();
    await tester.pumpAndSettle();
    final sheet = sheetAt(tester, 0);
    expect(sheet.isClosed, isTrue);

    Navigator.of(tester.element(find.byType(SizedBox).last)).pop();
    await tester.pumpAndSettle();
    expect(flag(), isFalse);
    tapCursor();
    await tester.pumpAndSettle();
    expect(sheet.isClosed, isFalse);
    await tearDownApp(tester);
  });

  testWidgets('a sheet left half-way by a dead fling comes back on the next cursor tap', (tester) async {
    await pumpApp(tester);
    tapCursor();
    await tester.pumpAndSettle();
    final sheet = sheetAt(tester, 0);
    final openHeight = sheet.sheetHeight;

    await tester.fling(find.byType(CursorsPageContent), const Offset(0, 150), 1500);
    await tester.pump(const Duration(milliseconds: 16));
    touchSlop.value = kTouchSlop + 1;
    await tester.pumpAndSettle();
    // Neither open nor closed, idle, no onClose: the flag stays up...
    expect(sheet.isClosed, isFalse);
    expect(sheet.isAnimating, isFalse);
    expect(sheet.sheetHeight, lessThan(openHeight - 1));
    expect(flag(), isTrue);

    // ...and the next tap is not swallowed by it.
    tapCursor();
    await tester.pumpAndSettle();
    expect(sheet.sheetHeight, closeTo(openHeight, 0.01));
    await tearDownApp(tester);
  });
}
