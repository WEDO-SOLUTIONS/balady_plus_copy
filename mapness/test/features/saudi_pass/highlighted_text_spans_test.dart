import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/saudi_pass/widgets/city_selection_dialog_widget.dart';

void main() {
  late String search;
  late String source;
  const highlightStyle = TextStyle(fontSize: 1, debugLabel: 'highlightStyle');
  const baseStyle = TextStyle(fontSize: 2, debugLabel: 'baseStyle');

  List<TextSpan> highlight({required String source, required String search}) =>
      highlightedTextSpans(source: source, search: search, highlightStyle: highlightStyle, baseStyle: baseStyle);

  group('GIVEN source=Saint-P AND search=Sa', () {
    setUp(() {
      source = 'Saint-P';
      search = 'Sa';
    });

    group('WHEN highlighting', () {
      late List<TextSpan> spans;
      setUp(() => spans = highlight(source: source, search: search));

      test('THEN Sa has highlightStyle', () {
        expect(
          spans.first,
          isA<TextSpan>()
              .having((it) => it.text, 'text', equals('Sa'))
              .having((it) => it.style, 'highlightStyle', highlightStyle),
        );
      });

      test('THEN int-P has baseStyle', () {
        expect(
          spans.last,
          isA<TextSpan>()
              .having((it) => it.text, 'text', equals('int-P'))
              .having((it) => it.style, 'baseStyle', baseStyle),
        );
      });
    });
  });
}
