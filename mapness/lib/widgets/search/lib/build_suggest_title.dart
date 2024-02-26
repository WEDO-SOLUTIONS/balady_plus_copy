import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

List<TextSpan> buildSuggestTitle(BuildContext context, SuggestMessage suggest) {
  final parts = <TextSpan>[];
  final matchedParts =
      suggest.title.matchedParts.whereType<MarkedUpTextSpanMessage>().toList();

  if (matchedParts.isEmpty) {
    return [
      TextSpan(
        text: suggest.title.text,
        style: Theme.of(context)
            .extension<ThemeTextStyles>()!
            .textM
            .copyWith(color: context.color.text_and_icons_base_tertiary),
      ),
    ];
  }

  var markupValid = true;
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
            .copyWith(color: context.color.text_and_icons_base_tertiary),
      ),
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
          .copyWith(color: context.color.text_and_icons_base_tertiary),
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
            .copyWith(color: context.color.text_and_icons_base_primary),
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
              .copyWith(color: context.color.text_and_icons_base_tertiary),
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
          .copyWith(color: context.color.text_and_icons_base_tertiary),
    ),
  );

  return parts;
}
