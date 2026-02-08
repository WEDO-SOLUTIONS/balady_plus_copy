import 'dart:convert';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/src/components/content_row/options/markerd_up_text_span.dart';
import 'package:balady_uikit/src/layouts/spacing.dart';
import 'package:flutter/material.dart';

class ContentRowTitle extends StatelessWidget {
  final String title;
  final List<UIMarkedUpTextSpan>? matchedParts;
  final TextStyle style;
  final int? maxLines;

  const ContentRowTitle({
    required this.title,
    required this.style,
    this.matchedParts,
    this.maxLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (matchedParts == null) {
      return Text(
        title,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines ?? 1,
        softWrap: false,
        style: style,
      );
    }
    final textSpans = _textSpanGenerator(
      spans: matchedParts!,
      text: title,
      style: style,
      context: context,
    );
    return RichText(
      maxLines: maxLines,
      text: TextSpan(
        children: textSpans,
        style: style,
      ),
    );
  }
}

class ContentRowSubtitle extends StatelessWidget {
  final String subtitle;
  final List<UIMarkedUpTextSpan>? matchedParts;
  final int? maxLines;
  final TextStyle? style;

  const ContentRowSubtitle({
    required this.subtitle,
    required this.style,
    this.matchedParts,
    this.maxLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Spacing.$0_5x.widthBox,
          Builder(
            builder: (context) {
              if (matchedParts == null) {
                return Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLines ?? 1,
                  softWrap: false,
                  style: style,
                );
              }

              final textSpans = _textSpanGenerator(
                spans: matchedParts!,
                text: subtitle,
                context: context,
                style: style,
              );
              return RichText(
                maxLines: maxLines,
                text: TextSpan(
                  children: textSpans,
                  style: style,
                ),
              );
            },
          )
        ],
      );
}

class ContentRowSubtitleExtra extends StatelessWidget {
  final String subtitleExtra;
  final int? maxLines;
  final TextStyle style;

  const ContentRowSubtitleExtra({
    required this.subtitleExtra,
    required this.style,
    this.maxLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Spacing.$0_5x.widthBox,
          Text(
            subtitleExtra,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines ?? 1,
            softWrap: false,
            style: context.textStyles.bodySmallMedium.copyWith(
              color: context.colors.foregroundMuted,
            ),
          )
        ],
      );
}

/// In this generator we use [TextStyle] that is used in the widget that calls this method
/// We do it because the text style (except color) should be the same for consistency
List<TextSpan> _textSpanGenerator({
  required String text,
  required List<UIMarkedUpTextSpan> spans,
  required BuildContext context,
  TextStyle? style,
}) {
  final base = context.color.textAndIconsBaseSecondary;
  final hi = context.color.textAndIconsBasePrimary;

  // fix offsets
  final resultSpans = spans
      .map((s) {
    final fixed = _utf8ToUtf16(text, s.offset, s.length);

    return UIMarkedUpTextSpan(offset: fixed.index, length: fixed.length);
  })
      .where((s) => s.offset + s.length <= text.length) // safety
      .toList()
    ..sort((a, b) => a.offset.compareTo(b.offset));

  final out = <TextSpan>[];
  var cursor = 0;

  void add(String part, Color c) => out.add(
    TextSpan(
      text: part,
      style: style?.copyWith(color: c),
    ),
  );

  for (final s in resultSpans) {
    if (cursor < s.offset) {
      add(text.substring(cursor, s.offset), base);
    }
    add(text.substring(s.offset, s.offset + s.length), hi);
    cursor = s.offset + s.length;
  }
  if (cursor < text.length) {
    add(text.substring(cursor), base);
  }

  return out;
}

/// Translate offset/length, to indexes for substring
({int index, int length}) _utf8ToUtf16(String fullText, int byteOffset, int byteLength) {
  final bytes = utf8.encode(fullText);

  final prefixBytes = bytes.sublist(0, byteOffset);
  final highlightBytes = bytes.sublist(byteOffset, byteOffset + byteLength);

  final index = utf8.decode(prefixBytes).length;
  final length = utf8.decode(highlightBytes).length;

  return (index: index, length: length);
}
