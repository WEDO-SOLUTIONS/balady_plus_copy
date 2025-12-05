import 'package:flutter/widgets.dart';

List<TextSpan> getHighlightedTextSpans({
  required String source,
  required String search,
  required TextStyle highlightStyle,
  required TextStyle baseStyle,
}) {
  if (search.isEmpty || !source.toLowerCase().contains(search.toLowerCase())) {
    return [TextSpan(text: source, style: baseStyle)];
  }

  final matches = search.toLowerCase().allMatches(source.toLowerCase());

  int lastMatchEnd = 0;

  final List<TextSpan> children = [];
  for (var i = 0; i < matches.length; i++) {
    final match = matches.elementAt(i);

    if (match.start != lastMatchEnd) {
      children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start), style: baseStyle));
    }

    children.add(TextSpan(
        text: source.substring(match.start, match.end), style: highlightStyle));

    if (i == matches.length - 1 && match.end != source.length) {
      children.add(TextSpan(
          text: source.substring(match.end, source.length), style: baseStyle));
    }

    lastMatchEnd = match.end;
  }
  return children;
}
