import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

List<TextSpan> buildSuggestTitle(BuildContext context, SuggestMessage suggest) {
  List<TextSpan> parts = [];
  final matchedParts =
      suggest.title.matchedParts.whereType<MarkedUpTextSpanMessage>().toList();

  if (matchedParts.isEmpty) {
    return [
      TextSpan(
        text: suggest.title.text,
        style: Theme.of(context)
            .extension<ThemeTextStyles>()!
            .textM
            .copyWith(color: const Color(0x801E2A36)),
      )
    ];
  }

  bool markupValid = true;
  for (final matchedPart in matchedParts) {
    if (matchedPart.offset >= suggest.title.text.length ||
        matchedPart.offset + matchedPart.length > suggest.title.text.length) {
      markupValid = false;
      break;
    }
  }
  if (!markupValid) {
    return [
      TextSpan(
        text: suggest.title.text,
        style: Theme.of(context)
            .extension<ThemeTextStyles>()!
            .textM
            .copyWith(color: const Color(0x801E2A36)),
      )
    ];
  }

  parts.add(
    TextSpan(
      text: suggest.title.text.substring(
        0,
        matchedParts[0].offset,
      ),
      style: Theme.of(context)
          .extension<ThemeTextStyles>()!
          .textM
          .copyWith(color: const Color(0x801E2A36)),
    ),
  );

  for (var i = 0; i < matchedParts.length; i++) {
    parts.add(
      TextSpan(
        text: suggest.title.text.substring(
          matchedParts[i].offset,
          matchedParts[i].offset + matchedParts[i].length,
        ),
        style: Theme.of(context)
            .extension<ThemeTextStyles>()!
            .textM
            .copyWith(color: const Color(0xFF1E2A36)),
      ),
    );
    if (i != matchedParts.length - 1) {
      parts.add(
        TextSpan(
          text: suggest.title.text.substring(
            matchedParts[i].offset + matchedParts[i].length,
            matchedParts[i + 1].offset,
          ),
          style: Theme.of(context)
              .extension<ThemeTextStyles>()!
              .textM
              .copyWith(color: const Color(0x801E2A36)),
        ),
      );
    }
  }
  parts.add(
    TextSpan(
      text: suggest.title.text.substring(
        matchedParts[matchedParts.length - 1].offset +
            matchedParts[matchedParts.length - 1].length,
      ),
      style: Theme.of(context)
          .extension<ThemeTextStyles>()!
          .textM
          .copyWith(color: const Color(0x801E2A36)),
    ),
  );

  return parts;
}
