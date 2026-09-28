import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/widgets/timed_fill_button.dart';

void main() {
  const duration = Duration(seconds: 5);

  Widget buildButton({VoidCallback? onCompleted}) => Directionality(
    textDirection: TextDirection.ltr,
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

  double fillWidth(WidgetTester tester) {
    final clip = tester.widget<ClipRect>(find.byType(ClipRect));
    return clip.clipper!.getClip(const Size(200, 48)).width;
  }

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

  testWidgets('does not call onCompleted after being disposed', (tester) async {
    var completed = 0;
    await tester.pumpWidget(buildButton(onCompleted: () => completed++));
    await tester.pump(duration ~/ 2);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(duration);
    expect(completed, 0);
  });
}
