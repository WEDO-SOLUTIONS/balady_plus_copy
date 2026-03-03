part of '../content_row.dart';

/// Text options for the content row.
/// If we have a text in the content row it will be styled using this options.
/// We don't have here all the options that we can have in a text widget, only the restricted by design
class ContentRowTextOption {
  /// The maximum number of lines to be shown.
  final int? maxLines;

  /// If the text should be bold or not.
  final bool isBold;

  /// The base color of the text. Color called [base] because we can have [matchedParts] that will have different colors.
  final Color? baseColor;

  /// A list of [UIMarkedUpTextSpan] that will be used to highlight parts of the text.
  final List<UIMarkedUpTextSpan>? matchedParts;

  /// Custom builder that returns a [Widget] to be used as the content of the row.
  /// Should be used first if it is not null
  final RowContentBuilder? builder;

  const ContentRowTextOption({
    this.maxLines,
    this.isBold = false,
    this.matchedParts,
    this.builder,
    this.baseColor,
  });
}

/// The text that will be shown in the content row.
/// Represents text block in the content row.
class ContentRowTextOptions {
  final String? title;
  final ContentRowTextOption? titleOptions;
  final String? subtitle;
  final ContentRowTextOption? subtitleOptions;
  final String? subtitleExtra;
  final ContentRowTextOption? subtitleExtraOptions;

  const ContentRowTextOptions({
    this.title,
    this.titleOptions,
    this.subtitle,
    this.subtitleOptions,
    this.subtitleExtra,
    this.subtitleExtraOptions,
  });
}
