import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/widgets/timed_fill_button.dart';

void main() {
  const duration = Duration(seconds: 5);

  Widget buildButton({VoidCallback? onCompleted, TextDirection direction = TextDirection.ltr}) => Directionality(
    textDirection: direction,
    child: Center(
      child: SizedBox(
        width: 200,
        height: 48,
        child: TimedFillButton(
          duration: duration,
          onCompleted: onCompleted,
          background: const ColoredBox(color: Color(0xFFEEEEEE)),
          fill: const ColoredBox(color: Color(0xFF222222)),
        ),
      ),
    ),
  );

  Rect fillRect(WidgetTester tester) =>
      tester.widget<ClipRect>(find.byType(ClipRect)).clipper!.getClip(const Size(200, 48));

  double fillWidth(WidgetTester tester) => fillRect(tester).width;

  testWidgets('calls onCompleted once, only when the duration has run out', (tester) async {
    var completed = 0;
    await tester.pumpWidget(buildButton(onCompleted: () => completed++));

    await tester.pump(duration - const Duration(milliseconds: 1));
    expect(completed, 0);

    await tester.pump(const Duration(milliseconds: 2));
    expect(completed, 1);

    await tester.pump(duration);
    expect(completed, 1);
  });

  testWidgets('reveals the fill from left to right over the duration', (tester) async {
    await tester.pumpWidget(buildButton());
    expect(fillWidth(tester), 0);

    await tester.pump(duration ~/ 2);
    expect(fillWidth(tester), closeTo(100, 0.01));

    await tester.pump(duration ~/ 2);
    expect(fillWidth(tester), 200);
  });

  testWidgets('fills from the right in RTL', (tester) async {
    await tester.pumpWidget(buildButton(direction: TextDirection.rtl));

    await tester.pump(duration ~/ 4);
    expect(fillRect(tester).left, closeTo(150, 0.01));
    expect(fillRect(tester).right, 200);

    await tester.pump(duration);
    expect(fillRect(tester), const Rect.fromLTWH(0, 0, 200, 48));
  });

  testWidgets('does not call onCompleted after being disposed', (tester) async {
    var completed = 0;
    await tester.pumpWidget(buildButton(onCompleted: () => completed++));
    await tester.pump(duration ~/ 2);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(duration);
    expect(completed, 0);
  });
}
